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
  String? _selectedType;
  bool isDropDownOpened = false;

  final borderStyle = const OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey),
  );


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
                        border: borderStyle,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: "Type",
                      labelStyle: const TextStyle(color: Colors.black),
                      border: borderStyle,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedType,
                        isDense: true,
                        icon: Icon(
                          isDropDownOpened ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                          color: Colors.black, // Couleur de la flèche déroulante
                        ),
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        dropdownColor: Colors.white, // Couleur de fond du menu déroulant
                        hint: const Text("Choisir le type de la note..."),
                        items: const [
                          DropdownMenuItem(
                            value: "1",
                            child: Text("Int. de fin de cours"),
                          ),
                          DropdownMenuItem(
                            value: "2",
                            child: Text("Stage"),
                          ),
                          DropdownMenuItem(
                            value: "3",
                            child: Text("Int. surprise"),
                          ),
                        ],
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedType = newValue!;
                            isDropDownOpened = !isDropDownOpened;
                            switch (_selectedType) {
                              case "1":
                                widget.note.type = "IRFC";
                                break;
                              case "2":
                                widget.note.type = "STAGE";
                                break;
                              case "3":
                                widget.note.type = "IS";
                                break;
                              default:
                                break;
                            }
                          });
                        },
                        onTap: () {
                          setState(() {
                            isDropDownOpened = !isDropDownOpened;
                          });
                        },
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(10.0), // Ajout de marge extérieure
                  child: TextField(
                    maxLines: null, // permet plusieurs lignes
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: 'Rentrez la note ici...',
                      labelText: 'Note',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                      border: borderStyle,

                    ),
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    onChanged: (value) => widget.note.note = value,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(10.0), // Ajout de marge extérieure
                  child: TextField(
                    maxLines: null, // permet plusieurs lignes
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: 'Écrivez votre commentaire ici...',
                      labelText: 'Commentaire',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                      border: borderStyle,

                    ),
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    onChanged: (value) => widget.note.commentaire = value,
                  ),
                ),

                const SizedBox(height: 5),
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
            backgroundColor: MaterialStateProperty.all<Color>(orangePerso),
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
