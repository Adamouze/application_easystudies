import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;

import '../utilities/constantes.dart';

import '../utils.dart';
import '../logs/auth_stat.dart';



class EleveInfoBlock extends StatelessWidget {
  final Eleve eleve;

  const EleveInfoBlock({required this.eleve, Key? key}) : super(key: key);

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
                topLeft: Radius.circular(arrondiBox),
                topRight: Radius.circular(arrondiBox),
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
                '${'Éleve -'} ${eleve.identifier}',
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
                bottomLeft: Radius.circular(arrondiBox),
                bottomRight: Radius.circular(arrondiBox),
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
              padding: const EdgeInsets.all(8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Civilité : "),
                        Text("Nom : "),
                        Text("Prénom : "),
                        Text("Date de n. : "),
                        Text("Classe : "),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(eleve.civilite),
                        Tooltip(
                          message: eleve.nom,
                          child: Text(
                            eleve.nom,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Tooltip(
                          message: eleve.prenom,
                          child: Text(
                            eleve.prenom,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          eleve.dob.isNotEmpty ? eleve.dob : "non renseigné",
                          style: eleve.dob.isEmpty
                              ? TextStyle(fontWeight: FontWeight.normal, fontStyle: FontStyle.italic, color: Colors.grey[700])
                              : null,
                        ),
                        Text(
                          eleve.classe.isNotEmpty ? eleve.classe : "non renseigné",
                          style: eleve.classe.isEmpty
                              ? TextStyle(fontWeight: FontWeight.normal, fontStyle: FontStyle.italic, color: Colors.grey[700])
                              : null,
                        )

                      ],
                    ),
                  ),

                  // const Spacer(flex: 1),

                  Expanded(
                    flex: 2,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(arrondiBox),  // Ajustez ce chiffre pour contrôler le rayon d'arrondi
                      child: Image.network(
                        eleve.photo,
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            // Le chargement est terminé et aucune erreur ne s'est produite
                            return child;
                          } else if (loadingProgress.expectedTotalBytes != null &&
                              loadingProgress.cumulativeBytesLoaded < loadingProgress.expectedTotalBytes!) {
                            // L'image est en cours de chargement
                            return const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(orangePerso),
                              ),
                            );
                          } else {
                            // Une erreur s'est produite (par exemple, une erreur 404)
                            return Image.asset(getDefaultPhoto(eleve.civilite), fit: BoxFit.cover);
                          }
                        },
                        errorBuilder: (context, error, stackTrace) {
                          // En cas d'erreur, afficher l'image par défaut
                          return Image.asset(getDefaultPhoto(eleve.civilite), fit: BoxFit.cover);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EleveContactBlock extends StatelessWidget {
  final Eleve eleve;

  const EleveContactBlock({required this.eleve, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = Provider.of<AuthState>(context, listen: false);

    if (authState.userType == "eleve") {
      return _buildEleveLayout(theme, context);
    } else if (authState.userType == "prof") {
      return _buildProfLayout(theme, context);
    } else {
      return Container(); // Retourner un widget vide ou une vue d'erreur si le type d'utilisateur n'est pas reconnu.
    }
  }

  Widget _buildEleveLayout(ThemeData theme, BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.95,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ExpandableNotifier(
            child: ScrollOnExpand(
              scrollOnExpand: false,
              scrollOnCollapse: true,
              child: Column(
                children: <Widget>[
                  ExpandablePanel(
                    theme: const ExpandableThemeData(
                      headerAlignment: ExpandablePanelHeaderAlignment.center,
                      tapBodyToCollapse: true,
                      hasIcon: false, // This disables the default icon
                    ),
                    header: Container(
                      decoration: BoxDecoration(
                        color: orangePerso,
                        borderRadius: BorderRadius.circular(arrondiBox),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '${'Contacts -'} ${eleve.prenom}',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'NotoSans',
                            ),
                          ),
                          ExpandableIcon(  // use this instead of Icon
                            theme: ExpandableThemeData(
                              expandIcon: Icons.keyboard_arrow_down,
                              collapseIcon: Icons.keyboard_arrow_up,
                              iconColor: theme.iconTheme.color,
                              iconSize: 28.0,
                              iconRotationAngle: - math.pi,
                              iconPadding: const EdgeInsets.only(right: 5),
                              hasIcon: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                    collapsed: Container(),
                    expanded: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(arrondiBox),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              // Ici les informations
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    flex: 2,
                                    child: ListView(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      children: const <Widget>[
                                        Text("Numéro de fixe : "),
                                        Text("Mobile de l'élève: "),
                                        Text("Mobile d'un parent : "),
                                        Text("Email de l'élève : "),
                                        Text("Email d'un parent : "),
                                        Text("Adresse : "),
                                        Text(""),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: ListView(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      children: <Widget>[
                                        eleve.numFix == ""
                                            ? Text("non renseigné", style: TextStyle(color: theme.textTheme.bodySmall?.color, fontStyle: FontStyle.italic))
                                            : Text(eleve.numFix),
                                        Text(eleve.numMobileEleve),
                                        Text(eleve.numMobileParents),
                                        Tooltip(
                                          message: eleve.emailEleve,
                                          child: Text(
                                            eleve.emailEleve,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Tooltip(
                                          message: eleve.emailParents,
                                          child: Text(
                                            eleve.emailParents,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Text(
                                          eleve.adresse.isNotEmpty ? eleve.adresse : "non renseigné",
                                          style: eleve.adresse.isEmpty
                                              ? TextStyle(fontWeight: FontWeight.normal, fontStyle: FontStyle.italic, color: Colors.grey[700])
                                              : null,
                                        ),
                                        Text(
                                          eleve.ville.isNotEmpty ? eleve.ville : "non renseigné",
                                          style: eleve.classe.isEmpty
                                              ? TextStyle(fontWeight: FontWeight.normal, fontStyle: FontStyle.italic, color: Colors.grey[700])
                                              : null,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              // Ici les boutons
                              Padding(
                                padding: const EdgeInsets.only(top: 16), // Espace entre les informations et les boutons
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        IconButton(
                                          icon: const Icon(Icons.phone),
                                          color: eleve.numFix == "" ? Colors.grey : Colors.black,
                                          onPressed: eleve.numFix == "" ? null : () => launchUrl(Uri.parse("tel://${eleve.numFix}")),
                                        ),
                                        const Text('Fixe'),
                                      ],
                                    ),
                                    if (eleve.numMobileEleve != eleve.numMobileParents)
                                      Column(
                                        children: <Widget>[
                                          IconButton(
                                            icon: const Icon(Icons.phone),
                                            color: Colors.green,
                                            onPressed: eleve.numMobileEleve == "" ? null : () => launchUrl(Uri.parse("tel://${eleve.numMobileEleve}")),
                                          ),
                                          const Text('Élève'),
                                        ],
                                      ),
                                    Column(
                                      children: <Widget>[
                                        IconButton(
                                          icon: const Icon(Icons.phone),
                                          color: Colors.red,
                                          onPressed: eleve.numMobileParents == "" ? null : () => launchUrl(Uri.parse("tel://${eleve.numMobileParents}")),
                                        ),
                                        const Text('Parents'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfLayout(ThemeData theme, BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.95,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ExpandableNotifier(
            child: ScrollOnExpand(
              scrollOnExpand: false,
              scrollOnCollapse: true,
              child: Column(
                children: <Widget>[
                  ExpandablePanel(
                    theme: const ExpandableThemeData(
                      headerAlignment: ExpandablePanelHeaderAlignment.center,
                      tapBodyToCollapse: true,
                      hasIcon: false, // This disables the default icon
                    ),
                    header: Container(
                      decoration: BoxDecoration(
                        color: orangePerso,
                        borderRadius: BorderRadius.circular(arrondiBox),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '${'Contacts -'} ${eleve.prenom}',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'NotoSans',
                            ),
                          ),
                          ExpandableIcon(  // use this instead of Icon
                            theme: ExpandableThemeData(
                              expandIcon: Icons.keyboard_arrow_down,
                              collapseIcon: Icons.keyboard_arrow_up,
                              iconColor: theme.iconTheme.color,
                              iconSize: 28.0,
                              iconRotationAngle: - math.pi,
                              iconPadding: const EdgeInsets.only(right: 5),
                              hasIcon: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                    collapsed: Container(),
                    expanded: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(arrondiBox),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              // Ici les informations
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    flex: 2,
                                    child: ListView(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      children: const <Widget>[
                                        Text("Mobile : "),
                                        Text("Email : "),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: ListView(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      children: <Widget>[
                                        Text(eleve.numMobileEleve),
                                        Tooltip(
                                          message: eleve.emailEleve,
                                          child: Text(
                                            eleve.emailEleve,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}




class EleveComptabiliteBlock extends StatelessWidget {
  final Eleve eleve;

  const EleveComptabiliteBlock({required this.eleve, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FractionallySizedBox(
      widthFactor: 0.95,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ExpandableNotifier(
            child: ScrollOnExpand(
              scrollOnExpand: false,
              scrollOnCollapse: true,
              child: Column(
                children: <Widget>[
                  ExpandablePanel(
                    theme: const ExpandableThemeData(
                      headerAlignment: ExpandablePanelHeaderAlignment.center,
                      tapBodyToCollapse: true,
                      hasIcon: false, // This disables the default icon
                    ),
                    header: Container(
                      decoration: BoxDecoration(
                        color: orangePerso,
                        borderRadius: BorderRadius.circular(arrondiBox),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '${'Comptabilité -'} ${eleve.prenom}',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'NotoSans',
                            ),
                          ),
                          ExpandableIcon(  // use this instead of Icon
                            theme: ExpandableThemeData(
                              expandIcon: Icons.keyboard_arrow_down,
                              collapseIcon: Icons.keyboard_arrow_up,
                              iconColor: theme.iconTheme.color,
                              iconSize: 28.0,
                              iconRotationAngle: - math.pi,
                              iconPadding: const EdgeInsets.only(right: 5),
                              hasIcon: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                    collapsed: Container(),
                    expanded: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(arrondiBox),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Solde : ${eleve.solde} €"),
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Prévisionnel : ${eleve.prev} €"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfilScreen extends StatefulWidget {
  final Eleve eleve;

  const ProfilScreen({required this.eleve, Key? key}) : super(key: key);

  @override
  ProfilScreenState createState() => ProfilScreenState();
}

class ProfilScreenState extends State<ProfilScreen> {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = Provider.of<AuthState>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: orangePerso,
        title:Text(
          'Profil - ${widget.eleve.prenom}',
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
                EleveInfoBlock(eleve: widget.eleve),
                const SizedBox(height: 20),
                EleveContactBlock(eleve: widget.eleve),
                const SizedBox(height: 20),
                if (authState.userType == "eleve")
                  EleveComptabiliteBlock(eleve: widget.eleve),
                const SizedBox(height: 120),
              ],
            ),
          )
      ),
    );
  }
}