import 'package:flutter/material.dart';


import '../../../utilities/constantes.dart';

import '../../../utils.dart';


class DevoirBlock extends StatelessWidget {
  final Eleve eleve;

  const DevoirBlock({required this.eleve, Key? key}) : super(key: key);

  Widget buildDevoirRow(Devoir devoir, int index, Color color) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: color,
        margin: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  text: "Date: ",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  children: <TextSpan>[
                    TextSpan(
                      text: afficherDate(devoir.date),
                      style: afficherDate(devoir.date) == "non renseigné"
                          ? TextStyle(fontWeight: FontWeight.normal, fontStyle: FontStyle.italic, color: Colors.grey[700])
                          : const TextStyle(fontStyle: FontStyle.normal, color: Colors.black),
                    ),
                    TextSpan(
                      text: "   Fait: ${devoir.fait}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Text(devoir.comment),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> createDevoirRows(Eleve eleve) {
    List<Widget> rows = [];

    for (int i = 0; i < eleve.devoirs.length; i++) {
      Devoir devoir = eleve.devoirs[i];
      Color color = (i % 2 == 0 ? Colors.grey[300] : Colors.grey[400]) ?? Colors.grey;
      rows.add(buildDevoirRow(devoir, i, color));
    }

    // Ajoutez une marge en bas du dernier élément
    if (rows.isNotEmpty) {
      rows.add(const SizedBox(height: 8.0));
    }

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> devoirRows = createDevoirRows(eleve);
    return ClipRRect(
      borderRadius: BorderRadius.circular(arrondiBox),
      child: FractionallySizedBox(
        widthFactor: 0.95,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                color: orangePerso,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(arrondiBox),
                  topRight: Radius.circular(arrondiBox),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 8 - epaisseurContour),
                child: Text(
                  'Devoirs',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'NotoSans',
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: orangePerso,
                  width: epaisseurContour,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(arrondiBox),
                  bottomRight: Radius.circular(arrondiBox),
                ),
              ),
              child: devoirRows.isEmpty
                  ? Container(
                height: 10,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(arrondiBox - 3),
                    bottomRight: Radius.circular(arrondiBox - 3),
                  ),
                ),
              )
                  : Column(
                children: devoirRows,
              ),
            ),
          ],
        ),
      ),
    );  }
}

class DevoirScreen extends StatelessWidget {
  final Eleve eleve;

  const DevoirScreen({required this.eleve, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: orangePerso,
        title:Text(
          'Détails des devoirs',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.primaryColor,
          ),
        ),
        iconTheme: IconThemeData(
          color: theme.primaryColor, // Définissez ici la couleur souhaitée pour l'icône
        ),
      ),
      body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 20),
                DevoirBlock(eleve: eleve),
                const SizedBox(height: 20),
              ],
            ),
          )
      ),
    );
  }
}




