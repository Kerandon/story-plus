import 'dart:typed_data';

import 'package:story_plus/extension_methods.dart';

class StoryModel {
  final String title;
  final List<String> content;
  final Uint8List? image;

  StoryModel(this.title, this.content, [this.image]);

  Map<String, dynamic> toMap() {
    final contentAsString = content.asStoryString();

    return {
      'title': title,
      'content': contentAsString,
      'image': image,
    };
  }

  factory StoryModel.fromMap(Map<String, dynamic> map) {
    String content = map['content'] as String;
    List<String> contentSplitByWords = content.splitByWords();
    return StoryModel(map['title'], contentSplitByWords);
  }
}
