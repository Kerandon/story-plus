import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:story_plus/app_state.dart';
import 'package:story_plus/extension_methods.dart';
import 'package:story_plus/main.dart';
import 'package:story_plus/sqlite_database.dart';
import 'package:story_plus/story_model.dart';
import 'package:story_plus/story_tile.dart';

import 'constants.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late final Future<List<StoryModel>> storiesFuture;

  @override
  void initState() {
    storiesFuture = getStories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Story Plus',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              getIt<SqliteDatabase>().deleteTable();
            },
            icon: const Icon(Icons.minimize),
          ),
        ],
      ),
      body: FutureBuilder<List<StoryModel>>(
        future: storiesFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return GridView.builder(
              itemCount: snapshot.data!.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: state.isHorizontal ? 3 : 1,
              ),
              itemBuilder: (context, index) => StoryTile(snapshot.data![index]),
            );
          }
          if (snapshot.hasError) {
            return const Text(kErrorNoInternet);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

Future<List<StoryModel>> getStories() async {
  final database = getIt<SqliteDatabase>();
  List<StoryModel> stories = [];

  final sqliteStories = await database.getStories();

  if (sqliteStories.isNotEmpty) {
    stories = sqliteStories.toList();
  } else {
    final instance = FirebaseFirestore.instance;
    final data = await instance.collection('stories').get();
    for (var d in data.docs) {
      String content = d.data().entries.elementAt(0).value;
      stories.add(
        StoryModel(d.id, content.splitString()),
      );
    }
    await database.insertIntoDatabase(stories);
  }
  return stories;
}
