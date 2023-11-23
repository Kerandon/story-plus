import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(const StoryPlus());
}

class StoryPlus extends StatelessWidget {
  const StoryPlus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: GoogleFonts.rubik().fontFamily,
        ),
        title: 'Story Plus',
        home: const HomePage(),
      ),
    );
  }
}
