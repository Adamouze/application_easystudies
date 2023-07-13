
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utilities/constantes.dart';
import '../app_bar.dart';


class EleveInfoBlock extends StatelessWidget {
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


class BilanBlock extends StatefulWidget {
  const BilanBlock({Key? key}) : super(key: key);

  @override
  _BilanBlockState createState() => _BilanBlockState();
}

class _BilanBlockState extends State<BilanBlock> {
  DateTime _date = DateTime.now();
  Map<String, bool> matieres = {
    'Mathématiques': false,
    'Français / Philosophie': false,
    'Anglais': false,
    'Physique / Chimie': false,
    'SVT': false,
    'Histoire / Géo': false,
    'Comptabilité / Gestion': false,
    'Autres': false,
  };
  String axes = '';
  String pointsForts = '';
  String commentaires = '';

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
                'Bilan',
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
                      initialDate: _date,
                      firstDate: DateTime(2023),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null && picked != _date)
                      setState(() {
                        _date = picked;
                      });
                  },
                  child: TextField(
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: DateFormat('dd/MM/yyyy').format(_date),
                      labelStyle: const TextStyle(color: Colors.black),
                      suffixIcon: const Icon(
                        Icons.calendar_month,
                        color: orangePerso,
                      ),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                Column(
                  children: matieres.keys.map((String key) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 0.0), // adjust this value to control the space between the items
                      child: Row(
                        children: <Widget>[
                          Checkbox(
                            value: matieres[key],
                            onChanged: (bool? value) {
                              setState(() {
                                matieres[key] = value ?? false;
                              });
                            },
                          ),
                          Text(
                            key,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Axes d\'amélioration',
                    contentPadding: EdgeInsets.only(left: 10.0),
                  ),
                  style: const TextStyle(
                    color: Colors.black, // change this color to your preference
                  ),
                  onChanged: (value) => setState(() => axes = value),
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Points forts',
                    contentPadding: EdgeInsets.only(left: 10.0),
                  ),
                  style: const TextStyle(
                    color: Colors.black, // change this color to your preference
                  ),
                  onChanged: (value) => setState(() => pointsForts = value),
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Commentaires',
                    contentPadding: EdgeInsets.only(left: 10.0),
                  ),
                  style: const TextStyle(
                    color: Colors.black, // change this color to your preference
                  ),
                  onChanged: (value) => setState(() => commentaires = value),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class SoumettreButton extends StatelessWidget {
  const SoumettreButton({Key? key}) : super(key: key);

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
            backgroundColor: MaterialStateProperty.all<Color>(Colors.orangeAccent),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            // TODO : Ajouter le nouveau bilan dans la liste des bilans
          },
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


class NewBilan extends StatefulWidget {
  const NewBilan({Key? key}) : super(key: key);

  @override
  _NewBilanState createState() => _NewBilanState();
}

class _NewBilanState extends State<NewBilan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(color: orangePerso, context: context),
      body: const SingleChildScrollView(
        child: Center(
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
            ],
          ),
        )
      ),
    );
  }
}



class DetailsContent extends StatelessWidget {
  final int eleveId;

  const DetailsContent({required this.eleveId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: orangePerso,
        title: const Text('Détails'),
      ),
      body: const Center(
        child: Text("Salut bg"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        tooltip: 'Retour',
        child: const Icon(Icons.arrow_back),
      ),
    );
  }
}




class BilanContent extends StatefulWidget {
  final int eleveId;

  BilanContent({required this.eleveId, Key? key}) : super(key: key);

  @override
  _BilanContentState createState() => _BilanContentState();
}

class _BilanContentState extends State<BilanContent> {

  @override
  Widget build(BuildContext context) {

    final Map<int, List<DataRow>> bilansEleves = { // FACTICE
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DetailsContent(eleveId: widget.eleveId)),
                    );
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DetailsContent(eleveId: widget.eleveId)),
                    );
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DetailsContent(eleveId: widget.eleveId)),
                    );
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
                      rows: bilansEleves[widget.eleveId] ?? [], // Si l'élève n'a pas de bilans, affichez une liste vide
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
                        MaterialPageRoute(builder: (context) => const NewBilan()),
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



