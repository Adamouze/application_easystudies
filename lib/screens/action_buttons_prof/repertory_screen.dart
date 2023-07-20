import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'details_eleve_screen.dart';

import '../../logs/auth_stat.dart';

import '../../utilities/constantes.dart';
import '../../utilities/theme_provider.dart';

import '../../utils.dart';


class RepertoryScreen extends StatefulWidget {
  const RepertoryScreen({Key? key}) : super(key: key);

  @override
  RepertoryScreenState createState() => RepertoryScreenState();
}

class RepertoryScreenState extends State<RepertoryScreen> {

  // List<Eleve> eleves = createEleves(); // Appel de la fonction createEleves pour obtenir la liste des élèves



  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    final authState = Provider.of<AuthState>(context, listen: false);
    final token = authState.token;
    final login = authState.identifier;

    if (token == null) {
      return const Text("ERREUR de token dans la requête API");
    }
    if (login == null) {
      return const Text("ERREUR de login dans la requête API");
    }

    return FutureBuilder<List<Eleve>>(
      future: getListEleves(token, login),
      builder: (BuildContext context, AsyncSnapshot<List<Eleve>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // retourne un indicateur de progression pendant le chargement
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // en cas d'erreur
        } else {
          List<Eleve> eleves = snapshot.data ?? []; // une fois les données chargées

          return Column(
            children: <Widget>[
              const SizedBox(height: 10),
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
                                height: 55.0,
                                width: 55.0,
                                child: ClipOval(
                                  child: eleves[index].photo == ""
                                      ? Container(
                                          decoration: BoxDecoration(
                                            color: themeProvider.isDarkTheme ? Colors.white : null,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: themeProvider.isDarkTheme ? Colors.black : Colors.black,
                                              width: 2.0,
                                            ),
                                          ),
                                          child: Image.asset(getDefaultPhoto(eleves[index].civilite), fit: BoxFit.cover),
                                        )
                                      : Image.network(eleves[index].photo, fit: BoxFit.cover),
                                ),
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
          ); // remplacez ceci par votre widget utilisant les élèves
        }
      },
    );
  }
}



