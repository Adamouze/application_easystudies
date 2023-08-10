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
                ? const Icon(Icons.check, color: Colors.black)
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
              color: orangePerso,
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

    Widget buildBilanEntry(String title, String content) {
      if (content.isEmpty) {
        return RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: '$title: \n',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              TextSpan(
                text: "non renseigné",
                style: TextStyle(fontWeight: FontWeight.normal, fontStyle: FontStyle.italic, color: Colors.grey[700]),
              ),
            ],
          ),
        );
      }

      int italicIndex = content.indexOf('Entré par:');
      if (italicIndex == -1) {
        italicIndex = content.indexOf('Modifié par:');
      }

      if (italicIndex == -1) {
        return RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: '$title: \n',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              TextSpan(
                text: content,
                style: DefaultTextStyle.of(context).style,
              ),
            ],
          ),
        );
      }

      String normalText = content.substring(0, italicIndex);
      String italicText = content.substring(italicIndex);

      return RichText(
        text: TextSpan(
          text: '$title: \n',
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          children: [
            TextSpan(text: normalText, style: DefaultTextStyle.of(context).style),
            TextSpan(text: italicText, style: const TextStyle(fontWeight: FontWeight.normal, fontStyle: FontStyle.italic, color: Colors.black)),
          ],
        ),
      );
    }

    return FractionallySizedBox(
      widthFactor: 0.95,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: orangePerso,
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
                    "Date: ${afficherDate(bilan.date)}",
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

                  const Divider(color: Colors.black),
                  const SizedBox(height: 2),

                  buildBilanEntry('Axes d\'amélioration', bilan.toImprove),
                  const SizedBox(height: 8),
                  buildBilanEntry('Points forts', bilan.good),
                  const SizedBox(height: 8),
                  buildBilanEntry('Commentaires', bilan.comment),
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
  final Bilan bilan;

  const DetailsBilanContent({required this.bilan, Key? key}) : super(key: key);

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
              const SizedBox(height: 100),
            ],
          ),
        )
      ),
    );
  }
}