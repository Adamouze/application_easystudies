/*
import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;
*/

import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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

  List<Devoir> _devoirs = [];
  List<Commentaire> _commentaires = [];
  List<Note> _notes = [];
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

  List<Devoir> get devoirs => _devoirs;
  List<Commentaire> get commentaires => _commentaires;
  List<Note> get notes => _notes;
  List<Bilan> get bilans => _bilans;

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

  set commentaires(List<Commentaire> value) {_commentaires = value;}
  set notes(List<Note> value) {_notes = value;}
  set bilans(List<Bilan> value) {_bilans = value;}
}

class Devoir {
  String _index;
  String _date;
  String _comment;
  String _fait;

  Devoir(this._index, this._date, this._comment, this._fait);

  String get index => _index;
  String get date => _date;
  String get comment => _comment;
  String get fait => _fait;

  set index(String value) {_index = value;}
  set date(String value) {_date = value;}
  set comment(String value) {_comment = value;}
  set fait(String value) {_fait = value;}
}

class Commentaire {
  String _index;
  String _date;
  String _heure;
  String _from;
  String _comment;

  Commentaire(this._index, this._date, this._heure, this._from, this._comment);

  String get index => _index;
  String get date => _date;
  String get heure => _heure;
  String get from => _from;
  String get comment => _comment;

  set index(String value) {_index = value;}
  set date(String value) {_date = value;}
  set heure(String value) {_heure = value;}
  set from(String value) {_from = value;}
  set comment(String value) {_comment = value;}
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
  String _date = "";
  String _global = "";
  String _comp = "";
  String _assidu = "";
  String _dm = "";
  String _subjects = "";
  String _toImprove = "";
  String _good = "";
  String _comment = "";

  Bilan(this._index, this._date, this._global, this._comp, this._assidu, this._dm, this._subjects, this._toImprove, this._good, this._comment);

  String get index => _index;
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

Future<Eleve> getNomPrenomEleve(String token, String login, Eleve eleve) async {
  final response = await http.get(Uri.parse('https://app.easystudies.fr/api/students_details.php?_token=$token&_login=$login&_studentLogin=${eleve.identifier}'));

  if (response.statusCode != 200) {
    throw Exception('Failed to load user details');
  }

  final jsonResponse = jsonDecode(response.body);

  if (jsonResponse.isEmpty) {
    throw Exception('No student details received');
  }

  Map<String, dynamic> details = jsonResponse[0];

  Eleve newEleve = Eleve.fromEleve(eleve);
  newEleve.nom = details["_nom"];
  newEleve.prenom = details["_prenom"];

  return newEleve;
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

Future<Eleve> getCommentsEleve(String token, String login, Eleve eleve) async {
  final response = await http.get(Uri.parse('https://app.easystudies.fr/api/comments_get.php?_token=$token&_login=$login&_studentLogin=${eleve.identifier}'));

  if (response.statusCode != 200) {
    throw Exception('Failed to load student comments');
  }

  final jsonResponse = jsonDecode(response.body);
  List<dynamic> commentsData = jsonResponse["_data"];

  List<Commentaire> commentaires = [];
  for (var u in commentsData) {
    Commentaire commentaire = Commentaire(u["_index"], u["_date"].substring(0,10), u["_date"].substring(11,19), u["_from"], u["_comment"]);
    commentaires.add(commentaire);
  }

  eleve.commentaires = commentaires;
  return eleve;
}

Future<Eleve> getNotesEleve(String token, String login, Eleve eleve) async {
  final response = await http.get(
    Uri.parse('https://app.easystudies.fr/api/grades_get.php?_token=$token&_login=$login&_studentLogin=${eleve.identifier}'),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to load student grades');
  }

  final jsonResponse = jsonDecode(response.body);
  List<dynamic> gradesData = jsonResponse["_data"];

  List<Note> notes = [];
  for (var u in gradesData) {
    Note note = Note(u["_date"], u["_type"], u["_grade"], u["_comment"]);
    notes.add(note);
  }

  eleve.notes = notes;
  return eleve;
}

Future<Eleve> getBilansEleve(String token, String login, Eleve eleve) async {
  final response = await http.get(Uri.parse('https://app.easystudies.fr/api/students_bilans.php?_token=$token&_login=$login&_studentLogin=${eleve.identifier}'));

  if (response.statusCode != 200) {
    throw Exception('Failed to load student reports');
  }

  final jsonResponse = jsonDecode(response.body);

  List<Bilan> bilans = [];
  for (var u in jsonResponse) {
    Bilan bilan = Bilan(u["_index"], u["_date"], u["_global"], u["_comp"], u["_assidu"], u["_dm"], u["_subjects"], u["_toImprove"], u["_good"], u["_comment"]);
    bilans.add(bilan);
  }

  eleve.bilans = bilans;
  return eleve;
}

Future<Eleve> getAllEleve(String token, String login, Eleve eleve) async {
  final detailsFuture = getDetailsEleve(token, login, eleve);
  final commentsFuture = getCommentsEleve(token, login, eleve);
  final notesFuture = getNotesEleve(token, login, eleve);
  final bilansFuture = getBilansEleve(token, login, eleve);


  final responses = await Future.wait([detailsFuture, commentsFuture, notesFuture, bilansFuture]);

  Eleve detailedEleve = responses[0];
  Eleve eleveWithComments = responses[1];
  Eleve eleveWithNotes = responses[2];
  Eleve eleveWithBilans = responses[3];

  detailedEleve.commentaires = eleveWithComments.commentaires;
  detailedEleve.notes = eleveWithNotes.notes;
  detailedEleve.bilans = eleveWithBilans.bilans;

  return detailedEleve;
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

Future<bool> updatePresence(String token, String login, String classID, String identifier, String action, String nbHours) async {

  final response = await http.get(Uri.parse('https://app.easystudies.fr/api/scan_presences.php?_token=$token&_login=$login&_idClass=$classID&_identifier=$identifier&_action=$action&_nbHours=$nbHours'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    if (data.containsKey('_data') &&
        data['_data'].containsKey('_result') &&
        data['_data']['_result'] is bool) {
      return data['_data']['_result'];
    }
  }
  throw Exception('Failed to load data');
}



Future<void> addCommentaireToDatabase(String token, String login, Eleve eleve, Commentaire commentaire) async {
  final uri = Uri.parse('https://app.easystudies.fr/api/ajouter_commentaire');  // TODO: à remplacer
  final response = await http.post(
    uri,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', // si l'authentification est nécessaire
    },
    body: jsonEncode({
      '_data': [
        {
          '_identifier': eleve.identifier,
          '_date': commentaire.date,
          '_from': commentaire.from,
          '_comment': commentaire.comment,
        }
      ],
    }),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to add commentaire');
  }
}

Future<void> addNoteToDatabase(String token, String login, Eleve eleve, Note note) async {
  final uri = Uri.parse('https://app.easystudies.fr/api/ajouter_note'); // TODO: à remplacer
  final response = await http.post(
    uri,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', // si l'authentification est nécessaire
    },
    body: jsonEncode({
      '_data': [
        {
          '_identifier': eleve.identifier,
          '_date': note.date,
          '_grade': note.note,
          '_type': note.type,
          '_comment': note.commentaire,
        }
      ],
    }),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to add note');
  }
}

Future<void> addBilanToDatabase(String token, String login, Eleve eleve, Bilan bilan) async {
  final uri = Uri.parse('https://app.easystudies.fr/api/ajouter_bilan'); // TODO: à remplacer
  final response = await http.post(
    uri,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', // si l'authentification est nécessaire
    },
    body: jsonEncode({
      '_login': login,
      '_studentLogin': eleve.identifier,
      // Autres attributs du bilan
    }),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to add bilan');
  }
}




String afficherDate(String date) {
  if (date == "0000-00-00") {
    return "non renseigné";
  } else {
    return DateFormat('dd MMM y', 'fr_FR').format(DateTime.parse(date));
  }
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
      controller: details.controller,  // Ajout du controller ici
      thickness: 5.0,
      radius: const Radius.circular(10),
      child: child,
    );
  }

  Color getScrollbarColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.hovered)) {
      return Colors.white.withOpacity(0.9);
    }
    return Colors.white.withOpacity(0.5);
  }
}



