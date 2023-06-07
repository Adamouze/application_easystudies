import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'First Application',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Bienvenue sur ClickLand'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  Color _currentColor = Colors.black;
  Color _backgroundColor = Colors.white; // New state variable for background color
  final _random = Random();

  void _incrementCounter() {
    setState(() {
      _counter++;
      _currentColor = Color.fromRGBO(
        _random.nextInt(256),
        _random.nextInt(256),
        _random.nextInt(256),
        1,
      );
      _backgroundColor = Color.fromRGBO( // Set background color to a random color
        _random.nextInt(256),
        _random.nextInt(256),
        _random.nextInt(256),
        1,
      );
    });
  }

  void _resetCounter() {  // Add this
    setState(() {
      _counter = 0;
      _currentColor = const Color.fromRGBO( // Set increment color to default
        0,
        0,
        0,
        1,
      );
      _backgroundColor = const Color.fromRGBO( // Set background color to default
        255,
        255,
        255,
        1,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FractionallySizedBox(
              widthFactor: 0.8,
              child: ElevatedButton(
                onPressed: () {
                  // Action pour le bouton "News"
                },
                child: Text('News'),
              ),
            ),
            const SizedBox(height: 16),
            FractionallySizedBox(
              widthFactor: 0.8,
              child: ElevatedButton(
                onPressed: () {
                  // Action pour le bouton "Cours"
                },
                child: Text('Cours'),
              ),
            ),
            const SizedBox(height: 16),
            FractionallySizedBox(
              widthFactor: 0.8,
              child: ElevatedButton(
                onPressed: () {
                  // Action pour le bouton "Autre Site"
                },
                child: Text('Autre Site'),
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
