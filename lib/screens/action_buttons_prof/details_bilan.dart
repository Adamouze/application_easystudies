import 'package:flutter/material.dart';

import '../../utilities/constantes.dart';

import '../../../utils.dart';


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
      body: const SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 20),
              //BaseDeNotationBlock(),
              SizedBox(height: 20),
              // BilanBlock(),
              SizedBox(height: 20),
              // SoumettreButton(),
              SizedBox(height: 20),
            ],
          ),
        )
      ),
    );
  }
}