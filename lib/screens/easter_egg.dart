import 'package:flutter/material.dart';
import '../utilities/constantes.dart';


class EasterEggPage extends StatelessWidget {
  const EasterEggPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final screenWidth = MediaQuery.of(context).size.width;

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Bloc de texte
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    "Sympathique petit easter egg, non ?",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: theme.textTheme.bodyLarge?.color),
                    textAlign: TextAlign.center,
                  )
                ),
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      "Bravo à toi pour l'avoir trouvé ! ",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: theme.textTheme.bodyLarge?.color),
                      textAlign: TextAlign.center,
                    )
                ),
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      "Nous espérons que vous appreciez cette petite application !",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: theme.textTheme.bodyLarge?.color),
                      textAlign: TextAlign.center,
                    )
                ),
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      "Enjoy, et bossez bien !",
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
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.textTheme.bodyLarge?.color),
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
    );
  }
}
