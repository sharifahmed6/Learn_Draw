import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../progress/presentation/bloc/progress_bloc.dart';
import '../../../progress/presentation/bloc/progress_state.dart';
import '../../../drawing/domain/entities/practice_mode.dart';
import 'curriculum_tracker_page.dart';
import 'previous_progress_page.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProgressBloc, ProgressState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator(color: Colors.deepPurple));
        }

        final monthName = DateFormat('MMMM').format(DateTime.now());
        final today = DateTime.now();
        final startOfMonth = DateTime(today.year, today.month, 1);
        final endOfMonth = DateTime(today.year, today.month + 1, 0);
        final dateRange = '${startOfMonth.day} $monthName – ${endOfMonth.day} $monthName';

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          children: [
            // Header
            Center(
              child: Column(
                children: [
                  Text('$monthName Progress', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                  const SizedBox(height: 4),
                  Text(dateRange, style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 30-Day Tracker Button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const CurriculumTrackerPage()));
              },
              icon: const Icon(Icons.calendar_month, color: Colors.white),
              label: const Text('30-Day Progress', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
              ),
            ),
            const SizedBox(height: 12),
            
            // Previous Progress Button
            if (state.hasPreviousProgress)
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const PreviousProgressPage()));
                },
                icon: const Icon(Icons.history, color: Colors.deepPurple),
                label: const Text('Previous Progress', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: const BorderSide(color: Colors.deepPurple, width: 2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            const SizedBox(height: 24),

            // Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatBox('Total Practice', '${state.totalPracticeThisMonth}', Colors.blue),
                _buildStatBox('Items Completed', '${state.itemsCompletedThisMonth}', Colors.green),
                _buildStatBox('Current Streak', '${state.streak?.currentStreak ?? 0} days', Colors.orange),
              ],
            ),
            const SizedBox(height: 30),

            // Categories
            if (state.monthlyItemCounts.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text('Let\'s start learning this month!', style: TextStyle(fontSize: 18, color: Colors.grey)),
                ),
              )
            else ...[
              _buildCategorySection('Uppercase', _getCategoryData(state, [PracticeMode.learnUppercase, PracticeMode.practiceUppercase])),
              _buildCategorySection('Lowercase', _getCategoryData(state, [PracticeMode.learnLowercase, PracticeMode.practiceLowercase])),
              _buildCategorySection('Cursive Uppercase', _getCategoryData(state, [PracticeMode.learnCursiveUppercase, PracticeMode.practiceCursiveUppercase])),
              _buildCategorySection('Cursive Lowercase', _getCategoryData(state, [PracticeMode.learnCursiveLowercase, PracticeMode.practiceCursiveLowercase])),
              _buildCategorySection('Numbers', _getCategoryData(state, [PracticeMode.learnNumbers])),
              _buildCategorySection('Words', _getCategoryData(state, [PracticeMode.learnWordsSimple, PracticeMode.learnWordsCursive, PracticeMode.practiceWords])),
            ],
          ],
        );
      },
    );
  }

  Map<String, int> _getCategoryData(ProgressState state, List<PracticeMode> modes) {
    Map<String, int> combined = {};
    for (var mode in modes) {
      final data = state.monthlyItemCounts[mode.name];
      if (data != null) {
        data.forEach((key, value) {
          combined[key] = (combined[key] ?? 0) + value;
        });
      }
    }
    return combined;
  }

  Widget _buildStatBox(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildCategorySection(String title, Map<String, int> items) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Item', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                      Text('Completed', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                    ],
                  ),
                ),
                const Divider(height: 1, thickness: 1),
                ...items.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(entry.key, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('${entry.value} times', style: const TextStyle(fontSize: 16, color: Colors.blue, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
