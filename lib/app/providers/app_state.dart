import 'package:flutter/foundation.dart';

class AppState extends ChangeNotifier {
  int _completedBreaks = 0;
  int _dailyGoal = 4;

  int get completedBreaks => _completedBreaks;
  int get dailyGoal => _dailyGoal;

  double get dailyProgress {
    if (_dailyGoal <= 0) {
      return 0;
    }

    return (_completedBreaks / _dailyGoal).clamp(0.0, 1.0);
  }

  void completeMovement() {
    _completedBreaks++;
    notifyListeners();
  }

  void setDailyGoal(int goal) {
    if (goal < 1 || goal == _dailyGoal) {
      return;
    }

    _dailyGoal = goal;
    notifyListeners();
  }

  void resetDailyProgress() {
    _completedBreaks = 0;
    notifyListeners();
  }
}
