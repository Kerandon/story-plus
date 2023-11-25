extension StringSplitter on String {
  List<String> splitString() {
    List<String> result = [];
    RegExp regExp = RegExp(r"\s+|(?=[,.!;:?])|(?<=[,.!;:?])");

    Iterable<Match> matches = regExp.allMatches(this);
    int start = 0;

    for (Match match in matches) {
      if (start != match.start) {
        result.add(substring(start, match.start));
      }
      result.add(substring(match.start, match.end));
      start = match.end;
    }

    if (start < length) {
      result.add(substring(start));
    }

    // Remove leading and trailing blank strings
    while (result.isNotEmpty && result.first.trim().isEmpty) {
      result.removeAt(0);
    }
    while (result.isNotEmpty && result.last.trim().isEmpty) {
      result.removeLast();
    }

    return result;
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

extension StringListJoiner on List<String> {
  String joinToString() {
    return join('');
  }
}

extension WordCheckExtensions on String {
  bool isBlankSpaceOrPunctuation() {
    return trim().isEmpty || RegExp(r'^[\s\W]').hasMatch(this);
  }
}

extension CapitalizeFirstLetterExtension on String {
  String capitalizeFirstLetter() {
    if (isEmpty) {
      return this; // Return the string as is if it's empty
    }
    return this[0].toUpperCase() + substring(1); // Capitalize first letter and concatenate with the rest of the string
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
