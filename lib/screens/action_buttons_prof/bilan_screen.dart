
import 'package:flutter/material.dart';
import '../../utilities/constantes.dart';

import '../app_bar.dart';


// Ici, déplacez le contenu du body de BilanScreen dans BilanContent
class BilanContent extends StatelessWidget {
  final int eleveId;

  final Map<int, List<DataRow>> bilansEleves = {
    1: [
      DataRow(
        cells: <DataCell>[
          const DataCell(Center(child: Text('1'))), // centrage du contenu
          const DataCell(Center(child: Text('12/07/2023'))),
          const DataCell(Center(
            child: Image(
              image: AssetImage('assets/smiley/1.png'),
              height: 20,
              alignment: Alignment.center,
            ),
          )),
          const DataCell(Center(child: Text('8'))),
          const DataCell(Center(child: Text('9'))),
          const DataCell(Center(child: Text('10'))),
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
          const DataCell(Center(child: Text('8'))),
          const DataCell(Center(child: Text('9'))),
          const DataCell(Center(child: Text('8'))),
          const DataCell(Center(child: Text('7'))),
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
          const DataCell(Center(child: Text('7'))),
          const DataCell(Center(child: Text('8'))),
          const DataCell(Center(child: Text('9'))),
          const DataCell(Center(child: Text('10'))),
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

            ],
          ),
        ),
      ),
    );
  }
}


// Modifiez BilanScreen pour qu'il utilise BilanContent dans son body
class BilanScreen extends StatelessWidget {
  final int eleveId;

  const BilanScreen({required this.eleveId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(color: orangePerso, context: context),
      body: SingleChildScrollView(
        child: BilanContent(eleveId: eleveId),
      ),
    );
  }
}

