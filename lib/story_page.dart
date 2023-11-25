import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:story_plus/app_state.dart';
import 'package:story_plus/extension_methods.dart';
import 'package:story_plus/word.dart';

class StoryPage extends ConsumerWidget {
  const StoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appProvider);
    final notifier = ref.read(appProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              notifier.setLanguage();
            },
            icon: const Icon(Icons.abc),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final biggest = constraints.biggest;
          final padding = biggest.width * 0.03;
          return Padding(
            padding: EdgeInsets.fromLTRB(padding, 0, padding, padding),
            child: ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: biggest.height * 0.01),
                  child: Container(
                    color: Colors.red,
                    child: Center(
                      child: Text(state.selectedStory.title,
                          style: Theme.of(context).textTheme.displayMedium),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(padding),
                  child: state.selectedStory.image == null
                      ? const SizedBox()
                      : Image.memory(state.selectedStory.image!),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Wrap(
                        children: state.selectedStory.content
                            .mapIndexed(
                              (index, e) =>
                                  Word(index, e.isBlankSpaceOrPunctuation()),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
