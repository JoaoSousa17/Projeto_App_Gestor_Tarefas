class LevelCalculator {
  static int calculateLevel(int points) {
    int level = 1;
    int pointsRequired = 800;
    int totalPointsRequired = 0;

    while (points >= totalPointsRequired + pointsRequired) {
      level++;
      totalPointsRequired += pointsRequired;
      pointsRequired = (pointsRequired * 1.25).round();
    }

    return level;
  }

  static int pointsToNextLevel(int points) {
    int level = 1;
    int pointsRequired = 800;
    int totalPointsRequired = 0;

    while (points >= totalPointsRequired + pointsRequired) {
      level++;
      totalPointsRequired += pointsRequired;
      pointsRequired = (pointsRequired * 1.25).round();
    }

    return totalPointsRequired + pointsRequired - points;
  }
}