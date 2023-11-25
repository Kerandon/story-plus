import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:story_plus/app_state.dart';
import 'package:story_plus/scale_rotate_animation.dart';

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
              style: Theme.of(context).textTheme.headlineLarge,
            )),
      ),
    );
  }
}
