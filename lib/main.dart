import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:story_plus/sqlite_database.dart';

import 'home_page.dart';

final getIt = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  getIt.registerSingletonAsync<SqliteDatabase>(() async => SqliteDatabase());
  await Firebase.initializeApp();

  runApp(const ProviderScope(child: StoryPlus()));
}

class StoryPlus extends ConsumerWidget {
  const StoryPlus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: GoogleFonts.rubik().fontFamily,
      ),
      title: 'Story Plus',
      home: const HomePage(),
    );
  }
}
