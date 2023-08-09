// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:EasyStudies/logs/auth_stat.dart';
import 'package:EasyStudies/utilities/constantes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:EasyStudies/screens/action_buttons_prof/partie_cours/details_cours_screen.dart';
import 'package:EasyStudies/utils.dart';

class CourseDialog extends StatefulWidget {

  const CourseDialog({Key? key}) : super(key: key);

  @override
  _CourseDialogState createState() => _CourseDialogState();
}

class _CourseDialogState extends State<CourseDialog> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  Centre? _selectedCentre;
  String? _selectedType;
  DateTime _selectedDate;
  _CourseDialogState() : _selectedDate = DateTime.now() {
    _selectedDate = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
  }

  Future<List<Centre>>? _centresFuture;


  final TextEditingController _dateController = TextEditingController();

  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    final authState = context.read<AuthState>(); // Récupérer l'instance de AuthState ici pour éviter des problèmes de contexte dans initState
    final token = authState.token; // Récupérer le token de AuthState
    final identifier = authState.identifier; // Récupérer l'identifiant de AuthState
    _centresFuture = fetchCenterList(token!, identifier!);
    _dateController.text = afficherDate(DateFormat('yyyy-MM-dd').format(_selectedDate));
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )
      ..forward();

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = context.read<AuthState>(); // Récupérer l'instance de AuthState ici pour éviter des problèmes de contexte dans initState
    final token = authState.token; // Récupérer le token de AuthState
    final identifier = authState.identifier; // Récupérer l'identifiant de AuthState
    return FutureBuilder<List<Centre>>(
        future: _centresFuture,
        builder: (BuildContext context, AsyncSnapshot<List<Centre>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const
            Center(
               child : SizedBox(
              width: 30.0,
              height: 30.0,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
              ),
                ),
            );

          } else if (snapshot.hasError) {
            return Text('Erreur: ${snapshot.error}'); // Gérer les erreurs comme vous le souhaitez
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('Aucun centre trouvé.');
          } else {
            List<Centre> centres = snapshot.data!;
            return SlideTransition(
              position: _offsetAnimation,
              child: Dialog(
                insetPadding: const EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: const BorderSide(color: orangePerso, width: 4),
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Ajout d\'un cours',
                          style: TextStyle(
                            fontFamily: 'NotoSans',
                            color: theme.textTheme.bodyLarge?.color,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 15),

                        DropdownButtonFormField<Centre>(
                          value: _selectedCentre,
                          decoration: InputDecoration(
                            fillColor: theme.primaryColor,
                            filled: true,
                            labelText: 'Lieu',
                            labelStyle: TextStyle(
                              color: theme.textTheme.bodyLarge?.color,
                              fontFamily: 'NotoSans',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            prefixIcon: Icon(
                                Icons.location_on, color: theme.primaryIconTheme.color),
                          ),
                            items: centres.map((Centre centre) {
                              return DropdownMenuItem<Centre>(
                                value: centre,
                                child: Text(centre.nomCentre, style: const TextStyle(fontWeight: FontWeight.normal)),
                              );
                            }).toList(),
                            onChanged: (Centre? newValue) {
                              setState(() {
                                _selectedCentre = newValue;
                              });
                            },
                          validator: (value) {
                            if (value == null) {
                              return 'Veuillez sélectionner un lieu';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 15),

                        DropdownButtonFormField<String>(
                          value: _selectedType,
                          decoration:  InputDecoration(
                            fillColor: theme.primaryColor,
                            filled: true,
                            labelText: 'Type',
                            labelStyle: TextStyle(
                              color: theme.textTheme.bodyLarge?.color,
                              fontFamily: 'NotoSans',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            prefixIcon: Icon(
                                Icons.category, color: theme.primaryIconTheme.color),
                          ),
                          items: ["REG", "PART","GROUPE", "STAGE", "ONLINE"].map((
                              String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: const TextStyle(
                                  fontWeight: FontWeight.normal)),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedType = newValue;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez sélectionner un type';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 15),

                        TextFormField(
                          controller: _dateController,
                          decoration: InputDecoration(
                            fillColor: theme.primaryColor,
                            filled: true,
                            labelText: 'Date',
                            labelStyle: TextStyle(
                              color: theme.textTheme.bodyLarge?.color,
                              fontFamily: 'NotoSans',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            prefixIcon: Icon(Icons.calendar_today,
                                color: theme.primaryIconTheme.color),
                          ),
                          readOnly: true,
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (date != null) {
                              setState(() {
                                _selectedDate = DateTime(date.year, date.month, date.day); // Cette ligne assure que vous obtenez une date sans heure/minute/seconde
                                _dateController.text =
                                    afficherDate(DateFormat('yyyy-MM-dd').format(date));
                              });
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer une date';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 20.0),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: theme.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text('Annuler',
                                style: TextStyle(
                                  fontFamily: 'NotoSans',
                                  color: orangePerso,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            const SizedBox(width: 10),
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: theme.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text('Ajouter',
                                style: TextStyle(
                                  fontFamily: 'NotoSans',
                                  color: orangePerso,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  bool result = await add_Course(token!, identifier!, _selectedCentre!.centre, DateFormat('yyyy-MM-dd').format(_selectedDate), _selectedType!);
                                  Navigator.of(context).pop({
                                    'type': _selectedType,
                                    'date': afficherDate(DateFormat('yyyy-MM-dd').format(_selectedDate)),
                                    'isCourseAdded': result
                                  });
                                }
                              },

                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        }
    );
  }
}

class CoursScreen extends StatefulWidget {
  const CoursScreen({Key? key}) : super(key: key);

  @override
  _CoursScreenState createState() => _CoursScreenState();
}

class _CoursScreenState extends State<CoursScreen> {
  final Map<String, List<Course>> _coursList = {};

  Future<void>? _dataLoadFuture;
  String _selectedLocation = ""; // This will be updated once we fetch the center list

  @override
  void initState() {
    super.initState();

    final authState = context.read<AuthState>(); // Get the instance of AuthState
    final token = authState.token; // Get token from AuthState
    final identifier = authState.identifier; // Get identifier from AuthState

    _dataLoadFuture = _loadData(token!, identifier!);
  }

  Future<void> _loadData(String token, String identifier) async {
    List<Centre> centerList = await fetchCenterList(token, identifier);
    setState(() {
      for (Centre center in centerList) {
        _coursList[center.nomCentre] = []; // Assuming 'Centre' has a 'name' property
      }
      if (centerList.isNotEmpty) {
        _selectedLocation = centerList[0].nomCentre; // Assuming 'Centre' has a 'name' property
      }
    });
    await _fetchCourses(centerList);
  }

  Future<void> _fetchCourses(List<Centre> centres) async {
    for (var centre in centres) {
      var courses = await fetchCourseList(context.read<AuthState>().token!, context.read<AuthState>().identifier!, centre.centre);
      setState(() {
        _coursList[centre.nomCentre] = courses;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: FutureBuilder(
        future: _dataLoadFuture,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(orangePerso),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Erreur : ${snapshot.error}'),
            );
          } else {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: orangePerso,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(10),
                          ),
                          border: Border.all(
                            color: orangePerso,
                            width: 2,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            dropdownColor: orangePerso,
                            value: _selectedLocation,
                            icon: Icon(Icons.arrow_downward, color: theme.iconTheme.color),
                            style: TextStyle(
                              color: theme.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'NotoSans',
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedLocation = newValue!;
                              });
                            },
                            items: _coursList.keys.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    color: theme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'NotoSans',
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(10),
                            ),
                            border: Border.all(
                              color: orangePerso,
                              width: 2,
                            ),
                          ),
                          child: ListView.builder(
                            itemCount: _coursList[_selectedLocation]?.length ?? 0,
                            itemBuilder: (context, index) {
                              Course currentCourse = _coursList[_selectedLocation]![index];
                              return Card(
                                color: theme.cardColor,
                                child: ListTile(
                                  leading: Icon(Icons.book, color: theme.primaryIconTheme.color),
                                  title: Text(
                                    'Cours du ${afficherDate(currentCourse.date)} - ${currentCourse.type}',
                                    style: TextStyle(
                                      color: theme.textTheme.bodyLarge?.color,
                                      fontFamily: 'NotoSans',
                                    ),
                                  ),
                                  trailing: Icon(Icons.more_horiz, color: theme.primaryIconTheme.color),
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => CoursDetailsScreen(
                                          title: 'Cours du ${afficherDate(currentCourse.date)}',
                                          Cours: currentCourse,
                                          location: _selectedLocation,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: FloatingActionButton(
                      backgroundColor: orangePerso,
                      child: Icon(Icons.add, color: theme.iconTheme.color),
                      onPressed: () async {
                        final result = await showDialog<Map<String, dynamic>>(
                          context: context,
                          builder: (context) => const CourseDialog(),
                        );
                        // Vérifiez si le résultat de la fenêtre de dialogue indique qu'une action a été effectuée (par exemple, si un cours a été ajouté)
                        if (result?['isCourseAdded'] == true) {
                          final authState = context.read<AuthState>(); // Get the instance of AuthState
                          final token = authState.token; // Get token from AuthState
                          final identifier = authState.identifier; // Get identifier from AuthState

                          setState(() {
                            _dataLoadFuture = _loadData(token!, identifier!);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            backgroundColor: Colors.green,
                            content: Text('Cours du ${result?['date']} - ${result?['type']} ajouté avec succès',
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
                      },
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }



}