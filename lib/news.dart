import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;


class NewsService {
  Future<List<String>> fetchNewsData() async {
    final url = Uri.parse('https://extranet.easystudies.fr/news');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final document = parser.parse(response.body);
      final newsElements = document.querySelectorAll('.news-item');
      final newsData = newsElements.map((element) {
        final title = element.querySelector('.news-title')?.text;
        final description = element.querySelector('.news-description')?.text;
        return '$title\n$description';
      }).toList();
      return newsData;
    } else {
      throw Exception('Failed to fetch news data');
    }
  }

  Future<List<String>> simulateNewsData() async {
    await Future.delayed(const Duration(seconds: 2)); // Simuler un délai de 2 secondes
    return ["News 1" , "News 2", "News 3"];
  }
}
