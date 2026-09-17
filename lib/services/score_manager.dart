import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScoreManager {
  static final ScoreManager _instance = ScoreManager._internal();
  factory ScoreManager() => _instance;
  ScoreManager._internal();

  static const String _keyStars = 'abc_kids_stars_count';
  final ValueNotifier<int> starsNotifier = ValueNotifier<int>(0);

  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      starsNotifier.value = prefs.getInt(_keyStars) ?? 0;
    } catch (e) {
      debugPrint('ScoreManager init error: $e');
    }
  }

  Future<void> addStar() async {
    starsNotifier.value++;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_keyStars, starsNotifier.value);
    } catch (e) {
      debugPrint('ScoreManager addStar error: $e');
    }
  }

  Future<void> resetStars() async {
    starsNotifier.value = 0;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_keyStars, 0);
    } catch (e) {
      debugPrint('ScoreManager resetStars error: $e');
    }
  }
}
