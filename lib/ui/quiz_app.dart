import 'package:flutter/material.dart';
import '../model/quiz.dart';
import '../data/quiz_repository.dart';
import 'screens/welcome_screen.dart';
import 'screens/question_screen.dart';
import 'screens/result_screen.dart';
import 'screens/history_screen.dart';

enum AppScreen { welcome, question, result, history }

class QuizApp extends StatefulWidget {
  const QuizApp({super.key});

  @override
  State<QuizApp> createState() => _QuizAppState();
}

class _QuizAppState extends State<QuizApp> {
  final QuizRepository quizRepository = QuizRepository();
  
  List<Quiz> quizzes = [];
  List<QuizAttempt> attempts = [];
  AppScreen currentScreen = AppScreen.welcome;
  
  int currentQuestionIndex = 0;
  int? selectedAnswerIndex;
  List<int?> userAnswers = [];
  bool isAnswered = false;

  Future<void> loadData() async {
    final quiz = await quizRepository.loadQuizzes();
    final history = await quizRepository.loadAttempts();
    setState(() {
      quizzes = quiz;
      attempts = history;
    });
  }

  void startQuiz() {
    setState(() {
      currentScreen = AppScreen.question;
      currentQuestionIndex = 0;
      selectedAnswerIndex = null;
      userAnswers = List<int?>.filled(quizzes[0].questions.length, null);
      isAnswered = false;
    });
  }

  void selectAnswer(int index) {
    if (!isAnswered) {
      setState(() {
        selectedAnswerIndex = index;
        userAnswers[currentQuestionIndex] = index;
        isAnswered = true;
      });

      // Auto-navigate after showing answer
      Future.delayed(const Duration(milliseconds: 1500), () {
        nextQuestion();
      });
    }
  }

  void nextQuestion() {
    if (currentQuestionIndex < quizzes[0].questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswerIndex = userAnswers[currentQuestionIndex];
        isAnswered = selectedAnswerIndex != null;
      });
    } else {
      finishQuiz();
    }
  }

  void finishQuiz() async {
    int correctCount = 0;
    for (int i = 0; i < userAnswers.length; i++) {
      if (userAnswers[i] != null && userAnswers[i] == quizzes[0].questions[i].correctAnswerIndex) {
        correctCount++;
      }
    }

    final attempt = QuizAttempt(
      quizId: quizzes[0].id,
      quizTitle: quizzes[0].title,
      userAnswers: userAnswers,
      score: correctCount,
      timestamp: DateTime.now(),
    );

    await quizRepository.saveAttempt(attempt);
    await loadData();

    setState(() {
      currentScreen = AppScreen.result;
    });
  }

  void restartQuiz() {
    setState(() {
      currentScreen = AppScreen.welcome;
      currentQuestionIndex = 0;
      selectedAnswerIndex = null;
      userAnswers = [];
      isAnswered = false;
    });
  }

  void viewHistory() {
    setState(() {
      currentScreen = AppScreen.history;
    });
  }

  void backFromHistory() {
    setState(() {
      currentScreen = AppScreen.welcome;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    if (quizzes.isEmpty) {
      loadData();
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: quizzes.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : buildCurrentScreen(),
      ),
    );
  }

  Widget buildCurrentScreen() {
    switch (currentScreen) {
      case AppScreen.welcome:
        return WelcomeScreen(
          quiz: quizzes[0],
          onStart: startQuiz,
          onHistory: viewHistory,
        );
      case AppScreen.question:
        return QuestionScreen(
          quiz: quizzes[0],
          questionIndex: currentQuestionIndex,
          selected: selectedAnswerIndex,
          onSelect: selectAnswer,
          onNext: nextQuestion,
          isLast: currentQuestionIndex == quizzes[0].questions.length - 1,
          answered: isAnswered,
        );
      case AppScreen.result:
        return ResultScreen(
          quiz: quizzes[0],
          answers: userAnswers,
          onRestart: restartQuiz,
          onHistory: viewHistory,
        );
      case AppScreen.history:
        return HistoryScreen(
          attempts: attempts,
          onBack: backFromHistory,
        );
    }
  }
}
