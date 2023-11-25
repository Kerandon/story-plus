import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:story_plus/app_state.dart';
import 'package:story_plus/constants.dart';
import 'package:story_plus/extension_methods.dart';
import 'package:story_plus/language_enum.dart';
import 'package:story_plus/word.dart';

import 'font_size_enum.dart';

class StoryPage extends ConsumerWidget {
  const StoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appProvider);
    final notifier = ref.read(appProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(elevation: 0),
              onPressed: () {
                iterateFontSize(state, notifier);
              },
              child: Row(
                children: [
                  SizeLetter(fontSize: FontSize.small,),
                  SizeLetter(fontSize: FontSize.medium,),
                  SizeLetter(fontSize: FontSize.large,),
                ],
              )),
          ElevatedButton(
              style: ElevatedButton.styleFrom(elevation: 0),
              onPressed: () {
                notifier.setLanguage();
              },
              child: Text('${state.language.getAbbreviation()}  🔊')),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final biggest = constraints.biggest;
          final textTheme = Theme.of(context).textTheme;
          final padding = biggest.width * 0.05;
          return Padding(
            padding: EdgeInsets.fromLTRB(padding, 0, padding, padding),
            child: ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: biggest.height * 0.01),
                  child: Center(
                    child: Text(
                      state.selectedStory.title,
                      textAlign: TextAlign.center,
                      style: () {
                        switch (state.fontSize) {
                          case FontSize.small:
                            return textTheme.displaySmall;
                          case FontSize.medium:
                            return textTheme.displayMedium;
                          case FontSize.large:
                            return textTheme.displayLarge;
                        }
                      }(),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: padding),
                  child: state.selectedStory.image == null
                      ? const SizedBox()
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(kBorderRadius),
                          child: Image.memory(state.selectedStory.image!)),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Wrap(
                        runAlignment: WrapAlignment.spaceEvenly,
                        runSpacing: biggest.height * 0.015,
                        children: state.selectedStory.content
                            .mapIndexed(
                              (index, word) =>
                                  Word(index, word.isBlankSpaceOrPunctuation()),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class SizeLetter extends StatelessWidget {
  const SizeLetter({
    required this.fontSize,
    super.key,
  });

  final FontSize fontSize;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Text(
      'A',
      style: () {
        switch (fontSize) {
          case FontSize.small:
            return textTheme.displaySmall;
          case FontSize.medium:
            return textTheme.displayMedium;
          case FontSize.large:
            return textTheme.displayLarge;
        }
      }(),
    );
  }
}

void iterateFontSize(AppState state, AppNotifier notifier) {
  const List<FontSize> values = FontSize.values;
  final int nextIndex = (state.fontSize.index + 1) % values.length;
  notifier.setFontSize(values[nextIndex]);
}
