import 'package:EasyStudies/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logs/auth_stat.dart';

class AnimatedDialog extends StatefulWidget {
  const AnimatedDialog({Key? key}) : super(key: key);

  @override
  AnimatedDialogState createState() => AnimatedDialogState();
}

class AnimatedDialogState extends State<AnimatedDialog> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )
      ..forward();
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
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

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

class LogoutDialog extends StatefulWidget {
  const LogoutDialog({super.key});

  @override
  LogoutDialogState createState() => LogoutDialogState();
}

class LogoutDialogState extends State<LogoutDialog> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )
      ..forward();
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: const BorderSide(color: Colors.white, width: 8),
        ),
        backgroundColor: Colors.orangeAccent,
        title: const Text('Confirmation',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'NotoSans',
          ),
        ),
        content: const Text('Voulez-vous vraiment vous déconnecter?',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'NotoSans',
          ),
        ),
        actions: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: TextButton(
              onPressed: () => Navigator.pop(context, 'Non'),
              child: const Text('Non',
                style: TextStyle(
                  color: Colors.orangeAccent,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NotoSans',
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: TextButton(
              onPressed: () {
                // Vous pouvez faire la déconnexion ici
                Provider.of<AuthState>(context, listen: false).logout();
                Navigator.of(context).pushNamed('/home');
                // Show the snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    backgroundColor: Colors.redAccent,
                    content: Text('Déconnecté',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'NotoSans',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('Oui',
                style: TextStyle(
                  color: Colors.orangeAccent,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NotoSans',
                ),
              ),
            ),
          ),
        ],
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
      automaticallyImplyLeading: false,
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

          Consumer<AuthState>(
            builder: (context, authState, _) {
              if (authState.isAuthenticated) {
                return PopupMenuButton<int>(
                  color: Colors.orangeAccent,
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 1,
                      child: Row(
                        children: [
                          IconTheme(
                            data: IconThemeData(color: Colors.white),
                            child: Icon(Icons.brightness_3_rounded), // Icone de lune pour le dark mode
                          ),
                          DefaultTextStyle(
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'NotoSans',
                            ),
                            child: Text('DarkMode'),
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 2,
                      child: Row(
                        children: [
                          IconTheme(
                            data: IconThemeData(color: Colors.white),
                            child: Icon(Icons.logout), // Icone pour le logout
                          ),
                          DefaultTextStyle(
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'NotoSans',
                            ),
                            child: Text('Déconnexion'),
                          ),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 2) { // si l'utilisateur a cliqué sur le bouton de déconnexion
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const LogoutDialog();
                        },
                      );
                    }
                  },
                  icon: const Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: 45,
                  ),
                );
              }


              else {
                return SizedBox(
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
                );
              }
            },
          ),




        ],
      ),
    ),
  );
}


