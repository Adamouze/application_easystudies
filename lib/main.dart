import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'dart:convert';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


// import 'package:html/dom.dart' as dom;


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
    await Future.delayed(const Duration(seconds: 2)); // Simuler un délai de 2 secondes
    return ["News 1" , "News 2", "News 3"];
  }

}


class VideoDetail {
  final String thumbnailUrl;
  final String title;
  final String description;
  final String videoId;

  VideoDetail(this.thumbnailUrl, this.title, this.description, this.videoId);
}


class VideoPlayerPage extends StatefulWidget {
  final String videoId;

  VideoPlayerPage(this.videoId);

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Player'),
      ),
      body: YoutubePlayer(
        controller: _controller,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
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
  final NewsService newsService = NewsService();
  final MaterialAccentColor orangePerso = Colors.orangeAccent;

  Future<VideoDetail> fetchLatestVideoDetails() async {
    const String channelId = 'UCm19VoVNI76RHqpaRbS1kgw';
    const String apiKey = 'AIzaSyAbIR-eFQwQ6ESK_9OKhHYLo08Hn24MQwo';
    final response = await http.get(Uri.parse(
        'https://www.googleapis.com/youtube/v3/search?order=date&part=snippet&channelId=$channelId&maxResults=1&key=$apiKey'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['items'][0];
      return VideoDetail(
        data['snippet']['thumbnails']['high']['url'],
        data['snippet']['title'],
        data['snippet']['description'],
        data['id']['videoId'], // ajout de l'ID de la vidéo
      );
    } else {
      throw Exception('Failed to load video');
    }
  }







  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0), // Increase this to increase space
        child: AppBar(
          toolbarHeight: 80.0, // Match this with preferredSize height
          backgroundColor: orangePerso,
          title: Row(
            children: [
              SizedBox(
                width: 70,
                height: 80,
                child: Stack(
                  children: [
                    Positioned(
                      top: 5, // adjust this to move logo vertically
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 5, // match this with Container's top
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(150), // n'importe quoi > 35
                          child: Image.asset(
                            'assets/images/logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),
              Expanded(
                flex: 5,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Noto Sans',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const Spacer(flex: 1),
              SizedBox(
                width: 50.0,
                height: 50.0,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(150),
                    ),
                    padding: const EdgeInsets.all(10),
                    backgroundColor: Colors.blue,
                  ),
                  child: const Icon(
                    Icons.account_circle_rounded,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),



      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              const SizedBox(height: 20),

              FractionallySizedBox(
                widthFactor: 0.95,
                child: Container(
                  padding: const EdgeInsets.all(16),
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
                        return const Text('Failed to fetch news data');
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),

              FractionallySizedBox(
                widthFactor: 0.95,
                child: FutureBuilder<VideoDetail>(
                  future: fetchLatestVideoDetails(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final videoDetail = snapshot.data!;
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoPlayerPage(videoDetail.videoId),
                            ),
                          );
                        },
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
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                                  image: DecorationImage(
                                    image: NetworkImage(videoDetail.thumbnailUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      videoDetail.title,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      videoDetail.description,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );

                    } else if (snapshot.hasError) {
                      return const Text('Failed to fetch video details');
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
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
                  child: const Text('Autre Potentiel Site'),
                ),
              ),
            const Text(
              "TODO : Boutons des différents réseaux",
              style: TextStyle(
                fontSize: 18,
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}
