import 'package:flutter/material.dart';
import 'ui/quiz_app.dart';
import 'data/quiz_repository.dart';
 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1 - Load the quiz data
  final quizRepository = QuizRepository();
  await quizRepository.loadQuizzes();

  // 2 - Display the quiz
  runApp(const QuizApp());
}
