import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:story_plus/app_state.dart';
import 'package:story_plus/scale_rotate_animation.dart';

import 'font_size_enum.dart';

class Word extends ConsumerWidget {
  const Word(
    this.wordTapped,
    this.isSpace, {
    super.key,
  });

  final int wordTapped;
  final bool isSpace;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(appProvider.notifier);
    final state = ref.watch(appProvider);
    final textTheme = Theme.of(context).textTheme;
    return ScaleRotateAnimation(
      animate: state.wordTapped == wordTapped && !isSpace,
      child: InkWell(
        onTap: () {
          notifier.setWordTapped(wordTapped);
        },
        child: Container(
          decoration: const BoxDecoration(color: Colors.lightBlueAccent),
          child: Text(
            state.selectedStory.content[wordTapped],
            style: () {
              switch (state.fontSize) {
                case FontSize.small:
                  return textTheme.displaySmall;
                case FontSize.medium:
                  return textTheme.displayMedium;
                case FontSize.large:
                  return textTheme
                      .displayLarge; // Fallback to a default style if needed
              }
            }(),
          ),
        ),
      ),
    );
  }
}
