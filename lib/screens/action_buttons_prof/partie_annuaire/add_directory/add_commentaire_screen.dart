import 'package:flutter/material.dart';

import '../../../../utilities/constantes.dart';

import '../../../../utils.dart';

class AddCommentaire extends StatefulWidget {
  final Eleve eleve;

  const AddCommentaire({required this.eleve, Key? key}) : super(key: key);

  @override
  AddCommentaireState createState() => AddCommentaireState();
}

class AddCommentaireState extends State<AddCommentaire> {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: orangePerso,
        title:Text(
          'Nouveau commentaire - ${widget.eleve.prenom}',
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