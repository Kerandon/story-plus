extension StringExtensions on String {
  List<String> splitByWords() {
    // This regex matches words with punctuation as one group
    final regex = RegExp(r"\b[\w']+[.,!?;]*");
    final matches = regex.allMatches(this);
    final words = matches.map((match) => match.group(0)!).toList();

    // Add an empty string after each word
    final wordsWithSpaces = <String>[];
    for (var word in words) {
      wordsWithSpaces.add(word);
      wordsWithSpaces.add(' ');
    }

    return wordsWithSpaces;
  }
}

extension WordCountExtension on String {
  int get wordCount {
    // Split the string by whitespace and count the non-empty elements
    return split(RegExp(r'\s+')).where((word) => word.isNotEmpty).length;
  }
}

extension ListStringExtension on List<String> {
  String asStoryString() {
    return map((word) => word.trim())
        .where((word) => word.isNotEmpty)
        .join(' ');
  }
}
