import 'package:flutter/material.dart';
import '../../../../features/drawing/domain/entities/practice_mode.dart';
import '../../../../features/drawing/presentation/pages/drawing_page.dart';
import '../../../../features/drawing/presentation/pages/free_writing_page.dart';
import '../../../../features/home/presentation/pages/custom_word_input_page.dart';
import '../../../../features/subscription/presentation/pages/subscription_page.dart';
import '../../../../core/utils/premium_manager.dart';

class OptionButton extends StatelessWidget {
  final String title;
  final PracticeMode mode;
  final Color color;

  const OptionButton({
    super.key,
    required this.title,
    required this.mode,
    required this.color,
  });

  bool get _isPremiumFeature {
    return mode == PracticeMode.practiceCursiveUppercase ||
           mode == PracticeMode.practiceCursiveLowercase ||
           mode == PracticeMode.learnCursiveUppercase ||
           mode == PracticeMode.learnCursiveLowercase ||
           mode == PracticeMode.learnWordsCursive ||
           mode == PracticeMode.practiceCustomWords ||
           mode == PracticeMode.practiceFreeWriting;
  }

  bool get _isLocked {
    return _isPremiumFeature && !PremiumManager.isPremium;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: _isLocked ? Colors.grey.shade400 : color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: _isLocked ? 1 : 4,
        shadowColor: color.withValues(alpha: 0.5),
        minimumSize: const Size(double.infinity, 60),
      ),
      onPressed: () {
        if (_isLocked) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SubscriptionPage(),
            ),
          );
          return;
        }

        if (mode == PracticeMode.practiceFreeWriting) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FreeWritingPage(),
            ),
          );
        } else if (mode == PracticeMode.practiceCustomWords) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CustomWordInputPage(),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DrawingPage(practiceMode: mode),
            ),
          );
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_isLocked) const Icon(Icons.lock, color: Colors.white, size: 20),
          if (_isLocked) const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}
