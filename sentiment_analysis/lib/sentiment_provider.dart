import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class SentimentProvider with ChangeNotifier {
  String status = "Positive";

  final model = GenerativeModel(
    model: 'gemini-2.5-flash',
    apiKey: 'AIzaSyCPEHhJfgQD7LcRTktB9G9FNyZyzi7_KcA',
  );

  bool isLoading = false;

  Future<void> analyzeSentiment(String text) async {
    if (text.isEmpty) return;

    isLoading = true;
    notifyListeners();

    try {
      final prompt =
          '''
      Analyze the sentiment of the given text.
      Return only one word from this list:
      Positive, Negative, Neutral
      
      Text: "$text"
      ''';

      final response = await model.generateContent([Content.text(prompt)]);
      debugPrint(response.text);

      final result = response.text?.trim().toLowerCase();

      if (result == 'positive') {
        status = 'Positive';
      } else if (result == 'negative') {
        status = 'Negative';
      } else {
        status = 'Neutral';
      }
    } catch (e) {
      debugPrint('Sentiment Error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
