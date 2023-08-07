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

  final ValueNotifier<bool> isNoteValidNotifier = ValueNotifier<bool>(false);

  void _checkNoteValidity() {
    bool isNoteValid = _selectedType != null &&
        widget.note.note.trim().isNotEmpty &&
        double.tryParse(widget.note.note) != null &&
        (double.parse(widget.note.note) >= 0 && double.parse(widget.note.note) <= 20);
    isNoteValidNotifier.value = isNoteValid;
  }

  bool _isNoteValid() {
    double? parsedNote = double.tryParse(widget.note.note);
    return parsedNote != null && parsedNote >= 0 && parsedNote <= 20;
  }


  @override
  void dispose() {
    isNoteValidNotifier.dispose();
    super.dispose();
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
                      lastDate: DateTime(2100),
                    );
                    _date = picked ?? _date;
                    widget.note.date = DateFormat('yyyy-MM-dd').format(_date);
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
                          _checkNoteValidity();
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
                if (_selectedType == null)
                  const Padding(
                    padding: EdgeInsets.only(left: 0.0),
                    child: Text(
                      'Veuillez choisir un type.',
                      style: TextStyle(color: Colors.red),
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
                      onChanged: (value) {
                        widget.note.note = value;
                        _checkNoteValidity();
                        setState(() {}); // Cela permet de rafraîchir l'interface utilisateur
                      }
                  ),
                ),
                if (widget.note.note.trim().isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(left: 0.0),
                    child: Text(
                      'Veuillez entrer une note.',
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                else if (!_isNoteValid())
                  const Padding(
                    padding: EdgeInsets.only(left: 0.0),
                    child: Text(
                      "La note n'est pas valide.",
                      style: TextStyle(color: Colors.red),
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
                    onChanged: (value) {
                      widget.note.commentaire = value;
                    }
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

class SoumettreButton extends StatefulWidget {
  final Eleve eleve;
  final Note note;
  final VoidCallback onSubmit;
  final ValueNotifier<bool> isNoteValidNotifier;

  const SoumettreButton({
    required this.eleve,
    required this.note,
    required this.onSubmit,
    required this.isNoteValidNotifier,
    Key? key,
  }) : super(key: key);

  @override
  SoumettreButtonState createState() => SoumettreButtonState();
}

class SoumettreButtonState extends State<SoumettreButton> {
  @override
  void initState() {
    super.initState();
    widget.isNoteValidNotifier.addListener(_rebuild);
  }

  @override
  void dispose() {
    widget.isNoteValidNotifier.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() {
    setState(() {});
  }

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
          onPressed: widget.isNoteValidNotifier.value
              ? () {
            widget.onSubmit();
            Navigator.pop(context);
          }
              : null,
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
  final Function? onNoteAdded;

  const AddNote({required this.eleve, this.onNoteAdded, Key? key}) : super(key: key);

  @override
  AddNoteState createState() => AddNoteState();
}

class AddNoteState extends State<AddNote> {

  final GlobalKey<NoteBlockState> noteBlockKey = GlobalKey<NoteBlockState>();

  final Note note = Note("", "", "", "", "");

  void handleSubmitNote(String token, String login) async {
    try {
      await manageNote(token, login, widget.eleve, "add", note);
      print('Note ajoutée avec succès.');

      // Appel au callback pour rafraîchir la liste des commentaires
      if (widget.onNoteAdded != null) {
        widget.onNoteAdded!();
      }
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

    note.date == '' ? note.date = DateFormat('yyyy-MM-dd').format(DateTime.now()) : ();

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

                NoteBlock(
                  key: noteBlockKey, // Passer la clé ici
                  note: note,
                ),

                const SizedBox(height: 20),

                Builder(
                  builder: (BuildContext context) {
                    return SoumettreButton(
                      eleve: widget.eleve,
                      note: note,
                      isNoteValidNotifier: noteBlockKey.currentState!.isNoteValidNotifier, // Ici, ça devrait être OK
                      onSubmit: () => handleSubmitNote(token, login),
                    );
                  },
                ),

                const SizedBox(height: 20),
              ],
            ),
          )
      ),
    );
  }
}
