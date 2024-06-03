import 'package:flutter/material.dart';

class LevelManager {
  static const Map<int, int> levelExpMap = {
    1: 0,
    2: 100,
    3: 300,
    4: 500,
    5: 700,
    6: 1000,
    7: 1500,
    8: 2100,
    9: 3000,
    10: 5000,
  };

  static int calculateLevel(int exp) {
    int level = 1;
    levelExpMap.forEach((key, value) {
      if (exp >= value) {
        level = key;
      }
    });
    return level;
  }

  static int getExpForNextLevel(int level) {
    if (levelExpMap.containsKey(level + 1)) {
      return levelExpMap[level + 1]!;
    }
    return levelExpMap[level]!;
  }

  static double getProgressToNextLevel(int exp) {
    int currentLevel = calculateLevel(exp);
    int nextLevelExp = getExpForNextLevel(currentLevel);
    int currentLevelExp = levelExpMap[currentLevel]!;

    if (nextLevelExp == currentLevelExp) {
      return 1.0;
    }
    return (exp - currentLevelExp) / (nextLevelExp - currentLevelExp);
  }
}
