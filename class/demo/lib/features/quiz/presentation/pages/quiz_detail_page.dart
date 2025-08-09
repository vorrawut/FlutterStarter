import 'package:flutter/material.dart';

class QuizDetailPage extends StatelessWidget {
  final String quizId;

  const QuizDetailPage({super.key, required this.quizId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quiz $quizId')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Quiz Detail Page - Coming Soon'),
            Text('Quiz ID: $quizId'),
          ],
        ),
      ),
    );
  }
}
