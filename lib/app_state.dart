import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:story_plus/static_methods.dart';
import 'package:story_plus/story_model.dart';
import 'font_size_enum.dart';
import 'language_enum.dart';

class AppState {
  final bool isHorizontal;
  final int tileTapped;
  final int wordTapped;
  final Language language;
  final StoryModel selectedStory;
  final FontSize fontSize;

  AppState({
    required this.isHorizontal,
    required this.tileTapped,
    required this.wordTapped,
    required this.language,
    required this.selectedStory,
    required this.fontSize,
  });

  AppState copyWith({
    bool? isHorizontal,
    int? tileTapped,
    int? wordTapped,
    Language? language,
    StoryModel? selectedStory,
    FontSize? fontSize,
  }) {
    return AppState(
      isHorizontal: isHorizontal ?? this.isHorizontal,
      tileTapped: tileTapped ?? this.tileTapped,
      wordTapped: wordTapped ?? this.wordTapped,
      language: language ?? this.language,
      selectedStory: selectedStory ?? this.selectedStory,
      fontSize: fontSize ?? this.fontSize,
    );
  }
}

class AppNotifier extends StateNotifier<AppState> {
  AppNotifier(state) : super(state);

  void setIsHorizontal(bool horizontal) {
    state = state.copyWith(isHorizontal: horizontal);
  }

  void setTileTapped(int tile) {
    state = state.copyWith(tileTapped: tile);
  }

  void setSelectedStory(StoryModel story) {
    state = state.copyWith(selectedStory: story);
  }

  void setWordTapped(int index) async {
    state = state.copyWith(wordTapped: index);
    print('word tapped is $index');
    await speak(state.selectedStory.content[index], state);
  }

  void setLanguage() {
    Language language = Language.english;
    if (state.language == Language.english) {
      language = Language.chinese;
    } else {
      language = Language.english;
    }
    state = state.copyWith(language: language);
  }

  void setFontSize(FontSize size) {
    state = state.copyWith(fontSize: size);
    print('font size set to ${size}');
  }
}

final appProvider = StateNotifierProvider<AppNotifier, AppState>(
  (ref) => AppNotifier(
    AppState(
      isHorizontal: true,
      tileTapped: 9999999,
      wordTapped: 9999999,
      language: Language.english,
      selectedStory: StoryModel('', []),
      fontSize: FontSize.medium,
    ),
  ),
);
