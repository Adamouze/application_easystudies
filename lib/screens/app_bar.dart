import 'package:EasyStudies/screens/login_screen.dart';
import 'package:flutter/material.dart';

class AnimatedDialog extends StatefulWidget {
  const AnimatedDialog({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AnimatedDialogState createState() => _AnimatedDialogState();
}

class _AnimatedDialogState extends State<AnimatedDialog> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..forward();
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height * 0.5;  // 50% of screen height
    var width = MediaQuery.of(context).size.width * 0.85; // 100% of screen width
    return SlideTransition(
      position: _offsetAnimation,
      child: Dialog(
        elevation: 0, // removes the shadow
        backgroundColor: Colors.transparent, // Set the background color to transparent
        insetPadding: EdgeInsets.zero, // removes padding around the dialog
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: SizedBox(
          height: height,  // set dialog height
          width: width,  // set dialog width
          child: const LoginScreen(),
        ),
      ),
    );
  }
}



class CustomAppBar extends PreferredSize {
  final String title;
  final MaterialAccentColor color;
  final BuildContext context;

  CustomAppBar({Key? key, required this.title, required this.color, required this.context})
      : super(
    key: key,
    preferredSize: const Size.fromHeight(80.0),
    child: AppBar(
      toolbarHeight: 80.0,
      backgroundColor: color,
      title: Row(
        children: [
          SizedBox(
            width: 70,
            height: 80,
            child: Stack(
              children: [
                Positioned(
                  top: 5, // adjust this to move logo vertically
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  top: 5, // match this with Container's top
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(150), // n'importe quoi > 35
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          Expanded(
            flex: 5,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Noto Sans',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const Spacer(flex: 1),

          SizedBox(
            width: 50,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const AnimatedDialog();
                    },
                );
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(150),
                ),
                padding: const EdgeInsets.all(3),
              ),
              child: const FittedBox(
                child: Icon(
                  Icons.account_circle_rounded,
                  size: 50,
                  color: Colors.orangeAccent,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}


