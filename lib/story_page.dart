import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:story_plus/app_state.dart';
import 'package:story_plus/word.dart';

class StoryPage extends ConsumerWidget {
  const StoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appProvider);
    final notifier = ref.read(appProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              notifier.setLanguage();
            },
            icon: const Icon(Icons.abc),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: [
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    children: state.selectedStory.content
                        .map(
                          (e) => Word(
                            state.selectedStory.content.indexOf(e),
                          ),
                        )
                        .toList(),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
