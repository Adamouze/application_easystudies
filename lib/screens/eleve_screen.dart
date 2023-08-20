import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logs/auth_stat.dart';

import '../utilities/constantes.dart';
import '../utils.dart';
import 'app_bar.dart';
import 'body.dart';

import 'action_buttons_eleve/devoirs_screen.dart';
import 'action_buttons_eleve/bilans_screen.dart';
import 'action_buttons_eleve/commentaires_screen.dart';
import 'action_buttons_eleve/notes_screen.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CustomBody(userType: "eleve");
  }
}

class EleveScreen extends StatefulWidget {
  const EleveScreen({Key? key}) : super(key: key);

  @override
  EleveScreenState createState() => EleveScreenState();
}

class EleveScreenState extends State<EleveScreen> {
  int _selectedIndex = 0;
  Future<Eleve>? _eleveFuture;
  Eleve eleve0 = Eleve.basic('', '', '', '', '', '');

  @override
  void initState() {
    super.initState();
    final authState = Provider.of<AuthState>(context, listen: false);
    final token = authState.token ?? '';
    final login = authState.identifier ?? '';
    Eleve eleve = Eleve.basic(login, '', '', '', '', '');
    _eleveFuture = getAllEleve(token, login, eleve);
  }

  Widget getScreen(int index, Eleve eleve) {
    switch (index) {
      case 0:
        return const HomeContent();
      case 1:
        return DevoirBlock(eleve: eleve);
      case 2:
        return CommentaireBlock(eleve: eleve);
      case 3:
        return NoteBlock(eleve: eleve);
      case 4:
        return BilanBlock(eleve: eleve);
      default:
        return const HomeContent();
    }
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => const QuitDialog(),
    )) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FutureBuilder<Eleve>(
      future: _eleveFuture,
      builder: (BuildContext context, AsyncSnapshot<Eleve> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(orangePerso),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // en cas d'erreur
        } else {
          Eleve eleve = snapshot.data ?? eleve0;
          return WillPopScope(
            onWillPop: _onWillPop,
            child: Scaffold(
              appBar: CustomAppBar(context: context, eleve: eleve),

              body: getScreen(_selectedIndex, eleve),

              bottomNavigationBar: Theme(
                data: theme.copyWith(
                  splashColor: couleurSplashBottomBar.withOpacity(0.3),
                ),
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: orangePerso,
                  unselectedItemColor: theme.primaryColor,
                  selectedItemColor: couleurItemBottomBar,
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Accueil',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.menu_book),
                      label: 'Devoirs',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.comment),
                      label: 'Commentaires',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.check_circle),
                      label: 'Notes',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.fact_check),
                      label: 'Bilan',
                    ),
                  ],
                  currentIndex: _selectedIndex,
                  onTap: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                ),
              ),
            ),
          );
        }
      },
    );
  }
}