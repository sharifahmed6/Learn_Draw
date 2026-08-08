import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/progress_repository.dart';
import '../../data/models/user_progress_model.dart';
import '../../data/models/practice_history_model.dart';
import '../../data/models/daily_challenge_model.dart';
import '../../../../core/constants/curriculum_dataset.dart';
import '../../../../core/constants/word_dataset.dart';
import '../../../drawing/domain/entities/practice_mode.dart';
import 'progress_event.dart';
import 'progress_state.dart';

import 'dart:convert';

class ProgressBloc extends Bloc<ProgressEvent, ProgressState> {
  final ProgressRepository repository;

  ProgressBloc({required this.repository}) : super(const ProgressState()) {
    on<LoadProgressEvent>(_onLoadProgress);
    on<SavePracticeResultEvent>(_onSavePracticeResult);
    on<SaveContinueLearningEvent>(_onSaveContinueLearning);
    on<CompleteCurriculumDayEvent>(_onCompleteCurriculumDay);
  }

  Future<void> _onLoadProgress(LoadProgressEvent event, Emitter<ProgressState> emit) async {
    emit(state.copyWith(isLoading: true));
    
    final userProgress = await repository.getAllProgress();
    final practiceHistory = await repository.getPracticeHistory();
    final streak = await repository.getStreak();
    final lastPracticeData = await repository.getLastPractice();
    final curriculumDay = await repository.getCurriculumDay();
    
    final now = DateTime.now();

    // 7-Day Rule logic: Find recently practiced words
    final recentlyPracticed = userProgress
        .where((p) => p.lastPracticeDate?.isAfter(now.subtract(const Duration(days: 7))) ?? false)
        .map((p) => p.itemId)
        .toSet();

    // Filter available words
    final availableWords = WordDataset.allWords
        .where((word) => !recentlyPracticed.contains(word))
        .toList();
    availableWords.shuffle();

    // Check and update Daily Challenge
    final dateStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    
    var dailyChallenge = await repository.getDailyChallenge(dateStr);
    if (dailyChallenge == null) {
      // Pick 3 random words for the challenge
      final challengeWords = availableWords.take(3).toList();
      if (challengeWords.isEmpty) challengeWords.addAll(['APPLE', 'BALL', 'CAT']);
      
      dailyChallenge = DailyChallengeModel(
        date: dateStr,
        assignedItems: challengeWords,
      );
      await repository.saveDailyChallenge(dailyChallenge);
    }
    
    // Priority-based Recommendations Engine
    List<UserProgressModel> recommendedPractices = [];
    
    // Priority 1: Low Score (< 75%)
    final lowScoreItems = userProgress.where((p) => p.bestScore < 75).toList()
      ..sort((a, b) => a.bestScore.compareTo(b.bestScore));
    
    // Priority 2: High Attempts, Low-ish Score (>2 attempts, <85%)
    final struggleItems = userProgress.where((p) => p.attemptCount > 2 && p.bestScore < 85 && p.bestScore >= 75).toList()
      ..sort((a, b) => a.bestScore.compareTo(b.bestScore));

    // Priority 3: Not practiced recently (> 14 days ago)
    final staleItems = userProgress.where((p) => p.lastPracticeDate != null && now.difference(p.lastPracticeDate!).inDays > 14).toList()
      ..sort((a, b) => a.lastPracticeDate!.compareTo(b.lastPracticeDate!));
      
    // Priority 4: Not learned yet (From Curriculum up to current day)
    List<UserProgressModel> unlearnedItems = [];
    Set<String> learnedItemIds = userProgress.map((p) => p.itemId).toSet();
    
    for (int day = 1; day <= curriculumDay; day++) {
      final itemsForDay = CurriculumDataset.getCurriculumForDay(day);
      for (var item in itemsForDay) {
        if (!learnedItemIds.contains(item.text)) {
          unlearnedItems.add(UserProgressModel(
            itemId: item.text,
            category: item.mode.name,
            completed: false,
            bestScore: 0,
            attemptCount: 0,
            lastPracticeDate: null,
          ));
        }
      }
    }
    // Shuffle unlearned to provide variety
    unlearnedItems.shuffle();

    if (userProgress.isEmpty) {
      recommendedPractices.add(UserProgressModel(
        itemId: 'A',
        category: PracticeMode.learnUppercase.name,
        completed: false,
        bestScore: 0,
        attemptCount: 0,
        lastPracticeDate: null,
      ));
    } else {
      // Assemble final list (max 3 items)
      for (var list in [lowScoreItems, struggleItems, staleItems, unlearnedItems]) {
        for (var item in list) {
          if (recommendedPractices.length >= 3) break;
          if (!recommendedPractices.any((p) => p.itemId == item.itemId)) {
            recommendedPractices.add(item);
          }
        }
        if (recommendedPractices.length >= 3) break;
      }

      // Fallback if the child is completely caught up and has high scores on everything!
      if (recommendedPractices.isEmpty) {
        final recWord = availableWords.isNotEmpty ? availableWords.first : 'HELLO';
        recommendedPractices.add(UserProgressModel(
          itemId: recWord,
          category: 'Words',
          completed: false,
          bestScore: 0,
          attemptCount: 0,
          lastPracticeDate: null,
        ));
      }
    }

    // Calculate Previous Month
    int prevMonth = now.month - 1;
    int prevYear = now.year;
    if (prevMonth == 0) {
      prevMonth = 12;
      prevYear--;
    }
    
    // Trigger cleanup asynchronously for data older than the previous month
    final cutoffDate = DateTime(prevYear, prevMonth, 1);
    repository.deleteOldPracticeHistory(cutoffDate);

    // Monthly Data Aggregation
    Map<String, Map<String, int>> monthlyItemCounts = {};
    int totalPracticeThisMonth = 0;
    Set<String> uniqueItemsCompleted = {};
    
    Map<String, Map<String, int>> previousMonthlyItemCounts = {};
    int previousTotalPracticeThisMonth = 0;
    Set<String> previousUniqueItemsCompleted = {};

    for (var history in practiceHistory) {
      if (history.completedAt.year == now.year && history.completedAt.month == now.month) {
        totalPracticeThisMonth++;
        uniqueItemsCompleted.add(history.itemId);
        
        final categoryMap = monthlyItemCounts.putIfAbsent(history.category, () => {});
        categoryMap[history.itemId] = (categoryMap[history.itemId] ?? 0) + 1;
      } else if (history.completedAt.year == prevYear && history.completedAt.month == prevMonth) {
        previousTotalPracticeThisMonth++;
        previousUniqueItemsCompleted.add(history.itemId);
        
        final categoryMap = previousMonthlyItemCounts.putIfAbsent(history.category, () => {});
        categoryMap[history.itemId] = (categoryMap[history.itemId] ?? 0) + 1;
      }
    }

    emit(state.copyWith(
      isLoading: false,
      userProgress: userProgress,
      practiceHistory: practiceHistory,
      streak: streak,
      lastPracticeData: lastPracticeData,
      dailyChallenge: dailyChallenge,
      recommendedPractices: recommendedPractices,
      availableWords: availableWords,
      curriculumDay: curriculumDay,
      monthlyItemCounts: monthlyItemCounts,
      totalPracticeThisMonth: totalPracticeThisMonth,
      itemsCompletedThisMonth: uniqueItemsCompleted.length,
      previousMonthlyItemCounts: previousMonthlyItemCounts,
      previousTotalPracticeThisMonth: previousTotalPracticeThisMonth,
      previousItemsCompletedThisMonth: previousUniqueItemsCompleted.length,
      hasPreviousProgress: previousTotalPracticeThisMonth > 0,
    ));
  }

  Future<void> _onSavePracticeResult(SavePracticeResultEvent event, Emitter<ProgressState> emit) async {
    final now = DateTime.now();
    
    // Save history
    final history = PracticeHistoryModel(
      itemId: event.itemId,
      category: event.category,
      practiceType: event.practiceType,
      score: event.score,
      durationSeconds: event.durationSeconds,
      completedAt: now,
    );
    await repository.savePracticeHistory(history);

    // Update Progress
    var progress = await repository.getProgress(event.itemId, event.category);
    if (progress == null) {
      progress = UserProgressModel(
        itemId: event.itemId,
        category: event.category,
        completed: true,
        bestScore: event.score,
        attemptCount: 1,
        lastPracticeDate: now,
      );
    } else {
      progress.completed = true;
      progress.attemptCount += 1;
      progress.lastPracticeDate = now;
      if (event.score > progress.bestScore) {
        progress.bestScore = event.score;
      }
    }
    await repository.saveProgress(progress);

    // Update Streak
    await repository.updateStreak(now);

    // Reload state
    add(LoadProgressEvent());
  }

  Future<void> _onSaveContinueLearning(SaveContinueLearningEvent event, Emitter<ProgressState> emit) async {
    final data = {
      'practiceMode': event.practiceMode,
      'title': event.title,
      'nextItemId': event.nextItemId,
      'currentIndex': event.currentIndex,
      'totalCount': event.totalCount,
      'customWords': event.customWords,
      'timestamp': DateTime.now().toIso8601String(),
    };
    
    await repository.saveLastPractice(jsonEncode(data));
    final updatedLastPractice = await repository.getLastPractice();
    emit(state.copyWith(lastPracticeData: updatedLastPractice));
  }

  Future<void> _onCompleteCurriculumDay(CompleteCurriculumDayEvent event, Emitter<ProgressState> emit) async {
    await repository.incrementCurriculumDay();
    
    final now = DateTime.now();
    final dateStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    var dailyChallenge = await repository.getDailyChallenge(dateStr);
    if (dailyChallenge != null) {
      dailyChallenge.isCompleted = true;
      await repository.saveDailyChallenge(dailyChallenge);
    }

    add(LoadProgressEvent());
  }
}
