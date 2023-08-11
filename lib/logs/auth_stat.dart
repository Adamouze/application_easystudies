import 'dart:convert'; // Pour encoder/décoder en JSON.
import 'package:http/http.dart' as http; // Pour faire des requêtes HTTP.

import 'package:flutter/foundation.dart'; // Pour la gestion d'état et les listeners.
import 'package:shared_preferences/shared_preferences.dart'; // Pour sauvegarder des données locales sur l'appareil.


/*
* Ce fichier permet de vérifier pour refuser ou accorder la connexion de l'utilisateur à l'application, mais aussi de garder en mémoire du téléphone l'identifiant et le token lorsqu'on s'est déjà connecté une fois à l'application.
* Il permet aussi d'avoir ainsi accès au type d'utilisateur, token, login, prenom et nom partout dans l'application comme des variables "globales".
* */



class AuthState with ChangeNotifier {

  // Variables privées pour stocker l'état d'authentification, le type d'utilisateur, l'identifiant, le token, le prénom et le nom.
  bool _isAuthenticated = false;
  String? _userType;
  String? _identifier;
  String? _token;
  String? _prenom;
  String? _nom;

  // Getters pour permettre l'accès en lecture à ces variables en dehors de cette classe.
  bool get isAuthenticated => _isAuthenticated;
  String? get userType => _userType;
  String? get identifier => _identifier;
  String? get token => _token;
  String? get prenom => _prenom;
  String? get nom => _nom;

  // Constructeur qui charge les données initiales.
  AuthState() {
    loadInitialData();
  }

  // Fonction pour charger les données initiales depuis les SharedPreferences.
  Future<void> loadInitialData() async {
    final prefs = await SharedPreferences.getInstance(); // Obtient une instance de SharedPreferences.
    // Charge les valeurs depuis SharedPreferences (ou utilise des valeurs par défaut si non trouvées).
    _isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
    _userType = prefs.getString('userType');
    _identifier = prefs.getString('identifier');
    _token = prefs.getString('token');
    _prenom = prefs.getString('prenom');
    _nom = prefs.getString('nom');
    if (_isAuthenticated && _token != null) {  // Vérifie la validité du token si l'utilisateur est authentifié.
      checkTokenValidity();
    }
    notifyListeners(); // Notifie les listeners que l'état a changé.
  }

  // Fonction pour définir l'état d'authentification et sauvegarder les données dans SharedPreferences.
  void setAuthenticationStatus(bool status, String userType, String identifier, String token, String prenom, String nom) async {
    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = status;
    _userType = userType;
    _identifier = identifier;
    _token = token;
    _prenom = prenom;
    _nom = nom;

    // Sauvegarde les nouvelles valeurs dans SharedPreferences.
    prefs.setBool('isAuthenticated', status);
    prefs.setString('userType', userType);
    prefs.setString('identifier', identifier);
    prefs.setString('token', token);
    prefs.setString('prenom', prenom);
    prefs.setString('nom', nom);
    notifyListeners();
  }

  // Fonction pour vérifier la validité du token en interagissant avec une API.
  Future<void> checkTokenValidity() async {
    // Requête à l'API pour vérifier la validité du token.
    final response = await http.get(Uri.parse(
        'https://app.easystudies.fr/api/login.php?_token=$_token&_login=$_identifier&_pwd='));

    if (response.statusCode == 200) { // Si le statut de la réponse est 200 (OK).
      Map<String, dynamic> jsonResponse = jsonDecode(response.body); // Décodage de la réponse JSON.
      if (jsonResponse['_valid'] != true) { // Si le token n'est pas valide, on déconnecte l'utilisateur.
        logout();
      }
    }
    else {
      throw Exception('Failed to load data from API'); // Lance une exception en cas d'échec.
    }
  }

  // Fonction pour déconnecter l'utilisateur.
  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = false;
    _userType = 'home'; // Fixe le type d'utilisateur à 'home' par défaut lors de la déconnexion.
    _identifier = null;
    _token = null;
    _prenom = null;
    _nom = null;
    // Met à jour les SharedPreferences pour refléter l'état déconnecté.
    prefs.setBool('isAuthenticated', false);
    prefs.setString('userType', 'home');
    prefs.remove('identifier');
    prefs.remove('token');
    prefs.remove('prenom');
    prefs.remove('nom');
    notifyListeners(); // Notifie les listeners que l'état a changé.
  }
}
