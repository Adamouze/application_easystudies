import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/splash_screen.dart';
import 'screens/app_bar.dart';
import 'screens/body.dart';
import 'screens/login_screen.dart';
import 'screens/eleve_screen.dart';
import 'screens/prof_screen.dart';
import 'screens/super_user_screen.dart';


import 'utilities/video_youtube.dart';
import 'utilities/facebook_news.dart';
import 'utilities/constantes.dart';
import 'utilities/theme_provider.dart';

import 'logs/auth_stat.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthState(),
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'EasyStudies',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.orangeAccent).copyWith(
              background: Colors.white,  //couleur de fond pour le mode clair
              shadow: Colors.grey.withOpacity(0.5),
            ),
            primaryColor: Colors.white,
            textTheme: const TextTheme(
              bodyLarge: TextStyle(
                color: Colors.black,
              ),
            ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.orangeAccent).copyWith(
              background: Colors.grey[850],  //couleur de fond pour le mode sombre
              shadow: Colors.grey[850],
            ),
            primaryColor: Colors.black,
            textTheme: const TextTheme(
              bodyLarge: TextStyle(
                color: Colors.white,
              ),
            ),
            useMaterial3: true,
          ),

          themeMode: themeProvider.themeMode,
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
              );
            }
            else if (settings.name == '/eleve') {
              return MaterialPageRoute(builder: (_) => const EleveScreen());
            }
            else if (settings.name == '/prof') {
              return MaterialPageRoute(builder: (_) => const ProfScreen());
            }
            else if (settings.name == '/super_user') {
              return MaterialPageRoute(builder: (_) => const SuperUserScreen());
            }
            return null;
          },
        );
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
      appBar: CustomAppBar(color: orangePerso, context: context),
      body: const CustomBody(),
    );
  }
}
