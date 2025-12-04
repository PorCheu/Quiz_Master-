import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/quiz.dart';

class QuizRepository {
  static const String _historyKey = 'quiz_history';

  Future<List<Quiz>> loadQuizzes() async {
    try {
      final jsonString = await rootBundle.loadString('lib/data/quizzes.json');
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final quizzes = (json['quizzes'] as List)
          .map((q) => Quiz.fromJson(q))
          .toList();
      return quizzes;
    } catch (e) {
      print('Error loading quizzes: $e');
      // Return default quiz if file not found
      return [
        Quiz(
          id: 'quiz_1',
          title: 'General Knowledge',
          questions: [
            Question(
              id: 'q1',
              question: 'Who is the best teacher?',
              options: ['Ronan', 'Hongly', 'Leangsiv'],
              correctAnswerIndex: 1,
            ),
            Question(
              id: 'q2',
              question: 'What is the best color?',
              options: ['Blue', 'Red', 'Green'],
              correctAnswerIndex: 2,
            ),
          ],
        )
      ];
    }
  }

  Future<void> saveAttempt(QuizAttempt attempt) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<QuizAttempt> attempts = await loadAttempts();
      attempts.add(attempt);
      final jsonString = jsonEncode(attempts.map((a) => a.toJson()).toList());
      await prefs.setString(_historyKey, jsonString);
    } catch (e) {
      print('Error saving attempt: $e');
    }
  }

  Future<List<QuizAttempt>> loadAttempts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_historyKey);
      
      if (jsonString == null) {
        return [];
      }
      
      final json = jsonDecode(jsonString) as List;
      return json.map((a) => QuizAttempt.fromJson(a)).toList();
    } catch (e) {
      print('Error loading attempts: $e');
      return [];
    }
  }
}
