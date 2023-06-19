// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../liste_identifiant_test.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';

  bool isLoginValid(String username, String password) {
    for (var identifiant in listeIdentifiants) {
      if (identifiant['username'] == username && identifiant['password'] == password) {
        return true;
      }
    }
    return false;
  }

  void tryLogin() {
    String username = _username;
    String password = _password;
    if (isLoginValid(username, password)) {
      // ici, naviguez vers la page d'accueil et affichez un message de bienvenue
      Navigator.pushReplacementNamed(context, '/eleve');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Connecté en tant que $username')),
      );
    } else {
      // ici, montrez une erreur indiquant que le couple identifiant/mot de passe est invalide
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Le couple identifiant/mot de passe n\'est pas valide')),
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
                border: Border.all(color: Colors.white, width: 8),
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
                        const Text(
                          'Connectez-vous !',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'NotoSans',
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
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
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
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
                              backgroundColor: Colors.white,
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
