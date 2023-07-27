import 'package:flutter/material.dart';

import '../../../../utilities/constantes.dart';

import '../../../../utils.dart';

class AddDevoir extends StatefulWidget {
  final Eleve eleve;

  const AddDevoir({required this.eleve, Key? key}) : super(key: key);

  @override
  AddDevoirState createState() => AddDevoirState();
}

class AddDevoirState extends State<AddDevoir> {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: orangePerso,
        title:Text(
          'Nouveau devoir - ${widget.eleve.prenom}',
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