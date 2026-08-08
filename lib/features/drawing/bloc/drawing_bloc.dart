import 'package:flutter_bloc/flutter_bloc.dart';
import 'drawing_event.dart';
import 'drawing_state.dart';
import '../domain/entities/practice_mode.dart';
import '../domain/entities/practice_item.dart';
import '../../../../core/utils/premium_manager.dart';

class DrawingBloc extends Bloc<DrawingEvent, DrawingState> {
  DrawingBloc(PracticeMode mode, {List<String>? customWords, List<PracticeItem>? customItems, int initialIndex = 0}) 
      : super(DrawingState(items: customItems ?? _generateItems(mode, customWords: customWords), currentIndex: initialIndex)) {
    on<DrawingAnimationStarted>((event, emit) {
      emit(state.copyWith(isAnimating: true, isTracing: false, isCompleted: false));
    });

    on<DrawingTracingStarted>((event, emit) {
      emit(state.copyWith(isAnimating: false, isTracing: true, isCompleted: false));
    });

    on<DrawingCompleted>((event, emit) {
      emit(state.copyWith(isAnimating: false, isTracing: false, isCompleted: true));
    });

    on<DrawingSubLetterCompleted>((event, emit) {
      if (state.items.isEmpty) return;
      final currentWord = state.items[state.currentIndex].text;
      
      if (state.currentLetterIndex < currentWord.length - 1) {
        emit(state.copyWith(
          currentLetterIndex: state.currentLetterIndex + 1,
          isAnimating: false,
          isTracing: true,
          isCompleted: false,
        ));
      } else {
        emit(state.copyWith(isAnimating: false, isTracing: false, isCompleted: true));
      }
    });

    on<DrawingNextLetterRequested>((event, emit) {
      if (state.currentIndex < state.items.length - 1) {
        emit(state.copyWith(
          currentIndex: state.currentIndex + 1,
          currentLetterIndex: 0,
          isAnimating: false,
          isTracing: false,
          isCompleted: false,
        ));
      }
    });

    on<DrawingPreviousLetterRequested>((event, emit) {
      if (state.currentIndex > 0) {
        emit(state.copyWith(
          currentIndex: state.currentIndex - 1,
          currentLetterIndex: 0,
          isAnimating: false,
          isTracing: false,
          isCompleted: false,
        ));
      }
    });

    on<DrawingReplayRequested>((event, emit) {
      emit(state.copyWith(
        replayId: state.replayId + 1,
        currentLetterIndex: 0,
        isAnimating: false,
        isTracing: false,
        isCompleted: false,
      ));
    });
  }

  static List<PracticeItem> _generateItems(PracticeMode mode, {List<String>? customWords}) {
    List<String> textItems;
    
    if (customWords != null && customWords.isNotEmpty) {
      textItems = customWords;
    } else {
      switch (mode) {
        case PracticeMode.learnUppercase:
        case PracticeMode.learnCursiveUppercase:
        case PracticeMode.practiceUppercase:
        case PracticeMode.practiceCursiveUppercase:
          textItems = List.generate(26, (i) => String.fromCharCode(65 + i)); // 'A' to 'Z'
          break;
          
        case PracticeMode.learnLowercase:
        case PracticeMode.learnCursiveLowercase:
        case PracticeMode.practiceLowercase:
        case PracticeMode.practiceCursiveLowercase:
          textItems = List.generate(26, (i) => String.fromCharCode(97 + i)); // 'a' to 'z'
          break;
          
        case PracticeMode.learnNumbers:
          textItems = List.generate(10, (i) => i.toString()); // '0' to '9'
          break;
          
        case PracticeMode.learnWordsSimple:
        case PracticeMode.learnWordsCursive:
        case PracticeMode.practiceWords:
          textItems = ['APPLE', 'BALL', 'CAT', 'DOG', 'EGG', 'FISH', 'GOAT', 'HAT', 'ICE', 'JUG'];
          break;
          
        case PracticeMode.practiceCustomWords:
          textItems = ['HELLO'];
          break;
          
        case PracticeMode.practiceFreeWriting:
          textItems = [' ']; // Empty space or blank canvas for free writing
          break;
          
        case PracticeMode.dailyChallenge:
          textItems = [];
          break;
      }
    }
    
    // Removal of truncation logic: We want the list to show its full size (e.g. 1 of 26)
    // The restriction is now handled at the UI layer (DrawingPage) when the user clicks 'Next'
    
    return textItems.map((text) => PracticeItem(text: text, mode: mode)).toList();
  }
}
