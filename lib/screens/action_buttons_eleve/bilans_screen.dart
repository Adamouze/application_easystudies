import 'package:flutter/material.dart';

import '../../../utilities/constantes.dart';
import '../action_buttons_prof/partie_annuaire/details_bilan.dart';

import '../../../../utils.dart';


class BilanBlock extends StatelessWidget {
  final Eleve eleve;

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

    Map<String, List<DataRow>> bilanRows = createBilanRows(eleve);

    Widget buildHeaderRow() {
      final theme = Theme.of(context);
      if (bilanRows[eleve.identifier] == null || bilanRows[eleve.identifier]!.isEmpty) {
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
      if (bilanRows[eleve.identifier] == null || bilanRows[eleve.identifier]!.isEmpty) {
        return [];
      }

      List<DataRow> bilanRowsList = bilanRows[eleve.identifier]!;
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

    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
          const SizedBox(height: 20),
          ClipRRect(
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
          ),
          const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}