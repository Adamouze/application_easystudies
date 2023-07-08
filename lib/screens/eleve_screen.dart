import 'package:flutter/material.dart';

import '../utilities/constantes.dart';
import 'app_bar.dart';
import 'body.dart';

import 'action_buttons_eleve/attendance_history_screen.dart';
import 'action_buttons_eleve/bilan_screen.dart';
import 'action_buttons_eleve/comments_screen.dart';
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
  static const List<Widget> _widgetOptions = <Widget>[
    HomeContent(),
    NoteScreen(),
    BilanScreen(),
    CommentScreen(),
    HistoryScreen(),
  ];

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => const LogoutDialog(),
    )) ?? false;
  }

  @override
  Widget build(BuildContext context) {
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
