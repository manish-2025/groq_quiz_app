import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/score.dart';

class ScoreStorageService {
  static const String scoresKey = 'quiz_scores';

  Future<List<Score>> getPastScores() async {
    final prefs = await SharedPreferences.getInstance();
    final String? scoresJson = prefs.getString(scoresKey);

    if (scoresJson == null) return [];

    List<dynamic> scoresList = jsonDecode(scoresJson);
    return scoresList.map((json) => Score.fromJson(json)).toList();
  }

  Future<void> saveScore(Score score) async {
    final prefs = await SharedPreferences.getInstance();
    List<Score> existingScores = await getPastScores();
    existingScores.add(score);

    List<Map<String, dynamic>> jsonList = existingScores.map((score) => score.toJson()).toList();
    await prefs.setString(scoresKey, jsonEncode(jsonList));
  }
}