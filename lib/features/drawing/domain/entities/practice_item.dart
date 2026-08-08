import 'package:equatable/equatable.dart';
import 'practice_mode.dart';

class PracticeItem extends Equatable {
  final String text;
  final PracticeMode mode;
  final bool isCursive;

  const PracticeItem({
    required this.text,
    required this.mode,
  }) : isCursive = mode == PracticeMode.learnCursiveUppercase ||
                   mode == PracticeMode.learnCursiveLowercase ||
                   mode == PracticeMode.learnWordsCursive ||
                   mode == PracticeMode.practiceCursiveUppercase ||
                   mode == PracticeMode.practiceCursiveLowercase;

  @override
  List<Object?> get props => [text, mode];
}
