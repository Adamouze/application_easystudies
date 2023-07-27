import 'package:flutter/material.dart';

import '../../../../utilities/constantes.dart';

import '../../../../utils.dart';

class AddNote extends StatefulWidget {
  final Eleve eleve;

  const AddNote({required this.eleve, Key? key}) : super(key: key);

  @override
  AddNoteState createState() => AddNoteState();
}

class AddNoteState extends State<AddNote> {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: orangePerso,
        title:Text(
          'Nouvelle note - ${widget.eleve.prenom}',
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