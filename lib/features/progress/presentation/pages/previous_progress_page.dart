import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../progress/presentation/bloc/progress_bloc.dart';
import '../../../progress/presentation/bloc/progress_state.dart';
import '../../../drawing/domain/entities/practice_mode.dart';

class PreviousProgressPage extends StatelessWidget {
  const PreviousProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        title: const Text('Previous Progress', style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.deepPurple),
      ),
      body: BlocBuilder<ProgressBloc, ProgressState>(
        builder: (context, state) {
          final today = DateTime.now();
          int prevMonth = today.month - 1;
          int prevYear = today.year;
          if (prevMonth == 0) {
            prevMonth = 12;
            prevYear--;
          }
          final prevMonthDate = DateTime(prevYear, prevMonth, 1);
          final monthName = DateFormat('MMMM').format(prevMonthDate);

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Header
              Center(
                child: Column(
                  children: [
                    Text('$monthName Progress', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                    const SizedBox(height: 4),
                    const Text('Archived Data', style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Stats
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatBox('Total Practice', '${state.previousTotalPracticeThisMonth}', Colors.blue),
                  _buildStatBox('Items Completed', '${state.previousItemsCompletedThisMonth}', Colors.green),
                ],
              ),
              const SizedBox(height: 30),

              // Categories
              if (state.previousMonthlyItemCounts.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Text('No data found for previous month.', style: TextStyle(fontSize: 18, color: Colors.grey)),
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
      ),
    );
  }

  Map<String, int> _getCategoryData(ProgressState state, List<PracticeMode> modes) {
    Map<String, int> combined = {};
    for (var mode in modes) {
      final data = state.previousMonthlyItemCounts[mode.name];
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
