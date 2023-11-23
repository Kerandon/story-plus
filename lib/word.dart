import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:story_plus/app_state.dart';

class Word extends ConsumerWidget {
  const Word(this.wordTapped,{
    super.key,
  });

  final int wordTapped;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(appProvider.notifier);
    final state = ref.watch(appProvider);
    return InkWell(
      onTap: (){
      notifier.setWordTapped(wordTapped);
      },
      child: Container(
          decoration: const BoxDecoration(color: Colors.lightBlueAccent),
          child: Text(
           state.selectedStory.content[wordTapped],
            style: Theme.of(context).textTheme.headlineLarge,
          )),
    );
  }
}
