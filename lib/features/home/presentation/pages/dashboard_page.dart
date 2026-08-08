import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../progress/presentation/bloc/progress_bloc.dart';
import '../../../progress/presentation/bloc/progress_state.dart';
import '../../../../features/drawing/domain/entities/practice_mode.dart';
import '../../../../features/drawing/presentation/pages/drawing_page.dart';
import '../../../../features/drawing/presentation/pages/free_writing_page.dart';
import '../../../../features/subscription/presentation/pages/subscription_page.dart';
import '../../../../core/utils/premium_manager.dart';
import '../../../../core/constants/curriculum_dataset.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProgressBloc, ProgressState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator(color: Colors.deepPurple));
        }
        
        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          children: [
            _buildContinueLearning(context, state),
            const SizedBox(height: 24),
            _buildTodaysPractice(context, state),
            const SizedBox(height: 24),
            _buildRecommendedPractice(context, state),
            const SizedBox(height: 24),
            _buildQuickPractice(context),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }

  Widget _buildContinueLearning(BuildContext context, ProgressState state) {
    final lastPractice = state.lastPracticeData;
    
    String content = 'Ready to start your first lesson?';
    bool isLocked = false;

    if (lastPractice != null) {
      final titleStr = lastPractice['title']?.toString() ?? 'Lesson';
      final title = titleStr.replaceAll('practice', '').replaceAll('learn', '').replaceAll('Simple', '').replaceAll('Uppercase', 'Uppercase ').replaceAll('Lowercase', 'Lowercase ').replaceAll('Words', 'Words ');
      final nextItem = lastPractice['nextItemId'] ?? '';
      final currentIndex = lastPractice['currentIndex'] ?? 0;
      final total = lastPractice['totalCount'] ?? 0;
      
      isLocked = !PremiumManager.isPremium && 
          (title.contains('Cursive') || title.contains('Free') || title.contains('Custom') || PremiumManager.isItemLocked(nextItem));

      content = isLocked 
          ? 'Upgrade to Premium to continue $title!'
          : '🔤 $title\nLetter $nextItem\nProgress: $currentIndex/$total';
    }

    return _buildCard(
      title: 'Continue Learning',
      icon: isLocked ? Icons.lock : Icons.play_circle_fill,
      iconColor: isLocked ? Colors.grey : Colors.green,
      content: lastPractice != null 
          ? content 
          : '🔤 Uppercase Letters\nLetter A\nTap here to start your first lesson!',
      onTap: () {
        if (isLocked) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const SubscriptionPage()));
          return;
        }
        if (lastPractice != null) {
          final modeStr = lastPractice['practiceMode'];
          final initialIndex = lastPractice['currentIndex'] as int? ?? 0;
          
          PracticeMode? mode;
          for (var m in PracticeMode.values) {
            if (m.toString() == modeStr) {
              mode = m;
              break;
            }
          }
          if (mode != null) {
            final customWordsList = lastPractice['customWords'] as List?;
            final customWords = customWordsList?.map((e) => e.toString()).toList();
            Navigator.push(context, MaterialPageRoute(builder: (_) => DrawingPage(
              practiceMode: mode!,
              initialIndex: initialIndex,
              customWords: customWords,
            )));
          }
        } else {
          // Fallback for brand new users
          Navigator.push(context, MaterialPageRoute(builder: (_) => const DrawingPage(
            practiceMode: PracticeMode.learnUppercase,
            initialIndex: 0,
          )));
        }
      },
    );
  }

  Widget _buildTodaysPractice(BuildContext context, ProgressState state) {
    // Generate items dynamically for the current day
    final challenge = state.dailyChallenge;
    final isCompleted = challenge?.isCompleted ?? false;
    final dayItems = CurriculumDataset.getCurriculumForDay(state.curriculumDay);
    
    final previewList = dayItems.map((e) => e.isCursive ? "Cursive ${e.text}" : e.text).toList();
    final previewText = previewList.join(' • ');

    final bool isLocked = state.curriculumDay > 3 && !PremiumManager.isPremium;

    return _buildCard(
      title: "Today's Practice (Day ${state.curriculumDay})",
      icon: isLocked ? Icons.lock : Icons.today,
      iconColor: isLocked ? Colors.grey : Colors.blue,
      content: isLocked 
          ? 'Upgrade to Premium to unlock Day 4 to Day 30!'
          : isCompleted 
            ? 'Great job! Come back tomorrow for Day ${state.curriculumDay} 🎉'
            : '${dayItems.length} lessons today\n$previewText',
      onTap: () {
        if (isLocked) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const SubscriptionPage()));
          return;
        }
        if (!isCompleted) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => DrawingPage(
            practiceMode: PracticeMode.dailyChallenge,
            customItems: dayItems,
          )));
        }
      },
    );
  }

  Widget _buildRecommendedPractice(BuildContext context, ProgressState state) {
    if (state.recommendedPractices.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Text(
            '⭐ Recommended for You',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
        ),
        ...state.recommendedPractices.map((rec) {
          final item = rec.itemId;
          final bool isLocked = PremiumManager.isItemLocked(item);
          
          String message = 'Practice "$item" to improve your score!';
          if (state.userProgress.isEmpty && rec.itemId == 'A') {
            message = "Begin your handwriting journey!";
          } else if (isLocked) {
            message = "Upgrade to Premium to unlock $item!";
          } else if (rec.bestScore < 75 && rec.bestScore > 0) {
            message = "You can improve your $item!";
          } else if (rec.attemptCount > 2) {
            message = "Keep practicing $item!";
          } else if (rec.bestScore == 0) {
            message = "Time to learn $item!";
          }
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildCard(
              title: (state.userProgress.isEmpty && rec.itemId == 'A') ? 'Start Learning A' : (rec.itemId.length > 1 ? rec.itemId : 'Practice ${rec.itemId}'),
              icon: isLocked ? Icons.lock : Icons.auto_awesome,
              iconColor: isLocked ? Colors.grey : Colors.amber,
              content: message,
              onTap: () {
                if (isLocked) {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const SubscriptionPage()));
                  return;
                }
                // Try to infer mode from category or fallback to simple heuristics
                PracticeMode mode = item.length > 1 ? PracticeMode.learnWordsSimple : PracticeMode.learnUppercase;
                Navigator.push(context, MaterialPageRoute(builder: (_) => DrawingPage(practiceMode: mode, customWords: [item])));
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _buildQuickPractice(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Text(
            'Quick Practice',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
        ),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildQuickChip(context, 'Uppercase', PracticeMode.practiceUppercase),
            _buildQuickChip(context, 'Lowercase', PracticeMode.practiceLowercase),
            _buildCursiveChip(context),
            _buildQuickChip(context, 'Numbers', PracticeMode.learnNumbers),
            _buildQuickChip(context, 'Words', PracticeMode.practiceWords),
            _buildQuickChip(context, 'Free Writing', PracticeMode.practiceFreeWriting),
          ],
        ),
      ],
    );
  }

  Widget _buildCursiveChip(BuildContext context) {
    final isLocked = !PremiumManager.isPremium;
    return ActionChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLocked) const Icon(Icons.lock, size: 14, color: Colors.deepPurple),
          if (isLocked) const SizedBox(width: 4),
          const Text('Cursive', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      backgroundColor: Colors.white,
      side: const BorderSide(color: Colors.deepPurple, width: 1.5),
      onPressed: () {
        if (isLocked) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const SubscriptionPage()));
          return;
        }
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          builder: (context) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Select Cursive Practice', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.text_fields, color: Colors.blue),
                      title: const Text('Cursive Uppercase'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const DrawingPage(practiceMode: PracticeMode.practiceCursiveUppercase)));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.text_format, color: Colors.green),
                      title: const Text('Cursive Lowercase'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const DrawingPage(practiceMode: PracticeMode.practiceCursiveLowercase)));
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildQuickChip(BuildContext context, String label, PracticeMode mode) {
    final bool isPremiumFeature = mode == PracticeMode.practiceFreeWriting;
    final bool isLocked = isPremiumFeature && !PremiumManager.isPremium;

    return ActionChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLocked) const Icon(Icons.lock, size: 14, color: Colors.deepPurple),
          if (isLocked) const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      backgroundColor: Colors.white,
      side: const BorderSide(color: Colors.deepPurple, width: 1.5),
      onPressed: () {
        if (isLocked) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const SubscriptionPage()));
          return;
        }

        if (mode == PracticeMode.practiceFreeWriting) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const FreeWritingPage()));
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (_) => DrawingPage(practiceMode: mode)));
        }
      },
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required String content,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    content,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }
}
