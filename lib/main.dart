import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;


void main() {
  runApp(const MyApp());
}

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
    await Future.delayed(Duration(seconds: 2)); // Simuler un délai de 2 secondes
    return ["News 1 : Aujourd'hui, maman est morte."  , "News 2 : Ou peut-être hier, je ne sais pas.", "News 3 : J’ai reçu un télégramme de l’asile : « Mère décédée. Enterrement demain. Sentiments distingués. »"];
  }

}



class MyApp extends StatelessWidget {
  const MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test de notre application',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orangeAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'EasyStudies'),
    );
  }
  }

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  final NewsService newsService = NewsService();
  final MaterialAccentColor orangePerso = Colors.orangeAccent;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: orangePerso,
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0),
                color: Colors.transparent,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.asset(
                  'assets/images/logo.png',
                  width: MediaQuery.of(context).size.width * 0.20, // 25% de la largeur de l'écran pour le logo
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.05), // Espacement de 5% de la largeur de l'écran
            Expanded(
              flex: 3,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Noto Sans',
                    fontSize: 24, // 30% de la largeur de l'écran pour le titre
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.1), // Espacement de 10% de la largeur de l'écran
            SizedBox(
              width: 40.0,
              height: 40.0,
              child: ElevatedButton(
                onPressed: () {
                  // Action à effectuer lorsque le bouton "Login" est cliqué
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.all(8),
                  backgroundColor: Colors.blue,
                ),
                child: Icon(
                  Icons.account_circle_rounded,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FractionallySizedBox(
              widthFactor: 0.95,
              child: Container(
                padding: EdgeInsets.all(16),
                color: Colors.grey[200],
                child: FutureBuilder<List<String>>(
                  future: newsService.simulateNewsData(), // newsService.fetchNewsData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final newsData = snapshot.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: newsData.map((data) => Text(data)).toList(),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Failed to fetch news data');
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            FractionallySizedBox(
              widthFactor: 0.95,
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 200,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                        image: DecorationImage(
                          image: NetworkImage('https://yt3.googleusercontent.com/ytc/AGIKgqO2HL50bKd5mp2fruEO76bn-Pu1SRNlzTTq6wME7g=s900-c-k-c0x00ffffff-no-rj'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dernière vidéo Youtube',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Récupérer le titre directement sur Youtube (dynamiquement)',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
            FractionallySizedBox(
              widthFactor: 0.95,
              child: ElevatedButton(
                onPressed: () {
                  // Action pour le bouton "Autre Site"
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink, // Couleur de fond du bouton
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Arrondi des bords
                  ),
                ),
                child: const Text('Autre Site'),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Nombre de clics petit coquin :',
            ),
            const Text(
              'Deuxième ligne de texte (oui oui baguette)',
            ),
            Text(
              '$_counter',
              style: const TextStyle(
                color: Colors.black, // Texte en noir
                fontSize: 24, // Taille de police personnalisée (optionnel)
                fontWeight: FontWeight.bold, // Poids de police personnalisé (optionnel)
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Incrément du compteur',
        child: const Icon(Icons.add_circle_rounded),
      ),
    );
  }
}
