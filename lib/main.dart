import 'package:flutter/material.dart';

import 'video_youtube.dart';
import 'news.dart';
import 'app_bar.dart';
import 'body.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test de notre application',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orangeAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'EasyStudies'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final newsService = NewsService();
  final MaterialAccentColor orangePerso = Colors.orangeAccent;
  final youtubeService = YoutubeService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: CustomAppBar(title: widget.title, color: orangePerso),

      body: CustomBody(),
    );
  }
}
