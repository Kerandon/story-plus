import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:story_plus/extension_methods.dart';
import 'package:story_plus/main.dart';
import 'package:story_plus/sqlite_database.dart';
import 'package:story_plus/story_model.dart';
import 'package:story_plus/story_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Future<List<StoryModel>> storiesFuture;

  @override
  void initState() {
    storiesFuture = getStories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          IconButton(
            onPressed: () {
              getIt<SqliteDatabase>().getStories();
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder<List<StoryModel>>(
        future: storiesFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return GridView.builder(
              itemCount: snapshot.data!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemBuilder: (context, index) => StoryTile(snapshot.data![index]),
            );
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
        StoryModel(d.id, content.splitByWords()),
      );
    }
    await database.insertIntoDatabase(stories);
  }
  return stories;
}
