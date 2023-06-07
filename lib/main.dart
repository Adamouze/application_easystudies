import 'package:flutter/material.dart';

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
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
  super.initState();
  _animationController = AnimationController(
    duration: const Duration(seconds: 3),
    vsync: this,
  );

  _animation = Tween<double>(
    begin: 0.0,
    end: 1.0,
  ).animate(_animationController);

  _animationController.forward();

  Future.delayed(const Duration(seconds: 4), () {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(seconds: 2),  // duration of the transition
        transitionsBuilder: (context, animation, animationTime, child) {
          var begin = const Offset(1.0, 0.0);  // start position of the page
          var end = Offset.zero;  // end position of the page
          var tween = Tween(begin: begin, end: end);  // defines the transition from beginning position to end
          var offsetAnimation = animation.drive(tween);  // applies the transition to the animation

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
        pageBuilder: (context, _, __) => const MyHomePage(title: 'Test - Easy Studies'),
      ),
    );
  });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(flex: 2),
            FadeTransition(
              opacity: _animation,
              child: const Text(
                'Bienvenue',
                style: TextStyle(fontSize: 40, color: Colors.orangeAccent),
                textAlign: TextAlign.center,
              ),
            ),
            FadeTransition(
              opacity: _animation,
              child: const Text(
                'sur',
                style: TextStyle(fontSize: 40, color: Colors.orangeAccent),
                textAlign: TextAlign.center,
              ),
            ),
            FadeTransition(
              opacity: _animation,
              child: SizedBox(
                width: 200,
                height: 200,
                child: Image.asset('assets/EasyStudies.png'), // Replace with your logo image asset
              ),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
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
