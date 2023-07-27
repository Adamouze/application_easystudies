import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../utilities/constantes.dart';

import '../../../../utils.dart';



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
  RatingCellState createState() => RatingCellState();
}

class RatingCellState extends State<RatingCell> {
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
  BaseDeNotationBlockState createState() => BaseDeNotationBlockState();
}

class BaseDeNotationBlockState extends State<BaseDeNotationBlock> {

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
  BilanBlockState createState() => BilanBlockState();
}

class BilanBlockState extends State<BilanBlock> {
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


class AddBilan extends StatefulWidget {
  final Eleve eleve;

  const AddBilan({required this.eleve, Key? key}) : super(key: key);

  @override
  AddBilanState createState() => AddBilanState();
}

class AddBilanState extends State<AddBilan> {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: orangePerso,
        title:Text(
          'Nouveau bilan - ${widget.eleve.prenom}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.primaryColor,
          ),
        ),
      ),
      body: const SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
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



