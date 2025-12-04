class Question {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;

  Question({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'question': question,
    'options': options,
    'correctAnswerIndex': correctAnswerIndex,
  };

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    id: json['id'],
    question: json['question'],
    options: List<String>.from(json['options']),
    correctAnswerIndex: json['correctAnswerIndex'],
  );
}

class Quiz {
  final String id;
  final String title;
  final List<Question> questions;

  Quiz({
    required this.id,
    required this.title,
    required this.questions,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'questions': questions.map((q) => q.toJson()).toList(),
  };

  factory Quiz.fromJson(Map<String, dynamic> json) => Quiz(
    id: json['id'],
    title: json['title'],
    questions: (json['questions'] as List)
        .map((q) => Question.fromJson(q))
        .toList(),
  );
}

class QuizAttempt {
  final String quizId;
  final String quizTitle;
  final List<int?> userAnswers;
  final int score;
  final DateTime timestamp;

  QuizAttempt({
    required this.quizId,
    required this.quizTitle,
    required this.userAnswers,
    required this.score,
    required this.timestamp,
  });

  int get totalQuestions => userAnswers.length;

  Map<String, dynamic> toJson() => {
    'quizId': quizId,
    'quizTitle': quizTitle,
    'userAnswers': userAnswers,
    'score': score,
    'timestamp': timestamp.toIso8601String(),
  };

  factory QuizAttempt.fromJson(Map<String, dynamic> json) => QuizAttempt(
    quizId: json['quizId'],
    quizTitle: json['quizTitle'],
    userAnswers: List<int?>.from(json['userAnswers']),
    score: json['score'],
    timestamp: DateTime.parse(json['timestamp']),
  );
}