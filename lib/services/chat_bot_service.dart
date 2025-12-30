import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatBotService {
  
  final String apiKey = "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";
  final String baseUrl = "https://openrouter.ai/api/v1/chat/completions";

  /// Mengirim pesan ke OpenRouter dan mendapatkan balasan
  Future<String?> getReply(List<Map<String, String>> messages) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          "Authorization": "Bearer $apiKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "model": "xiaomi/mimo-v2-flash:free",
          "messages": messages,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["choices"][0]["message"]["content"];
      } else {
        print("ERROR API: ${response.body}");
        return "Error API: ${response.statusCode}";
      }
    } catch (e) {
      return "Gagal terhubung. Periksa internet Anda.";
    }
  }
}