import 'package:flutter/material.dart';
import '../../model/quiz.dart';

class ResultScreen extends StatelessWidget {
  final Quiz quiz;
  final List<int?> answers;
  final VoidCallback onRestart;
  final VoidCallback onHistory;

  const ResultScreen({
    super.key,
    required this.quiz,
    required this.answers,
    required this.onRestart,
    required this.onHistory,
  });

  @override
  Widget build(BuildContext context) {
    // Find the last answered question
    int lastAnsweredIndex = -1;
    for (int i = 0; i < answers.length; i++) {
      if (answers[i] != null && answers[i] != -1) {
        lastAnsweredIndex = i;
      } else {
        break;
      }
    }
    
    // Count questions answered and correct answers
    int questionsAnswered = lastAnsweredIndex + 1;
    int correct = 0;
    for (int i = 0; i <= lastAnsweredIndex; i++) {
      if (answers[i] == quiz.questions[i].correctAnswerIndex) correct++;
    }
    final percentage = questionsAnswered > 0 ? ((correct / questionsAnswered) * 100).toInt() : 0;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text('Quiz Completed!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
                      const Text('Your Score', style: TextStyle(fontSize: 16, color: Colors.grey)),
                      const SizedBox(height: 10),
                      Text('$correct/$questionsAnswered', style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Color(0xFF2196F3))),
                      const SizedBox(height: 10),
                      Text('$percentage%', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: percentage >= 60 ? Colors.green : Colors.red)),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                const Text('Review Your Answers', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 15),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: questionsAnswered,
                  itemBuilder: (context, index) {
                    final question = quiz.questions[index];
                    final userAnswer = answers[index];
                    final isCorrect = userAnswer == question.correctAnswerIndex;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isCorrect ? Colors.green.shade200 : Colors.red.shade200,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isCorrect ? Colors.green : Colors.red, width: 2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(shape: BoxShape.circle, color: isCorrect ? Colors.green : Colors.red),
                                child: Center(child: Icon(isCorrect ? Icons.check : Icons.close, color: Colors.white, size: 16)),
                              ),
                              const SizedBox(width: 10),
                              Expanded(child: Text('Question ${index + 1}', style: TextStyle(fontWeight: FontWeight.bold, color: isCorrect ? Colors.green.shade900 : Colors.red.shade900))),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(question.question, style: TextStyle(fontWeight: FontWeight.bold, color: isCorrect ? Colors.green.shade900 : Colors.red.shade900)),
                          const SizedBox(height: 8),
                          Text('Your: ${question.options[userAnswer!]}', style: TextStyle(color: isCorrect ? Colors.green.shade900 : Colors.red.shade900)),
                          if (!isCorrect) ...[const SizedBox(height: 5), Text('Correct: ${question.options[question.correctAnswerIndex]}', style: TextStyle(color: Colors.red.shade900, fontWeight: FontWeight.bold))],
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: onRestart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text('Restart Quiz', style: TextStyle(color: Color(0xFF2196F3), fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: onHistory,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text('View History', style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
 