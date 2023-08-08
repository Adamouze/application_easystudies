// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';

import '../utilities/constantes.dart';

import 'app_bar.dart';
import 'body.dart';

import 'action_buttons_prof/partie_annuaire/repertory_screen.dart';
import 'action_buttons_prof/partie_cours/cours_screen.dart';

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
  static final List<Widget> _widgetOptions = <Widget>[
    const HomeContent(),
    const RepertoryScreen(),
    const CoursScreen(),
  ];

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => const QuitDialog(),
    )) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: CustomAppBar(context: context),
        body: Stack(
          children: <Widget>[
            _widgetOptions.elementAt(_selectedIndex),
          ],
        ),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
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
                icon: Icon(Icons.perm_contact_cal_sharp),
                label: 'Annuaire',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.class_),
                label: 'Cours',
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
