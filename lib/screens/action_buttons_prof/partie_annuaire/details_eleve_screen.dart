import 'package:EasyStudies/screens/boutons_app_bar/historique_paiement.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expandable/expandable.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;


import '../../../utilities/constantes.dart';
import '../../../logs/auth_stat.dart';

import 'devoirs_screen.dart';
import 'commentaires_screen.dart';
import 'notes_screen.dart';
import 'bilans_screen.dart';
import 'details_bilan.dart';
import '../../boutons_app_bar/historique_presence.dart';
import 'add_directory/add_bilan_screen.dart';
import 'add_directory/add_commentaire_screen.dart';
import 'add_directory/add_devoir_screen.dart';
import 'add_directory/add_note_screen.dart';


import '../../../utils.dart';


class EleveInfoBlock extends StatelessWidget {
  final Eleve eleve;

  const EleveInfoBlock({required this.eleve, Key? key}) : super(key: key);

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
                topLeft: Radius.circular(arrondiBox),
                topRight: Radius.circular(arrondiBox),
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
                '${'Éleve -'} ${eleve.identifier}',
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
                bottomLeft: Radius.circular(arrondiBox),
                bottomRight: Radius.circular(arrondiBox),
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
              padding: const EdgeInsets.all(8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Civilité : "),
                        Text("Nom : "),
                        Text("Prénom : "),
                        Text("Date de n. : "),
                        Text("Classe : "),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(eleve.civilite),
                        Tooltip(
                          message: eleve.nom,
                          child: Text(
                            eleve.nom,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Tooltip(
                          message: eleve.prenom,
                          child: Text(
                            eleve.prenom,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(eleve.dob),
                        Text(eleve.classe),
                      ],
                    ),
                  ),

                  // const Spacer(flex: 1),

                  Expanded(
                    flex: 2,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(arrondiBox),  // Ajustez ce chiffre pour contrôler le rayon d'arrondi
                      child: Image.network(
                        eleve.photo,
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            // Le chargement est terminé et aucune erreur ne s'est produite
                            return child;
                          } else if (loadingProgress.expectedTotalBytes != null &&
                              loadingProgress.cumulativeBytesLoaded < loadingProgress.expectedTotalBytes!) {
                            // L'image est en cours de chargement
                            return const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(orangePerso),
                              ),
                            );
                          } else {
                            // Une erreur s'est produite (par exemple, une erreur 404)
                            return Image.asset(getDefaultPhoto(eleve.civilite), fit: BoxFit.cover);
                          }
                        },
                        errorBuilder: (context, error, stackTrace) {
                          // En cas d'erreur, afficher l'image par défaut
                          return Image.asset(getDefaultPhoto(eleve.civilite), fit: BoxFit.cover);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EleveContactBlock extends StatelessWidget {
  final Eleve eleve;

  const EleveContactBlock({required this.eleve, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FractionallySizedBox(
      widthFactor: 0.95,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ExpandableNotifier(
            child: ScrollOnExpand(
              scrollOnExpand: false,
              scrollOnCollapse: true,
              child: Column(
                children: <Widget>[
                  ExpandablePanel(
                    theme: const ExpandableThemeData(
                      headerAlignment: ExpandablePanelHeaderAlignment.center,
                      tapBodyToCollapse: true,
                      hasIcon: false, // This disables the default icon
                    ),
                    header: Container(
                      decoration: BoxDecoration(
                        color: orangePerso,
                        borderRadius: BorderRadius.circular(arrondiBox),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '${'Contacts -'} ${eleve.prenom}',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'NotoSans',
                            ),
                          ),
                          ExpandableIcon(  // use this instead of Icon
                            theme: ExpandableThemeData(
                              expandIcon: Icons.keyboard_arrow_down,
                              collapseIcon: Icons.keyboard_arrow_up,
                              iconColor: theme.iconTheme.color,
                              iconSize: 28.0,
                              iconRotationAngle: - math.pi,
                              iconPadding: const EdgeInsets.only(right: 5),
                              hasIcon: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                    collapsed: Container(),
                    expanded: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(arrondiBox),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              // Ici les informations
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    flex: 2,
                                    child: ListView(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      children: const <Widget>[
                                        Text("Numéro de fixe : "),
                                        Text("Mobile de l'élève: "),
                                        Text("Mobile d'un parent : "),
                                        Text("Email de l'élève : "),
                                        Text("Email d'un parent : "),
                                        Text("Adresse : "),
                                        Text(""),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: ListView(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      children: <Widget>[
                                        eleve.numFix == ""
                                            ? Text("non renseigné", style: TextStyle(color: theme.textTheme.bodySmall?.color, fontStyle: FontStyle.italic))
                                            : Text(eleve.numFix),
                                        Text(eleve.numMobileEleve),
                                        Text(eleve.numMobileParents),
                                        Tooltip(
                                          message: eleve.emailEleve,
                                          child: Text(
                                            eleve.emailEleve,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Tooltip(
                                          message: eleve.emailParents,
                                          child: Text(
                                            eleve.emailParents,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Text(eleve.adresse),
                                        Text(eleve.ville),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              // Ici les boutons
                              Padding(
                                padding: const EdgeInsets.only(top: 16), // Espace entre les informations et les boutons
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        IconButton(
                                          icon: const Icon(Icons.phone),
                                          color: eleve.numFix == "" ? Colors.grey : Colors.black,
                                          onPressed: eleve.numFix == "" ? null : () => launchUrl(Uri.parse("tel://${eleve.numFix}")),
                                        ),
                                        const Text('Fixe'),
                                      ],
                                    ),
                                    if (eleve.numMobileEleve != eleve.numMobileParents)
                                      Column(
                                        children: <Widget>[
                                          IconButton(
                                            icon: const Icon(Icons.phone),
                                            color: Colors.green,
                                            onPressed: eleve.numMobileEleve == "" ? null : () => launchUrl(Uri.parse("tel://${eleve.numMobileEleve}")),
                                          ),
                                          const Text('Élève'),
                                        ],
                                      ),
                                    Column(
                                      children: <Widget>[
                                        IconButton(
                                          icon: const Icon(Icons.phone),
                                          color: Colors.red,
                                          onPressed: eleve.numMobileParents == "" ? null : () => launchUrl(Uri.parse("tel://${eleve.numMobileParents}")),
                                        ),
                                        const Text('Parents'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EleveComptabiliteBlock extends StatelessWidget {
  final Eleve eleve;

  const EleveComptabiliteBlock({required this.eleve, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FractionallySizedBox(
      widthFactor: 0.95,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ExpandableNotifier(
            child: ScrollOnExpand(
              scrollOnExpand: false,
              scrollOnCollapse: true,
              child: Column(
                children: <Widget>[
                  ExpandablePanel(
                    theme: const ExpandableThemeData(
                      headerAlignment: ExpandablePanelHeaderAlignment.center,
                      tapBodyToCollapse: true,
                      hasIcon: false, // This disables the default icon
                    ),
                    header: Container(
                      decoration: BoxDecoration(
                        color: orangePerso,
                        borderRadius: BorderRadius.circular(arrondiBox),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '${'Comptabilité -'} ${eleve.prenom}',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'NotoSans',
                            ),
                          ),
                          ExpandableIcon(  // use this instead of Icon
                            theme: ExpandableThemeData(
                              expandIcon: Icons.keyboard_arrow_down,
                              collapseIcon: Icons.keyboard_arrow_up,
                              iconColor: theme.iconTheme.color,
                              iconSize: 28.0,
                              iconRotationAngle: - math.pi,
                              iconPadding: const EdgeInsets.only(right: 5),
                              hasIcon: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                    collapsed: Container(),
                    expanded: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(arrondiBox),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Solde : ${eleve.solde} €"),
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Prévisionnel : ${eleve.prev} €"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DevoirBlock extends StatefulWidget {
  final Eleve eleve;
  const DevoirBlock({required this.eleve, Key? key}) : super(key: key);

  @override
  DevoirBlockState createState() => DevoirBlockState();
}

class DevoirBlockState extends State<DevoirBlock> {

  Widget buildDevoirRow(Devoir devoir, int index, Color color) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DevoirScreen(eleve: widget.eleve),
          ),
        );
      },
      child: SizedBox(
        width: double.infinity,
        child: Card(
          color: color,
          margin: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: "Date: ",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    children: <TextSpan>[
                      TextSpan(
                        text: afficherDate(devoir.date),
                        style: afficherDate(devoir.date) == "non renseigné"
                            ? TextStyle(fontWeight: FontWeight.normal, fontStyle: FontStyle.italic, color: Colors.grey[700])
                            : const TextStyle(fontStyle: FontStyle.normal, color: Colors.black),
                      ),
                      TextSpan(
                        text: "   Fait: ${devoir.fait}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  devoir.comment,
                  maxLines: 2, // Limite à deux lignes
                  overflow: TextOverflow.ellipsis, // Ajoute des ellipses à la fin si le texte est trop long
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> devoirRows = [];

  List<Widget> createDevoirRows(Eleve eleve) {
    List<Widget> rows = [];

    // On ne prend que les 2 derniers commentaires
    var devoirs = eleve.devoirs.take(2).toList();

    for (int i = 0; i < devoirs.length; i++) {
      Devoir devoir = devoirs[i];
      Color color = (i % 2 == 0 ? Colors.grey[300] : Colors.grey[400]) ?? Colors.grey;
      rows.add(buildDevoirRow(devoir, i, color));
    }

    // Ajoutez une marge en bas du dernier élément
    if (rows.isNotEmpty) {
      rows.add(const SizedBox(height: 8.0));
    }

    return rows;
  }

  @override
  void initState() {
    super.initState();
    devoirRows = createDevoirRows(widget.eleve);
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                padding: const EdgeInsets.only(left: 8, right: 4, top: epaisseurContour),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Aligns the children on the horizontal axis
                  children: [
                    Text(
                      'Devoirs',
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NotoSans',
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward), // replace with your desired icon
                      color: theme.iconTheme.color, // color of the icon
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DevoirScreen(eleve: widget.eleve)),
                        );
                      },
                    )
                    ,
                  ],
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
              child: devoirRows.isEmpty
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
                  children: devoirRows,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CommentaireBlock extends StatefulWidget {
  final Eleve eleve;
  const CommentaireBlock({required this.eleve, Key? key}) : super(key: key);

  @override
  CommentaireBlockState createState() => CommentaireBlockState();
}

class CommentaireBlockState extends State<CommentaireBlock> {

  Widget buildCommentaireRow(Commentaire commentaire, int index, Color color) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: color,
        margin: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CommentaireScreen(eleve: widget.eleve),
              ),
            );
          },
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
                Text(
                  commentaire.comment,
                  maxLines: 2, // Limite à deux lignes
                  overflow: TextOverflow.ellipsis, // Ajoute des ellipses à la fin si le texte est trop long
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> commentaireRows = [];

  List<Widget> createCommentaireRows(Eleve eleve) {
    List<Widget> rows = [];

    // On ne prend que les 2 derniers commentaires
    var commentaires = eleve.commentaires.take(2).toList();

    for (int i = 0; i < commentaires.length; i++) {
      Commentaire commentaire = commentaires[i];
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
  void initState() {
    super.initState();
    commentaireRows = createCommentaireRows(widget.eleve);
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                padding: const EdgeInsets.only(left: 8, right: 4, top: epaisseurContour),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Aligns the children on the horizontal axis
                  children: [
                    Text(
                      'Commentaires',
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NotoSans',
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward), // replace with your desired icon
                      color: theme.iconTheme.color, // color of the icon
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CommentaireScreen(eleve: widget.eleve)),
                        );
                      },
                    )
                    ,
                  ],
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
    );
  }
}

class NoteBlock extends StatefulWidget {
  final Eleve eleve;
  const NoteBlock({required this.eleve, Key? key}) : super(key: key);

  @override
  NoteBlockState createState() => NoteBlockState();
}

class NoteBlockState extends State<NoteBlock> {

  Widget _buildNoteComment(String comment) {
    // Remplacez tous les '\n' par '\r\n'
    comment = comment.replaceAll('\n', '\r\n');

    // Vérifiez si le commentaire est vide
    if (comment.isEmpty) {
      return Text(
          "non renseigné",
          style: TextStyle(fontWeight: FontWeight.normal, fontStyle: FontStyle.italic, color: Colors.grey[700]),
          maxLines: 2,
          overflow: TextOverflow.ellipsis
      );
    }

    int italicIndex = comment.indexOf('Entrée par:');
    if (italicIndex == -1) {
      italicIndex = comment.indexOf('Modifiée par:');
    }

    if (italicIndex == -1) {
      // Aucun des préfixes n'est présent
      return Text(
          comment,
          style: const TextStyle(fontStyle: FontStyle.normal, color: Colors.black),
          maxLines: 2,
          overflow: TextOverflow.ellipsis
      );
    }

    String normalText = comment.substring(0, italicIndex);
    String italicText = comment.substring(italicIndex);

    return Text.rich(
      TextSpan(
        text: normalText,
        style: const TextStyle(color: Colors.black),
        children: [
          TextSpan(text: italicText, style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.black)),
        ],
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget buildNoteRow(Note note, int index, Color color) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: color,
        margin: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NoteScreen(eleve: widget.eleve),
              ),
            );
          },
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


  List<Widget> noteRows = [];

  List<Widget> createNoteRows(Eleve eleve) {
    List<Widget> rows = [];

    // On ne prend que les 2 derniers commentaires
    var notes = eleve.notes.take(2).toList();

    for (int i = 0; i < notes.length; i++) {
      Note note = notes[i];
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
  void initState() {
    super.initState();
    noteRows = createNoteRows(widget.eleve);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                padding: const EdgeInsets.only(left: 8, right: 4, top: epaisseurContour),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Aligns the children on the horizontal axis
                  children: [
                    Text(
                      'Notes',
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NotoSans',
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward), // replace with your desired icon
                      color: theme.iconTheme.color, // color of the icon
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NoteScreen(eleve: widget.eleve)),
                        );
                      },
                    )
                    ,
                  ],
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
    );
  }
}

class BilanBlock extends StatefulWidget {
  final Eleve eleve;
  const BilanBlock({required this.eleve, Key? key}) : super(key: key);

  @override
  BilanBlockState createState() => BilanBlockState();
}

class BilanBlockState extends State<BilanBlock> {
  int tailleDate = 4;
  int tailleGlobal = 2;
  int tailleComportement = 2;
  int tailleAssidu = 2;
  int tailleDM = 2;
  int tailleDetails = 2;


  Map<String, List<DataRow>> bilanRows = {};

  Map<String, List<DataRow>> createBilanRows(Eleve eleve) {
    Map<String, List<DataRow>> bilanRows = {};

    var bilans = eleve.bilans.take(2).toList();

    for (int i = 0; i < bilans.length; i++) {
      Bilan bilan = bilans[i];
      DataRow row = DataRow(
        color: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return Theme.of(context).colorScheme.primary.withOpacity(0.08);
          }
          return i % 2 == 0 ? Colors.grey[300] : Colors.grey[400];
        }),
        cells: <DataCell>[
          DataCell(Center(
              child: RichText(
                text: TextSpan(
                  text: afficherDate(bilan.date),
                  style: afficherDate(bilan.date) == "non renseigné"
                      ? TextStyle(fontWeight: FontWeight.normal, fontStyle: FontStyle.italic, color: Colors.grey[700])
                      : const TextStyle(fontStyle: FontStyle.normal, color: Colors.black),
                ),
              ),
          )),
          DataCell(Center(child: getSmiley(bilan.global))),
          DataCell(Center(child: getSmiley(bilan.comp))),
          DataCell(Center(child: getSmiley(bilan.assidu))),
          DataCell(Center(child: getSmiley(bilan.dm))),
          DataCell(
            Center(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DetailsBilanContent(bilan: bilan)),
                  );
                },
                child: detailsBilan,
              ),
            ),
          ),
        ],
      );

      bilanRows[eleve.identifier] = [...?bilanRows[eleve.identifier], row];
    }
    return bilanRows;
  }

  @override
  void initState() {
    super.initState();
    bilanRows = createBilanRows(widget.eleve);
  }

  Widget buildHeaderRow() {
    final theme = Theme.of(context);
    if (bilanRows[widget.eleve.identifier] == null || bilanRows[widget.eleve.identifier]!.isEmpty) {
      return Container(
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
        child: Container(
          height: 10,
          decoration: BoxDecoration(
            color: theme.colorScheme.background,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(arrondiBox - 3),
              bottomRight: Radius.circular(arrondiBox - 3),
            ),
          ),
        ),
      );
    }
    return Flex(
      direction: Axis.horizontal,
      children: <Widget>[
        Expanded(flex: tailleDate, child: const Center(child: Text('Date', style: TextStyle(fontWeight: FontWeight.bold)))),
        Expanded(flex: tailleGlobal, child: const Center(child: Text('Global', style: TextStyle(fontWeight: FontWeight.bold)))),
        Expanded(flex: tailleComportement, child: const Center(child: Text('Comp.', style: TextStyle(fontWeight: FontWeight.bold)))),
        Expanded(flex: tailleAssidu, child: const Center(child: Text('Assid.', style: TextStyle(fontWeight: FontWeight.bold)))),
        Expanded(flex: tailleDM, child: const Center(child: Text('DM', style: TextStyle(fontWeight: FontWeight.bold)))),
        Expanded(flex: tailleDetails, child: const Center(child: Text('Détails', style: TextStyle(fontWeight: FontWeight.bold)))),
      ],
    );
  }

  List<Widget> buildBilanRows() {
    if (bilanRows[widget.eleve.identifier] == null || bilanRows[widget.eleve.identifier]!.isEmpty) {
      return [];
    }

    List<DataRow> bilanRowsList = bilanRows[widget.eleve.identifier]!;
    List<int> flexValues = [
      tailleDate,
      tailleGlobal,
      tailleComportement,
      tailleAssidu,
      tailleDM,
      tailleDetails,
    ];
    return List<Widget>.generate(bilanRowsList.length, (int index) {
      DataRow row = bilanRowsList[index];
      return Container(
        color: index % 2 == 0 ? Colors.grey[300] : Colors.grey[400], // recréer l'alternance des gris
        child: Flex(
          direction: Axis.horizontal,
          children: List<Widget>.generate(row.cells.length, (int cellIndex) {
            return Expanded(
              flex: flexValues[cellIndex],
              child: Padding(
                padding: const EdgeInsets.all(4.0), // Marge au sein des cases du tableau
                child: row.cells[cellIndex].child,
              ),
            );
          }),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                padding: const EdgeInsets.only(left: 8, right: 4, top: epaisseurContour),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Aligns the children on the horizontal axis
                  children: [
                    Text(
                      'Bilans',
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NotoSans',
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward), // replace with your desired icon
                      color: theme.iconTheme.color, // color of the icon
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BilanScreen(eleve: widget.eleve)),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(arrondiBox),
                  bottomRight: Radius.circular(arrondiBox),
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
                padding: const EdgeInsets.only(left: 0.0),
                child: Column(
                  children: [
                    buildHeaderRow(),
                    ...buildBilanRows(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FancyFab extends StatefulWidget {
  final Eleve eleve;
  const FancyFab({required this.eleve, Key? key}) : super(key: key);

  @override
  FancyFabState createState() => FancyFabState();
}

class FancyFabState extends State<FancyFab> with SingleTickerProviderStateMixin {
  bool isOpened = false;
  late AnimationController _animationController;
  late Animation<Color?> _buttonColor;
  late Animation<double> _animateIcon;
  late Animation<double> _translateButton;
  final Curve _curve = Curves.easeOut;
  final double _fabHeight = 56.0;

  @override
  initState() {
    _animationController =
    AnimationController(vsync: this, duration: const Duration(milliseconds: 500))
      ..addListener(() {
        setState(() {});
      });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: Colors.blue,
      end: Colors.red,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 6,
            0.0,
          ),
          child: FloatingActionButton(
            backgroundColor: theme.primaryColor,
            heroTag: null,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddBilan(eleve: widget.eleve)),
              );
            },
            tooltip: 'Ajouter un bilan',
            child: addBilan,
          ),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 5,
            0.0,
          ),
          child: FloatingActionButton(
            backgroundColor: theme.primaryColor,
            heroTag: null,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddNote(eleve: widget.eleve)),
              );
            },
            tooltip: 'Ajouter une note',
            child: addNote,
          ),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 4,
            0.0,
          ),
          child: FloatingActionButton(
            backgroundColor: theme.primaryColor,
            heroTag: null,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddCommentaire(eleve: widget.eleve)),
              );
            },
            tooltip: 'Ajouter un commentaire',
            child: addComment,
          ),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 3,
            0.0,
          ),
          child: FloatingActionButton(
            backgroundColor: theme.primaryColor,
            heroTag: null,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddDevoir(eleve: widget.eleve)),
              );
            },
            tooltip: 'Ajouter un devoir',
            child: addDevoirs,
          ),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 2,
            0.0,
          ),
          child: FloatingActionButton(
            backgroundColor: theme.primaryColor,
            heroTag: null,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoryPaiementScreen(eleve: widget.eleve)),
              );
            },
            tooltip: 'Historique de paiement',
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: historiquePaiement,
            ),
          ),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 1,
            0.0,
          ),
          child: FloatingActionButton(
            backgroundColor: theme.primaryColor,
            heroTag: null,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoryPresenceScreen(eleve: widget.eleve)),
              );
            },
            tooltip: 'Historique de présence',
            child: const Padding(
              padding: EdgeInsets.all(3.0),
              child: historiquePresence,
            ),
          ),
        ),
        toggle(),
      ],
    );
  }

  Widget toggle() {
    return FloatingActionButton(
      backgroundColor: _buttonColor.value,
      onPressed: animate,
      tooltip: 'Toggle',
      child: AnimatedIcon(
        icon: AnimatedIcons.menu_close,
        progress: _animateIcon,
      ),
    );
  }
}


class DetailsEleve extends StatefulWidget {
  final Eleve eleve;
  const DetailsEleve({required this.eleve, Key? key}) : super(key: key);

  @override
  DetailsEleveState createState() => DetailsEleveState();
}

class DetailsEleveState extends State<DetailsEleve> {

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

    return FutureBuilder<Eleve>(
      future: getAllEleve(token, login, widget.eleve),
      builder: (BuildContext context, AsyncSnapshot<Eleve> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(orangePerso),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // en cas d'erreur
        } else {
          Eleve eleve = snapshot.data ?? widget.eleve; // une fois les données chargées

          return Scaffold(
            appBar: AppBar(
              backgroundColor: orangePerso,
              title:Text(
                '${eleve.nom} ${eleve.prenom}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
              iconTheme: IconThemeData(
                color: theme.primaryColor,
              ),
            ),
            body: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: espacementBlocsDetailsEleve),
                    EleveInfoBlock(eleve: eleve),
                    const SizedBox(height: espacementBlocsDetailsEleve),
                    EleveContactBlock(eleve: eleve),
                    const SizedBox(height: espacementBlocsDetailsEleve),
                    EleveComptabiliteBlock(eleve: eleve),
                    const SizedBox(height: espacementBlocsDetailsEleve),
                    DevoirBlock(eleve: eleve),
                    const SizedBox(height: espacementBlocsDetailsEleve),
                    CommentaireBlock(eleve: eleve),
                    const SizedBox(height: espacementBlocsDetailsEleve),
                    NoteBlock(eleve: eleve),
                    const SizedBox(height: espacementBlocsDetailsEleve),
                    BilanBlock(eleve: eleve),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
            floatingActionButton: FancyFab(eleve: eleve),
          );
        }
      },
    );
  }
}

