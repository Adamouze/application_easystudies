import 'package:flutter/material.dart';

import '../utilities/constantes.dart';
import 'app_bar.dart';
import 'body.dart';

import 'action_buttons_eleve/attendance_history_screen.dart';
import 'action_buttons_eleve/bilan_screen.dart';
import 'action_buttons_eleve/comments_screen.dart';
import 'action_buttons_eleve/notes_screen.dart';
import 'action_buttons_eleve/qrcode_screen.dart';


class FancyFab extends StatefulWidget {
  final VoidCallback onPressed;
  final String tooltip;
  final IconData icon;
  final Color iconColor;
  final ValueNotifier<bool> isOpened;

  const FancyFab({
    required this.onPressed,
    required this.tooltip,
    required this.icon,
    required this.iconColor,
    required this.isOpened,
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
    if (!widget.isOpened.value) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    widget.isOpened.value = isOpened = !isOpened;
  }


  Widget notes() {
    return FloatingActionButton(
      backgroundColor: Colors.blue,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NoteScreen()),
        );
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BilanScreen()),
        );
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CommentScreen()),
        );
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
      tooltip: 'Menu',
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




class EleveScreen extends StatefulWidget {
  const EleveScreen({Key? key}) : super(key: key);

  @override
  EleveScreenState createState() => EleveScreenState();
}

class EleveScreenState extends State<EleveScreen> {
  final ValueNotifier<bool> _isFancyFabOpen = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Eleve', color: orangePerso, context: context),
      body: Stack(
        children: <Widget>[
          CustomBody(userType: "eleve"),
          ValueListenableBuilder<bool>(
            valueListenable: _isFancyFabOpen,
            builder: (BuildContext context, bool isOpened, Widget? child) {
              if (isOpened) {
                return const ModalBarrier(dismissible: false, color: Colors.transparent);
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
          Positioned(
            right: 16.0,
            bottom: 16.0,
            child: FancyFab(
              onPressed: () {
                setState(() {
                  _isFancyFabOpen.value = !_isFancyFabOpen.value;
                });
              },
              tooltip: 'Menu',
              icon: Icons.menu,
              iconColor: couleurIcone,
              isOpened: _isFancyFabOpen,
            ),
          ),
          Positioned(
            left: 16.0,
            bottom: 16.0,
            child: FloatingActionButton(
              backgroundColor: orangePerso,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HistoryScreen()),
                );
              },
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const QRCodeScreen()),
                  );
                },
                tooltip: 'QR Code',
                elevation: 6.0,
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.qr_code_2_sharp,
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




