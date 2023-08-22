import 'package:flutter/material.dart';
import 'dart:math';

import '../utilities/constantes.dart';


class EasterEggPage extends StatefulWidget {
  const EasterEggPage({Key? key}) : super(key: key);

  @override
  EasterEggState createState() => EasterEggState();
}

class EasterEggState extends State<EasterEggPage> {

  final GlobalKey centerKey = GlobalKey();
  double? centerHeight;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        centerHeight = centerKey.currentContext!.size!.height;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final oeufsWidth =  0.95 * screenWidth;
    final oeufsHeight = oeufsWidth * (293 / 1280);
    final imageWidth = 0.35 * screenWidth;
    final spaceBetweenImages = 0.1 * screenWidth;
    final externalMargin = (screenWidth - 2*imageWidth - spaceBetweenImages)/2;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Surprise !',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: orangePerso,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // Espace pour les œufs en haut
                SizedBox(
                  height: oeufsHeight,
                ),

                Center(
                  key: centerKey,
                  child: Column(
                    children: [
                      // Bloc de texte
                      Column(
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                "Bravo à toi pour avoir trouvé cette page secrète haha !",
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: theme.textTheme.bodyLarge?.color),
                                textAlign: TextAlign.center,
                              )
                          ),
                          Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                "C'était sympa de bosser sur cette application pendant un peu plus de 2 mois. Nous espérons que tu apprecies le résultat final !",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.textTheme.bodyLarge?.color),
                                textAlign: TextAlign.center,
                              )
                          ),
                          Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                "Enjoy !",
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: theme.textTheme.bodyLarge?.color),
                                textAlign: TextAlign.center,
                              )
                          ),

                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0, right: 12.0),
                              child: Text(
                                'Adamouze et Alaska',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.textTheme.bodyLarge?.color),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Espace
                      const SizedBox(height: 40),
                      // Deux photos côte à côte
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: externalMargin,
                          ),
                          SizedBox(
                            width: imageWidth,
                            child: Image.asset('assets/easter_egg/adamouze.png', fit: BoxFit.contain),
                          ),
                          SizedBox(
                            width: spaceBetweenImages,
                          ),
                          SizedBox(
                            width: imageWidth,
                            child: Image.asset('assets/easter_egg/alaska.png', fit: BoxFit.contain),
                          ),
                          SizedBox(
                            width: externalMargin,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Espace pour les œufs en bas
                SizedBox(
                  height: max(screenHeight - oeufsHeight - (centerHeight ?? 0) - oeufsHeight, screenHeight - oeufsHeight - (centerHeight ?? 0) - oeufsHeight - 205), // Dernière valeur totalement artificielle, mais ça marche !
                ),
              ],
            ),
          ),

          // Oeufs en haut
          Positioned(
            top: 0,
            left: (screenWidth - oeufsWidth)/2,
            child: SizedBox(
              width: oeufsWidth,
              child: Image.asset('assets/easter_egg/oeufs.png', fit: BoxFit.contain),
            ),
          ),

          // Oeufs en bas
          Positioned(
            bottom: 0,
            left: (screenWidth - oeufsWidth)/2,
            child: SizedBox(
              width: oeufsWidth,
              child: Image.asset('assets/easter_egg/oeufs.png', fit: BoxFit.contain),
            ),
          ),
        ],
      ),
    );
  }
}
