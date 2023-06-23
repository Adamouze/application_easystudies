// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logs/liste_identifiant_test.dart';
import '../logs/auth_stat.dart';


/*

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _identifier = new TextEditingController();
  TextEditingController _password = new TextEditingController();

  Future<void> _login() async {
    try {
      final response = await http.post(
        Uri.parse("<TODO par Stéphane>"),
        body: {
          "_identifier": _identifier.text,
          "_password": _password.text,
        },
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData["_result"] == "Data Matched") {
          addIdentifierToSF(jsonData["_identifier"]);

          if (jsonData["_userType"] == "prof") {
            print("Connexion PROF");
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => StudentsList(title: "EasyStudies"),
              ),
            );
          } else if (jsonData["_userType"] == "eleve") {
            print("Connexion ELEVE");
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => FicheEleve(Eleve.id(jsonData["_identifier"])),
              ),
            );
          } else if (jsonData["_userType"] == "super_user") {
            print("Connexion SUPER USER");
            // Naviguer vers la page de l'utilisateur super
            // Replacez SuperUserScreen par la page de l'utilisateur super
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => SuperUserScreen(),
              ),
            );
          }
        }
      } else {
        print('Erreur du serveur : ${response.statusCode}');
      }
    } catch (e) {
      print('Une erreur s\'est produite pendant la requête HTTP : $e');
    }
  }
}

*/



class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';

  String? getUserType(String username, String password) {
    if (listeIdentifiantsEleves.any((identifiant) =>
    identifiant['username'] == username &&
        identifiant['password'] == password)) {
      return 'eleve';
    }
    if (listeIdentifiantsProfs.any((identifiant) =>
    identifiant['username'] == username &&
        identifiant['password'] == password)) {
      return 'prof';
    }
    if (listeIdentifiantsSuperUsers.any((identifiant) =>
    identifiant['username'] == username &&
        identifiant['password'] == password)) {
      return 'super_user';
    }
    return null;
  }

  void tryLogin() {
    String username = _username;
    String password = _password;
    String? userType = getUserType(username, password);
    if (userType != null) {
      // ici, naviguez vers la page d'accueil et affichez un message de bienvenue
      Navigator.of(context).pushNamed('/$userType');
      // Mis à jour pour définir l'état d'authentification
      Provider.of<AuthState>(context, listen: false).setAuthenticationStatus(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          backgroundColor: Colors.green,
          content: Text('Connecté en tant que $username',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'NotoSans',
              fontWeight: FontWeight.bold,
            ),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      // ici, montrez une erreur indiquant que le couple identifiant/mot de passe est invalide
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: Colors.red,
          content: const Text(
            'Le couple identifiant/mot de passe n\'est pas valide',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'NotoSans',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
  }

  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

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
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Accéder au ThemeData actuel

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              top: 8.0,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(color: theme.colorScheme.background, width: 8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Form(
                  key: _formKey,
                  child: SlideTransition(
                    position: _offsetAnimation,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'Connectez-vous !',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'NotoSans',
                            color: theme.primaryColor,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.background,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: theme.colorScheme.shadow,
                                spreadRadius: 1,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: TextFormField(
                            cursorColor: Colors.orangeAccent,
                            decoration: const InputDecoration(
                              errorStyle: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'NotoSans',
                              ),
                              labelText: 'Identifiant',
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.orangeAccent,
                              ),
                              border: InputBorder.none,
                              labelStyle: TextStyle(
                                color: Colors.orangeAccent,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'NotoSans',
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer votre identifiant';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _username = value!;
                            },
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.background,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: theme.colorScheme.shadow,
                                spreadRadius: 1,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: TextFormField(
                            cursorColor: Colors.orangeAccent,
                            decoration: const InputDecoration(
                              errorStyle: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'NotoSans',
                              ),
                              labelText: 'Mot de passe',
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.orangeAccent,
                              ),
                              border: InputBorder.none,
                              labelStyle: TextStyle(
                                color: Colors.orangeAccent,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'NotoSans',
                              ),
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer votre mot de passe';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _password = value!;
                            },
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        FractionallySizedBox(
                          widthFactor: 1,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.orangeAccent,
                              backgroundColor: theme.colorScheme.background,
                              textStyle: const TextStyle(
                                fontFamily: 'NotoSans',
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                tryLogin();
                              }
                            },
                            child: const Text('Se connecter'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
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

