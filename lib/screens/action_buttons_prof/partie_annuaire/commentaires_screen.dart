import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_directory/add_commentaire_screen.dart';
import 'update_directory/update_commentaire_screen.dart';
import '../../../utilities/constantes.dart';
import '../../../logs/auth_stat.dart';
import '../../../utils.dart';


class CommentaireBlock extends StatefulWidget {
  final Eleve eleve;

  const CommentaireBlock({required this.eleve, Key? key}) : super(key: key);

  @override
  CommentaireBlockState createState() => CommentaireBlockState();
}

class CommentaireBlockState extends State<CommentaireBlock> {

  void refreshComments() async {
    final authState = Provider.of<AuthState>(context, listen: false);
    final token = authState.token ?? "";
    final login = authState.identifier ?? "";
    final newEleve = await getCommentsEleve(token, login, widget.eleve);
    setState(() {
      widget.eleve.commentaires = newEleve.commentaires;
    });
  }

  Widget _buildCommentWithModification(String comment) {
    // Remplacez tous les '\n' par '\r\n'
    comment = comment.replaceAll('\n', '\r\n');

    int modifiedIndex = comment.indexOf('Modifié par:');

    if (modifiedIndex == -1) {
      return Text(comment);
    }

    String beforeModified = comment.substring(0, modifiedIndex);
    String modifiedPart = comment.substring(modifiedIndex);

    return RichText(
      text: TextSpan(
        text: beforeModified,
        style: DefaultTextStyle.of(context).style,
        children: [
          TextSpan(text: modifiedPart, style: const TextStyle(fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }

  Widget buildCommentaireRow(Commentaire commentaire, int index, Color color) {
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
                              builder: (context) => UpdateCommentaire(eleve: widget.eleve, commentaire: commentaire, onCommentUpdate: refreshComments),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min, // Pour que la Row n'occupe que l'espace nécessaire
                          children: [
                            Icon(Icons.edit, color: theme.primaryIconTheme.color),
                            const SizedBox(width: 10.0),
                            Text("Modifier le commentaire", style: TextStyle(color: theme.textTheme.bodyLarge?.color, fontFamily: 'NotoSans')),
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
                RichText(
                  text: TextSpan(
                    text: "Date: ",
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                        text: afficherDate(commentaire.date),
                        style: afficherDate(commentaire.date) == "non renseigné"
                            ? TextStyle(fontWeight: FontWeight.normal, fontStyle: FontStyle.italic, color: Colors.grey[700])
                            : const TextStyle(fontStyle: FontStyle.normal, color: Colors.black),
                      ),
                      TextSpan(
                        text: "   Par: ${commentaire.from}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),

                _buildCommentWithModification(commentaire.comment)
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> createCommentaireRows(Eleve eleve) {
    List<Widget> rows = [];

    for (int i = 0; i < eleve.commentaires.length; i++) {
      Commentaire commentaire = eleve.commentaires[i];
      Color color = (i % 2 == 0 ? Colors.grey[300] : Colors.grey[400]) ?? Colors.grey;
      rows.add(buildCommentaireRow(commentaire, i, color));
    }

    // Ajoutez une marge en bas du dernier élément
    if (rows.isNotEmpty) {
      rows.add(const SizedBox(height: 8.0));
    }

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> commentaireRows = createCommentaireRows(widget.eleve);
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
                  'Commentaires',
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
              child: commentaireRows.isEmpty
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
                children: commentaireRows,
              ),
            ),
          ],
        ),
      ),
    );  }
}

class CommentaireScreen extends StatefulWidget {
  final Eleve eleve;

  const CommentaireScreen({required this.eleve, Key? key}) : super(key: key);

  @override
  CommentaireScreenState createState() => CommentaireScreenState();
}

class CommentaireScreenState extends State<CommentaireScreen> {

  void refreshComments() async {
    final authState = Provider.of<AuthState>(context, listen: false);
    final token = authState.token ?? "";
    final login = authState.identifier ?? "";
    final newEleve = await getCommentsEleve(token, login, widget.eleve);
    setState(() {
      widget.eleve.commentaires = newEleve.commentaires;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: orangePerso,
        title:Text(
          'Détails des commentaires',
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
              CommentaireBlock(eleve: widget.eleve),
              const SizedBox(height: 120),
            ],
          ),
        )
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
                MaterialPageRoute(builder: (context) => AddCommentaire(eleve: widget.eleve, onCommentAdded: refreshComments)),
              );
            },
            tooltip: "Ajout d'un commentaire",
            elevation: 10.0, // Rehaussement
            shape: const CircleBorder(),
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                  theme.iconTheme.color ?? Colors.white, BlendMode.srcIn),
              child: addComment,
            ),
          ),
        ),
      ),
    );
  }
}




