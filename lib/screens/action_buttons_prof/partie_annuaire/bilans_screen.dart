import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../../../utilities/constantes.dart';
import 'details_bilan.dart';
import 'add_directory/add_bilan_screen.dart';
import 'update_directory/update_bilan_screen.dart';
import '../../../logs/auth_stat.dart';
import '../../../../utils.dart';


class BilanBlock extends StatefulWidget {
  final Eleve eleve;

  const BilanBlock({required this.eleve, Key? key}) : super(key: key);

  @override
  BilanBlockState createState() => BilanBlockState();
}

class BilanBlockState extends State<BilanBlock> {

  final int tailleDate = 4;
  final int tailleGlobal = 2;
  final int tailleComportement = 2;
  final int tailleAssidu = 2;
  final int tailleDM = 2;
  final int tailleDetails = 2;

  void refreshBilans() async {
    final authState = Provider.of<AuthState>(context, listen: false);
    final token = authState.token ?? "";
    final login = authState.identifier ?? "";
    final newEleve = await getBilansEleve(token, login, widget.eleve);
    setState(() {
      widget.eleve.bilans = newEleve.bilans;
    });
  }

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

    Map<String, List<DataRow>> bilanRows = createBilanRows(widget.eleve);

    Widget buildHeaderRow() {
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

      final theme = Theme.of(context); // Pour utiliser le thème dans le dialogue

      return List<Widget>.generate(bilanRowsList.length, (int index) {
        DataRow row = bilanRowsList[index];
        Bilan currentBilan = widget.eleve.bilans[index];  // Assumant que les bilans sont dans le même ordre que bilanRowsList

        return GestureDetector(
          onLongPress: () {
            showDialog(
              context: context,
              builder: (context) => Theme(
                data: ThemeData(
                  dialogBackgroundColor: theme.primaryColor, // Couleur de fond du dialogue
                ),
                child: SimpleDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Bords arrondis
                    side: const BorderSide(
                      color: orangePerso, // Couleur de la bordure
                      width: 3, // Largeur de la bordure
                    ),
                  ),
                  children: [
                    Center(
                      child: SimpleDialogOption(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateBilan(eleve: widget.eleve, bilan: currentBilan, onBilanUpdate: refreshBilans),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min, // Pour que la Row n'occupe que l'espace nécessaire
                          children: [
                            Icon(Icons.edit, color: theme.primaryIconTheme.color),
                            const SizedBox(width: 10.0),
                            Text("Modifier le bilan", style: TextStyle(color: theme.textTheme.bodyLarge?.color, fontFamily: 'NotoSans')),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          child: Container(
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
    );
  }
}

class BilanScreen extends StatefulWidget {
  final Eleve eleve;

  const BilanScreen({required this.eleve, Key? key}) : super(key: key);

  @override
  BilanScreenState createState() => BilanScreenState();
}

class BilanScreenState extends State<BilanScreen> {

  void refreshBilans() async {
    final authState = Provider.of<AuthState>(context, listen: false);
    final token = authState.token ?? "";
    final login = authState.identifier ?? "";
    final newEleve = await getBilansEleve(token, login, widget.eleve);
    setState(() {
      widget.eleve.bilans = newEleve.bilans;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Contenu du corps selon la condition
    Widget bodyContent;

    if (widget.eleve.bilans.isEmpty) {
      bodyContent = const Center(
        child: Text(
          "Pas de bilans ici",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            fontSize: 18,
          ),
        ),
      );
    } else {
      bodyContent = SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 20),
                BilanBlock(eleve: widget.eleve),
                const SizedBox(height: 120)
              ],
            ),
          )
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: orangePerso,
        title: Text(
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
      body: bodyContent,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, right: 16.0), // Écartement aux bords
        child: Transform.scale(
          scale: 1.3,
          child: FloatingActionButton(
            backgroundColor: Colors.blue,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddBilan(eleve: widget.eleve, onBilanAdded: refreshBilans)),
              );
            },
            tooltip: "Ajout d'un bilan",
            elevation: 10.0, // Rehaussement
            shape: const CircleBorder(),
            child: addBilan,
          ),
        ),
      ),
    );
  }
}
