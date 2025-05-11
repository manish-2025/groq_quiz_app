import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groq_quiz_app/controller/quiz_controller.dart';
import '../models/question.dart';
import '../models/score.dart';
import '../services/score_storage_service.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  final List<Question> questions;
  final String category;
  final String difficulty;

  const QuizScreen({
    Key? key,
    required this.questions,
    required this.category,
    required this.difficulty,
  }) : super(key: key);

  @override
  QuizScreenState createState() => QuizScreenState();
}

class QuizScreenState extends State<QuizScreen> {
  QuizController controller = Get.put(QuizController());

  @override
  void initState() {
    controller.getQuizData(
      questions: widget.questions,
      category: widget.category,
      difficulty: widget.difficulty,
    );
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    controller.questionTimer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    switch (controller.difficulty.toLowerCase()) {
      case 'easy':
        controller.remainingSeconds = 30;
        break;
      case 'medium':
        controller.remainingSeconds = 25;
        break;
      case 'hard':
        controller.remainingSeconds = 15;
        break;
      default:
        controller.remainingSeconds = 30;
    }

    controller.questionTimer?.cancel();
    controller.questionTimer =
        Timer.periodic(const Duration(seconds: 1), (timer) {
      if (controller.remainingSeconds > 0) {
        controller.remainingSeconds--;
      } else {
        _timeUp();
      }
      controller.updateState();
    });
  }

  void _timeUp() {
    controller.questionTimer?.cancel();
    if (!controller.answered) {
      controller.answered = true;
      controller.updateState();
      Future.delayed(const Duration(seconds: 2), () {
        _moveToNextQuestion();
      });
    }
  }

  void _checkAnswer({required String answer, required int index}) {
    if (controller.answered) return;
    controller.selectedIndex = index;

    controller.selectedAnswer = answer;
    controller.answered = true;

    if (answer ==
        controller.questions[controller.currentQuestionIndex].correctAnswer) {
      controller.score++;
    }
    controller.updateState();
    controller.questionTimer?.cancel();
  }

  void _moveToNextQuestion() {
    if (controller.currentQuestionIndex < controller.questions.length - 1) {
      controller.currentQuestionIndex++;
      controller.answered = false;
      controller.selectedAnswer = null;

      _startTimer();
    } else {
      // End of quiz
      _saveScore();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            score: controller.score,
            totalQuestions: controller.questions.length,
            category: widget.category,
            difficulty: widget.difficulty,
          ),
        ),
      );
    }
  }

  void _saveScore() async {
    final scoreService = ScoreStorageService();
    final newScore = Score(
      category: widget.category,
      difficulty: widget.difficulty,
      score: controller.score,
      totalQuestions: controller.questions.length,
      dateTime: DateTime.now(),
    );
    await scoreService.saveScore(newScore);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<QuizController>(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Question ${controller.currentQuestionIndex + 1}/${controller.questions.length}',
              ),
              automaticallyImplyLeading: false,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.timer,
                        color: controller.remainingSeconds < 10
                            ? Colors.red
                            : Colors.blue,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Time: ${controller.remainingSeconds} seconds',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: controller.remainingSeconds < 10
                              ? Colors.red
                              : Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: (controller.currentQuestionIndex + 1) /
                        controller.questions.length,
                    backgroundColor: Colors.purple,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    flex: 2,
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                          child: SingleChildScrollView(
                            child: Text(
                              controller
                                  .questions[controller.currentQuestionIndex]
                                  .question,
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    flex: 3,
                    child: ListView.builder(
                      itemCount: controller
                          .questions[controller.currentQuestionIndex]
                          .options
                          .length,
                      itemBuilder: (context, index) {
                        final option = controller
                            .questions[controller.currentQuestionIndex]
                            .options[index];

                        return GestureDetector(
                          onTap: controller.answered
                              ? null
                              : () {
                                  _checkAnswer(answer: option, index: index);
                                  controller.updateState();
                                },
                          child: Container(
                            height: 50,
                            width: 300,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: getColor(index: index, isDark: false),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                width: controller.answered ? 2 : 1,
                                color: getColor(index: index),
                              ),
                            ),
                            child: Center(
                              child: Text(option),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                          controller.answered ? Colors.orange : Colors.grey),
                    ),
                    onPressed: () {
                      if (controller.answered) {
                        _moveToNextQuestion();
                      }
                    },
                    child: const Text(
                      'Next Question',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Score: ${controller.score}/${controller.questions.length}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  getColor({required int index, bool isDark = true}) {
    return controller.answered
        ? (controller
                    .questions[controller.currentQuestionIndex].correctAnswer ==
                controller
                    .questions[controller.currentQuestionIndex].options[index])
            ? isDark
                ? Colors.green
                : Colors.green.shade300
            : (index == controller.selectedIndex && controller.answered)
                ? isDark
                    ? Colors.red
                    : Colors.red.shade300
                : Colors.grey.shade300
        : Colors.grey.shade300;
  }
}
