import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/response_model.dart';
import 'api_key.dart';

class ApiService {
  Future<String?> summarizeText(String rawText) async {
    if (geminiApiKey == "YOUR_GEMINI_API_KEY_HERE") {
      return "Please set your Gemini API Key in api_service.dart to get real AI summaries!";
    }

    try {
      final model = GenerativeModel(model: 'gemini-1.5-flash-latest', apiKey: geminiApiKey);
      final prompt = "Summarize this document text concisely:\n\n$rawText";
      final response = await model.generateContent([Content.text(prompt)]);
      return response.text;
    } catch (e) {
      print("Gemini Error: $e");
      return "Error: $e";
    }
  }

  ResponseModel generateResult(String ocrText, String summary) {
    return ResponseModel(
      text: ocrText,
      summary: summary,
    );
  }
}
