import 'package:http/http.dart' as http;
import 'dart:convert';

class FacebookService {
  Future<String?> fetchLatestNewsData() async {
    const String pageId = '1004307882934421'; // Remplacer par l'ID de votre page
    const String accessToken = 'EAAOIk6MidKgBAIZCChiRTONAtfLLvafMJ8mggsTZAi0pwAcZC6BtVWoCDmWVSUpZADdEoUj8houItqzSvsRclZBXZCnzZCW9QUFe3OZCivZBO6EJvqEr7nsYrG7dcyV6nRlpORZCA7edrBG3jUzMBuPZABuV5EbqdQq7k4jKhFuJ5ZCnWOJuYoLID8Uej3NFhWhMZBJpnAnBe4tYQ3mz6j9YbD2SYpatJtTRle6PI67HbVMyzLI0Wsl7jpwqu'; // Remplacer par votre jeton d'accès
    final url = Uri.parse('https://graph.facebook.com/$pageId/feed?access_token=$accessToken');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final posts = data['data'] as List;
      String? latestNewsData;
      for (var post in posts) {
        final message = post['message'];
        if(message != null && message.isNotEmpty) {
          latestNewsData = message;
          break;
        }
      }
      return latestNewsData;
    } else {
      throw Exception('Failed to fetch news data');
    }
  }
}
