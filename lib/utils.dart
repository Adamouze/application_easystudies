/*
import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;
*/

import 'package:flutter/material.dart';
import 'utilities/constantes.dart';

///Fichier contenant toutes les classes utilisées dans les autres layout pour essayer de rendre le tout plus ergonomique et facile d'utilisation
///Il faudra essayer de mettre la plupart des classes ici pour laisser les fichiers de layout épurés
///J'ai peut être oublier de déplacer certaine méthode/class se trouvant dans les autres fichiers

class Eleve {
  String _identifiant = "";
  String _nom = "";
  String _prenom = "";
  String _classe = "";
  String _genre = "";
  String _ddn = "";
  String _etat = "";
  String _int_ent = "";
  String _solde = "";
  String _prev = "";
  String _nbHeures = "";
  List<Bilan> _bilans = []; // Ajoutez cette ligne

  Eleve.id(this._identifiant);

  Eleve.basic(this._identifiant, this._nom, this._prenom, this._classe, this._genre);

  Eleve.extra(this._ddn, this._etat, this._int_ent, this._solde, this._prev,
      this._nbHeures);

  String get nbHeures => _nbHeures;

  String get prev => _prev;

  String get solde => _solde;

  String get int_ent => _int_ent;

  String get etat => _etat;

  String get ddn => _ddn;

  String get genre => _genre;

  String get identifiant => _identifiant;

  String get classe => _classe;

  String get prenom => _prenom;

  String get nom => _nom;

  List<Bilan> get bilans => _bilans; // Ajoutez ce getter pour _bilans

  set nbHeures(String value) {
    _nbHeures = value;
  }

  set prev(String value) {
    _prev = value;
  }

  set solde(String value) {
    _solde = value;
  }

  set int_ent(String value) {
    _int_ent = value;
  }

  set etat(String value) {
    _etat = value;
  }

  set ddn(String value) {
    _ddn = value;
  }

  set genre(String value) {
    _genre = value;
  }

  set identifiant(String value) {
    _identifiant = value;
  }

  set classe(String value) {
    _classe = value;
  }

  set prenom(String value) {
    _prenom = value;
  }

  set nom(String value) {
    _nom = value;
  }

  set bilans(List<Bilan> value) {
    _bilans = value;
  }
}

class Note {
  String _date = "";
  String _type = "";
  String _note = "";
  String _commentaire = "";

  Note(this._date, this._type, this._note, this._commentaire);

  String get commentaire => _commentaire;

  set commentaire(String value) {
    _commentaire = value;
  }

  String get note => _note;

  set note(String value) {
    _note = value;
  }

  String get type => _type;

  set type(String value) {
    _type = value;
  }

  String get date => _date;

  set date(String value) {
    _date = value;
  }
}

class Bilan {
  String _date = "";
  String _global = "";
  String _comp = "";
  String _assidu = "";
  String _dm = "";
  String _subjects = "";
  String _toImprove = "";
  String _good = "";
  String _comment = "";

  Bilan(this._date, this._global, this._comp, this._assidu, this._dm,
      this._subjects, this._toImprove, this._good, this._comment);

  String get date => _date;
  String get global => _global;
  String get comp => _comp;
  String get assidu => _assidu;
  String get dm => _dm;
  String get subjects => _subjects;
  String get toImprove => _toImprove;
  String get good => _good;
  String get comment => _comment;
}

class Commentaire {
  String _date;
  String _comment;

  Commentaire(this._date, this._comment);

  String get comment => _comment;

  set comment(String value) {
    _comment = value;
  }

  String get date => _date;

  set date(String value) {
    _date = value;
  }
}

/*

Future<Eleve> get_User(Eleve eleve) async {
  final response =
  await http.post("http://atchu82.free.fr/FicheEleveJson.php", body: {
    'id': eleve.identifiant,
  });
  var jsonData = json.decode(response.body);

  eleve.ddn = jsonData[0]["_dob"];
  if (jsonData[0]["_active"] == "1") {
    eleve.etat = "Actif";
  } else {
    eleve.etat = "Inactif";
  }
  eleve.int_ent = jsonData[0]["_typeStudent"];
  eleve.solde = jsonData[0]["_solde"];
  eleve.prev = jsonData[0]["_prev"];
  eleve.nbHeures = jsonData[0]["_nbHeuresRestantes"];
  return eleve;
}

Future<List<Bilan>> get_Bilans(Eleve eleve, List<Bilan> _bilans) async {
  final response =
  await http.post("http://atchu82.free.fr/RecupBilanJson.php", body: {
    'id': eleve.identifiant,
  });
  var jsonData = json.decode(response.body);

  for (var u in jsonData) {
    Bilan bilan = Bilan(u["_date"], u["_global"], u["_comp"], u["_assidu"],
        u["_dm"], u["_subjects"], u["_comment"], u["_good"], u["_toImprove"]);
    _bilans.add(bilan);
  }

  return _bilans;
}

Future<List<Note>> get_Notes(Eleve eleve, List<Note> _notes) async {
  final response =
  await http.post("http://atchu82.free.fr/RecupNoteJson.php", body: {
    'id': eleve.identifiant,
  });
  var jsonData = json.decode(response.body);

  for (var u in jsonData) {
    Note note = Note(u["_date"], u["_type"], u["_grade"], u["_comment"]);
    _notes.add(note);
  }

  return _notes;
}

Future<List<Commentaire>> get_comments(Eleve eleve, List<Commentaire> _commentaires) async {
  final response = await http.post(
      "http://atchu82.free.fr/RecupCommentairesJSON.php",
      body: {'id': eleve.identifiant});
  var jsonData = json.decode(response.body);

  for (var u in jsonData) {
    Commentaire commentaire = Commentaire(u["_date"], u["_comment"]);
    _commentaires.add(commentaire);
  }
  return _commentaires;
}

 */


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

