import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../../utilities/constantes.dart';
import '../../../../utils.dart';
import '../../../../logs/auth_stat.dart';


class NoteBlock extends StatefulWidget {
  final Note note;
  const NoteBlock({required this.note ,Key? key}) : super(key: key);

  @override
  NoteBlockState createState() => NoteBlockState();
}

class NoteBlockState extends State<NoteBlock> {

  DateTime _date = DateTime.now();

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
                'Note',
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
            child: Column(
              children: <Widget>[
                TextButton(
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _date,
                      firstDate: DateTime(2015),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null && picked != _date) {
                      setState(() {
                        _date = picked;
                        widget.note.date = DateFormat('yyyy-MM-dd').format(picked);
                      });
                    }
                  },
                  child: TextField(
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: DateFormat('dd/MM/yyyy').format(_date),
                      labelStyle: const TextStyle(color: Colors.black),
                      suffixIcon: const Icon(
                        Icons.calendar_month,
                        color: Colors.black,
                      ),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0), // Ajout de marge extérieure
                  child: TextField(
                    maxLines: null, // permet plusieurs lignes
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      hintText: 'Écrivez votre commentaire ici...',
                      labelText: 'Commentaire',
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                      border: OutlineInputBorder(),

                    ),
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    onChanged: (value) => widget.note.commentaire = value,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SoumettreButton extends StatelessWidget {
  final Eleve eleve;
  final Note note;
  final VoidCallback onSubmit; // Rappel à appeler lors de la soumission

  const SoumettreButton({
    required this.eleve,
    required this.note,
    required this.onSubmit, // Inclure le rappel dans le constructeur
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // This centers the two buttons
      children: <Widget>[
        const SizedBox(),
        ElevatedButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
          label: const Text('Retour'),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.orangeAccent),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            onSubmit(); // Appelle le rappel lorsqu'il est pressé
            Navigator.pop(context); // Optionnel : ferme la page actuelle
          },
          icon: const Icon(Icons.check),
          label: const Text('Ajouter'),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
        ),
        const SizedBox(),
      ],
    );
  }
}


class AddNote extends StatefulWidget {
  final Eleve eleve;

  const AddNote({required this.eleve, Key? key}) : super(key: key);

  @override
  AddNoteState createState() => AddNoteState();
}

class AddNoteState extends State<AddNote> {

  final Note note = Note("", "", "", "");

  void handleSubmitNote(String token, String login) async {
    try {
      await addNoteToDatabase(token, login, widget.eleve, note);
      print('Note ajoutée avec succès.');

      // Appel à getCommentsEleve pour rafraîchir les notes
      await getNotesEleve(token, login, widget.eleve);

    } catch (e) {
      print('Erreur lors de l\'ajout de la note : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final authState = Provider.of<AuthState>(context, listen: false);
    final token = authState.token;
    final login = authState.identifier;

    if (token == null) {
      return const Text("ERREUR de token dans la requête API");
    }
    if (login == null) {
      return const Text("ERREUR de login dans la requête API");
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: orangePerso,
        title: Text(
          'Nouvelle note - ${widget.eleve.prenom}',
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
                NoteBlock(note: note),
                const SizedBox(height: 20),
                SoumettreButton(
                  eleve: widget.eleve,
                  note: note,
                  onSubmit: () => handleSubmitNote(token, login),
                ),
                const SizedBox(height: 20),
              ],
            ),
          )
      ),
    );
  }
}
