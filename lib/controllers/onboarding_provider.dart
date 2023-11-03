import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardNotifier extends ChangeNotifier {
  bool isOnboardingPassed = false;
  bool _isLastPage = false;

  bool get isLastPage => _isLastPage;

  set isLastPage(bool isLastpage) {
    _isLastPage = isLastpage;
    notifyListeners();
  }

  void setOnboardingPassed() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isOnboardingPassed", true);
    print(prefs.getBool("isOnboardingPassed"));
    isOnboardingPassed = true;
    notifyListeners();
  }
}
