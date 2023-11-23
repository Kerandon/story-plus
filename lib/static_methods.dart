import 'package:flutter_tts/flutter_tts.dart';
import 'package:story_plus/app_state.dart';
import 'package:story_plus/language_enum.dart';
import 'package:translator/translator.dart';

Future<void> speak(String text, AppState state) async {
  FlutterTts tts = FlutterTts();
  final translate = GoogleTranslator();
  if (state.language == Language.english) {
    tts.setLanguage('en-US');
    await tts.speak(text);
  }
  if (state.language == Language.chinese) {
    tts.setLanguage('zh-CN');
    final translatedText =
        await translate.translate(text, from: 'en', to: 'zh-cn');
    await tts.speak(translatedText.text);
  }
}
