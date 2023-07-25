import 'package:flutter/material.dart';

import '../../utilities/constantes.dart';
import 'details_bilan.dart';

import '../../../utils.dart';


class BilanBlock extends StatelessWidget {
  final Eleve eleve;

  final int tailleNumero = 1;
  final int tailleDate = 4;
  final int tailleGlobal = 2;
  final int tailleComportement = 2;
  final int tailleAssidu = 2;
  final int tailleDM = 2;
  final int tailleDetails = 2;

  const BilanBlock({required this.eleve, Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    Map<String, List<DataRow>> createBilanRows(Eleve eleve) {
      Map<String, List<DataRow>> bilanRows = {};

      for (int i = 0; i < eleve.bilans.length; i++) {
        Bilan bilan = eleve.bilans[i];
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

    Map<String, List<DataRow>> bilanRows = createBilanRows(eleve);

    Widget buildHeaderRow() {
      if (bilanRows[eleve.identifier] == null || bilanRows[eleve.identifier]!.isEmpty) {
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
      if (bilanRows[eleve.identifier] == null || bilanRows[eleve.identifier]!.isEmpty) {
        return [];
      }

      List<DataRow> bilanRowsList = bilanRows[eleve.identifier]!;
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

class BilanScreen extends StatelessWidget {
  final Eleve eleve;

  const BilanScreen({required this.eleve, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: orangePerso,
        title:Text(
          'Détails des bilans',
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
                BilanBlock(eleve: eleve),
                const SizedBox(height: 20),
              ],
            ),
          )
      ),
    );
  }
}
