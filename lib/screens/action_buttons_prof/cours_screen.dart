// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CourseDialog extends StatefulWidget {
  final Function(String, DateTime) addCourse;

  const CourseDialog({super.key, required this.addCourse});

  @override
  _CourseDialogState createState() => _CourseDialogState();
}

class _CourseDialogState extends State<CourseDialog> {
  final _formKey = GlobalKey<FormState>();
  String _selectedLocation = "Paris";
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('dd/MM/yyyy').format(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Ajout d\'un cours',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20.0),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Lieu',
                ),
                items: ['Paris', 'Villeneuve Saint-Georges'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedLocation = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Veuillez sélectionner un lieu';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'Date',
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
                      _dateController.text = DateFormat('dd/MM/yyyy').format(date);
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
              ElevatedButton(
                child: const Text('Ajouter'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.addCourse(_selectedLocation, _selectedDate);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CoursScreen extends StatefulWidget {
  const CoursScreen({super.key});

  @override
  _CoursScreenState createState() => _CoursScreenState();
}

class _CoursScreenState extends State<CoursScreen> {
  final Map<String, List<String>> _coursList = {
    'Paris': [],
    'Villeneuve Saint-Georges': [],
  };

  void _addCourse(String location, DateTime date) {
    setState(() {
      _coursList[location]!.add('Cours n°${_coursList[location]!.length + 1} du ${DateFormat('dd/MM/yyyy').format(date)}');
    });
  }

  String _selectedLocation = 'Paris';

  void _selectLocation(String newLocation) {
    setState(() {
      _selectedLocation = newLocation;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 10.0),
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
          SizedBox(
            height: 40,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectLocation('Paris'),
                    child: Container(
                      alignment: Alignment.center,
                      color: _selectedLocation == 'Paris' ? Colors.blueAccent : Colors.orangeAccent,
                      child: const Text('Paris',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'NotoSans',
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectLocation('Villeneuve Saint-Georges'),
                    child: Container(
                      alignment: Alignment.center,
                      color: _selectedLocation == 'Villeneuve Saint-Georges' ? Colors.blueAccent : Colors.orangeAccent,
                      child: const Text('Villeneuve Saint-Georges',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'NotoSans',
                        ),),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _coursList[_selectedLocation]!.length,
              itemBuilder: (context, index) {
                var reversedList = _coursList[_selectedLocation]!.reversed.toList();
                return Card(
                  color: Colors.orangeAccent,
                  child: ListTile(
                    leading: Container(
                      width: 70, // adjust width of the image
                      height: 50, // adjust height of the image
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10), // circular border
                        image: const DecorationImage(
                          image: AssetImage('assets/images/logo.png'),
                          fit: BoxFit.cover, // to cover the entire container with the image
                        ),
                      ),
                    ),
                    title: Text(reversedList[index],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NotoSans',
                      ),),
                    trailing: const Icon(Icons.more_horiz, color: Colors.white),
                    onTap: () {
                          // à faire
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

}

