import 'package:equatable/equatable.dart';
import '../../data/models/user_progress_model.dart';
import '../../data/models/streak_model.dart';
import '../../data/models/practice_history_model.dart';

import '../../data/models/daily_challenge_model.dart';

class ProgressState extends Equatable {
  final bool isLoading;
  final List<UserProgressModel> userProgress;
  final List<PracticeHistoryModel> practiceHistory;
  final StreakModel? streak;
  final Map<String, dynamic>? lastPracticeData;
  final DailyChallengeModel? dailyChallenge;
  final List<UserProgressModel> recommendedPractices;
  final List<String> availableWords;
  final int curriculumDay;
  final Map<String, Map<String, int>> monthlyItemCounts;
  final int totalPracticeThisMonth;
  final int itemsCompletedThisMonth;
  
  final Map<String, Map<String, int>> previousMonthlyItemCounts;
  final int previousTotalPracticeThisMonth;
  final int previousItemsCompletedThisMonth;
  final bool hasPreviousProgress;

  const ProgressState({
    this.isLoading = false,
    this.userProgress = const [],
    this.practiceHistory = const [],
    this.streak,
    this.lastPracticeData,
    this.dailyChallenge,
    this.recommendedPractices = const [],
    this.availableWords = const [],
    this.curriculumDay = 1,
    this.monthlyItemCounts = const {},
    this.totalPracticeThisMonth = 0,
    this.itemsCompletedThisMonth = 0,
    this.previousMonthlyItemCounts = const {},
    this.previousTotalPracticeThisMonth = 0,
    this.previousItemsCompletedThisMonth = 0,
    this.hasPreviousProgress = false,
  });

  ProgressState copyWith({
    bool? isLoading,
    List<UserProgressModel>? userProgress,
    List<PracticeHistoryModel>? practiceHistory,
    StreakModel? streak,
    Map<String, dynamic>? lastPracticeData,
    DailyChallengeModel? dailyChallenge,
    List<UserProgressModel>? recommendedPractices,
    List<String>? availableWords,
    int? curriculumDay,
    Map<String, Map<String, int>>? monthlyItemCounts,
    int? totalPracticeThisMonth,
    int? itemsCompletedThisMonth,
    Map<String, Map<String, int>>? previousMonthlyItemCounts,
    int? previousTotalPracticeThisMonth,
    int? previousItemsCompletedThisMonth,
    bool? hasPreviousProgress,
  }) {
    return ProgressState(
      isLoading: isLoading ?? this.isLoading,
      userProgress: userProgress ?? this.userProgress,
      practiceHistory: practiceHistory ?? this.practiceHistory,
      streak: streak ?? this.streak,
      lastPracticeData: lastPracticeData ?? this.lastPracticeData,
      dailyChallenge: dailyChallenge ?? this.dailyChallenge,
      recommendedPractices: recommendedPractices ?? this.recommendedPractices,
      availableWords: availableWords ?? this.availableWords,
      curriculumDay: curriculumDay ?? this.curriculumDay,
      monthlyItemCounts: monthlyItemCounts ?? this.monthlyItemCounts,
      totalPracticeThisMonth: totalPracticeThisMonth ?? this.totalPracticeThisMonth,
      itemsCompletedThisMonth: itemsCompletedThisMonth ?? this.itemsCompletedThisMonth,
      previousMonthlyItemCounts: previousMonthlyItemCounts ?? this.previousMonthlyItemCounts,
      previousTotalPracticeThisMonth: previousTotalPracticeThisMonth ?? this.previousTotalPracticeThisMonth,
      previousItemsCompletedThisMonth: previousItemsCompletedThisMonth ?? this.previousItemsCompletedThisMonth,
      hasPreviousProgress: hasPreviousProgress ?? this.hasPreviousProgress,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        userProgress,
        practiceHistory,
        streak,
        lastPracticeData,
        dailyChallenge,
        recommendedPractices,
        availableWords,
        curriculumDay,
        monthlyItemCounts,
        totalPracticeThisMonth,
        itemsCompletedThisMonth,
        previousMonthlyItemCounts,
        previousTotalPracticeThisMonth,
        previousItemsCompletedThisMonth,
        hasPreviousProgress,
      ];
}
