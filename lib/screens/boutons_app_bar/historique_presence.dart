import 'package:flutter/material.dart';

import '../../utilities/constantes.dart';

import '../../utils.dart';

class EleveComptabiliteBlock extends StatelessWidget {
  final Eleve eleve;

  const EleveComptabiliteBlock({required this.eleve, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.95,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: orangePerso,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(arrondiBox),
                topRight: Radius.circular(arrondiBox),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Comptabilité - ${eleve.prenom}',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'NotoSans',
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(arrondiBox),
                bottomRight: Radius.circular(arrondiBox),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Solde : ${eleve.solde} €"),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Prévisionnel : ${eleve.prev} €"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HistoryPresenceBlock extends StatelessWidget {
  final Eleve eleve;

  const HistoryPresenceBlock({required this.eleve, Key? key}) : super(key: key);

  Widget buildHistoryRow(Presence presence, int index, Color color) {
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: "Date: ",
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                text: afficherDate(presence.cours.date),
                                style: afficherDate(presence.cours.date) == "non renseigné"
                                    ? TextStyle(fontWeight: FontWeight.normal, fontStyle: FontStyle.italic, color: Colors.grey[700])
                                    : const TextStyle(fontStyle: FontStyle.normal, color: Colors.black),
                              ),
                              TextSpan(
                                text: "   Type: ${presence.cours.type}",
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: "Centre: ${presence.cours.centre}",
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Number of hours to the right side of the Row
                  Text(
                    '${presence.nbHeures} h',
                    style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ],
              ),

              const Divider(color: Colors.black, thickness: 0.5, height: 10),
              // const SizedBox(height: 5),

              Text(
                presence.cours.comment.isEmpty ? "non renseigné" : presence.cours.comment,
                style: presence.cours.comment.isEmpty
                    ? TextStyle(fontWeight: FontWeight.normal, fontStyle: FontStyle.italic, color: Colors.grey[700])
                    : const TextStyle(fontStyle: FontStyle.normal, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> createHistoryRows(Eleve eleve) {
    List<Widget> rows = [];

    for (int i = 0; i < eleve.presences.length; i++) {
      Presence presence = eleve.presences[i];
      Color color = (i % 2 == 0 ? Colors.grey[300] : Colors.grey[400]) ?? Colors.grey;
      rows.add(buildHistoryRow(presence, i, color));
    }

    // Ajoutez une marge en bas du dernier élément
    if (rows.isNotEmpty) {
      rows.add(const SizedBox(height: 8.0));
    }

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> historyRows = createHistoryRows(eleve);
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
                  'Historique de présence - ${eleve.prenom}',
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
              child: historyRows.isEmpty
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
                children: historyRows,
              ),
            ),
          ],
        ),
      ),
    );  }
}

class HistoryPresenceScreen extends StatefulWidget {
  final Eleve eleve;

  const HistoryPresenceScreen({required this.eleve, Key? key}) : super(key: key);

  @override
  HistoryPresenceScreenState createState() => HistoryPresenceScreenState();
}

class HistoryPresenceScreenState extends State<HistoryPresenceScreen> {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: orangePerso,
        title:Text(
          'Historique de présence',
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
                EleveComptabiliteBlock(eleve: widget.eleve),
                const SizedBox(height: 20),
                HistoryPresenceBlock(eleve: widget.eleve),
                const SizedBox(height: 120),
              ],
            ),
          )
      ),
    );
  }
}