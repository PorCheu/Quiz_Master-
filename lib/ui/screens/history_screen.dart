import 'package:flutter/material.dart';
import '../../model/quiz.dart';

class HistoryScreen extends StatelessWidget {
  final List<QuizAttempt> attempts;
  final VoidCallback onBack;

  const HistoryScreen({
    super.key,
    required this.attempts,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: onBack),
                  const Text('Quiz History', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              ),
            ),
            Expanded(
              child: attempts.isEmpty
                  ? const Center(child: Text('No attempts yet', style: TextStyle(color: Colors.white70, fontSize: 16)))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: attempts.length,
                      itemBuilder: (context, index) {
                        final attempt = attempts[attempts.length - 1 - index];
                        final pct = ((attempt.score / attempt.totalQuestions) * 100).toInt();
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(child: Text(attempt.quizTitle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1976D2)))),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: pct >= 60 ? Colors.green.shade200 : Colors.red.shade200,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text('$pct%', style: TextStyle(fontWeight: FontWeight.bold, color: pct >= 60 ? Colors.green.shade900 : Colors.red.shade900)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text('Score: ${attempt.score}/${attempt.totalQuestions}', style: const TextStyle(color: Colors.grey)),
                              const SizedBox(height: 4),
                              Text('Date: ${attempt.timestamp.toString().split('.')[0]}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
