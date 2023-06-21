import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/splash_screen.dart';
import 'screens/app_bar.dart';
import 'screens/bodies/body_home.dart';
import 'screens/login_screen.dart';
import 'screens/eleve_screen.dart';

import 'utilities/video_youtube.dart';
import 'utilities/facebook_news.dart';
import 'utilities/constantes.dart';

import 'screens/logs/auth_stat.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthState(),
      child: const MyApp(),
    ),
  );
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
      initialRoute: '/',
      onGenerateRoute: (settings) {
        if (settings.name == '/') {
          return MaterialPageRoute(builder: (_) => const SplashScreen());
        } else if (settings.name == '/home') {
          return PageRouteBuilder(
            pageBuilder: (_, __, ___) => const MyHomePage(title: 'EasyStudies'),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          );
        } else if (settings.name == '/login') {
          return PageRouteBuilder(
            pageBuilder: (_, __, ___) => const LoginScreen(),
            transitionsBuilder: (_, animation, __, child) {
              var begin = const Offset(0.0, -1.0);
              var end = Offset.zero;
              var tween = Tween(begin: begin, end: end);
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          );
        }
        else if (settings.name == '/eleve') { // Ajout de la nouvelle route
          return MaterialPageRoute(builder: (_) => const EleveScreen());
        }
        return null;
      },
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
  final facebookService = FacebookService();
  final youtubeService = YoutubeService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.title, color: orangePerso, context: context),
      body: CustomBody(),
    );
  }
}
