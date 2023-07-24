// ignore_for_file: library_private_types_in_public_api

import 'package:EasyStudies/logs/auth_stat.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:EasyStudies/screens/action_buttons_prof/details_cours_screen.dart';
import 'package:EasyStudies/utils.dart';

class CourseDialog extends StatefulWidget {
  final Function(String, DateTime) addCourse;

  const CourseDialog({Key? key, required this.addCourse}) : super(key: key);

  @override
  _CourseDialogState createState() => _CourseDialogState();
}

class _CourseDialogState extends State<CourseDialog> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String? _selectedLocation;
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _dateController = TextEditingController();

  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('dd-MM-yyyy').format(_selectedDate);
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
    return SlideTransition(
      position: _offsetAnimation,
      child : Dialog(
        insetPadding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: const BorderSide(color: Colors.white, width: 8),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.orangeAccent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Ajout d\'un cours',
                  style: TextStyle(
                    fontFamily: 'NotoSans',
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                FutureBuilder<List<String>>(
                  builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return const Text("Erreur");
                      } else {
                        return DropdownButtonFormField<String>(
                          value: _selectedLocation,
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            labelText: 'Lieu',
                            labelStyle: TextStyle(
                              color: Colors.orangeAccent,
                              fontFamily: 'NotoSans',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            prefixIcon: Icon(Icons.location_on, color: Colors.orangeAccent),
                          ),
                          items: snapshot.data!.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: const TextStyle(fontWeight: FontWeight.normal)),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedLocation = newValue;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez sélectionner un lieu';
                            }
                            return null;
                          },
                        );
                      }
                    } else {
                      return const CircularProgressIndicator(color: Colors.white);
                    }
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    labelText: 'Date',
                    labelStyle: TextStyle(
                      color: Colors.orangeAccent,
                      fontFamily: 'NotoSans',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    prefixIcon: Icon(Icons.calendar_today, color: Colors.orangeAccent),
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
                        _selectedDate = date;
                        _dateController.text = DateFormat('dd-MM-yyyy').format(date);
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
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('Annuler',
                        style: TextStyle(
                          fontFamily: 'NotoSans',
                          color: Colors.orangeAccent,
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
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('Ajouter',
                        style: TextStyle(
                          fontFamily: 'NotoSans',
                          color: Colors.orangeAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          widget.addCourse(_selectedLocation!, _selectedDate);
                          Navigator.of(context).pop();
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


  void _addCourse(String location, DateTime date) {
    setState(() {
      _coursList.putIfAbsent(location, () => []);
      _coursList[location]!.add(
        Course(
          index: "Un index unique ici", // à définir
          date: DateFormat('dd-MM-yyyy').format(date),
          type: "Un type ici", // à définir
          centre: location,
          comment: "Un commentaire ici", // à définir
        ),
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _dataLoadFuture,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Erreur : ${snapshot.error}'),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add, color: Colors.white),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                    ),
                    label: const Text('Ajouter un cours',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NotoSans',
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => CourseDialog(addCourse: _addCourse),
                      );
                    },
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: const BoxDecoration(
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(10),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        dropdownColor: Colors.orangeAccent,
                        value: _selectedLocation,
                        icon: const Icon(Icons.arrow_downward, color: Colors.white),
                        style: const TextStyle(
                          color: Colors.white,
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
                              style: const TextStyle(
                                color: Colors.white,
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
                        color: Colors.white,
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(10),
                        ),
                        border: Border.all(
                          color: Colors.orangeAccent,
                          width: 2,
                        ),
                      ),
                      child: ListView.builder(
                        itemCount: _coursList[_selectedLocation]?.length ?? 0,
                        itemBuilder: (context, index) {
                          Course currentCourse = _coursList[_selectedLocation]![index];
                          return Card(
                            color: Colors.orangeAccent,
                            child: ListTile(
                              leading: const Icon(Icons.book, color: Colors.white),
                              title: Text(
                                'Cours du ${currentCourse.date} ${currentCourse.type}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'NotoSans',
                                ),
                              ),
                              trailing: const Icon(Icons.more_horiz, color: Colors.white),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => CoursDetailsScreen(
                                      title: 'Cours du ${currentCourse.date}',
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
            );
          }
        },
      ),
    );
  }


}