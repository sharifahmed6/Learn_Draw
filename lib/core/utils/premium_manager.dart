class PremiumManager {
  // Set this to true to unlock all features, false to lock premium features
  static bool isPremium = false;
  
  // Stores the name of the active plan (e.g., 'Yearly', 'Monthly')
  static String activePlanName = 'Yearly';
  
  // Maximum number of items free users can practice in a single mode
  static const int freeItemLimit = 5;

  // Check if a specific item (letter/word) is locked for the current user
  static bool isItemLocked(String itemId) {
    if (isPremium) return false;
    
    if (itemId.length == 1) {
      int code = itemId.codeUnitAt(0);
      if (code >= 65 && code <= 90) return code > 69; // Free: A-E
      if (code >= 97 && code <= 122) return code > 101; // Free: a-e
      if (code >= 48 && code <= 57) return code > 52; // Free: 0-4
    } else {
      const freeWords = ['APPLE', 'BALL', 'CAT', 'DOG', 'EGG'];
      return !freeWords.contains(itemId.toUpperCase());
    }
    return false;
  }
}
