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

  String? selectedType;
  bool isDropDownOpened = false;
  final borderStyle = const OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey),
  );
  String? mapNoteTypeToDropdownValue(String? type) {
    switch (type) {
      case "IRFC":
        return "1";
      case "STAGE":
        return "2";
      case "IS":
        return "3";
      default:
        return null;
    }
  }

  final ValueNotifier<bool> isNoteValidNotifier = ValueNotifier<bool>(true);
  final _noteController = TextEditingController();
  final _commentController = TextEditingController();

  bool _isNoteValid() {
    double? parsedNote = double.tryParse(widget.note.note);
    return parsedNote != null && parsedNote >= 0 && parsedNote <= 20;
  }

  void _checkNoteValidity() {
    double? parsedNote = double.tryParse(widget.note.note);
    bool noteNotEmpty = widget.note.note.trim().isNotEmpty;
    bool isParsedNoteValid = parsedNote != null && parsedNote >= 0 && parsedNote <= 20;
    bool isNoteValid = selectedType != null && noteNotEmpty && isParsedNoteValid;

    isNoteValidNotifier.value = isNoteValid;
  }

  _onNoteChanged() {
    widget.note.note = _noteController.text;
    _checkNoteValidity();
    setState(() {});
  }

  _onCommentChanged() {
    widget.note.commentaire = _commentController.text;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    // Initialisation de la variable qui gère le type de note
    selectedType = mapNoteTypeToDropdownValue(widget.note.type);

    // Initialisation des contrôleurs avec les valeurs des widgets
    _noteController.text = widget.note.note;
    _commentController.text = widget.note.commentaire;

    // Ajout des écouteurs pour chaque contrôleur
    _noteController.addListener(_onNoteChanged);
    _commentController.addListener(_onCommentChanged);
  }

  @override
  void dispose() {
    // Suppression des écouteurs et libération des ressources des contrôleurs
    _noteController.removeListener(_onNoteChanged);
    _noteController.dispose();

    _commentController.removeListener(_onCommentChanged);
    _commentController.dispose();

    isNoteValidNotifier.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    DateTime date = widget.note.date.isEmpty ? DateTime.now() : DateTime.parse(widget.note.date);

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
                      initialDate: date,
                      firstDate: DateTime(2015),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null && picked != date) { // Ajout d'une vérification pour éviter des reconstructions inutiles
                      setState(() { // Encadrer les modifications d'état avec setState()
                        date = picked;
                        widget.note.date = DateFormat('yyyy-MM-dd').format(date);
                      });
                    }
                  },
                  child: TextField(
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: DateFormat('dd/MM/yyyy').format(date),
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
                        value: selectedType,
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
                            selectedType = newValue!;
                            isDropDownOpened = !isDropDownOpened;
                            switch (selectedType) {
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
                if (selectedType == null)
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
                    controller: _noteController,
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
                      controller: _commentController,
                      minLines: 3,
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




class UpdateNote extends StatefulWidget {
  final Eleve eleve;
  final Note note;
  final Function? onNoteUpdate;

  const UpdateNote({required this.eleve, required this.note, this.onNoteUpdate, Key? key}) : super(key: key);

  @override
  UpdateNoteState createState() => UpdateNoteState();
}

class UpdateNoteState extends State<UpdateNote> {

  final GlobalKey<NoteBlockState> noteBlockKey = GlobalKey<NoteBlockState>();

  void handleSubmitNote(String token, String login, String user, String prenom) async {
    widget.note.commentaire = widget.note.commentaire.replaceAll('\n', '\r\n');
    if (widget.note.commentaire.trim().isEmpty) {
      // Si le commentaire est vide, assignez seulement "Modifié par: $user ($prenom)"
      widget.note.commentaire = 'Modifiée par: $user ($prenom)';
    } else if (widget.note.commentaire.contains("Modifiée par")) {
      // Si "Modifié par" existe, remplacez la partie après cela
      widget.note.commentaire = widget.note.commentaire.replaceAllMapped(
          RegExp(r'Modifiée par:.*'),
              (match) => 'Modifiée par: $user ($prenom)'
      );
    } else if (widget.note.commentaire.contains("Entrée par")) {
      // Si "Entrée par" existe, ajoutez "Modifié par: $user ($prenom)" après une nouvelle ligne
      widget.note.commentaire = '${widget.note.commentaire}\r\nModifiée par: $user ($prenom)';
    } else {
      // Sinon, ajoutez simplement à la fin
      widget.note.commentaire = '${widget.note.commentaire}\r\n\r\nModifiée par: $user ($prenom)';
    }



    await manageNote(token, login, widget.eleve, "update", widget.note);

    // Appel au callback pour rafraîchir la liste des commentaires
    if (widget.onNoteUpdate != null) {
      widget.onNoteUpdate!();
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

    // Normalement, la ligne ne sera pas utile
    // widget.note.date == '' ? widget.note.date = DateFormat('yyyy-MM-dd').format(DateTime.now()) : ();

    String prenom = authState.prenom!;
    String user = authState.userType!;
    if (user == "prof") {
      user = "PROF";
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: orangePerso,
        title: Text(
          'Modification de la note',
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
                  note: widget.note,
                ),

                const SizedBox(height: 20),

                Builder(
                  builder: (BuildContext context) {
                    return SoumettreButton(
                      eleve: widget.eleve,
                      note: widget.note,
                      isNoteValidNotifier: noteBlockKey.currentState!.isNoteValidNotifier, // Ici, ça devrait être OK
                      onSubmit: () => handleSubmitNote(token, login, user, prenom),
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
