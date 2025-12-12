import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProgressService extends ChangeNotifier {
  static const String _xpKey = 'user_xp';
  static const String _levelKey = 'user_level';
  static const String _badgesKey = 'unlocked_badges';
  static const String _highscoreKey = 'trivia_highscore';

  int _xp = 0;
  int _level = 1;
  int _highscore = 0;
  List<String> _unlockedBadges = [];

  int get xp => _xp;
  int get level => _level;
  int get highscore => _highscore;
  List<String> get unlockedBadges => _unlockedBadges;

  // Badge Definitions
  static const Map<String, String> badgeDetails = {
    'beginner': 'Reach Level 2',
    'scholar': 'Reach Level 5',
    'master': 'Reach Level 10',
    'sharp_shooter': 'Score 50+ in Trivia',
    'grand_master': 'Score 100+ in Trivia',
  };

  static const Map<String, IconData> badgeIcons = {
    'beginner': Icons.star_half_rounded,
    'scholar': Icons.school_rounded,
    'master': Icons.workspace_premium_rounded,
    'sharp_shooter': Icons.ads_click_rounded,
    'grand_master': Icons.military_tech_rounded,
  };

  SharedPreferences? _prefs;

  UserProgressService() {
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    _prefs = await SharedPreferences.getInstance();
    _xp = _prefs?.getInt(_xpKey) ?? 0;
    _level = _prefs?.getInt(_levelKey) ?? 1;
    _highscore = _prefs?.getInt(_highscoreKey) ?? 0;
    _unlockedBadges = _prefs?.getStringList(_badgesKey) ?? [];
    notifyListeners();
  }

  int get unlockedNamesCount => _level * 5;

  Future<void> addXp(int amount) async {
    _xp += amount;
    _checkLevelUp();
    await _prefs?.setInt(_xpKey, _xp);
    notifyListeners();
  }

  Future<void> updateHighscore(int score) async {
    if (score > _highscore) {
      _highscore = score;
      await _prefs?.setInt(_highscoreKey, _highscore);
      _checkHighscoreBadges(score);
      notifyListeners();
    } else {
       // Check badges typically on highscore, but we can verify here too
       _checkHighscoreBadges(score);
    }
  }

  void _checkLevelUp() {
    // Level 1: 0-99 XP
    // Level 2: 100-199 XP
    int newLevel = (_xp / 100).floor() + 1;
    if (newLevel > _level) {
      _level = newLevel;
      _prefs?.setInt(_levelKey, _level);
      _checkLevelBadges();
      // Logic for notifying user handled in UI by listening to level changes
    }
  }

  Future<void> unlockBadge(String badgeId) async {
    if (!_unlockedBadges.contains(badgeId)) {
      _unlockedBadges.add(badgeId);
      await _prefs?.setStringList(_badgesKey, _unlockedBadges);
      notifyListeners();
    }
  }

  Future<void> _unlockBadge(String badgeId) async {
    await unlockBadge(badgeId);
  }

  void _checkLevelBadges() {
    if (_level >= 2) _unlockBadge('beginner');
    if (_level >= 5) _unlockBadge('scholar');
    if (_level >= 10) _unlockBadge('master');
  }

  void _checkHighscoreBadges(int score) {
    if (score >= 50) _unlockBadge('sharp_shooter');
    if (score >= 100) _unlockBadge('grand_master');
  }
}
