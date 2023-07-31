// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, deprecated_member_use, prefer_interpolation_to_compose_strings, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'scanner.dart';
import 'package:EasyStudies/utils.dart';
import 'package:EasyStudies/logs/auth_stat.dart';

class CoursDetailsScreen extends StatefulWidget {
  final Course Cours;
  final String location;
  final String title;

  const CoursDetailsScreen({super.key, required this.location, required this.title, required this.Cours});

  @override
  _CoursDetailsScreenState createState() => _CoursDetailsScreenState();
}

class _CoursDetailsScreenState extends State<CoursDetailsScreen> {
  List<String> scannedIDs = [];
  final defaultDuration = 2;

  void scanID(String newID) {
    setState(() {
      scannedIDs.add(newID);
    });
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
        scanID(scanResult);
      }
    }else {
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

    final authState = context.read<AuthState>(); // Get the instance of AuthState
    final token = authState.token; // Get token from AuthState
    final identifier = authState.identifier; // Get identifier from AuthState

    Future<List<Presence>> presencesFuture = fetchClassPresences(widget.Cours.index.toString(), token!, identifier!);

    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: theme.primaryColor,
        ),
        backgroundColor: Colors.orangeAccent,
        title: Row(
          children: [
            const Icon(Icons.book, color: Colors.white),
            const SizedBox(width: 10.0),
            Text(
              widget.title,
              style: const TextStyle(
                color: Colors.white,
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
              return const Center(child: CircularProgressIndicator(color: Colors.orangeAccent)); // Loading indicator
            } else if (snapshot.hasError) {
              return Center(child: Text('Erreur: ${snapshot.error}')); // Error handling
            } else {
              List<Presence> presences = snapshot.data!;
              scannedIDs = presences.map((presence) => presence.identifier).toList();

              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: const BoxDecoration(
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "Liste de présence",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'NotoSans',
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: const BoxDecoration(
                      color: Colors.orangeAccent,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          formatStudentText(scannedIDs.length),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontFamily: 'NotoSans',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.location,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
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
                            color: Colors.white,
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(10),
                            ),
                            border: Border.all(
                              color: Colors.orangeAccent,
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
                                    child: const Text('Identifiant', textAlign: TextAlign.center),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: 2 * width,
                                    child: const Text('Nom/Prénom', textAlign: TextAlign.center),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: width,
                                    child: const Text('Durée', textAlign: TextAlign.center),
                                  ),
                                ),
                              ],
                              rows: presences.map((presence) {
                                return DataRow(
                                  cells: [
                                    DataCell(
                                      SizedBox(
                                        width: width,
                                        child: Text(presence.identifier, textAlign: TextAlign.center),
                                      ),
                                    ),
                                    DataCell(
                                      SizedBox(
                                        width: 2 * width,
                                        child: Text(presence.nom + '\n' + presence.prenom, textAlign: TextAlign.center),
                                      ),
                                    ),
                                    DataCell(
                                      SizedBox(
                                        width: width,
                                        child: Text(presence.nbHeures.toStringAsFixed(1), textAlign: TextAlign.center),
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
