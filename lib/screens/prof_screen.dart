// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';

import '../utilities/constantes.dart';
import '../utils.dart';
import '../exemples.dart';

import 'app_bar.dart';
import 'body.dart';

import 'action_buttons_prof/attendance_history_screen.dart';
import 'action_buttons_prof/bilan_screen.dart';
import 'action_buttons_prof/comments_screen.dart';
import 'action_buttons_prof/notes_screen.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CustomBody(userType: "prof");
  }
}

class ProfScreen extends StatefulWidget {
  const ProfScreen({Key? key}) : super(key: key);

  @override
  ProfScreenState createState() => ProfScreenState();
}

class ProfScreenState extends State<ProfScreen> {
  int _selectedIndex = 0;
  Eleve? _eleve;
  final List<Eleve> _eleves = createEleves(); // Liste de tous les élèves
  Key key = UniqueKey(); // Ajoutez cette ligne

  List<Widget> _widgetOptions() {
    return <Widget>[
      const HomeContent(),
      const NoteScreen(),
      _eleve == null ? Container() : BilanContent(key: key, eleve: _eleve!),
      const CommentScreen(),
      const HistoryScreen(),
    ];
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => const QuitDialog(),
    )) ?? false;
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        return AlertDialog(
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              children: _eleves.map((eleve) => ListTile(
                leading: Icon(
                  Icons.child_care,
                  color: theme.iconTheme.color,
                ),
                title: Text(
                    eleve.nom,
                    style: theme.textTheme.bodyLarge
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _eleve = eleve; // Mettez à jour _eleve avec l'élève sélectionné
                    key = UniqueKey(); // Générez une nouvelle clé unique à chaque fois que vous changez d'élève
                    _selectedIndex = 2; // Mettez à jour _selectedIndex avec le nouvel index
                  });
                },
              )).toList(),
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: CustomAppBar(color: orangePerso, context: context),
        body: Stack(
          children: <Widget>[
            _widgetOptions().elementAt(_selectedIndex),
          ],
        ),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.orange,
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.orangeAccent,
            unselectedItemColor: Colors.white,
            selectedItemColor: Colors.blueAccent,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Accueil',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.check_circle),
                label: 'Notes',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.fact_check),
                label: 'Bilan',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.comment),
                label: 'Commentaires',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: 'Historique',
              ),
            ],
            onTap: (index) {
              if (index == 2) {
                _showDialog(context);
              } else {
                setState(() {
                  _selectedIndex = index;
                });
              }
            },
          ),
        ),
      ),
    );
  }
}
