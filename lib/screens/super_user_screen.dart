import 'package:flutter/material.dart';
import '../utilities/constantes.dart';
import 'app_bar.dart';
import 'bodies/body_super_user.dart';

class SuperUserScreen extends StatelessWidget {
  const SuperUserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Super utilisateur', color: orangePerso, context: context),
      body: CustomBodySuperUser(),
    );
  }
}
