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
      body: Stack(
        children: <Widget>[
          Center(
            child: Container(
              color: _backgroundColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FittedBox(
                    child: Text(
                      'Nombre de fois où tu as cliqué petit malin :',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                  Text(
                    '$_counter',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: _currentColor),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 15,  // 15 pixels from the left edge of the screen
            bottom: 15,  // 15 pixels from the bottom edge of the screen
            child: FloatingActionButton(
              onPressed: _resetCounter,
              tooltip: 'Reset',
              child: const Icon(Icons.refresh),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
