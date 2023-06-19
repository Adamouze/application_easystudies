import 'package:flutter/material.dart';
import '../utilities/constantes.dart';
import 'app_bar.dart';
import 'bodies/body_prof.dart';

class ProfScreen extends StatelessWidget {
  const ProfScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Prof', color: orangePerso, context: context),
      body: CustomBodyProf(),
    );
  }
}
