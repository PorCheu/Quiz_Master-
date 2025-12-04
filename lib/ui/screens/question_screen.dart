import 'package:flutter/material.dart';
import '../../model/quiz.dart';

class QuestionScreen extends StatefulWidget {
  final Quiz quiz;
  final int questionIndex;
  final int? selected;
  final Function(int) onSelect;
  final VoidCallback onNext;
  final bool isLast;
  final bool answered;

  const QuestionScreen({
    super.key,
    required this.quiz,
    required this.questionIndex,
    required this.selected,
    required this.onSelect,
    required this.onNext,
    required this.isLast,
    required this.answered,
  });

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  @override
  Widget build(BuildContext context) {
    final question = widget.quiz.questions[widget.questionIndex];
    final progress = (widget.questionIndex + 1) / widget.quiz.questions.length;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            children: [
              // Progress bar and counter
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Question ${widget.questionIndex + 1}/${widget.quiz.questions.length}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 6,
                            backgroundColor: Colors.white24,
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '${widget.questionIndex + 1}/${widget.quiz.questions.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // Question Container
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 0,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 24,
                          decoration: BoxDecoration(
                            color: const Color(0xFF667EEA),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Question',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      question.question,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              // Options
              Expanded(
                child: ListView.builder(
                  itemCount: question.options.length,
                  itemBuilder: (context, index) {
                    final isSelected = widget.selected == index;
                    final isCorrect = index == question.correctAnswerIndex;

                    Color bgColor;
                    Color borderColor;
                    Color txtColor;
                    Color optionLabelColor;

                    if (!widget.answered) {
                      if (isSelected) {
                        bgColor = const Color(0xFF667EEA).withOpacity(0.15);
                        borderColor = const Color(0xFF667EEA);
                        txtColor = const Color(0xFF333333);
                        optionLabelColor = const Color(0xFF667EEA);
                      } else {
                        bgColor = Colors.white.withOpacity(0.5);
                        borderColor = Colors.white.withOpacity(0.3);
                        txtColor = const Color(0xFF666666);
                        optionLabelColor = Colors.grey;
                      }
                    } else {
                      if (isCorrect) {
                        bgColor = Colors.green.withOpacity(0.15);
                        borderColor = Colors.green;
                        txtColor = Colors.green.shade800;
                        optionLabelColor = Colors.green;
                      } else if (isSelected && !isCorrect) {
                        bgColor = Colors.red.withOpacity(0.15);
                        borderColor = Colors.red;
                        txtColor = Colors.red.shade800;
                        optionLabelColor = Colors.red;
                      } else {
                        bgColor = Colors.grey.withOpacity(0.08);
                        borderColor = Colors.grey.withOpacity(0.2);
                        txtColor = const Color(0xFF999999);
                        optionLabelColor = Colors.grey;
                      }
                    }

                    return GestureDetector(
                      onTap: widget.answered ? null : () => widget.onSelect(index),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: bgColor,
                          border: Border.all(color: borderColor, width: 2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: optionLabelColor.withOpacity(0.2),
                                border: Border.all(color: optionLabelColor, width: 2),
                              ),
                              child: Center(
                                child: widget.answered && isCorrect
                                    ? Icon(Icons.check, color: optionLabelColor, size: 18)
                                    : widget.answered && isSelected && !isCorrect
                                        ? Icon(Icons.close, color: optionLabelColor, size: 18)
                                        : Text(
                                            String.fromCharCode(65 + index), // A, B, C, D...
                                            style: TextStyle(
                                              color: optionLabelColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                question.options[index],
                                style: TextStyle(
                                  color: txtColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              // Next/Submit Button
              if (widget.answered)
                Container(
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: widget.onNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.isLast ? 'See Results' : 'Next Question',
                          style: const TextStyle(
                            color: Color(0xFF667EEA),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward,
                          color: Color(0xFF667EEA),
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.touch_app, color: Colors.white70, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Select an answer to continue',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
 