import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


import 'utilities/constantes.dart';

///Fichier contenant toutes les classes utilisées dans les autres layout pour essayer de rendre le tout plus ergonomique et facile d'utilisation
///Il faudra essayer de mettre la plupart des classes ici pour laisser les fichiers de layout épurés
///J'ai peut-être oublié de déplacer certaine méthode/class se trouvant dans les autres fichiers

class Eleve {
  String _identifier = "";
  String _nom = "";
  String _prenom = "";
  String _classe = "";
  String _civilite = "";
  String _idFamille = "";

  String _dob = "";
  String _adresse = "";
  String _ville = "";
  String _numFix = "";
  String _numMobileEleve = "";
  String _numMobileParents = "";
  String _emailEleve = "";
  String _emailParents = "";

  String _solde = "";
  String _prev = "";

  String _photo = "";

  List<Bilan> _bilans = [];

  Eleve.basic(this._identifier, this._nom, this._prenom, this._classe, this._civilite, this._idFamille);

  // Un constructeur qui accepte un autre objet Eleve et copie ses champs
  Eleve.fromEleve(Eleve eleve) {
    _identifier = eleve.identifier;
    _nom = eleve.nom;
    _prenom = eleve.prenom;
    _classe = eleve.classe;
    _civilite = eleve.civilite;
    _idFamille = eleve.idFamille;
  }

  String get identifier => _identifier;
  String get nom => _nom;
  String get prenom => _prenom;
  String get classe => _classe;
  String get civilite => _civilite;
  String get idFamille => _idFamille;

  String get dob => _dob;
  String get adresse => _adresse;
  String get ville => _ville;
  String get numFix => _numFix;
  String get numMobileEleve => _numMobileEleve;
  String get numMobileParents => _numMobileParents;
  String get emailEleve => _emailEleve;
  String get emailParents => _emailParents;

  String get solde => _solde;
  String get prev => _prev;

  String get photo => _photo;

  List<Bilan> get bilans => _bilans; // Ajoutez ce getter pour _bilans

  set identifier(String value) {_identifier = value;}
  set nom(String value) {_nom = value;}
  set prenom(String value) {_prenom = value;}
  set classe(String value) {_classe = value;}
  set civilite(String value) {_civilite = value;}
  set idFamille(String value) {_idFamille = value;}

  set dob(String value) {_dob = value;}
  set adresse(String value) {_adresse = value;}
  set ville(String value) {_ville = value;}
  set numFix(String value) {_numFix = value;}
  set numMobileEleve(String value) {_numMobileEleve = value;}
  set numMobileParents(String value) {_numMobileParents = value;}
  set emailEleve(String value) {_emailEleve = value;}
  set emailParents(String value) {_emailParents = value;}

  set solde(String value) {_solde = value;}
  set prev(String value) {_prev = value;}

  set photo(String value) {_photo = value;}

  set bilans(List<Bilan> value) {_bilans = value;}
}

class Note {
  String _date = "";
  String _type = "";
  String _note = "";
  String _commentaire = "";

  Note(this._date, this._type, this._note, this._commentaire);

  String get date => _date;
  String get type => _type;
  String get note => _note;
  String get commentaire => _commentaire;

  set date(String value) {_date = value;}
  set type(String value) {_type = value;}
  set note(String value) {_note = value;}
  set commentaire(String value) {_commentaire = value;}
}

class Bilan {
  String _index = "";
  String _eleveId = "";
  String _date = "";
  String _global = "";
  String _comp = "";
  String _assidu = "";
  String _dm = "";
  String _subjects = "";
  String _toImprove = "";
  String _good = "";
  String _comment = "";

  Bilan(this._index, this._eleveId, this._date, this._global, this._comp, this._assidu, this._dm, this._subjects, this._toImprove, this._good, this._comment);

  String get index => _index;
  String get eleveId => _eleveId;
  String get date => _date;
  String get global => _global;
  String get comp => _comp;
  String get assidu => _assidu;
  String get dm => _dm;
  String get subjects => _subjects;
  String get toImprove => _toImprove;
  String get good => _good;
  String get comment => _comment;

  set index(String value) {_index = value;}
  set eleveId(String value) {_eleveId = value;}
  set date(String value) {_date = value;}
  set global(String value) {_global = value;}
  set comp(String value) {_comp = value;}
  set assidu(String value) {_assidu = value;}
  set dm(String value) {_dm = value;}
  set subjects(String value) {_subjects = value;}
  set toImprove(String value) {_toImprove = value;}
  set good(String value) {_good = value;}
  set comment(String value) {_comment = value;}
}

class Commentaire {
  String _date;
  String _comment;

  Commentaire(this._date, this._comment);

  String get date => _date;
  String get comment => _comment;

  set date(String value) {_date = value;}
  set comment(String value) {_comment = value;}
}

Widget getSmiley(String rating) {
  switch (rating) {
    case "1":
      return smiley1;
    case "2":
      return smiley2;
    case "3":
      return smiley3;
    case "4":
      return smiley4;
    case "5":
      return smiley5;
    default:
      return Container();
  }
}




Future<List<Eleve>> getListEleves(String token, String login) async {
  final response = await http.get(Uri.parse('https://app.easystudies.fr/api/students_list.php?_token=$token&_login=$login'));

  List<dynamic> jsonResponse;

  if (response.statusCode == 200) {
    jsonResponse = jsonDecode(response.body);
  } else {
    throw Exception('Failed to load students');
  }

  List<Eleve> eleves = [];

  for (var u in jsonResponse) {
    Eleve eleve = Eleve.basic(u["_identifier"], u["_nom"], u["_prenom"], u["_class"], u["_civilite"], u["_family"]);
    eleves.add(eleve);
  }

  return eleves;
}

Future<Eleve> getDetailsEleve(String token, String login, Eleve eleve) async {
  final response = await http.get(Uri.parse('https://app.easystudies.fr/api/students_details.php?_token=$token&_login=$login&_studentLogin=${eleve.identifier}'));

  if (response.statusCode != 200) {
    throw Exception('Failed to load details student');
  }

  final jsonResponse = jsonDecode(response.body);
  Map<String, dynamic> details = jsonResponse[0];

  Eleve newEleve = Eleve.fromEleve(eleve);

  String dob = details["_dob"];
  dob = '${dob.substring(8,10)}/${dob.substring(5,7)}/${dob.substring(0,4)}';
  newEleve.dob = dob;

  newEleve.adresse = '${details["_nRoad"]} ${details["_address"]}';
  newEleve.ville = '${details["_codepostal"]} ${details["_city"]}';
  newEleve.numFix = (details["_landline"] == "0149494949" || details["_landline"] == "0149494948") ? "" : details["_landline"];
  newEleve.numMobileEleve = details["_mobileStudent"];
  newEleve.numMobileParents = details["_mobileParents"];
  newEleve.emailEleve = details["_emailStudent"];
  newEleve.emailParents = details["_emailParents"];

  newEleve.solde = details["_solde"];
  newEleve.prev = details["_prev"];

  return newEleve;
}


