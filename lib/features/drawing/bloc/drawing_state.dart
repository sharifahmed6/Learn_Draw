import 'package:equatable/equatable.dart';
import '../domain/entities/practice_item.dart';

class DrawingState extends Equatable {
  final bool isAnimating;
  final bool isTracing;
  final bool isCompleted;
  final int currentIndex;
  final int currentLetterIndex;
  final int replayId;
  final List<PracticeItem> items;

  const DrawingState({
    this.isAnimating = false,
    this.isTracing = false,
    this.isCompleted = false,
    this.currentIndex = 0,
    this.currentLetterIndex = 0,
    this.replayId = 0,
    this.items = const [],
  });

  DrawingState copyWith({
    bool? isAnimating,
    bool? isTracing,
    bool? isCompleted,
    int? currentIndex,
    int? currentLetterIndex,
    int? replayId,
    List<PracticeItem>? items,
  }) {
    return DrawingState(
      isAnimating: isAnimating ?? this.isAnimating,
      isTracing: isTracing ?? this.isTracing,
      isCompleted: isCompleted ?? this.isCompleted,
      currentIndex: currentIndex ?? this.currentIndex,
      currentLetterIndex: currentLetterIndex ?? this.currentLetterIndex,
      replayId: replayId ?? this.replayId,
      items: items ?? this.items,
    );
  }

  @override
  List<Object> get props => [isAnimating, isTracing, isCompleted, currentIndex, currentLetterIndex, replayId, items];
}
