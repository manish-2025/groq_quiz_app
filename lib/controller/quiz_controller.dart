import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:groq_quiz_app/models/question.dart';

class QuizController extends GetxController {
  int currentQuestionIndex = 0;
  int selectedIndex = 0;
  int score = 0;
  bool answered = false;
  String? selectedAnswer;
  Timer? questionTimer;
  int remainingSeconds = 30;
  Color buttonColor = Colors.blue;
  List<Question> questions = [];
  String category = 'general';
  String difficulty = 'Medium';

  void getQuizData({
    required List<Question> questions,
    required String category,
    required String difficulty,
  }) {
    this.questions.addAll(questions);
    this.category = category;
    this.difficulty = difficulty;
    updateState();
  }

  updateState() {
    update();
  }
}
