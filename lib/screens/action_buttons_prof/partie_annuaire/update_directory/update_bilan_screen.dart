import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../../utilities/constantes.dart';
import '../../../../utils.dart';
import '../../../../logs/auth_stat.dart';


class RatingCell extends StatefulWidget {
  final int value;
  final ValueChanged<int?> onChanged;
  final int groupValue;

  const RatingCell({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.groupValue,
  }) : super(key: key);

  @override
  RatingCellState createState() => RatingCellState();
}

class RatingCellState extends State<RatingCell> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Radio<int>(
        value: widget.value,
        groupValue: widget.groupValue,
        onChanged: widget.onChanged,
      ),
    );
  }
}

class BaseDeNotationBlock extends StatefulWidget {
  final ValueNotifier<Bilan> bilanNotifier;
  final ValueNotifier<bool> combinedValidNotifier;

  const BaseDeNotationBlock({
    required this.bilanNotifier,
    required this.combinedValidNotifier,
    Key? key,
  }) : super(key: key);

  @override
  BaseDeNotationBlockState createState() => BaseDeNotationBlockState();
}

class BaseDeNotationBlockState extends State<BaseDeNotationBlock> {

  ValueNotifier<bool> isBaseDeNotationValidNotifier = ValueNotifier<bool>(false);

  List<int> _groupValues = [0, 0, 0, 0];

  void _checkBilanValidity() {
    bool isBilanValid = _groupValues.every((value) => value != 0);
    isBaseDeNotationValidNotifier.value = isBilanValid;
  }


  TableRow _createRatingRow(String title, int groupIndex, ValueChanged<int?> onChanged) {
    return TableRow(
      children: [
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
            child: Text(title),
          ),
        ),
        for (int value = 1; value <= 5; value++)
          RatingCell(value: value, groupValue: _groupValues[groupIndex], onChanged: (selectedValue) {
            onChanged(selectedValue);
            setState(() {
              _groupValues[groupIndex] = selectedValue!;
              _checkBilanValidity();
            });
            switch (groupIndex) {
              case 0:
                widget.bilanNotifier.value.global = selectedValue.toString();
                break;
              case 1:
                widget.bilanNotifier.value.comp = selectedValue.toString();
                break;
              case 2:
                widget.bilanNotifier.value.assidu = selectedValue.toString();
                break;
              case 3:
                widget.bilanNotifier.value.dm = selectedValue.toString();
                break;
              default:
                break;
            }
          }),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _groupValues = [
      int.parse(widget.bilanNotifier.value.global),
      int.parse(widget.bilanNotifier.value.comp),
      int.parse(widget.bilanNotifier.value.assidu),
      int.parse(widget.bilanNotifier.value.dm)
    ];
    _checkBilanValidity();
    isBaseDeNotationValidNotifier.addListener(_updateCombinedValidity);
  }

  @override
  void dispose() {
    isBaseDeNotationValidNotifier.removeListener(_updateCombinedValidity);
    super.dispose();
  }

  void _updateCombinedValidity() {
    if (isBaseDeNotationValidNotifier.value) {
      widget.combinedValidNotifier.value = true; // Vous pouvez aussi avoir une logique plus complexe si nécessaire
    } else {
      widget.combinedValidNotifier.value = false;
    }
  }


  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.95,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: orangePerso,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 2), // changes position of shadow
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Base de Notation',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NotoSans',
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 2), // changes position of shadow
                ),
              ],
            ),
            child: Table(
              columnWidths: const <int, TableColumnWidth>{
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(0.3),
                2: FlexColumnWidth(0.3),
                3: FlexColumnWidth(0.3),
                4: FlexColumnWidth(0.3),
                5: FlexColumnWidth(0.3),
              },
              border: TableBorder.all(
                color: Colors.black26,
                width: 1,
              ),
              children: [
                TableRow(
                  children: [
                    const Center(child: Text(' ')),
                    for (int i = 1; i <= 5; i++)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Image.asset('assets/smiley/$i.png', height: 30),
                        ),
                      ),
                  ],
                ),

                _createRatingRow('Note globale', 0, (value) {
                  setState(() { _groupValues[0] = value ?? _groupValues[0]; });
                }),
                _createRatingRow('Note comportement', 1, (value) {
                  setState(() { _groupValues[1] = value ?? _groupValues[1]; });
                }),
                _createRatingRow('Note assiduité', 2, (value) {
                  setState(() { _groupValues[2] = value ?? _groupValues[2]; });
                }),
                _createRatingRow('Devoirs / DM faits', 3, (value) {
                  setState(() { _groupValues[3] = value ?? _groupValues[3]; });
                }),

              ],
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: isBaseDeNotationValidNotifier,
            builder: (context, isBilanValid, child) {
              if (!isBilanValid) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.0, left: 8.0),
                    child: Text(
                      'Veuillez remplir le bilan en entier.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                );
              }
              return Container(); // retournez un container vide si tout est valide
            },
          )
        ],
      ),
    );
  }
}


class BilanBlock extends StatefulWidget {
  final ValueNotifier<Bilan> bilanNotifier;
  final ValueNotifier<bool> combinedValidNotifier;

  const BilanBlock({
    required this.bilanNotifier,
    required this.combinedValidNotifier,
    Key? key,
  }) : super(key: key);
  @override
  BilanBlockState createState() => BilanBlockState();
}

class BilanBlockState extends State<BilanBlock> {

  ValueNotifier<bool> isBilanBlockValidNotifier = ValueNotifier<bool>(false);
  final _toImproveController = TextEditingController();
  final _goodController = TextEditingController();
  final _commentController = TextEditingController();

  void _checkMatieresValidity() {
    bool isAtLeastOneMatiereSelected = matieres.values.any((value) => value);
    isBilanBlockValidNotifier.value = isAtLeastOneMatiereSelected;
  }

  Map<String, bool> matieres = {
    'Mathématiques': false,
    'Français / Philosophie': false,
    'Anglais': false,
    'Physique / Chimie': false,
    'SVT': false,
    'Histoire / Géo': false,
    'Comptabilité / Gestion': false,
    'Autres': false,
  };

  void updateSubjects() {
    widget.bilanNotifier.value.subjects = matieres.keys
        .where((key) => matieres[key] == true) // Filtrer les matières sélectionnées
        .join('\r\n'); // Joindre avec le séparateur
  }

  @override
  void initState() {
    super.initState();

    // Initialiser 'matieres' avec les valeurs de 'bilan.subjects'
    for (var entry in matieres.keys.toList()) {
      String keyInitials = entry.split(' ').first; // Prend les premiers mots de chaque entrée
      if (widget.bilanNotifier.value.subjects.contains(keyInitials)) {
        matieres[entry] = true;
      }
    }
    _checkMatieresValidity();
    isBilanBlockValidNotifier.addListener(_updateCombinedValidity);

    _toImproveController.text = widget.bilanNotifier.value.toImprove;
    _goodController.text = widget.bilanNotifier.value.good;
    _commentController.text = widget.bilanNotifier.value.comment;

    setState(() {});

  }


  @override
  void dispose() {
    isBilanBlockValidNotifier.removeListener(_updateCombinedValidity);
    _toImproveController.dispose();
    _goodController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _updateCombinedValidity() {
    if (isBilanBlockValidNotifier.value) {
      widget.combinedValidNotifier.value = true; // Vous pouvez aussi avoir une logique plus complexe si nécessaire
    } else {
      widget.combinedValidNotifier.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime date = widget.bilanNotifier.value.date.isEmpty ? DateTime.now() : DateTime.parse(widget.bilanNotifier.value.date);

    return FractionallySizedBox(
      widthFactor: 0.95,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: orangePerso,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 2), // changes position of shadow
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Bilan',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NotoSans',
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 2), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              children: <Widget>[

                TextButton(
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: date,
                      firstDate: DateTime(2015),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null && picked != date) {
                      setState(() {
                        date = picked;
                        widget.bilanNotifier.value.date = DateFormat('yyyy-MM-dd').format(picked);
                      });
                    }
                  },
                  child: TextField(
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: DateFormat('dd/MM/yyyy').format(date),
                        labelStyle: const TextStyle(color: Colors.black),
                        suffixIcon: const Padding(
                          padding: EdgeInsets.only(right: 20.0), // Ajustez cette valeur pour déplacer l'icône
                          child: Icon(
                            Icons.calendar_month,
                            color: Colors.black,
                          ),
                        ),
                        border: const OutlineInputBorder(),
                      )
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey, // Couleur de la bordure
                        width: 1.0, // Épaisseur de la bordure
                      ),
                      borderRadius: BorderRadius.circular(4.0), // Arrondissement des coins si vous le souhaitez
                    ),
                    child: ExpansionTile(
                      title: const Text(
                        "Sélection des matières",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      children: matieres.keys.map((String key) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 0.0), // ajustez cette valeur pour contrôler l'espace entre les éléments
                          child: Row(
                            children: <Widget>[
                              Checkbox(
                                value: matieres[key],
                                onChanged: (bool? value) {
                                  setState(() {
                                    matieres[key] = value ?? false;
                                    updateSubjects();
                                    _checkMatieresValidity();  // Ajouté cette ligne
                                  });
                                },
                              ),
                              Text(
                                key,
                                style: const TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                ValueListenableBuilder<bool>(
                  valueListenable: isBilanBlockValidNotifier,
                  builder: (context, isMatiereSelected, child) {
                    if (!isMatiereSelected) {
                      return const Column(
                        children: [
                          Center(
                            child: Text(
                              'Veuillez sélectionner au moins une matière.',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          SizedBox(height: 6),
                        ],
                      );
                    }
                    return Container(); // retournez un container vide si une matière est sélectionnée
                  },
                ),

                Padding(
                  padding: const EdgeInsets.all(10.0), // Ajout de marge extérieure
                  child: TextField(
                    controller: _toImproveController,
                    minLines: 3,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      hintText: 'Écrivez ici...',
                      labelText: 'Axe d\'amélioration',
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                      border: OutlineInputBorder(),

                    ),
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    onChanged: (value) => widget.bilanNotifier.value.toImprove = value,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(10.0), // Ajout de marge extérieure
                  child: TextField(
                    controller: _goodController,
                    minLines: 3,
                    maxLines: null, // permet plusieurs lignes
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      hintText: 'Écrivez ici...',
                      labelText: 'Points forts',
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                      border: OutlineInputBorder(),

                    ),
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    onChanged: (value) => widget.bilanNotifier.value.good = value,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(10.0), // Ajout de marge extérieure
                  child: TextField(
                    controller: _commentController,
                    minLines: 3,
                    maxLines: null, // permet plusieurs lignes
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      hintText: 'Écrivez ici...',
                      labelText: 'Commentaire',
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                      border: OutlineInputBorder(),

                    ),
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    onChanged: (value) => widget.bilanNotifier.value.comment = value,
                  ),
                ),

                const SizedBox(height: 5),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class SoumettreButton extends StatefulWidget {
  final Eleve eleve;
  final Bilan bilan;
  final VoidCallback onSubmit;
  final ValueNotifier<bool> isBilanValidNotifier;

  const SoumettreButton({
    required this.eleve,
    required this.bilan,
    required this.onSubmit,
    required this.isBilanValidNotifier,
    Key? key,
  }) : super(key: key);

  @override
  SoumettreButtonState createState() => SoumettreButtonState();
}

class SoumettreButtonState extends State<SoumettreButton> {

  @override
  void initState() {
    super.initState();
    widget.isBilanValidNotifier.addListener(_rebuild);
  }

  @override
  void dispose() {
    widget.isBilanValidNotifier.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.isBilanValidNotifier,
      builder: (context, isValid, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // This centers the two buttons
          children: <Widget>[
            const SizedBox(),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Retour'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(orangePerso),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
            ),
            ElevatedButton.icon(
              onPressed: isValid
                  ? () {
                widget.onSubmit();
                Navigator.pop(context);
              }
                  : null,
              icon: const Icon(Icons.check),
              label: const Text('Ajouter'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
            ),
            const SizedBox(),
          ],
        );
      },
    );
  }
}


class UpdateBilan extends StatefulWidget {
  final Eleve eleve;
  final Bilan bilan;
  final Function? onBilanUpdate;

  const UpdateBilan({required this.eleve, required this.bilan, this.onBilanUpdate, Key? key}) : super(key: key);

  @override
  UpdateBilanState createState() => UpdateBilanState();
}

class UpdateBilanState extends State<UpdateBilan> {

  final ValueNotifier<Bilan> bilanNotifier = ValueNotifier<Bilan>(Bilan("", "", "", "", "", "", "", "", "", ""));
  ValueNotifier<bool> combinedValidNotifier = ValueNotifier<bool>(true);

  final GlobalKey<BaseDeNotationBlockState> baseDeNotationBlockKey = GlobalKey<BaseDeNotationBlockState>();
  final GlobalKey<BilanBlockState> bilanBlockKey = GlobalKey<BilanBlockState>();


  void handleSubmitBilan(String token, String login, String user, String prenom) async {
    bilanNotifier.value.toImprove = bilanNotifier.value.toImprove.replaceAll('\n', '\r\n');
    bilanNotifier.value.good = bilanNotifier.value.good.replaceAll('\n', '\r\n');
    bilanNotifier.value.comment = bilanNotifier.value.comment.replaceAll('\n', '\r\n');

    if (bilanNotifier.value.comment.trim().isEmpty) {
      // Si le commentaire est vide, assignez seulement "Entré par: $user ($prenom)"
      bilanNotifier.value.comment = 'Modifié par: $user ($prenom)';
    } else if (bilanNotifier.value.comment.contains("Modifié par")) {
      // Si "Modifié par" existe, remplacez la partie après cela
      bilanNotifier.value.comment = bilanNotifier.value.comment.replaceAllMapped(
          RegExp(r'Modifié par:.*'),
              (match) => 'Modifié par: $user ($prenom)'
      );
    } else if (bilanNotifier.value.comment.contains("Entré par")) {
      // Si "Entrée par" existe, ajoutez "Modifié par: $user ($prenom)" après une nouvelle ligne
      bilanNotifier.value.comment = '${bilanNotifier.value.comment}\r\nModifié par: $user ($prenom)';
    } else {
      // Sinon, ajoutez simplement à la fin
      bilanNotifier.value.comment = '${bilanNotifier.value.comment}\r\n\r\nModifié par: $user ($prenom)';
    }

    await manageBilan(token, login, widget.eleve, "update", bilanNotifier.value);

    // Appel au callback pour rafraîchir la liste des commentaires
    if (widget.onBilanUpdate != null) {
      widget.onBilanUpdate!();
    }
  }

  @override
  void initState() {
    super.initState();
    bilanNotifier.value = widget.bilan;
    combinedValidNotifier.addListener(_updateCombinedValidity);
  }

  @override
  void dispose() {
    // Il est aussi important de retirer les écouteurs lorsque le widget est disposé
    baseDeNotationBlockKey.currentState?.isBaseDeNotationValidNotifier.removeListener(_updateCombinedValidity);
    bilanBlockKey.currentState?.isBilanBlockValidNotifier.removeListener(_updateCombinedValidity);
    combinedValidNotifier.removeListener(_updateCombinedValidity);
    super.dispose();
  }

  void _updateCombinedValidity() {
    bool isBaseValid = baseDeNotationBlockKey.currentState?.isBaseDeNotationValidNotifier.value ?? false;
    bool isBilanValid = bilanBlockKey.currentState?.isBilanBlockValidNotifier.value ?? false;
    bool newValue = isBaseValid && isBilanValid;
    combinedValidNotifier.value = newValue;
  }



  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    final authState = Provider.of<AuthState>(context, listen: false);
    final token = authState.token;
    final login = authState.identifier;

    if (token == null) {
      return const Text("ERREUR de token dans la requête API");
    }
    if (login == null) {
      return const Text("ERREUR de login dans la requête API");
    }

    String prenom = authState.prenom!;
    String user = authState.userType!;
    if (user == "prof") {
      user = "PROF";
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: orangePerso,
        title:Text(
          'Modification du bilan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.primaryColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 20),

                BaseDeNotationBlock(key:baseDeNotationBlockKey, bilanNotifier: bilanNotifier, combinedValidNotifier: combinedValidNotifier),

                const SizedBox(height: 20),

                BilanBlock(key: bilanBlockKey, bilanNotifier: bilanNotifier, combinedValidNotifier: combinedValidNotifier),

                const SizedBox(height: 20),

                Builder(
                  builder: (BuildContext context) {
                    return SoumettreButton(
                      eleve: widget.eleve,
                      bilan: bilanNotifier.value,
                      isBilanValidNotifier: combinedValidNotifier,
                      onSubmit: () => handleSubmitBilan(token, login, user, prenom),
                    );
                  },
                ),

                const SizedBox(height: 100),
              ],
            ),
          )
      ),
    );
  }
}



