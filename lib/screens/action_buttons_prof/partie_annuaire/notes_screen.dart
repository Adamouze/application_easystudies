import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_directory/add_note_screen.dart';
import '../../../utilities/constantes.dart';
import '../../../logs/auth_stat.dart';
import '../../../utils.dart';




class NoteBlock extends StatelessWidget {
  final Eleve eleve;

  const NoteBlock({required this.eleve, Key? key}) : super(key: key);

  Widget buildNoteRow(Note note, int index, Color color) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: color,
        margin: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
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
              Text(note.commentaire),
            ],
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
    List<Widget> noteRows = createNoteRows(eleve);
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
              child: noteRows.isEmpty
                  ? Container(
                height: 10,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(arrondiBox - 3),
                    bottomRight: Radius.circular(arrondiBox - 3),
                  ),
                ),
              )
                  : Column(
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              NoteBlock(eleve: widget.eleve),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
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
              child: addDevoirs,
            ),
          ),
        ),
      ),
    );
  }
}




