import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utilities/constantes.dart';
import '../../logs/auth_stat.dart';

import 'details_bilan.dart';
import 'new_bilan_screen.dart';

import '../../utils.dart';


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
              color: Colors.orangeAccent,
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
                    child: eleve.photo == ""
                        ? Image.asset(getDefaultPhoto(eleve.civilite), fit: BoxFit.cover)
                        : Image.network(eleve.photo, fit: BoxFit.cover),
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
          Container(
            decoration: BoxDecoration(
              color: Colors.orangeAccent,
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
                '${'Contacts -'} ${eleve.prenom}',
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
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
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
            ),
          ),

        ],
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
  int tailleNumero = 1;
  int tailleDate = 4;
  int tailleFrom = 2;
  int tailleComment = 10;

  Widget buildHeaderRow() {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: tailleNumero,
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "N°",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            flex: tailleDate,
            child: const Align(
              alignment: Alignment.center,
              child: Text(
                "Date",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            flex: tailleFrom,
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Par",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: tailleComment,
            child: const Align(
              alignment: Alignment.center,
              child: Text(
                "Commentaire",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCommentaireRow(Commentaire commentaire, int index) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: tailleNumero,
            child: Text((index+1).toString()),
          ),
          Expanded(
            flex: tailleDate,
            child: Text('${commentaire.date.substring(8,10)}/${commentaire.date.substring(5,7)}/${commentaire.date.substring(0,4)}'),
          ),
          Expanded(
            flex: tailleFrom,
            child: Text(commentaire.from),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: tailleComment,
            child: Wrap(
              textDirection: TextDirection.ltr,
              children: [Text(commentaire.comment)],
            ),
          ),
        ],
      ),
    );
  }


  List<Widget> commentaireRows = [];

  @override
  void initState() {
    super.initState();
    commentaireRows = createCommentaireRows(widget.eleve);
  }

  List<Widget> createCommentaireRows(Eleve eleve) {
    List<Widget> rows = [];

    rows.add(buildHeaderRow());

    for (int i = 0; i < eleve.commentaires.length; i++) {
      Commentaire commentaire = eleve.commentaires[i];
      rows.add(buildCommentaireRow(commentaire, i));
    }
    return rows;
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
              color: Colors.orangeAccent,
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
              child: Column(
                children: commentaireRows, // Utilisez la liste des widgets générés comme enfants de la colonne
              ),
            ),
          ),        ],
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

  Map<String, List<DataRow>> bilanRows = {};

  @override
  void initState() {
    super.initState();
    bilanRows = createBilanRows(widget.eleve);
  }

  Map<String, List<DataRow>> createBilanRows(Eleve eleve) {
    Map<String, List<DataRow>> bilanRows = {};

    for (int i = 0; i < eleve.bilans.length; i++) {
      Bilan bilan = eleve.bilans[i];
      DataRow row = DataRow(
        color: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
          if (states.contains(MaterialState.selected))
            return Theme.of(context).colorScheme.primary.withOpacity(0.08);
          return i % 2 == 0 ? Colors.grey[300] : Colors.grey[400];
        }),
        cells: <DataCell>[
          DataCell(Center(child: Text((i+1).toString()))), // centrage du contenu
          DataCell(Center(child: Text('${bilan.date.substring(8,10)}/${bilan.date.substring(5,7)}/${bilan.date.substring(0,4)}'))),
          DataCell(Center(child: getSmiley(bilan.global))),
          DataCell(Center(child: getSmiley(bilan.comp))),
          DataCell(Center(child: getSmiley(bilan.assidu))),
          DataCell(Center(child: getSmiley(bilan.dm))),
          DataCell(
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DetailsContent(eleve: eleve, bilan: bilan)),
                  );
                },
                child: const Text('Détails'),
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
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(arrondiBox),
      child: FractionallySizedBox(
        widthFactor: 0.95,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
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
                  'Bilans',
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
                padding: const EdgeInsets.only(left: 0.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    dataRowMinHeight: 50,
                    dataRowMaxHeight: 50, // ajouter la hauteur de ligne
                    columnSpacing: 10 , // ajuster l'espace entre les colonnes si nécessaire
                    columns: const <DataColumn>[
                      DataColumn(label: Tooltip(
                        message: 'Numéro',
                        child: Text(
                          'N°',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),),
                      DataColumn(label: Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text('Date', style: TextStyle(fontWeight: FontWeight.bold))],
                        ),
                      ),
                      ),
                      DataColumn(label: Text('Global', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Tooltip(
                        message: 'Comportement',
                        child: Text(
                          'Comp.',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),),
                      DataColumn(label: Tooltip(
                        message: 'Assiduité',
                        child: Text(
                          'Assid.',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),),
                      DataColumn(label: Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text('DM', style: TextStyle(fontWeight: FontWeight.bold))],
                        ),
                      ),
                      ),
                      DataColumn(label: Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text('Détails', style: TextStyle(fontWeight: FontWeight.bold))],
                        ),
                      ),
                      ),
                    ],
                    rows: bilanRows[widget.eleve.identifier] ?? [], // Si l'élève n'a pas de bilans, affichez une liste vide
                  ),
                ),
              ),
            ),
          ],
        ),
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
          return const CircularProgressIndicator(); // retourne un indicateur de progression pendant le chargement
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
                    const SizedBox(height: 20),
                    EleveInfoBlock(eleve: eleve),
                    const SizedBox(height: 20),
                    EleveContactBlock(eleve: eleve),
                    const SizedBox(height: 20),
                    CommentaireBlock(eleve: eleve),
                    const SizedBox(height: 20),
                    BilanBlock(eleve: eleve),
                    const SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Transform.scale(
                        scale: 1.4,
                        child: FloatingActionButton(
                          backgroundColor: Colors.blue,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => NewBilan(eleve: eleve)),
                            );
                          },
                          tooltip: "Ajout d'un bilan",
                          elevation: 6.0,
                          shape: const CircleBorder(),
                          child: add_bilan,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20)
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

