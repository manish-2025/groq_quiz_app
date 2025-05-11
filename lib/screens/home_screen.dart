import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groq_quiz_app/controller/home_screen_controller.dart';
import '../screens/quiz_acreen.dart';
import '../screens/score_history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeScreenController controller = Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('GROQ Quiz App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            onPressed: () => Get.to(const ScoreHistoryScreen()),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: GetBuilder<HomeScreenController>(
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Select a Category',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200],
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: controller.selectedCategory,
                      isExpanded: true,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      items: controller.categories.entries.map((entry) {
                        return DropdownMenuItem(
                          value: entry.key,
                          child: Text(entry.value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        controller.selectedCategory = value!;
                        controller.updateState();
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Select Difficulty',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: controller.difficulties.map((difficulty) {
                    bool isSelected =
                        controller.selectedDifficulty == difficulty;
                    return GestureDetector(
                      onTap: () {
                        controller.selectedDifficulty = difficulty;
                        controller.updateState();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue : Colors.grey[300],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          difficulty,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: (controller.isLoading ? null : _startQuiz),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 10,
                    ),
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  child: SizedBox(
                    height: 35,
                    width: 200,
                    child: Center(
                      child: controller.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Start Quiz',
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _startQuiz() async {
    await controller.getQuestions();
    try {
      if (controller.questions.isNotEmpty) {
        Get.to(
          QuizScreen(
            questions: controller.questions,
            category: controller.selectedCategory,
            difficulty: controller.selectedDifficulty,
          ),
        );
      } else {
        Get.snackbar("", "No questions were generated. Please try again.");
      }
    } catch (e) {
      Get.snackbar("", 'Error: ${e.toString()}');
    } finally {
      controller.isLoading = false;
    }
  }
}
