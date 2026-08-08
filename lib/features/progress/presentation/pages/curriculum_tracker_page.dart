import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/progress_bloc.dart';
import '../bloc/progress_state.dart';

class CurriculumTrackerPage extends StatelessWidget {
  const CurriculumTrackerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        title: const Text('30-Day Curriculum', style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.deepPurple),
      ),
      body: BlocBuilder<ProgressBloc, ProgressState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(state),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    itemCount: 30,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.8,
                    ),
                    itemBuilder: (context, index) {
                      final day = index + 1;
                      return _buildDayCell(day, state.curriculumDay);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(ProgressState state) {
    final monthName = DateFormat('MMMM').format(DateTime.now());
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            '$monthName Progress',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStat('Total Practice', '${state.totalPracticeThisMonth}'),
              _buildStat('Items Done', '${state.itemsCompletedThisMonth}'),
              _buildStat('Streak', '${state.streak?.currentStreak ?? 0}🔥'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildDayCell(int day, int currentCurriculumDay) {
    final isCompleted = day < currentCurriculumDay;
    final isActive = day == currentCurriculumDay;
    
    Color bgColor = Colors.white;
    Color borderColor = Colors.grey.shade300;
    Widget icon = const SizedBox.shrink();
    
    if (isCompleted) {
      bgColor = Colors.green.shade50;
      borderColor = Colors.green;
      icon = const Icon(Icons.check_circle, color: Colors.green, size: 24);
    } else if (isActive) {
      bgColor = Colors.blue.shade50;
      borderColor = Colors.blue;
      icon = const Icon(Icons.star, color: Colors.amber, size: 24);
    } else {
      bgColor = Colors.grey.shade100;
      icon = const Icon(Icons.lock, color: Colors.grey, size: 20);
    }

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: isActive ? 2 : 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Day', style: TextStyle(fontSize: 12, color: isActive ? Colors.blue : Colors.grey)),
          Text('$day', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isActive ? Colors.blue : Colors.black87)),
          const SizedBox(height: 4),
          icon,
        ],
      ),
    );
  }
}
