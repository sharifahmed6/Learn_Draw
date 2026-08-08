import '../../features/drawing/domain/entities/practice_mode.dart';
import '../../features/drawing/domain/entities/practice_item.dart';

class CurriculumDataset {
  static List<PracticeItem> getCurriculumForDay(int day) {
    // 30 day cycle, so modulo 30 (day 31 becomes day 1)
    int cycleDay = (day - 1) % 30 + 1;
    
    return _generateDay(cycleDay);
  }

  static List<PracticeItem> _generateDay(int day) {
    List<PracticeItem> items = [];
    
    // Day 7, 14, 20 are Type & Trace reviews as requested
    if (day == 7) {
      return [
        const PracticeItem(text: 'A', mode: PracticeMode.learnUppercase),
        const PracticeItem(text: 'C', mode: PracticeMode.learnUppercase),
        const PracticeItem(text: 'E', mode: PracticeMode.learnUppercase),
        const PracticeItem(text: 'G', mode: PracticeMode.learnUppercase),
        const PracticeItem(text: 'B', mode: PracticeMode.learnCursiveUppercase),
        const PracticeItem(text: 'F', mode: PracticeMode.learnCursiveUppercase),
      ];
    }
    if (day == 14) {
      return [
        const PracticeItem(text: 'H', mode: PracticeMode.learnUppercase),
        const PracticeItem(text: 'J', mode: PracticeMode.learnUppercase),
        const PracticeItem(text: 'L', mode: PracticeMode.learnUppercase),
        const PracticeItem(text: 'N', mode: PracticeMode.learnUppercase),
      ];
    }
    if (day == 20) {
      return [
        const PracticeItem(text: 'O', mode: PracticeMode.learnUppercase),
        const PracticeItem(text: 'Q', mode: PracticeMode.learnUppercase),
        const PracticeItem(text: 'S', mode: PracticeMode.learnUppercase),
        const PracticeItem(text: 'T', mode: PracticeMode.learnUppercase),
      ];
    }
    
    // Day 27, 28, 29, 30 are special reviews
    if (day == 27) {
      return [
        const PracticeItem(text: 'A', mode: PracticeMode.learnUppercase),
        const PracticeItem(text: 'M', mode: PracticeMode.learnUppercase),
        const PracticeItem(text: 'Z', mode: PracticeMode.learnUppercase),
        const PracticeItem(text: '0', mode: PracticeMode.learnNumbers),
        const PracticeItem(text: '4', mode: PracticeMode.learnNumbers),
        const PracticeItem(text: 'CAT', mode: PracticeMode.learnWordsSimple),
      ];
    }
    if (day == 28) {
      return [
        const PracticeItem(text: 'a', mode: PracticeMode.learnLowercase),
        const PracticeItem(text: 'm', mode: PracticeMode.learnLowercase),
        const PracticeItem(text: 'z', mode: PracticeMode.learnLowercase),
        const PracticeItem(text: '5', mode: PracticeMode.learnNumbers),
        const PracticeItem(text: '9', mode: PracticeMode.learnNumbers),
        const PracticeItem(text: 'DOG', mode: PracticeMode.learnWordsSimple),
      ];
    }
    if (day == 29) {
      return [
        const PracticeItem(text: 'A', mode: PracticeMode.learnCursiveUppercase),
        const PracticeItem(text: 'M', mode: PracticeMode.learnCursiveUppercase),
        const PracticeItem(text: 'Z', mode: PracticeMode.learnCursiveUppercase),
        const PracticeItem(text: 'HELLO', mode: PracticeMode.learnWordsCursive),
      ];
    }
    if (day == 30) {
      return [
        const PracticeItem(text: 'a', mode: PracticeMode.learnCursiveLowercase),
        const PracticeItem(text: 'm', mode: PracticeMode.learnCursiveLowercase),
        const PracticeItem(text: 'z', mode: PracticeMode.learnCursiveLowercase),
        const PracticeItem(text: 'WORLD', mode: PracticeMode.learnWordsCursive),
        const PracticeItem(text: ' ', mode: PracticeMode.practiceFreeWriting),
      ];
    }

    // Normal day logic
    // Day 1 to 26 matches letters A-Z (subtracting review days)
    int letterIndex = day - 1;
    if (day > 7) letterIndex -= 1;
    if (day > 14) letterIndex -= 1;
    if (day > 20) letterIndex -= 1;
    
    if (letterIndex >= 0 && letterIndex < 26) {
      String upper = String.fromCharCode(65 + letterIndex);
      String lower = String.fromCharCode(97 + letterIndex);
      
      items.add(PracticeItem(text: upper, mode: PracticeMode.learnUppercase));
      items.add(PracticeItem(text: lower, mode: PracticeMode.learnLowercase));
      items.add(PracticeItem(text: upper, mode: PracticeMode.learnCursiveUppercase));
      items.add(PracticeItem(text: lower, mode: PracticeMode.learnCursiveLowercase));
      
      // Numbers or words
      if (letterIndex < 10) {
        items.add(PracticeItem(text: letterIndex.toString(), mode: PracticeMode.learnNumbers));
      } else {
        const words = ['APPLE', 'BALL', 'CAT', 'DOG', 'EGG', 'FISH', 'GOAT', 'HAT', 'ICE', 'JUG', 'KEY', 'LION', 'MOON', 'NEST', 'OWL', 'PEN'];
        int wordIndex = letterIndex - 10;
        if (wordIndex >= 0 && wordIndex < words.length) {
          items.add(PracticeItem(text: words[wordIndex], mode: PracticeMode.learnWordsSimple));
        } else {
          items.add(PracticeItem(text: 'HELLO', mode: PracticeMode.learnWordsSimple));
        }
      }
    }
    
    return items;
  }
}
