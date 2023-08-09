import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utilities/constantes.dart';
import '../../../../utils.dart';
import '../../../../logs/auth_stat.dart';


class CommentaireBlock extends StatefulWidget {
  final Commentaire commentaire;
  const CommentaireBlock({required this.commentaire ,Key? key}) : super(key: key);

  @override
  CommentaireBlockState createState() => CommentaireBlockState();
}

class CommentaireBlockState extends State<CommentaireBlock> {
  final TextEditingController _controller = TextEditingController();
  final ValueNotifier<bool> isCommentValidNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();

    _controller.text = widget.commentaire.comment;  // Seule ligne à modifier par rapport à l'ajout

    _controller.addListener(() {
      widget.commentaire.comment = _controller.text;
      isCommentValidNotifier.value = _controller.text.trim().isNotEmpty;
    });
  }


  @override
  void dispose() {
    _controller.dispose();
    isCommentValidNotifier.dispose();
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
                'Commentaire',
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
                const SizedBox(height: 5),

                Padding(
                  padding: const EdgeInsets.all(10.0), // Ajout de marge extérieure
                  child: TextField(
                    controller: _controller,
                    maxLines: null, // permet plusieurs lignes
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      hintText: 'Écrivez votre commentaire ici...',
                      labelText: 'Commentaire',
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                      border: OutlineInputBorder(),

                    ),
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
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
  final Commentaire commentaire;
  final VoidCallback onSubmit;
  final ValueNotifier<bool> isCommentValidNotifier;

  const SoumettreButton({
    required this.eleve,
    required this.commentaire,
    required this.onSubmit,
    required this.isCommentValidNotifier,
    Key? key,
  }) : super(key: key);

  @override
  SoumettreButtonState createState() => SoumettreButtonState();
}

class SoumettreButtonState extends State<SoumettreButton> {
  @override
  void initState() {
    super.initState();
    widget.isCommentValidNotifier.addListener(_rebuild);
  }

  @override
  void dispose() {
    widget.isCommentValidNotifier.removeListener(_rebuild);
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
          onPressed: widget.isCommentValidNotifier.value
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


class UpdateCommentaire extends StatefulWidget {
  final Eleve eleve;
  final Commentaire commentaire;
  final Function? onCommentUpdate;

  const UpdateCommentaire({required this.eleve, required this.commentaire, this.onCommentUpdate, Key? key}) : super(key: key);

  @override
  UpdateCommentaireState createState() => UpdateCommentaireState();
}

class UpdateCommentaireState extends State<UpdateCommentaire> {

  final GlobalKey<CommentaireBlockState> commentaireBlockKey = GlobalKey<CommentaireBlockState>();

  void handleSubmitCommentaire(String token, String login, String user, String prenom) async {
    try {
      widget.commentaire.comment = widget.commentaire.comment.replaceAll('\n', '\r\n');
      if (widget.commentaire.comment.contains("Modifié par")) {
        // Si "Modifié par" existe, on remplace la partie après cela
        widget.commentaire.comment = widget.commentaire.comment.replaceAllMapped(
            RegExp(r'Modifié par:.*'),
                (match) => 'Modifié par: $user ($prenom)'
        );
      } else {
        // Sinon, on ajoute simplement à la fin
        widget.commentaire.comment = '${widget.commentaire.comment}\r\n\r\nModifié par: $user ($prenom)';
      }

      await manageComment(token, login, widget.eleve, "update", widget.commentaire);
      print('Commentaire ajouté avec succès.');

      // Appel au callback pour rafraîchir la liste des commentaires
      if (widget.onCommentUpdate != null) {
        widget.onCommentUpdate!();
      }
    } catch (e) {
      print('Erreur lors de l\'ajout du commentaire: $e');
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: orangePerso,
        title: Text(
          'Modification du comment.',
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

                CommentaireBlock(
                  key: commentaireBlockKey, // Passer la clé ici
                  commentaire: widget.commentaire,
                ),

                const SizedBox(height: 20),

                // Encapsuler SoumettreButton dans un Builder vous permet d'accéder à la clé après que le widget CommentaireBlock a été construit, éliminant ainsi le problème de nullité.
                Builder(
                  builder: (BuildContext context) {
                    return SoumettreButton(
                      eleve: widget.eleve,
                      commentaire: widget.commentaire,
                      isCommentValidNotifier: commentaireBlockKey.currentState!.isCommentValidNotifier, // Ici, ça devrait être OK
                      onSubmit: () => handleSubmitCommentaire(token, login, user, prenom),
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
