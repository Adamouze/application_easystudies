import 'package:flutter/material.dart';
import '../utilities/constantes.dart';
import 'app_bar.dart';
import 'bodies/body_eleve.dart';

class EleveScreen extends StatelessWidget {
  const EleveScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Eleve', color: orangePerso, context: context),
      body: CustomBodyEleve(),
    );
  }
}
