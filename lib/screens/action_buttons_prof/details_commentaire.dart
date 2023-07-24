import 'package:flutter/material.dart';

import '../../utilities/constantes.dart';

import '../../../utils.dart';


class DetailsCommentaireBlock extends StatelessWidget {
  final Eleve eleve;

  DetailsCommentaireBlock({required this.eleve, Key? key}) : super(key: key);

  Widget buildCommentaireRow(Commentaire commentaire, int index, Color color) {
    return Container(
      width: double.infinity,
      child: Card(
        color: color,
        margin: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Date: ${commentaire.date.substring(8,10)}/${commentaire.date.substring(5,7)}/${commentaire.date.substring(0,4)} - Par: ${commentaire.from}",
                style: const TextStyle(fontWeight: FontWeight.bold),
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

    // On ne prend que les 2 derniers commentaires

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
    return ClipRRect(
      borderRadius: BorderRadius.circular(arrondiBox),
      child: FractionallySizedBox(
        widthFactor: 0.95,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: orangePerso,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(arrondiBox),
          ),
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
                      offset: const Offset(0, 2), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
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
              commentaireRows.isEmpty
                  ? Container(color: Colors.grey[200], child: const SizedBox(height: 10))
                  : Column(
                children: commentaireRows, // Utilisez la liste des widgets générés comme enfants de la Column
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class DetailsCommentaireContent extends StatelessWidget {
  final Eleve eleve;

  const DetailsCommentaireContent({required this.eleve, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: orangePerso,
        title:Text(
          'Détails des commentaires',
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
                DetailsCommentaireBlock(eleve: eleve),
                const SizedBox(height: 20),
              ],
            ),
          )
      ),
    );
  }
}




