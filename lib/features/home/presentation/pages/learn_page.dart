import 'package:flutter/material.dart';
import '../../../../features/drawing/domain/entities/practice_mode.dart';
import '../widgets/option_button.dart';

class LearnPage extends StatelessWidget {
  const LearnPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
      children: [
        _buildSectionHeader('Letters'),
        const OptionButton(
          title: 'Uppercase (A-Z)',
          mode: PracticeMode.learnUppercase,
          color: Colors.blueAccent,
        ),
        const SizedBox(height: 12),
        const OptionButton(
          title: 'Lowercase (a-z)',
          mode: PracticeMode.learnLowercase,
          color: Colors.lightBlue,
        ),
        const SizedBox(height: 24),
        
        _buildSectionHeader('Cursive'),
        const OptionButton(
          title: 'Uppercase (A-Z)',
          mode: PracticeMode.learnCursiveUppercase,
          color: Colors.green,
        ),
        const SizedBox(height: 12),
        const OptionButton(
          title: 'Lowercase (a-z)',
          mode: PracticeMode.learnCursiveLowercase,
          color: Colors.lightGreen,
        ),
        const SizedBox(height: 24),

        _buildSectionHeader('Numbers'),
        const OptionButton(
          title: 'Numbers (0-9)',
          mode: PracticeMode.learnNumbers,
          color: Colors.orange,
        ),
        const SizedBox(height: 24),

        _buildSectionHeader('Words'),
        const OptionButton(
          title: 'Simple Words',
          mode: PracticeMode.learnWordsSimple,
          color: Colors.purple,
        ),
        const SizedBox(height: 12),
        const OptionButton(
          title: 'Cursive Words',
          mode: PracticeMode.learnWordsCursive,
          color: Colors.deepPurpleAccent,
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
        ),
      ),
    );
  }
}
