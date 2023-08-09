import 'package:flutter/material.dart';

import '../../../../utilities/constantes.dart';

import '../../../../../utils.dart';


class NoteBlock extends StatelessWidget {
  final Eleve eleve;

  const NoteBlock({required this.eleve, Key? key}) : super(key: key);

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
              
              _buildNoteComment(note.commentaire),
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
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
          ClipRRect(
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
          ),
          const SizedBox(height: 100),
          ],
        ),
      )
    );
  }
}




