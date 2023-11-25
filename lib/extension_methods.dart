extension StringExtensions on String {
  List<String> splitByWords() {
    // This regex matches words and separates them with spaces
    final regex = RegExp(r"[\w']+|[.,!?;]+| ");
    final matches = regex.allMatches(this);
    final words = matches.map((match) => match.group(0)!).toList();

    return words;
  }
}

extension WordCountExtension on String {
  int get wordCount {
    // Split the string by common separators (space, period, comma, etc.)
    final separators = RegExp(r'[\s,.!?;:]+');
    final words = split(separators);

    // Filter out empty elements and count non-empty ones
    return words.where((word) => word.trim().isNotEmpty).length;
  }
}

extension ListStringExtension on List<String> {
  String asStoryString() {
    return map((word) => word.trim())
        .where((word) => word.isNotEmpty)
        .join(' ');
  }
}

extension WordCheckExtensions on String {
  bool isBlankSpaceOrPunctuation() {
    return trim().isEmpty || (length == 1 && RegExp(r'[^\w\s]').hasMatch(this));
  }
}

extension IterableExtension<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(int index, E e) f) sync* {
    var index = 0;
    for (final element in this) {
      yield f(index, element);
      index++;
    }
  }
}
