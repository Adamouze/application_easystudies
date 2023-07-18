// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../logs/auth_stat.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';

  void tryLogin() async {

    String username = _username;
    String password = _password;

    final response = await http.get(Uri.parse('https://app.easystudies.fr/api/login.php?_token=&_login=$username&_pwd=$password'));

    if(response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse['_valid']) {
        String userType;
        switch (jsonResponse['_access']) {
          case 1:
            userType = 'eleve';
            break;
          case 2:
            userType = 'prof';
            break;
          default:
            userType = 'home';
        }
        Navigator.of(context).pushNamed('/$userType');
        Provider.of<AuthState>(context, listen: false).setAuthenticationStatus(true, userType, jsonResponse['_identifier'], jsonResponse['_token']);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            backgroundColor: Colors.green,
            content: Text('Connecté en tant que ${jsonResponse['_prenom']}',
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
      }
      else {
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
    else {
      throw Exception('Failed to load data from API');
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
                            onPressed : () {
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



