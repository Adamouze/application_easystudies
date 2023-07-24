/*
import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;
*/

import 'dart:ui';

import 'package:flutter/material.dart';
import 'utilities/constantes.dart';
import 'package:EasyStudies/logs/auth_stat.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


///Fichier contenant toutes les classes utilisées dans les autres layout pour essayer de rendre le tout plus ergonomique et facile d'utilisation
///Il faudra essayer de mettre la plupart des classes ici pour laisser les fichiers de layout épurés
///J'ai peut-être oublié de déplacer certaine méthode/class se trouvant dans les autres fichiers

class Eleve {
  String _identifier = "";

  String _nom = "";
  String _prenom = "";
  String _classe = "";
  String _genre = "";
  String _dob = "";

  String _adresse = "";
  String _numFix = "";
  String _numMobile = "";
  String _emailEleve = "";
  String _emailParents = "";

  String _etat = "";
  String _int_ent = "";
  String _solde = "";
  String _prev = "";
  String _nbHeures = "";

  String _photo = "";
  String _idFamille = "";

  List<Bilan> _bilans = [];

  Eleve.basic(this._identifier, this._nom, this._prenom, this._classe, this._genre, this._dob);
  Eleve.contact(this._adresse, this._numFix, this._numMobile, this._emailEleve, this._emailParents);
  Eleve.compta(this._etat, this._int_ent, this._solde, this._prev, this._nbHeures);

  String get identifier => _identifier;
  String get nom => _nom;
  String get prenom => _prenom;
  String get classe => _classe;
  String get genre => _genre;
  String get dob => _dob;

  String get adresse => _adresse;
  String get numFix => _numFix;
  String get numMobile => _numMobile;
  String get emailEleve => _emailEleve;
  String get emailParents => _emailParents;

  String get etat => _etat;
  String get int_ent => _int_ent;
  String get solde => _solde;
  String get prev => _prev;
  String get nbHeures => _nbHeures;

  String get photo => _photo;
  String get idFamille => _idFamille;

  List<Bilan> get bilans => _bilans; // Ajoutez ce getter pour _bilans

  set identifier(String value) {
    _identifier = value;
  }

  set nom(String value) {_nom = value;}
  set prenom(String value) {_prenom = value;}
  set classe(String value) {_classe = value;}
  set genre(String value) {_genre = value;}
  set dob(String value) {_dob = value;}

  set adresse(String value) {_adresse = value;}
  set numFix(String value) {_numFix = value;}
  set numMobile(String value) {_numMobile = value;}
  set emailEleve(String value) {_emailEleve = value;}
  set emailParents(String value) {_emailParents = value;}

  set etat(String value) {_etat = value;}
  set int_ent(String value) {_int_ent = value;}
  set solde(String value) {_solde = value;}
  set prev(String value) {_prev = value;}
  set nbHeures(String value) {_nbHeures = value;}

  set photo(String value) {_photo = value;}
  set idFamille(String value) {_idFamille = value;}

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
  String _date = "";
  String _global = "";
  String _comp = "";
  String _assidu = "";
  String _dm = "";
  String _subjects = "";
  String _toImprove = "";
  String _good = "";
  String _comment = "";

  Bilan(this._date, this._global, this._comp, this._assidu, this._dm, this._subjects, this._toImprove, this._good, this._comment);

  String get date => _date;
  String get global => _global;
  String get comp => _comp;
  String get assidu => _assidu;
  String get dm => _dm;
  String get subjects => _subjects;
  String get toImprove => _toImprove;
  String get good => _good;
  String get comment => _comment;

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

/*

Future<Eleve> get_User(Eleve eleve) async {
  final response =
  await http.post("http://atchu82.free.fr/FicheEleveJson.php", body: {
    'id': eleve.identifier,
  });
  var jsonData = json.decode(response.body);

  eleve.dob = jsonData[0]["_dob"];
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
    'id': eleve.identifier,
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
    'id': eleve.identifier,
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
      body: {'id': eleve.identifier});
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

class Centre {
  final String index;
  final String centre;
  final String nomCentre;

  Centre({required this.index, required this.centre, required this.nomCentre});

  factory Centre.fromJson(Map<String, dynamic> json) {
    return Centre(
      index: json['_index'],
      centre: json['_centre'],
      nomCentre: json['_nom_centre'],
    );
  }
}

Future<List<Centre>> fetchCenterList(String token, String identifier) async {
  final response = await http.get(Uri.parse('https://app.easystudies.fr/api/center_list.php?_token=$token&_login=$identifier'));

  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = jsonDecode(response.body);
    return jsonResponse.map((item) => Centre.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load data from API');
  }
}

class Course {
  final String index;
  final String date;
  final String type;
  final String centre;
  final String comment;

  Course({
    required this.index,
    required this.date,
    required this.type,
    required this.centre,
    required this.comment,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      index: json['_index'],
      date: json['_date'],
      type: json['_type'],
      centre: json['_center'],
      comment: json['_comment'],
    );
  }
}

Future<List<Course>> fetchCourseList(String token, String identifier, String centre ) async {
  final response = await http.get(Uri.parse('https://app.easystudies.fr/api/class_list.php?_token=$token&_login=$identifier&_center=$centre'));

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    List<dynamic> data = jsonResponse['_data'];
    return data.map((item) => Course.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load courses from API');
  }
}


class Presence {
  final String identifier;
  final String nom;
  final String prenom;
  final String classType;
  final String idClass;
  final double nbHeures;
  final double prix;

  Presence({required this.identifier, required this.nom, required this.prenom, required this.classType, required this.idClass, required this.nbHeures, required this.prix});

  factory Presence.fromJson(Map<String, dynamic> json) {
    return Presence(
      identifier: json['_identifier'],
      nom: json['_nom'],
      prenom: json['_prenom'],
      classType: json['_class'],
      idClass: json['_idClass'],
      nbHeures: double.parse(json['_nbHeures']),
      prix: double.parse(json['_prix']),
    );
  }
}



Future<List<Presence>> fetchClassPresences(String classID, String token, String identifier) async {
  final response = await http.get(Uri.parse('https://app.easystudies.fr/api/class_presences.php?_token=$token&_login=$identifier&_classID=$classID'));

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    List<dynamic> data = jsonResponse['_data'];
    List<Presence> presences = data.map((item) => Presence.fromJson(item)).toList();
    return presences;
  } else {
    throw Exception('Failed to load class presences');
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };

  @override
  Scrollbar buildScrollbar(
      BuildContext context, Widget child, ScrollableDetails details) {
    return Scrollbar(
      thickness: 5.0,
      radius: const Radius.circular(10),
      thumbVisibility: true,
      child: child,
    );
  }

  @override
  Color getScrollbarColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.hovered)) {
      return Colors.white.withOpacity(0.9);
    }
    return Colors.white.withOpacity(0.5);
  }
}




