enum Language {
  english,
  chinese,
}
extension LanguageAbbreviationExtension on Language {
  String getAbbreviation() {
    switch (this) {
      case Language.english:
        return 'Eng';
      case Language.chinese:
        return 'Chin';
    }
  }
}