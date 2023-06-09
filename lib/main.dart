import 'package:flutter/material.dart';
import 'splash_screen.dart';

import 'video_youtube.dart';
import 'news.dart';
import 'app_bar.dart';
import 'body.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EasyStudies',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orangeAccent),
        useMaterial3: true,
      ),
      home: const SplashScreen(), const MyHomePage(title: 'EasyStudies'),
      
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