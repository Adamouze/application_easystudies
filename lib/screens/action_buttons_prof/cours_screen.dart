// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CourseDialog extends StatefulWidget {
  final Function(String, DateTime) addCourse;

  const CourseDialog({super.key, required this.addCourse});

  @override
  _CourseDialogState createState() => _CourseDialogState();
}

class _CourseDialogState extends State<CourseDialog> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String _selectedLocation = "Paris";
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _dateController = TextEditingController();

  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;


  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('dd/MM/yyyy').format(_selectedDate);
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
      child: Dialog(
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
                DropdownButtonFormField<String>(
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
                  items: ['Paris', 'Villeneuve Saint-Georges'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: const TextStyle(fontWeight: FontWeight.normal),),
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
                          widget.addCourse(_selectedLocation, _selectedDate);
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
                    leading: const Icon(Icons.book, color: Colors.white),
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

