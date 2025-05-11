import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/question.dart';

class GroqApiService {
  GroqApiService();

  String apiKey = 'gsk-aUzMc4m4gl090qElkbrOWGdyb3FYfWJ0uogPZDrsvHiPv0m3HXc8';
  final String baseUrl = "https://api.groq.com/openai/v1/chat/completions";

  Future<List<Question>> fetchQuestions(
      String category, String difficulty) async {
    try {
      String prompt = _buildPrompt(category, difficulty);
      final headers = {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer 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',
        'Cookie':
            '__cf_bm=tYhv77PRbguSBpe.rEVEY6wXtjvFJcAM_E0J.IQObSk-1746945180-1.0.1.1-eH5hJ.a4dWpZhvgWdDVIvTNPT.ASwTeu_vKatoLaZq1jeq96ubZ8gJkar_yciL7ptKsLPaXRNsHZm_Q4eBBREgjdzb31YyvGINUS.2PcBlo',
      };
      final body = jsonEncode({
        "model": "llama3-70b-8192",
        "messages": [
          {
            "role": "user",
            "content": prompt,
          }
        ]
      });

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        try {
          final responseData = jsonDecode(response.body);

          final content = responseData['choices']?[0]?['message']?['content'];
          if (content == null || content is! String) {
            throw Exception('Invalid response format: missing content.');
          }

          // Try to extract a JSON object from a possibly wrapped text
          final jsonRegex = RegExp(r'{[\s\S]*}');
          final match = jsonRegex.firstMatch(content);
          final jsonContent = match != null ? match.group(0)! : content;

          final questionsJson = jsonDecode(jsonContent);

          final List<Question> questions = [];
          if (questionsJson is Map<String, dynamic> &&
              questionsJson['questions'] is List) {
            for (var questionJson in questionsJson['questions']) {
              if (questionJson is Map<String, dynamic>) {
                questions.add(Question.fromJson(questionJson));
              }
            }
          } else {
            throw Exception(
                'Invalid JSON format: "questions" not found or malformed.');
          }

          return questions;
        } catch (e) {
          throw Exception('Failed to parse response: $e');
        }
      } else {
        throw Exception(
          'Failed to load questions: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching questions: $e');
    }
  }

  String _buildPrompt(String category, String difficulty) {
    return '''
    Generate 5 random multiple-choice questions on $category with $difficulty difficulty. 
    Return JSON in the following format:
    {
      "questions": [
        {
          "question": "Question text here?",
          "options": ["Option A", "Option B", "Option C", "Option D"],
          "correctAnswer": "Option that is correct"
        },
        // more questions...
      ]
    }
    Return ONLY valid JSON without any explanation or additional text.
    ''';
  }
}
