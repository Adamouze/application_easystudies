import 'package:flutter/material.dart';
import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController fadeController;
  late Animation<double> fadeAnimation;
  late AnimationController scaleController;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    fadeController = AnimationController(vsync: this, duration: const Duration(seconds: 5));
    fadeAnimation = CurvedAnimation(parent: fadeController, curve: Curves.easeIn);

    scaleController = AnimationController(vsync: this, duration: const Duration(seconds: 4));
    scaleAnimation = CurvedAnimation(parent: scaleController, curve: Curves.easeIn);

    fadeController.forward();
    scaleController.forward();

    Future.delayed(const Duration(seconds: 6), () {
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(seconds: 2),
          pageBuilder: (context, _, __) => const MyHomePage(title: 'Test - Easy Studies'),
        ),
      );
    });
  }

  @override
  void dispose() {
    fadeController.dispose();
    scaleController.dispose();
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
            Center(
              child: FadeTransition(
                opacity: fadeAnimation,
                child: ScaleTransition(
                  scale: scaleAnimation,
                  child: SizedBox(
                    width: 661,
                    height: 169,
                    child: Image.asset('assets/EasyStudies.png'), // Replace with your logo image asset
                  ),
                ),
              ),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}