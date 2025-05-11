import 'package:flutter/material.dart';
import '../models/score.dart';
import '../services/score_storage_service.dart';

class ScoreHistoryScreen extends StatelessWidget {
  const ScoreHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Score History'),
        ),
        body: FutureBuilder<List<Score>>(
            future: ScoreStorageService().getPastScores(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                    child: Text('Error loading scores: ${snapshot.error}'));
              }

              final scores = snapshot.data ?? [];

              if (scores.isEmpty) {
                return const Center(
                    child: Text(
                        'No quiz history yet. Take a quiz to see your scores here!'));
              }

              return ListView.builder(
                  itemCount: scores.length,
                  itemBuilder: (context, index) {
                    // Sort scores by date (most recent first)
                    final sortedScores = List<Score>.from(scores)
                      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));

                    final score = sortedScores[index];
                    final dateStr =
                        '${score.dateTime.day}/${score.dateTime.month}/${score.dateTime.year}';
                    final timeStr =
                        '${score.dateTime.hour}:${score.dateTime.minute.toString().padLeft(2, '0')}';

                    return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                (score.score / score.totalQuestions) >= 0.6
                                    ? Colors.green
                                    : Colors.orange,
                            child: Text(
                              '${(score.score / score.totalQuestions * 100).toStringAsFixed(0)}%',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(
                            '${score.category.toUpperCase()} - ${score.difficulty}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                              'Score: ${score.score}/${score.totalQuestions} • $dateStr at $timeStr'),
                        ));
                  });
            }));
  }
}
