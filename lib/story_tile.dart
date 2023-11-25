import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:story_plus/app_state.dart';
import 'package:story_plus/constants.dart';
import 'package:story_plus/sqlite_database.dart';
import 'package:story_plus/story_model.dart';
import 'package:story_plus/story_page.dart';
import 'dart:developer';
import 'main.dart';

class StoryTile extends ConsumerStatefulWidget {
  const StoryTile(
    this.storyModel, {
    super.key,
  });

  final StoryModel storyModel;

  @override
  ConsumerState<StoryTile> createState() => _StoryTileState();
}

class _StoryTileState extends ConsumerState<StoryTile> {
  late final Future _imageFuture;

  @override
  void initState() {
    _imageFuture = getImage(widget.storyModel.title);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appProvider);
    final notifier = ref.read(appProvider.notifier);
    Uint8List? bytes;
    return LayoutBuilder(
      builder: (context, constraints) {
        final biggest = constraints.biggest;
        return Padding(
          padding: EdgeInsets.all(biggest.width * 0.02),
          child: Stack(
            children: [
              FutureBuilder<dynamic>(
                  future: _imageFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      bytes = snapshot.data;

                      return Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(kBorderRadius),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black45,
                                  offset: Offset(5, 5),
                                  blurRadius: 3,
                                ),
                              ],
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(kBorderRadius),
                            child: Animate(
                              effects: const [FadeEffect()],
                              child: SizedBox(
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: Image.memory(
                                    bytes!,
                                    fit: BoxFit.cover,
                                  )),
                            ),
                          ),
                        ],
                      );
                    }
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text(kErrorNoInternet),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
              Align(
                alignment: const Alignment(0, 0.90),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: EdgeInsets.all(biggest.width * 0.01),
                    child: Text(
                      widget.storyModel.title,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      notifier.setSelectedStory(StoryModel(
                        widget.storyModel.title,
                        widget.storyModel.content,
                        bytes,
                      ));
                      WidgetsBinding.instance.addPostFrameCallback(
                        (timeStamp) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const StoryPage(),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(biggest.width * 0.03),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(biggest.width * 0.02),
                      color: Colors.white),
                  child: Padding(
                    padding: EdgeInsets.all(biggest.width * 0.02),
                    child: Text(
                        '${widget.storyModel.content.length.toString()} words',
                        style: Theme.of(context).textTheme.labelLarge),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

Future<Uint8List?> getImage(String image) async {
  final bytes = await getIt<SqliteDatabase>().getImage(image);
  if (bytes != null && bytes.isNotEmpty) {
    return bytes;
  } else {
    try {
      final instance = FirebaseStorage.instance;

      final bytes = await instance.ref('stories/$image.jpeg').getData();
      if (bytes != null) {
        getIt<SqliteDatabase>().saveImage(image, bytes);
        return bytes;
      }
    } catch (e) {
      log('error image not fetched from firebase $e');
    }
  }
  return null;
}
