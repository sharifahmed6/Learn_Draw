import 'package:equatable/equatable.dart';

abstract class ProgressEvent extends Equatable {
  const ProgressEvent();

  @override
  List<Object> get props => [];
}

class LoadProgressEvent extends ProgressEvent {}

class SavePracticeResultEvent extends ProgressEvent {
  final String itemId;
  final String category;
  final String practiceType;
  final int score;
  final int durationSeconds;

  const SavePracticeResultEvent({
    required this.itemId,
    required this.category,
    required this.practiceType,
    required this.score,
    required this.durationSeconds,
  });

  @override
  List<Object> get props => [itemId, category, practiceType, score, durationSeconds];
}

class SaveContinueLearningEvent extends ProgressEvent {
  final String practiceMode;
  final String title;
  final String nextItemId;
  final int currentIndex;
  final int totalCount;
  final List<String>? customWords;

  const SaveContinueLearningEvent({
    required this.practiceMode,
    required this.title,
    required this.nextItemId,
    required this.currentIndex,
    required this.totalCount,
    this.customWords,
  });

  @override
  List<Object> get props => [practiceMode, title, nextItemId, currentIndex, totalCount, customWords ?? <Object>[]];
}

class CompleteCurriculumDayEvent extends ProgressEvent {}
