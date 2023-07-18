import 'package:flutter/material.dart';

import '../../utilities/constantes.dart';
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
                'Élève',
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
                        Text("Identifiant : "),
                        Text("Nom : "),
                        Text("Prénom : "),
                        Text("Civilité : "),
                        Text("Date de n. : "),
                        Text("Classe : "),
                        Text("Int / Ext : "),
                        Text("Etat : "),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(eleve.identifiant),
                        Text(eleve.nom),
                        Text(eleve.prenom),
                        Text(eleve.genre),
                        Text(eleve.ddn),
                        Text(eleve.classe),
                        Text(eleve.int_ent),
                        Text(
                          eleve.etat,
                          style: const TextStyle(
                              color: Colors.green
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(flex: 1),
                  Expanded(
                    flex: 3,
                    child: Image.network(eleve.photo),
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
        cells: <DataCell>[
          DataCell(Center(child: Text((i+1).toString()))), // centrage du contenu
          DataCell(Center(child: Text(bilan.date))),
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
      bilanRows[eleve.identifiant] = [...?bilanRows[eleve.identifiant], row];
    }
    return bilanRows;
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
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  dataRowMinHeight: 50,
                  dataRowMaxHeight: 50, // ajouter la hauteur de ligne
                  columnSpacing: 15, // ajuster l'espace entre les colonnes si nécessaire
                  columns: const <DataColumn>[
                    DataColumn(label: Text('Numero')),
                    DataColumn(label: Text('Date')),
                    DataColumn(label: Text('Global')),
                    DataColumn(label: Text('Comportement')),
                    DataColumn(label: Text('Assiduité')),
                    DataColumn(label: Text('DM')),
                    DataColumn(label: Text('Détails')),
                  ],
                  rows: bilanRows[widget.eleve.identifiant] ?? [], // Si l'élève n'a pas de bilans, affichez une liste vide
                ),
              ),
            ),
          ),
        ],
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: orangePerso,
        title:Text(
          '${widget.eleve.nom} ${widget.eleve.prenom}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.primaryColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              EleveInfoBlock(eleve: widget.eleve),
              const SizedBox(height: 20),
              BilanBlock(eleve: widget.eleve),
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
                        MaterialPageRoute(builder: (context) => NewBilan(eleve: widget.eleve)),
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
}