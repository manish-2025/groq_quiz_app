import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:groq_quiz_app/models/question.dart';
import 'package:groq_quiz_app/services/qroq_api_service.dart';

class HomeScreenController extends GetxController {
  final _apiService = GroqApiService();
  final categories = {
    'general': 'General Knowledge',
    'science': 'Science & Technology',
    'history': 'History',
    'geography': 'Geography',
    'movies': 'Movies & Entertainment',
  };

  final difficulties = ['Easy', 'Medium', 'Hard'];
  String selectedCategory = 'general';
  String selectedDifficulty = 'Medium';
  bool isLoading = false;

  List<Question> questions = [];

  Future<void> getQuestions() async {
    isLoading = true;
    updateState();
    questions = await _apiService.fetchQuestions(
      selectedCategory,
      selectedDifficulty.toLowerCase(),
    );

    update();
  }

  void updateState() {
    update();
  }
}
