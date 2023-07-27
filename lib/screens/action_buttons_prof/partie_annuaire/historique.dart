import 'package:flutter/material.dart';

import '../../../utilities/constantes.dart';

import '../../../utils.dart';

class Historique extends StatefulWidget {
  final Eleve eleve;

  const Historique({required this.eleve, Key? key}) : super(key: key);

  @override
  HistoriqueState createState() => HistoriqueState();
}

class HistoriqueState extends State<Historique> {

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
      ),
      body: const SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 20),
              ],
            ),
          )
      ),
    );
  }
}