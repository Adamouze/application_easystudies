import 'package:flutter/material.dart';
import 'dart:convert';

import '../../../utilities/constantes.dart';

import '../../../../utils.dart';


class BaseDeNotationBlock extends StatelessWidget {
  final Bilan bilan;

  const BaseDeNotationBlock({required this.bilan, Key? key}) : super(key: key);

  TableRow _createRatingRow(String title, String rating) {
    int ratingInt = int.parse(rating);
    return TableRow(
      children: [
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
            child: Text(title),
          ),
        ),
        for (int value = 1; value <= 5; value++)
          Center(
            child: value == ratingInt
                ? const Icon(Icons.check)
                : Container(),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.95,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.orangeAccent,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
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
                'Base de Notation',
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
              color: Colors.grey[200],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
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
            child: Table(
              columnWidths: const <int, TableColumnWidth>{
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(0.3),
                2: FlexColumnWidth(0.3),
                3: FlexColumnWidth(0.3),
                4: FlexColumnWidth(0.3),
                5: FlexColumnWidth(0.3),
              },
              border: TableBorder.all(
                color: Colors.black26,
                width: 1,
              ),
              children: [
                TableRow(
                  children: [
                    const Center(child: Text(' ')),
                    for (int i = 1; i <= 5; i++)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Image.asset('assets/smiley/$i.png', height: 30),
                        ),
                      ),
                  ],
                ),
                _createRatingRow('Note globale', bilan.global),
                _createRatingRow('Note comportement', bilan.comp),
                _createRatingRow('Note assiduité', bilan.assidu),
                _createRatingRow('Devoirs / DM faits', bilan.dm),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BilanBlock extends StatelessWidget {
  final Bilan bilan;
  const BilanBlock({required this.bilan, Key? key}) : super(key: key);


  String decodeUtf8(String source) {
    return utf8.decode(latin1.encode(source));
  }

  @override
  Widget build(BuildContext context) {

    String decodeIfNeeded(String s) {
      String replaced = s.replaceAll('\r\n', ' / ');

      if (replaced.endsWith(' / ')) {
        replaced = replaced.substring(0, replaced.lastIndexOf(' / '));
      }

      if (s.contains('\u00c3')) {
        return decodeUtf8(replaced);
      }
      return replaced;
    }



    return FractionallySizedBox(
      widthFactor: 0.95,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.orangeAccent,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
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
                'Bilan',
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
              color: Colors.grey[200],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
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
              padding: const EdgeInsets.all(5.0),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Date: ${bilan.date.substring(8,10)}/${bilan.date.substring(5,7)}/${bilan.date.substring(0,4)}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        const TextSpan(
                          text: 'Matières: ',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        TextSpan(
                          text: decodeIfNeeded(bilan.subjects),
                          style: const TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: Colors.black,),
                  const SizedBox(height: 2),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        const TextSpan(
                          text: 'Axes d\'amélioration: ',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        TextSpan(
                          text: bilan.toImprove,
                          style: DefaultTextStyle.of(context).style,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        const TextSpan(
                          text: 'Points forts: ',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        TextSpan(
                          text: bilan.good,
                          style: DefaultTextStyle.of(context).style,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        const TextSpan(
                          text: 'Commentaires: ',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        TextSpan(
                          text: bilan.comment,
                          style: DefaultTextStyle.of(context).style,
                        ),
                      ],
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




class DetailsBilanContent extends StatelessWidget {
  final Eleve eleve;
  final Bilan bilan;

  const DetailsBilanContent({required this.eleve, required this.bilan, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: orangePerso,
        title:Text(
          'Détails du bilan',
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
              BaseDeNotationBlock(bilan: bilan),
              const SizedBox(height: 20),
              BilanBlock(bilan: bilan),
              const SizedBox(height: 20),
            ],
          ),
        )
      ),
    );
  }
}