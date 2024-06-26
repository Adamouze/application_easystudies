import 'package:flutter/material.dart';

import '../../../utilities/constantes.dart';

import '../../../utils.dart';


class CommentaireBlock extends StatelessWidget {
  final Eleve eleve;

  const CommentaireBlock({required this.eleve, Key? key}) : super(key: key);

  Widget buildCommentaireRow(Commentaire commentaire, int index, Color color) {
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
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(
                      text: afficherDate(commentaire.date),
                      style: afficherDate(commentaire.date) == "non renseigné"
                          ? TextStyle(fontWeight: FontWeight.normal, fontStyle: FontStyle.italic, color: Colors.grey[700])
                          : const TextStyle(fontStyle: FontStyle.normal, color: Colors.black),
                    ),
                    TextSpan(
                      text: "   Par: ${commentaire.from}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Text(commentaire.comment),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> createCommentaireRows(Eleve eleve) {
    List<Widget> rows = [];

    for (int i = 0; i < eleve.commentaires.length; i++) {
      Commentaire commentaire = eleve.commentaires[i];
      Color color = (i % 2 == 0 ? Colors.grey[300] : Colors.grey[400]) ?? Colors.grey;
      rows.add(buildCommentaireRow(commentaire, i, color));
    }

    // Ajoutez une marge en bas du dernier élément
    if (rows.isNotEmpty) {
      rows.add(const SizedBox(height: 8.0));
    }

    return rows;
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> commentaireRows = createCommentaireRows(eleve);

    if (eleve.commentaires.isEmpty) {
      return const Center(
        child: Text(
          "Pas de commentaires ici",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            fontSize: 18,
          ),
        ),
      );
    } else {
      return SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),

              ClipRRect(
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
                            'Commentaires',
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
                        child: commentaireRows.isEmpty
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
                          children: commentaireRows,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      );
    }

  }
}


