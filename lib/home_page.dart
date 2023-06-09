import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
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
                child: const Text('News'),
              ),
            ),
            const SizedBox(height: 16),
            FractionallySizedBox(
              widthFactor: 0.8,
              child: ElevatedButton(
                onPressed: () {
                  // Action pour le bouton "Cours"
                },
                child: const Text('Cours'),
              ),
            ),
            const SizedBox(height: 16),
            FractionallySizedBox(
              widthFactor: 0.8,
              child: ElevatedButton(
                onPressed: () {
                  // Action pour le bouton "Autre Site"
                },
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