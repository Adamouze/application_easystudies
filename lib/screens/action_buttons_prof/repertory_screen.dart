import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

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
  late Future<List<Eleve>> _elevesFuture;
  final _searchController = TextEditingController();
  String searchValue = '';

  @override
  void initState() {
    super.initState();
    _elevesFuture = getFilteredListEleves();

    _searchController.addListener(() {
      setState(() {
        searchValue = _searchController.text;
      });
    });
  }

  Future<List<Eleve>> getFilteredListEleves() async {
    final authState = Provider.of<AuthState>(context, listen: false);
    final token = authState.token;
    final login = authState.identifier;

    await Future.delayed(const Duration(milliseconds: 500));

    if (token == null || login == null) {
      return [];
    }

    final eleves = await getListEleves(token, login);
    return eleves;
  }


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
      future: _elevesFuture,
      builder: (BuildContext context, AsyncSnapshot<List<Eleve>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<Eleve> eleves = snapshot.data ?? [];

          eleves = eleves
              .where((eleve) =>
          eleve.identifier.contains(searchValue) ||
              eleve.nom.toLowerCase().contains(searchValue.toLowerCase()) ||
              eleve.prenom.toLowerCase().contains(searchValue.toLowerCase()))
              .toList();

          return Column(
            children: <Widget>[
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchValue = value;
                    });
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: theme.primaryIconTheme.color),
                    hintText: "Rechercher un élève...",
                    hintStyle: TextStyle(color: theme.textTheme.bodyLarge?.color)
                  ),
                ),
              ),
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

}



