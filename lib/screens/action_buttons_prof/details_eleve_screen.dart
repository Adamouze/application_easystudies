import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../../utilities/constantes.dart';
import '../../logs/auth_stat.dart';

import 'commentaires_screen.dart';
import 'bilans_screen.dart';
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

  Widget buildCommentaireRow(Commentaire commentaire, int index, Color color) {
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
              Text(
                "Date: ${commentaire.date.substring(8,10)}/${commentaire.date.substring(5,7)}/${commentaire.date.substring(0,4)} - Par: ${commentaire.from}",
                style: const TextStyle(fontWeight: FontWeight.bold),
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
    );
  }

  List<Widget> commentaireRows = [];

  List<Widget> createCommentaireRows(Eleve eleve) {
    List<Widget> rows = [];

    // On ne prend que les 2 derniers commentaires
    var commentaires = eleve.commentaires.reversed.take(2).toList().reversed.toList();

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
                padding: const EdgeInsets.only(left: 8, right: 8, top: epaisseurContourCommentaire),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Aligns the children on the horizontal axis
                  children: [
                    Text(
                      'Commentaires',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NotoSans',
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CommentaireScreen(eleve: widget.eleve)),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        backgroundColor: Colors.blue, // color of the button
                        foregroundColor: Colors.white, // color of the button text
                      ),
                      child: const Text('Voir plus'),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: orangePerso,
                  width: epaisseurContourCommentaire,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(arrondiBox),
                  bottomRight: Radius.circular(arrondiBox),
                ),
              ),
              child: commentaireRows.isEmpty
                ? Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(arrondiBox-3),
                      bottomRight: Radius.circular(arrondiBox-3),
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

class BilanBlock extends StatefulWidget {
  final Eleve eleve;
  const BilanBlock({required this.eleve, Key? key}) : super(key: key);

  @override
  BilanBlockState createState() => BilanBlockState();
}

class BilanBlockState extends State<BilanBlock> {
  int tailleNumero = 1;
  int tailleDate = 4;
  int tailleGlobal = 2;
  int tailleComportement = 2;
  int tailleAssidu = 2;
  int tailleDM = 2;
  int tailleDetails = 2;


  Map<String, List<DataRow>> bilanRows = {};

  Map<String, List<DataRow>> createBilanRows(Eleve eleve) {
    Map<String, List<DataRow>> bilanRows = {};

    var bilans = eleve.bilans.reversed.take(2).toList().reversed.toList();

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
          DataCell(Center(child: Text((i+1).toString()))), // centrage du contenu
          DataCell(Center(child: Text('${bilan.date.substring(8,10)}/${bilan.date.substring(5,7)}/${bilan.date.substring(0,4)}'))),
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
                    MaterialPageRoute(builder: (context) => DetailsBilanContent(eleve: eleve, bilan: bilan)),
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
    if (bilanRows[widget.eleve.identifier] == null || bilanRows[widget.eleve.identifier]!.isEmpty) {
      return const SizedBox(height: 10);
    }
    return Flex(
      direction: Axis.horizontal,
      children: <Widget>[
        Expanded(flex: tailleNumero, child: const Center(child: Text('N°', style: TextStyle(fontWeight: FontWeight.bold)))),
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
      tailleNumero,
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(arrondiBox),
      child: FractionallySizedBox(
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
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Aligns the children on the horizontal axis
                  children: [
                    Text(
                      'Bilans',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NotoSans',
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BilanScreen(eleve: widget.eleve)),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        backgroundColor: Colors.blue, // color of the button
                        foregroundColor: Colors.white, // color of the button text
                      ),
                      child: const Text('Voir plus'),
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
                          child: addBilan,
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

