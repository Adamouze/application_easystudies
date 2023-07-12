
import 'package:flutter/material.dart';

import '../../utilities/constantes.dart';
import '../app_bar.dart';


class EleveInfoBlock extends StatelessWidget {
  // TODO: Ajouter les champs d'information nécessaires en tant que variables finales ici

  const EleveInfoBlock({Key? key}) : super(key: key);

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
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 1,
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
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("H9GZH3"),
                        Text("GAJENDRAN"),
                        Text("Ajanthan"),
                        Text("M"),
                        Text("03/03/2005"),
                        Text("Term G"),
                        Text("CTEF Admin"),
                        Text(
                          "Active",
                          style: TextStyle(
                              color: Colors.green
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Image(
                      image: AssetImage('assets/smiley/1.png'),
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





class RatingCell extends StatefulWidget {
  final int value;
  final ValueChanged<int?> onChanged;
  final int groupValue;

  const RatingCell({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.groupValue,
  }) : super(key: key);

  @override
  _RatingCellState createState() => _RatingCellState();
}

class _RatingCellState extends State<RatingCell> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Radio<int>(
        value: widget.value,
        groupValue: widget.groupValue,
        onChanged: widget.onChanged,
      ),
    );
  }
}

class BaseDeNotationBlock extends StatefulWidget {
  const BaseDeNotationBlock({Key? key}) : super(key: key);

  @override
  _BaseDeNotationBlockState createState() => _BaseDeNotationBlockState();
}


class _BaseDeNotationBlockState extends State<BaseDeNotationBlock> {

  int _groupValue1 = 0;
  int _groupValue2 = 0;
  int _groupValue3 = 0;
  int _groupValue4 = 0;

  TableRow _createRatingRow(String title, int groupValue, ValueChanged<int?> onChanged) {
    return TableRow(
      children: [
        Center(child: Text(title)),
        for (int value = 1; value <= 5; value++)
          RatingCell(value: value, groupValue: groupValue, onChanged: onChanged),
      ],
    );
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
                'Base de Notation',
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
            child: Table(
              columnWidths: const <int, TableColumnWidth>{
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(0.3),
                2: FlexColumnWidth(0.3),
                3: FlexColumnWidth(0.3),
                4: FlexColumnWidth(0.3),
                5: FlexColumnWidth(0.3),
              },
              border: TableBorder.all(
                color: Colors.black26,
                width: 1,
              ),
              children: [
                TableRow(
                  children: [
                    const Center(child: Text(' ')),
                    for (int i = 1; i <= 5; i++)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Image.asset('assets/smiley/$i.png', height: 30),
                        ),
                      ),
                  ],
                ),

                _createRatingRow('Note globale', _groupValue1, (value) { setState(() { _groupValue1 = value ?? _groupValue1; }); }),
                _createRatingRow('Note comportement', _groupValue2, (value) { setState(() { _groupValue2 = value ?? _groupValue2; }); }),
                _createRatingRow('Note assiduité', _groupValue3, (value) { setState(() { _groupValue3 = value ?? _groupValue3; }); }),
                _createRatingRow('Devoirs / DM faits', _groupValue4, (value) { setState(() { _groupValue4 = value ?? _groupValue4; }); }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class BilanBlock extends StatelessWidget {
  // TODO: Ajouter les champs d'information nécessaires en tant que variables finales ici

  const BilanBlock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // TODO: Ajoutez ici le code pour construire votre bloc d'information
    );
  }
}


class SoumettreButton extends StatelessWidget {
  // TODO: Ajouter les champs d'information nécessaires en tant que variables finales ici

  const SoumettreButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // TODO: Ajoutez ici le code pour construire votre bloc d'information
    );
  }
}





class NewBilan extends StatefulWidget {
  const NewBilan({Key? key}) : super(key: key);

  @override
  _NewBilanState createState() => _NewBilanState();
}

class _NewBilanState extends State<NewBilan> {
  // TODO: Ajouter ici vos contrôleurs de champ de formulaire, vos variables d'état, etc.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(color: orangePerso, context: context),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            EleveInfoBlock(),
            SizedBox(height: 20),
            BaseDeNotationBlock(),
            SizedBox(height: 20),
            BilanBlock(),
            SizedBox(height: 20),
            SoumettreButton(),
            SizedBox(height: 20),
            // TODO: Ajoutez ici vos autres blocs
          ],
        ),
      ),
    );
  }
}










class BilanContent extends StatelessWidget {
  final int eleveId;

  final Map<int, List<DataRow>> bilansEleves = {
    1: [
      DataRow(
        cells: <DataCell>[
          const DataCell(Center(child: Text('1'))), // centrage du contenu
          const DataCell(Center(child: Text('12/07/2023'))),
          const DataCell(Center(child: smiley1)),
          const DataCell(Center(child: smiley2)),
          const DataCell(Center(child: smiley3)),
          const DataCell(Center(child: smiley5)),
          DataCell(
            Center(
              child: TextButton(
                onPressed: () {
                  // Navigation vers une autre page ou action
                },
                child: const Text('Détails'),
              ),
            ),
          ),
        ],
      ),
      DataRow(
        cells: <DataCell>[
          const DataCell(Center(child: Text('2'))),
          const DataCell(Center(child: Text('13/07/2023'))),
          const DataCell(Center(child: smiley4)),
          const DataCell(Center(child: smiley4)),
          const DataCell(Center(child: smiley4)),
          const DataCell(Center(child: smiley1)),
          DataCell(
            Center(
              child: TextButton(
                onPressed: () {
                  // Navigation vers une autre page ou action
                },
                child: const Text('Détails'),
              ),
            ),
          ),
        ],
      ),
    ],

    2: [
      DataRow(
        cells: <DataCell>[
          const DataCell(Center(child: Text('1'))), // centrage du contenu
          const DataCell(Center(child: Text('12/07/2023'))),
          const DataCell(Center(child: smiley5)),
          const DataCell(Center(child: smiley4)),
          const DataCell(Center(child: smiley4)),
          const DataCell(Center(child: smiley2)),
          DataCell(
            Center(
              child: TextButton(
                onPressed: () {
                  // Navigation vers une autre page ou action
                },
                child: const Text('Détails'),
              ),
            ),
          ),
        ],
      ),
    ],
    // Ajoutez plus d'élèves si nécessaire
  };







  BilanContent({required this.eleveId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: FractionallySizedBox(
          widthFactor: 0.95,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[

              const SizedBox(height: 20),

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
                      rows: bilansEleves[eleveId] ?? [], // Si l'élève n'a pas de bilans, affichez une liste vide
                    ),
                  ),
                ),
              ),

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
                        MaterialPageRoute(builder: (context) => NewBilan()),
                      );
                    },
                    tooltip: "Ajout d'un bilan",
                    elevation: 6.0,
                    shape: const CircleBorder(),
                    child: add_bilan,
                  ),
                ),
              ),

              const SizedBox(height: 20),

            ],
          ),
        ),
      ),
    );
  }
}

