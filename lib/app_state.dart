import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:story_plus/story_model.dart';
import 'language_enum.dart';

class AppState {
  final int tileTapped;
  final int wordTapped;
  final Language language;
  final StoryModel selectedStory;

  AppState(
      {required this.tileTapped,
      required this.wordTapped,
      required this.language,
      required this.selectedStory});

  AppState copyWith(
      {int? tileTapped,
      int? wordTapped,
      Language? language,
      StoryModel? selectedStory}) {
    return AppState(
        tileTapped: tileTapped ?? this.tileTapped,
        wordTapped: wordTapped ?? this.wordTapped,
        language: language ?? this.language,
        selectedStory: selectedStory ?? this.selectedStory);
  }
}

class AppNotifier extends StateNotifier<AppState> {
  AppNotifier(state) : super(state);

  void setTileTapped(int tile) {
    state = state.copyWith(tileTapped: tile);
  }

  void setSelectedStory(StoryModel story) {
    state = state.copyWith(selectedStory: story);
  }

  void setWordTapped(int index) {
    state = state.copyWith(wordTapped: index);
    print('word tapped is $index and ${state.selectedStory.content[index]}');
    // speak(storys[0].content[index], state);
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
}

final appProvider = StateNotifierProvider<AppNotifier, AppState>(
  (ref) => AppNotifier(
    AppState(
      tileTapped: 9999999,
      wordTapped: 9999999,
      language: Language.english,
      selectedStory: StoryModel('', []),
    ),
  ),
);
