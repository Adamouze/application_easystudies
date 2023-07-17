import 'package:flutter/material.dart';

import '../../utilities/constantes.dart';

import '../../../utils.dart';


class EleveInfoBlock extends StatelessWidget {
  final Eleve eleve;

  const EleveInfoBlock({required this.eleve, Key? key}) : super(key: key);

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
                'Élève',
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
              padding: const EdgeInsets.all(8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Identifiant : "),
                        Text("Nom : "),
                        Text("Prénom : "),
                        Text("Civilité : "),
                        Text("Date de n. : "),
                        Text("Classe : "),
                        Text("Int / Ext : "),
                        Text("Etat : "),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(eleve.identifiant),
                        Text(eleve.nom),
                        Text(eleve.prenom),
                        Text(eleve.genre),
                        Text(eleve.ddn),
                        Text(eleve.classe),
                        Text(eleve.int_ent),
                        Text(
                          eleve.etat,
                          style: const TextStyle(
                              color: Colors.green
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(flex: 1),
                  Expanded(
                    flex: 3,
                    child: Image.network(
                      'https://covers-ng3.hosting-media.net/art/r288/641835.jpg',
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

/*
class BaseDeNotationBlock extends StatelessWidget {
  const BaseDeNotationBlock({required this.bilan, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Base de notation",
              textAlign: TextAlign.start,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: Card(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Spacer(),
                    Column(
                      children: [
                        Text(
                          "Note de comportement:",
                          style: TextStyle(fontSize: 11, color: Colors.black54),
                        ),
                        Text(
                          "Note d'assiduité:",
                          style: TextStyle(fontSize: 11, color: Colors.black54),
                        ),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.end,
                    ),
                    Spacer(),
                    Column(
                      children: [
                        Image(
                          image: AssetImage(
                              'assets/drawable/' + bilan.comp + '.png'),
                          width: 20,
                          height: 20,
                        ),
                        Image(
                          image: AssetImage(
                              'assets/drawable/' + bilan.assidu + '.png'),
                          width: 20,
                          height: 20,
                        ),
                      ],
                    ),
                    Spacer(),
                    Column(
                      children: [
                        Text(
                          "Note de devoir:",
                          style: TextStyle(fontSize: 11, color: Colors.black54),
                        ),
                        Text(
                          "Note golabal:",
                          style: TextStyle(fontSize: 11, color: Colors.black54),
                        ),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.end,
                    ),
                    Spacer(),
                    Column(
                      children: [
                        Image(
                          image:
                          AssetImage('assets/drawable/' + bilan.dm + '.png'),
                          width: 20,
                          height: 20,
                        ),
                        Image(
                          image: AssetImage(
                              'assets/drawable/' + bilan.global + '.png'),
                          width: 20,
                          height: 20,
                        ),
                      ],
                    ),
                    Spacer(),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
            elevation: 5,
            shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.circular(5.0)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Bilan",
              textAlign: TextAlign.start,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(3.0),
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 78,
                      ),
                      Text("Date:",
                          style: TextStyle(fontSize: 11, color: Colors.black54)),
                      SizedBox(
                        width: 20,
                      ),
                      Text(bilan.date, style: TextStyle(fontSize: 11)),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    SizedBox(
                      width: 58,
                    ),
                    Text(
                      "Matières:",
                      style: TextStyle(fontSize: 11, color: Colors.black54),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    listSubjects(context, bilan.subjects),
                  ]),
                  Divider(
                    color: Colors.black,
                    thickness: 1,
                    indent: 5.0,
                    endIndent: 5.0,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Axes d'amélioration:",
                        style: TextStyle(fontSize: 11, color: Colors.black54),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                          child: Text(
                            bilan.toImprove,
                            style: TextStyle(fontSize: 11),
                          )),
                    ],
                  ),
                  Divider(
                    color: Colors.black,
                    thickness: 1,
                    indent: 5.0,
                    endIndent: 5.0,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 43,
                      ),
                      Text(
                        "Points forts:",
                        style: TextStyle(fontSize: 11, color: Colors.black54),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          child: Text(
                            bilan.good,
                            style: TextStyle(fontSize: 11),
                          )),
                    ],
                  ),
                  Divider(
                    color: Colors.black,
                    thickness: 1,
                    indent: 5.0,
                    endIndent: 5.0,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 30,
                      ),
                      Text(
                        "Commentaires:",
                        style: TextStyle(fontSize: 11, color: Colors.black54),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          child: Text(
                            bilan.comment,
                            style: TextStyle(fontSize: 11),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
              elevation: 5,
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(5.0)),
            ))
      ],
    );
  }
}

*/


class DetailsContent extends StatelessWidget {
  final Eleve eleve;
  final Bilan bilan;

  const DetailsContent({required this.eleve, required this.bilan, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: orangePerso,
        title:Text(
          'Détails',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.primaryColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              EleveInfoBlock(eleve: eleve),
              const SizedBox(height: 20),
              //BaseDeNotationBlock(),
              const SizedBox(height: 20),
              // BilanBlock(),
              const SizedBox(height: 20),
              // SoumettreButton(),
              const SizedBox(height: 20),
            ],
          ),
        )
      ),
    );
  }
}