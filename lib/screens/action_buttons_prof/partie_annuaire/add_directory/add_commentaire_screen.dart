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


class AddCommentaire extends StatefulWidget {
  final Eleve eleve;
  final Function? onCommentAdded;

  const AddCommentaire({required this.eleve, this.onCommentAdded, Key? key}) : super(key: key);

  @override
  AddCommentaireState createState() => AddCommentaireState();
}

class AddCommentaireState extends State<AddCommentaire> {

  final GlobalKey<CommentaireBlockState> commentaireBlockKey = GlobalKey<CommentaireBlockState>();

  final Commentaire commentaire = Commentaire("", "", "", "", "");

  void handleSubmitCommentaire(String token, String login) async {
    commentaire.comment = commentaire.comment.replaceAll('\n', '\r\n');
    await manageComment(token, login, widget.eleve, "add", commentaire);

    // Appel au callback pour rafraîchir la liste des commentaires
    if (widget.onCommentAdded != null) {
      widget.onCommentAdded!();
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

    String? user = authState.userType;
    if (user == "prof") {
      user = "PROF";
    }
    commentaire.from = '$user (${authState.prenom})';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: orangePerso,
        title: Text(
          'Nouveau comment. - ${widget.eleve.prenom}',
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
                  commentaire: commentaire,
                ),

                const SizedBox(height: 20),

                // Encapsuler SoumettreButton dans un Builder vous permet d'accéder à la clé après que le widget CommentaireBlock a été construit, éliminant ainsi le problème de nullité.
                Builder(
                  builder: (BuildContext context) {
                    return SoumettreButton(
                      eleve: widget.eleve,
                      commentaire: commentaire,
                      isCommentValidNotifier: commentaireBlockKey.currentState!.isCommentValidNotifier, // Ici, ça devrait être OK
                      onSubmit: () => handleSubmitCommentaire(token, login),
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
