import 'package:flutter/material.dart';
import '../../../../features/drawing/domain/entities/practice_mode.dart';
import '../widgets/option_button.dart';

class PracticePage extends StatelessWidget {
  const PracticePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
      children: const [
        OptionButton(
          title: 'Uppercase (A-Z)',
          mode: PracticeMode.practiceUppercase,
          color: Colors.blueAccent,
        ),
        SizedBox(height: 16),
        OptionButton(
          title: 'Lowercase (a-z)',
          mode: PracticeMode.practiceLowercase,
          color: Colors.lightBlue,
        ),
        SizedBox(height: 16),
        OptionButton(
          title: 'Cursive Uppercase (A-Z)',
          mode: PracticeMode.practiceCursiveUppercase,
          color: Colors.green,
        ),
        SizedBox(height: 16),
        OptionButton(
          title: 'Cursive Lowercase (a-z)',
          mode: PracticeMode.practiceCursiveLowercase,
          color: Colors.lightGreen,
        ),
        SizedBox(height: 16),
        OptionButton(
          title: 'Words',
          mode: PracticeMode.practiceWords,
          color: Colors.orange,
        ),
        SizedBox(height: 16),
        OptionButton(
          title: 'Type & Trace',
          mode: PracticeMode.practiceCustomWords,
          color: Colors.teal,
        ),
        SizedBox(height: 16),
        OptionButton(
          title: 'Free Writing',
          mode: PracticeMode.practiceFreeWriting,
          color: Colors.redAccent,
        ),
        SizedBox(height: 24),
      ],
    );
  }
}
