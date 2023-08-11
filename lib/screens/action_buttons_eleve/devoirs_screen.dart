import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utilities/constantes.dart';
import '../../../logs/auth_stat.dart';
import '../../../utils.dart';


class DevoirBlock extends StatefulWidget {
  final Eleve eleve;

  const DevoirBlock({required this.eleve, Key? key}) : super(key: key);

  @override
  DevoirBlockState createState() => DevoirBlockState();
}

class DevoirBlockState extends State<DevoirBlock> {

  IconData determineIcon(String state) {
    switch (state) {
      case "1":
        return Icons.close;  // Icône de croix
      case "2":
        return Icons.warning;  // Icône de point d'exclamation
      case "3":
        return Icons.check;  // Icône de check
      default:
        return Icons.help; // Icône par défaut si la valeur est inconnue
    }
  }

  Color determineColor(String state) {
    switch (state) {
      case "1":
        return Colors.red;
      case "2":
        return Colors.orange;
      case "3":
        return Colors.green;
      default:
        return Colors.grey; // Couleur par défaut si la valeur est inconnue
    }
  }

  Widget buildDevoirRow(Devoir devoir, int index, Color color) {
    final authState = Provider.of<AuthState>(context, listen: false);
    final token = authState.token;
    final login = authState.identifier;

    if (token == null) {
      return const Text("ERREUR de token dans la requête API");
    }
    if (login == null) {
      return const Text("ERREUR de login dans la requête API");
    }

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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Date de début
                        RichText(
                          text: TextSpan(
                            text: "Début: ",
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                text: afficherDate(devoir.dateStart),
                                style: afficherDate(devoir.dateStart) == "non renseigné"
                                    ? TextStyle(fontWeight: FontWeight.normal, fontStyle: FontStyle.italic, color: Colors.grey[700])
                                    : const TextStyle(fontStyle: FontStyle.normal, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        // Date de fin
                        RichText(
                          text: TextSpan(
                            text: "Fin: ",
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                text: afficherDate(devoir.dateEnd),
                                style: afficherDate(devoir.dateEnd) == "non renseigné"
                                    ? TextStyle(fontWeight: FontWeight.normal, fontStyle: FontStyle.italic, color: Colors.grey[700])
                                    : const TextStyle(fontStyle: FontStyle.normal, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        // From
                        RichText(
                          text: TextSpan(
                            text: "De: ${devoir.from}",
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Deux boutons carrés
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        children: [
                          ClipOval(
                            child: Container(
                              color: const Color.fromRGBO(128, 128, 128, 0.2), // Gris avec 20% d'opacité
                              child: IconButton(
                                padding: EdgeInsets.zero,  // Pas de padding
                                icon: Icon(determineIcon(devoir.stateStudent), color: determineColor(devoir.stateStudent)),
                                onPressed: authState.userType == "eleve"
                                    ? () async {
                                  // Incrémentation avec boucle
                                  devoir.stateStudent = ((int.parse(devoir.stateStudent) % 3) + 1).toString();

                                  // Appel de la fonction API
                                  await manageDevoir(token, login, widget.eleve, "update", devoir);

                                  // Rafraîchissement de la page
                                  setState(() {});
                                }
                                    : null, // Si authState.userType n'est pas "eleve", alors le bouton est désactivé
                              ),
                            ),
                          ),
                          const Text("Élève"),
                        ],
                      ),

                      const SizedBox(width: 5),  // Espace entre les deux boutons

                      Column(
                        children: [
                          ClipOval(
                            child: Container(
                              color: const Color.fromRGBO(128, 128, 128, 0.2), // Gris avec 20% d'opacité
                              child: IconButton(
                                padding: EdgeInsets.zero,  // Pas de padding
                                icon: Icon(determineIcon(devoir.stateProf), color: determineColor(devoir.stateProf)),
                                onPressed: authState.userType == "prof"
                                    ? () async {
                                  // Incrémentation avec boucle
                                  devoir.stateProf = ((int.parse(devoir.stateProf) % 3) + 1).toString();

                                  // Appel de la fonction API
                                  await manageDevoir(token, login, widget.eleve, "update", devoir);

                                  // Rafraîchissement de la page
                                  setState(() {});
                                }
                                    : null, // Si authState.usertype n'est pas "prof", alors le bouton est désactivé
                              ),
                            ),
                          ),
                          const Text("Prof"),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              const Divider(color: Colors.black, thickness: 1, height: 10),
              const SizedBox(height: 5),
              RichText(
                text: const TextSpan(
                  text: 'À faire : \n',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              RichText(
                text: TextSpan(
                  text: devoir.content,
                  style: DefaultTextStyle.of(context).style,
                ),
              ),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> createDevoirRows(Eleve eleve) {
    List<Widget> rows = [];

    for (int i = 0; i < eleve.devoirs.length; i++) {
      Devoir devoir = eleve.devoirs[i];
      Color color = (i % 2 == 0 ? Colors.grey[300] : Colors.grey[400]) ?? Colors.grey;
      rows.add(buildDevoirRow(devoir, i, color));
    }

    // Ajoutez une marge en bas du dernier élément
    if (rows.isNotEmpty) {
      rows.add(const SizedBox(height: 8.0));
    }

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> devoirRows = createDevoirRows(widget.eleve);

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
                      decoration: const BoxDecoration(
                        color: orangePerso,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(arrondiBox),
                          topRight: Radius.circular(arrondiBox),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 8 - epaisseurContour),
                        child: Text(
                          'Devoirs',
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
                        border: Border.all(
                          color: orangePerso,
                          width: epaisseurContour,
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(arrondiBox),
                          bottomRight: Radius.circular(arrondiBox),
                        ),
                      ),
                      child: devoirRows.isEmpty
                          ? Container(
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(arrondiBox - 3),
                            bottomRight: Radius.circular(arrondiBox - 3),
                          ),
                        ),
                      )
                          : Column(
                        children: devoirRows,
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




