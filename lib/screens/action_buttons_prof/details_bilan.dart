import 'package:flutter/material.dart';

import '../../utilities/constantes.dart';

import '../../../utils.dart';


class BaseDeNotationBlock extends StatelessWidget {
  final Bilan bilan;
  const BaseDeNotationBlock({required this.bilan, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
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