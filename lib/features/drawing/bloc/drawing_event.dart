import 'package:equatable/equatable.dart';

abstract class DrawingEvent extends Equatable {
  const DrawingEvent();

  @override
  List<Object> get props => [];
}

class DrawingAnimationStarted extends DrawingEvent {}

class DrawingTracingStarted extends DrawingEvent {}

class DrawingSubLetterCompleted extends DrawingEvent {}

class DrawingCompleted extends DrawingEvent {}

class DrawingNextLetterRequested extends DrawingEvent {}

class DrawingPreviousLetterRequested extends DrawingEvent {}

class DrawingReplayRequested extends DrawingEvent {}
