import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screens/home_screen.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final String category;
  final String difficulty;

  const ResultScreen({
    Key? key,
    required this.score,
    required this.totalQuestions,
    required this.category,
    required this.difficulty,
  }) : super(key: key);

  double get percentage => (score / totalQuestions) * 100;

  String get resultMessage {
    if (percentage >= 80) {
      return 'Excellent! You\'re a quiz master!';
    } else if (percentage >= 60) {
      return 'Good job! You know your stuff!';
    } else if (percentage >= 40) {
      return 'Not bad, but there\'s room for improvement.';
    } else {
      return 'Keep trying, you\'ll do better next time!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Results'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Quiz Complete!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 80,
                backgroundColor: Colors.blue,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$score/$totalQuestions',
                      style: const TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${percentage.toStringAsFixed(0)}%',
                      style: const TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Text(
                resultMessage,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Category: ${category.toUpperCase()}',
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                'Difficulty: $difficulty',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Get.to(const HomeScreen());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    child: const Text(
                      'Home',
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      Get.to(const HomeScreen());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    child: const Text(
                      'Retry',
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
