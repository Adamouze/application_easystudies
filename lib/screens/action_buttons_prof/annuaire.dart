import 'package:flutter/material.dart';

import 'details_eleve_screen.dart';
import '../../exemples.dart';
import '../../utils.dart';


class AnnuaireContent extends StatefulWidget {
  const AnnuaireContent({Key? key}) : super(key: key);

  @override
  AnnuaireContentState createState() => AnnuaireContentState();
}

class AnnuaireContentState extends State<AnnuaireContent> {
  List<Eleve> eleves = createEleves(); // Appel de la fonction createEleves pour obtenir la liste des élèves

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: <Widget>[
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemCount: eleves.length,
            itemBuilder: (context, index) {
              return Column(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsEleve(eleve: eleves[index]),
                        ),
                      );
                    },
                    child: Card(
                      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.025),
                      color: theme.cardColor,
                      child: ListTile(
                        leading: SizedBox(
                          height: 60.0,
                          width: 60.0,
                          child: Image.network(eleves[index].photo, fit: BoxFit.cover), // ClipOval est une option
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${eleves[index].nom} ${eleves[index].prenom}'), // Nom et Prénom de l'élève
                            Text(
                              eleves[index].classe, // Classe de l'élève
                              style: TextStyle(
                                fontSize: 12, // Taille du texte plus petite
                                color: theme.textTheme.bodySmall?.color, // Couleur du texte grise
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
