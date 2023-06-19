import 'package:http/http.dart' as http;
import 'dart:convert';

class FacebookService {
  Future<String?> fetchLatestNewsData() async {
    const String pageId = '1004307882934421'; // Remplacer par l'ID de votre page
    const String accessToken = 'EAAOIk6MidKgBAL7IxQs2WUxBxMkcpeTUXddayOopKSJDEqt1D3PJOF6Mgjg0RVr0xLtDDstRo5oc3GL5ngGjH7ZCwl9HHfIS7URNOijZAxkXxH05KM8cjedfJPjQ4lZCVH2e5rYZBntKvUk29wmMsVfo5ZAT17PWzbYoZBoNgkQ9VDnmoh4bbUBHIV3jCtBMDPYFdVfHZAPz9pYyMOEwG58dEPLOyWDIzkeiTZCTjI6NEwPTtDTCCKjt'; // Remplacer par votre jeton d'accès
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
