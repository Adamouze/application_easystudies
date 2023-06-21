import 'package:flutter/material.dart';
import '../utilities/constantes.dart';
import 'app_bar.dart';
import 'bodies/body_prof.dart';

class FancyFab extends StatefulWidget {
  final VoidCallback onPressed;
  final String tooltip;
  final IconData icon;
  final Color iconColor;

  const FancyFab({
    required this.onPressed,
    required this.tooltip,
    required this.icon,
    required this.iconColor,
    Key? key,
  }) : super(key: key);

  @override
  FancyFabState createState() => FancyFabState();
}

class FancyFabState extends State<FancyFab> with SingleTickerProviderStateMixin {
  bool isOpened = false;
  late AnimationController _animationController;
  late Animation<Color?> _buttonColor;
  late Animation<double> _animateIcon;
  late Animation<double> _translateButton;
  final Curve _curve = Curves.easeOut;
  final double _fabHeight = 56.0;

  @override
  void initState() {
    _animationController =
    AnimationController(vsync: this, duration: const Duration(milliseconds: 500))
      ..addListener(() {
        setState(() {});
      });
    _animateIcon = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(begin: orangePerso, end: Colors.red).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.00, 1.00, curve: Curves.linear),
    ));
    _translateButton = Tween<double>(begin: _fabHeight, end: -14.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.0, 0.75, curve: _curve),
    ));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget notes() {
    return FloatingActionButton(
      backgroundColor: Colors.blue,
      onPressed: () {
      },
      heroTag: 1,
      tooltip: 'Notes',
      shape: const CircleBorder(),
      child: Icon(
        Icons.check_circle,
        color: widget.iconColor,
      ),
    );
  }

  Widget bilan() {
    return FloatingActionButton(
      backgroundColor: Colors.blue,
      onPressed: () {
      },
      heroTag: 2,
      tooltip: 'Bilan',
      shape: const CircleBorder(),
      child: Icon(
        Icons.fact_check,
        color: widget.iconColor,
      ),
    );
  }

  Widget commentaire() {
    return FloatingActionButton(
      backgroundColor: Colors.blue,
      onPressed: () {
      },
      heroTag: 3,
      tooltip: 'Commentaires',
      shape: const CircleBorder(),
      child: Icon(
        Icons.comment,
        color: widget.iconColor,
      ),

    );
  }

  Widget toggle() {
    return FloatingActionButton(
      backgroundColor: _buttonColor.value,
      onPressed: animate,
      heroTag: 0,
      tooltip: 'Toggle',
      shape: const CircleBorder(),
      child: AnimatedIcon(
        icon: AnimatedIcons.menu_close,
        progress: _animateIcon,
        color: widget.iconColor,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 0.0, right: 0.0), // Espacement du bouton par rapport aux bords
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Transform(
              transform: Matrix4.translationValues(
                0.0,
                _translateButton.value * 3.0,
                0.0,
              ),
              child: notes(),
            ),
            Transform(
              transform: Matrix4.translationValues(
                0.0,
                _translateButton.value * 2.0,
                0.0,
              ),
              child: bilan(),
            ),
            Transform(
              transform: Matrix4.translationValues(
                0.0,
                _translateButton.value,
                0.0,
              ),
              child: commentaire(),
            ),
            toggle(),
          ],
        ),
      ),
    );
  }
}



class ProfScreen extends StatelessWidget {
  const ProfScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Prof', color: orangePerso, context: context),
      body: Stack(
        children: <Widget>[
          CustomBodyProf(),
          Positioned(
            right: 16.0,
            bottom: 16.0,
            child: FancyFab(
              onPressed: () {},
              tooltip: 'FancyFab',
              icon: Icons.menu,
              iconColor: couleurIcone,
            ),
          ),
          Positioned(
            left: 16.0,
            bottom: 16.0,
            child: FloatingActionButton(
              backgroundColor: orangePerso,
              onPressed: () {},
              tooltip: 'Historique',
              elevation: 6.0,
              shape: const CircleBorder(),
              child: const Icon(Icons.history, color: couleurIcone),
            ),
          ),
          Positioned(
            bottom: 26.0,
            left: MediaQuery.of(context).size.width / 2 - 28, // for a FAB button of standard size (56.0)
            child: Transform.scale(
              scale: 1.4,
              child: FloatingActionButton(
                backgroundColor: Colors.blue,
                onPressed: () {},
                tooltip: 'QR Code',
                elevation: 6.0,
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.add_circle_sharp,
                  color: couleurIcone,
                  size: 32.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
