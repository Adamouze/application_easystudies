// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, deprecated_member_use, prefer_interpolation_to_compose_strings, non_constant_identifier_names

import 'package:EasyStudies/screens/action_buttons_prof/partie_annuaire/details_eleve_screen.dart';
import 'package:EasyStudies/utilities/constantes.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'scanner.dart';
import 'package:EasyStudies/utils.dart';
import 'package:EasyStudies/logs/auth_stat.dart';

class DurationDialog extends StatefulWidget {
  final double initialDuration;
  final Function(double) onValidate;

  const DurationDialog({super.key, required this.initialDuration, required this.onValidate});

  @override
  _DurationDialogState createState() => _DurationDialogState();

}

class _DurationDialogState extends State<DurationDialog> {
  late double selectedDuration;

  @override
  void initState() {
    super.initState();
    selectedDuration = widget.initialDuration;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(
          color: Colors.orangeAccent,
          width: 3,
        ),
      ),
      title: const Text(
        "Choisir la durée",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'NotoSans',
          fontWeight: FontWeight.bold,
        ),
      ),
        content: DropdownButton<double>(
          value: selectedDuration,
          items: [
            for (double i = 0.0; i <= 10; i += 0.5)
              DropdownMenuItem(
                value: i,
                child: Text(i.toString()),
              )
          ],
          onChanged: (value) {
            setState(() {
              selectedDuration = value!;
            });
          },
        ),
      actions: [
        ElevatedButton(
          onPressed: () {
            widget.onValidate(selectedDuration);
            Navigator.pop(context);
          },
          child: const Text("Valider", style: TextStyle(
            fontFamily: 'NotoSans',
            color: Colors.black, // Couleur de l'écriture noire
          ),
          ),

        ),
      ],
    );
  }
}



class CoursDetailsScreen extends StatefulWidget {
  final Course Cours;
  final String location;
  final String title;

  const CoursDetailsScreen({super.key, required this.location, required this.title, required this.Cours});

  @override
  _CoursDetailsScreenState createState() => _CoursDetailsScreenState();
}

class _CoursDetailsScreenState extends State<CoursDetailsScreen> {
  late Future<List<Presence>> presencesFuture;
  var defaultDuration = 2.0;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthState>(); // Get the instance of AuthState
    final token = authState.token; // Get token from AuthState
    final identifier = authState.identifier; // Get identifier from AuthState
    presencesFuture = fetchClassPresences(widget.Cours.index.toString(), token!, identifier!);
  }

  String formatStudentText(int studentCount) {
    if (studentCount == 0) {
      return "0 présent";
    } else if (studentCount == 1) {
      return "1 présent";
    } else {
      return "$studentCount présents";

    }
  }


  Future<void> scanAndDisplayDialog() async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      status = await Permission.camera.request();
    }
    if (status.isGranted) {
      String? scanResult = await Scanner(context: context).scanBarcode();
      if (scanResult != null && scanResult.isNotEmpty && scanResult != '-1') {
        // Utiliser la fonction updatePresence ici
        final authState = context.read<AuthState>();
        final token = authState.token!;
        final login = authState.identifier!; // Assuming login is stored in identifier
        final idClass = widget.Cours.index;
        const action = 'add';
        final String nbHours = defaultDuration.toString();

        final update = await updatePresence(token, login, idClass, scanResult, action, nbHours);
        String nom = update[0];
        String prenom = update[1];
        String comment = update[2];
        if (comment=="add success") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            backgroundColor: Colors.green,
            content: Text('Élève $prenom $nom ajouté avec succès',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'NotoSans',
                fontWeight: FontWeight.bold,
              ),
            ),
            duration: const Duration(seconds: 2),
          ));
          setState(() {
            presencesFuture = fetchClassPresences(idClass.toString(), token, login);
          });
        }
        else if(comment=="already scanned") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            backgroundColor: Colors.yellow,
            content: Text('Élève $prenom $nom déjà présent',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'NotoSans',
                fontWeight: FontWeight.bold,
              ),
            ),
            duration: const Duration(seconds: 2),
          ));
        }
        else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            backgroundColor: Colors.red,
            content: Text('Élève inconnu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'NotoSans',
                fontWeight: FontWeight.bold,
              ),
            ),
            duration: Duration(seconds: 2),
          ));
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        backgroundColor: Colors.yellow,
        content: Text('Permission d\'accès à la caméra de votre appareil nécessaire',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'NotoSans',
            fontWeight: FontWeight.bold,
          ),
        ),
        duration: Duration(seconds: 2),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: theme.primaryColor,
        ),
        backgroundColor: orangePerso,
        title: Row(
          children: [
            Icon(Icons.book, color: theme.iconTheme.color),
            const SizedBox(width: 10.0),
            Text(
              widget.title,
              style: TextStyle(
                color: theme.primaryColor,
                fontWeight: FontWeight.bold,
                fontFamily: 'NotoSans',
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<Presence>>(
          future: presencesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(orangePerso),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Erreur: ${snapshot.error}')); // Error handling
            } else {
              List<Presence> presences = snapshot.data!;
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: const BoxDecoration(
                      color: orangePerso,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Liste de présence",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                          fontFamily: 'NotoSans',
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: const BoxDecoration(
                      color: orangePerso,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          formatStudentText(presences.map((presence) => presence.identifier).toList().length),
                          style: TextStyle(
                            fontSize: 16,
                            color: theme.primaryColor,
                            fontFamily: 'NotoSans',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.location,
                          style: TextStyle(
                            fontSize: 16,
                            color: theme.primaryColor,
                            fontFamily: 'NotoSans',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                        var width = MediaQuery.of(context).orientation == Orientation.portrait ? constraints.maxWidth / 4.5 : constraints.maxWidth / 4;
                        return Container(
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(10),
                            ),
                            border: Border.all(
                              color: orangePerso,
                              width: 2,
                            ),
                          ),
                          child: SingleChildScrollView(
                            child: DataTable(
                              columnSpacing: 0,
                              columns: [
                                DataColumn(
                                  label: SizedBox(
                                    width: width,
                                    child: Text(
                                      'Identifiant',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: 2 * width,
                                    child: Text(
                                      'Nom/Prénom',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: width,
                                    child: Text(
                                      'Durée',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                                    ),
                                  ),
                                ),
                              ],
                              rows: presences.map((presence) {
                                return DataRow(
                                  cells: [
                                    DataCell(
                                      SizedBox(
                                        width: width,
                                        child: Text(
                                          presence.identifier,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      InkWell(
                                        onLongPress: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => Theme(
                                              data: ThemeData(
                                                dialogBackgroundColor: Colors.white, // Couleur de fond du dialogue
                                              ),
                                              child: SimpleDialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(20), // Bords arrondis
                                                  side: const BorderSide(
                                                    color: Colors.orangeAccent, // Couleur de la bordure
                                                    width: 3, // Largeur de la bordure
                                                  ),
                                                ),
                                                title: Text(
                                                  presence.nom + '\n' + presence.prenom,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    color: Colors.black, // Couleur du texte du titre
                                                    fontWeight: FontWeight.bold, // Gras
                                                    fontFamily: 'NotoSans', // Police Noto Sans
                                                  ),
                                                ),
                                                children: [
                                                  SimpleDialogOption(
                                                    onPressed: () async { // Marquez cette méthode comme asynchrone
                                                      final authState = context.read<AuthState>();
                                                      final token = authState.token!;
                                                      final login = authState.identifier!; // Assuming login is stored in identifier
                                                      Eleve student = await getBasicEleveInfo(token,login,presence.identifier);
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => DetailsEleve(eleve: student),
                                                        ),
                                                      );
                                                    },
                                                    child: const Row(
                                                      children: [
                                                        Icon(Icons.person, color: Colors.black), // Icône de la fiche élève
                                                        SizedBox(width: 10.0),
                                                        Text("Aller vers la fiche élève", style: TextStyle(color: Colors.black, fontFamily: 'NotoSans')),
                                                      ],
                                                    ),
                                                  ),
                                                  SimpleDialogOption(
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) => DurationDialog(
                                                          initialDuration: presence.nbHeures,
                                                          onValidate: (selectedDuration) async {
                                                            final authState = context.read<AuthState>();
                                                            final token = authState.token!;
                                                            final login = authState.identifier!;
                                                            final idClass = widget.Cours.index;
                                                            const action = 'update';
                                                            final String nbHours = selectedDuration.toString();

                                                            final update = await updatePresence(token, login, idClass, presence.identifier, action, nbHours);
                                                            String comment = update[2];

                                                            if (comment == "update success") {
                                                              setState(() {
                                                                presencesFuture = fetchClassPresences(idClass.toString(), token, login);
                                                              });
                                                            }
                                                          },
                                                        ),
                                                      );

                                                    },
                                                    child: const Row(
                                                      children: [
                                                        Icon(Icons.edit, color: Colors.black), // Icône pour modifier la durée
                                                        SizedBox(width: 10.0),
                                                        Text("Modifier la durée", style: TextStyle(color: Colors.black, fontFamily: 'NotoSans')),
                                                      ],
                                                    ),
                                                  ),
                                                  SimpleDialogOption(
                                                    onPressed: () async {
                                                      final authState = context.read<AuthState>();
                                                      final token = authState.token!;
                                                      final login = authState.identifier!;
                                                      final idClass = widget.Cours.index;
                                                      final update = await updatePresence(token, login, idClass, presence.identifier, 'update', '0');
                                                      String comment = update[2];

                                                      if (comment == "update success") {
                                                        setState(() {
                                                          presencesFuture = fetchClassPresences(idClass, token, login);
                                                        });
                                                      }// Supprimer la donnée
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Row(
                                                      children: [
                                                        Icon(Icons.delete, color: Colors.black), // Icône pour supprimer la donnée
                                                        SizedBox(width: 10.0),
                                                        Text("Supprimer de la liste", style: TextStyle(color: Colors.black, fontFamily: 'NotoSans')),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );


                                        },
                                        splashColor: Colors.orangeAccent,
                                        onTap: () {},
                                        child: Container(
                                          width: 2 * width,
                                          color: Colors.grey.withAlpha(10),
                                          child: Text(
                                            presence.nom + '\n' + presence.prenom,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      SizedBox(
                                        width: width,
                                        child: Text(
                                          presence.nbHeures.toStringAsFixed(1),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Transform.scale(
                      scale: 1.4,
                      child: FloatingActionButton(
                        backgroundColor: Colors.blue,
                        onPressed: scanAndDisplayDialog,
                        tooltip: 'Scanner',
                        elevation: 6.0,
                        shape: const CircleBorder(),
                        child: const Icon(
                          Icons.photo_camera,
                          color: Colors.white,
                          size: 32.0,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),

    );

  }
}
