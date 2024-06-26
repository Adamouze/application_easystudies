import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utilities/constantes.dart';


class EasterEggPage extends StatelessWidget {
  const EasterEggPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // Force l'orientation en mode portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

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
          'Easter egg !',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: orangePerso,
        centerTitle: true,
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
                                "C'était sympa de bosser sur cette application chez Atchuthen pendant un peu plus de 2 mois. Nous espérons que tu apprecies le résultat final !",
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
                  height: screenHeight - 2 * oeufsHeight - 500, // Dernière valeur totalement artificielle, mais ça marche !
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
