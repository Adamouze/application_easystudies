import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_directory/add_note_screen.dart';
import 'update_directory/update_note_screen.dart';
import '../../../utilities/constantes.dart';
import '../../../logs/auth_stat.dart';
import '../../../utils.dart';




class NoteBlock extends StatefulWidget {
  final Eleve eleve;

  const NoteBlock({required this.eleve, Key? key}) : super(key: key);

  @override
  NoteBlockState createState() => NoteBlockState();
}

class NoteBlockState extends State<NoteBlock> {

  void refreshNotes() async {
    final authState = Provider.of<AuthState>(context, listen: false);
    final token = authState.token ?? "";
    final login = authState.identifier ?? "";
    final newEleve = await getNotesEleve(token, login, widget.eleve);
    setState(() {
      widget.eleve.notes = newEleve.notes;
    });
  }

  Widget _buildNoteComment(String comment) {
    // Remplacez tous les '\n' par '\r\n'
    comment = comment.replaceAll('\n', '\r\n');

    // Vérifiez si le commentaire est vide
    if (comment.isEmpty) {
      return Text(
          "non renseigné",
          style: TextStyle(fontWeight: FontWeight.normal, fontStyle: FontStyle.italic, color: Colors.grey[700])
      );
    }

    int italicIndex = comment.indexOf('Entrée par:');
    if (italicIndex == -1) {
      italicIndex = comment.indexOf('Modifiée par:');
    }

    if (italicIndex == -1) {
      // Aucun des préfixes n'est présent
      return Text(comment, style: const TextStyle(fontStyle: FontStyle.normal, color: Colors.black));
    }

    String normalText = comment.substring(0, italicIndex);
    String italicText = comment.substring(italicIndex);

    return RichText(
      text: TextSpan(
        text: normalText,
        style: const TextStyle(color: Colors.black),
        children: [
          TextSpan(text: italicText, style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.black)),
        ],
      ),
    );
  }

  Widget buildNoteRow(Note note, int index, Color color) {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: color,
        margin: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
        child: InkWell(
          onLongPress: () {
            showDialog(
              context: context,
              builder: (context) => Theme(
                data: ThemeData(
                  dialogBackgroundColor: theme.primaryColor, // Couleur de fond du dialogue
                ),
                child: SimpleDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Bords arrondis
                    side: const BorderSide(
                      color: orangePerso, // Couleur de la bordure
                      width: 3, // Largeur de la bordure
                    ),
                  ),
                  children: [
                    Center( // Ajout du widget Center pour centrer le contenu
                      child: SimpleDialogOption(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateNote(eleve: widget.eleve, note: note, onNoteUpdate: refreshNotes),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min, // Pour que la Row n'occupe que l'espace nécessaire
                          children: [
                            Icon(Icons.edit, color: theme.primaryIconTheme.color),
                            const SizedBox(width: 10.0),
                            Text("Modifier la note", style: TextStyle(color: theme.textTheme.bodyLarge?.color, fontFamily: 'NotoSans')),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          splashColor: orangePerso,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          text: "Date: ",
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                              text: afficherDate(note.date),
                              style: afficherDate(note.date) == "non renseigné"
                                  ? TextStyle(fontWeight: FontWeight.normal, fontStyle: FontStyle.italic, color: Colors.grey[700])
                                  : const TextStyle(fontStyle: FontStyle.normal, color: Colors.black),
                            ),
                            TextSpan(
                              text: "   Type: ${note.type}",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      "Note: ${note.note}/20",
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ],
                ),
                const SizedBox(height: 5),

                _buildNoteComment(note.commentaire),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> createNoteRows(Eleve eleve) {
    List<Widget> rows = [];

    // On ne prend que les 2 derniers Notes

    for (int i = 0; i < eleve.notes.length; i++) {
      Note note = eleve.notes[i];
      Color color = (i % 2 == 0 ? Colors.grey[300] : Colors.grey[400]) ?? Colors.grey;
      rows.add(buildNoteRow(note, i, color));
    }

    // Ajoutez une marge en bas du dernier élément
    if (rows.isNotEmpty) {
      rows.add(const SizedBox(height: 8.0));
    }

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> noteRows = createNoteRows(widget.eleve);
    return ClipRRect(
      borderRadius: BorderRadius.circular(arrondiBox),
      child: FractionallySizedBox(
        widthFactor: 0.95,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                color: orangePerso,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(arrondiBox),
                  topRight: Radius.circular(arrondiBox),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 8 - epaisseurContour),
                child: Text(
                  'Notes',
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
                border: Border.all(
                  color: orangePerso,
                  width: epaisseurContour,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(arrondiBox),
                  bottomRight: Radius.circular(arrondiBox),
                ),
              ),
              child: Column(
                children: noteRows,
              ),
            ),
          ],
        ),
      ),
    );  }
}

class NoteScreen extends StatefulWidget {
  final Eleve eleve;

  const NoteScreen({required this.eleve, Key? key}) : super(key: key);

  @override
  NoteScreenState createState() => NoteScreenState();
}

class NoteScreenState extends State<NoteScreen> {

  void refreshNotes() async {
    final authState = Provider.of<AuthState>(context, listen: false);
    final token = authState.token ?? "";
    final login = authState.identifier ?? "";
    final newEleve = await getNotesEleve(token, login, widget.eleve);
    setState(() {
      widget.eleve.notes = newEleve.notes;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Contenu du corps selon la condition
    Widget bodyContent;

    if (widget.eleve.notes.isEmpty) {
      bodyContent = const Center(
        child: Text(
          "Pas de notes ici",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            fontSize: 18,
          ),
        ),
      );
    } else {
      bodyContent = SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 20),
                NoteBlock(eleve: widget.eleve),
                const SizedBox(height: 120)
              ],
            ),
          )
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: orangePerso,
        title:Text(
          'Détails des notes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.primaryColor,
          ),
        ),
        iconTheme: IconThemeData(
          color: theme.primaryColor, // Définissez ici la couleur souhaitée pour l'icône
        ),
      ),
      body: bodyContent,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, right: 16.0), // Écartement aux bords
        child: Transform.scale(
          scale: 1.3,
          child: FloatingActionButton(
            backgroundColor: orangePerso,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddNote(eleve: widget.eleve, onNoteAdded: refreshNotes)),
              );
            },
            tooltip: "Ajout d'un commentaire",
            elevation: 10.0, // Rehaussement
            shape: const CircleBorder(),
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                  theme.iconTheme.color ?? Colors.white, BlendMode.srcIn),
              child: addNote,
            ),
          ),
        ),
      ),
    );
  }
}




