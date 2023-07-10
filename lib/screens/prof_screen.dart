// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';

import '../utilities/constantes.dart';

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
  int? _eleveId; // Ajoutez cette ligne

  List<Widget> get _widgetOptions {
    return <Widget>[
      const HomeContent(),
      const NoteScreen(),
      _eleveId != null ? BilanContent(eleveId: _eleveId!) : Container(),  // Affiche BilanContent seulement si _eleveId est défini
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
        return AlertDialog(
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.child_care),
                  title: const Text('Élève 1'),
                  onTap: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _eleveId = 1; // Mettez à jour _eleveId lorsque l'utilisateur sélectionne un élève
                    });
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.child_care),
                  title: const Text('Élève 2'),
                  onTap: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _eleveId = 2; // Mettez à jour _eleveId lorsque l'utilisateur sélectionne un élève
                    });
                  },
                ),
                // Ajouter autant de ListTile que d'élèves
              ],
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
            _widgetOptions.elementAt(_selectedIndex),
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
            currentIndex: _selectedIndex,
            onTap: (index) {
              if (index == 2) {
                _showDialog(context);
              }
              setState(() {
                _selectedIndex = index;
              });
            },


          ),
        ),

      ),
    );
  }

}