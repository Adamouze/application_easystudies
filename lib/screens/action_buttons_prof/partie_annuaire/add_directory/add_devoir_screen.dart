import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../../utilities/constantes.dart';
import '../../../../utils.dart';
import '../../../../logs/auth_stat.dart';


class DevoirBlock extends StatefulWidget {
  final Devoir devoir;
  const DevoirBlock({required this.devoir ,Key? key}) : super(key: key);

  @override
  DevoirBlockState createState() => DevoirBlockState();
}

class DevoirBlockState extends State<DevoirBlock> {

  final TextEditingController _controller = TextEditingController();
  final ValueNotifier<bool> isDevoirValidNotifier = ValueNotifier<bool>(false);


  DateTime _dateStart = DateTime.now();
  DateTime _dateEnd = DateTime.now();

  final borderStyle = const OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey),
  );

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      widget.devoir.content = _controller.text;
      isDevoirValidNotifier.value = _controller.text.trim().isNotEmpty;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    isDevoirValidNotifier.dispose();
    super.dispose();
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
                'Devoir',
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
                // Pour le bloc "date de début"
                const Text(
                  "Choisir la date de début du devoir",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,  // Ajustez la taille à vos besoins
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    final DateTime? pickedStart = await showDatePicker(
                      context: context,
                      initialDate: _dateStart,
                      firstDate: DateTime(2015),
                      lastDate: DateTime(2100),
                    );
                    if (pickedStart != null) {
                      setState(() {
                        _dateStart = pickedStart;
                        widget.devoir.dateStart = DateFormat('yyyy-MM-dd').format(_dateStart);
                      });
                    }
                  },
                  child: TextField(
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: DateFormat('dd/MM/yyyy').format(_dateStart),
                      labelStyle: const TextStyle(color: Colors.black),
                      suffixIcon: const Icon(
                        Icons.calendar_month,
                        color: Colors.black,
                      ),
                      border: borderStyle,
                    ),
                  ),
                ),

                // Espace entre les deux blocs
                const SizedBox(height: 10),

                // Pour le bloc "date de fin"
                const Text(
                  "Choisir la date de fin du devoir",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    final DateTime? pickedEnd = await showDatePicker(
                      context: context,
                      initialDate: _dateEnd,
                      firstDate: DateTime(2015),
                      lastDate: DateTime(2100),
                    );
                    if (pickedEnd != null) {
                      setState(() {
                        _dateEnd = pickedEnd;
                        widget.devoir.dateEnd = DateFormat('yyyy-MM-dd').format(_dateEnd);
                      });
                    }
                  },
                  child: TextField(
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: DateFormat('dd/MM/yyyy').format(_dateEnd),
                      labelStyle: const TextStyle(color: Colors.black),
                      suffixIcon: const Icon(
                        Icons.calendar_month,
                        color: Colors.black,
                      ),
                      border: borderStyle,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(10.0), // Ajout de marge extérieure
                  child: TextField(
                      controller: _controller,
                      maxLines: null, // permet plusieurs lignes
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        hintText: 'Écrivez les devoirs ici...',
                        labelText: 'Devoirs',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                        border: borderStyle,

                      ),
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                      onChanged: (value) {
                        setState(() {});
                      }
                  ),
                ),
                if (_controller.text.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(left: 0.0),
                    child: Text(
                      'Veuillez remplir ce champ',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),

                const SizedBox(height: 10),
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
  final Devoir devoir;
  final VoidCallback onSubmit;
  final ValueNotifier<bool> isDevoirValidNotifier;

  const SoumettreButton({
    required this.eleve,
    required this.devoir,
    required this.onSubmit,
    required this.isDevoirValidNotifier,
    Key? key,
  }) : super(key: key);

  @override
  SoumettreButtonState createState() => SoumettreButtonState();
}

class SoumettreButtonState extends State<SoumettreButton> {
  @override
  void initState() {
    super.initState();
    widget.isDevoirValidNotifier.addListener(_rebuild);
  }

  @override
  void dispose() {
    widget.isDevoirValidNotifier.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
          onPressed: widget.isDevoirValidNotifier.value
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
  }
}




class AddDevoir extends StatefulWidget {
  final Eleve eleve;
  final Function? onDevoirAdded;

  const AddDevoir({required this.eleve, this.onDevoirAdded, Key? key}) : super(key: key);

  @override
  AddDevoirState createState() => AddDevoirState();
}

class AddDevoirState extends State<AddDevoir> {

  final GlobalKey<DevoirBlockState> devoirBlockKey = GlobalKey<DevoirBlockState>();

  final Devoir devoir = Devoir("", "", "", "", "", "", "");

  void handleSubmitDevoir(String token, String login) async {
    await manageDevoir(token, login, widget.eleve, "add", devoir);

    // Appel au callback pour rafraîchir la liste des commentaires
    if (widget.onDevoirAdded != null) {
      widget.onDevoirAdded!();
    }
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

    devoir.from = '$user ($prenom)';
    devoir.stateProf = "1";
    devoir.stateStudent = "1";

    devoir.dateStart == "" ? devoir.dateStart = DateFormat('yyyy-MM-dd').format(DateTime.now()) : ();
    devoir.dateEnd == "" ? devoir.dateEnd = DateFormat('yyyy-MM-dd').format(DateTime.now()) : ();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: orangePerso,
        title: Text(
          'Nouvelle note - ${widget.eleve.prenom}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.primaryColor,
          ),
        ),
        iconTheme: IconThemeData(
          color: theme.primaryColor, // Définissez ici la couleur souhaitée pour l'icône
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),

              DevoirBlock(
                key: devoirBlockKey, // Passer la clé ici
                devoir: devoir,
              ),

              const SizedBox(height: 20),

              Builder(
                builder: (BuildContext context) {
                  return SoumettreButton(
                    eleve: widget.eleve,
                    devoir: devoir,
                    isDevoirValidNotifier: devoirBlockKey.currentState!.isDevoirValidNotifier,
                    onSubmit: () => handleSubmitDevoir(token, login),
                  );
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        )
      ),
    );
  }
}
