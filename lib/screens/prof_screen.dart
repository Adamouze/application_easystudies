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
      builder: (context) => const QuitDialog(),
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