// ignore_for_file: deprecated_member_use, constant_identifier_names, non_constant_identifier_names, duplicate_ignore, library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

import '../logs/auth_stat.dart';

import '../utilities/constantes.dart';
import '../utilities/video_youtube.dart';
import '../utilities/facebook_news.dart';



class QuitDialog extends StatefulWidget {
  const QuitDialog({Key? key}) : super(key: key);

  @override
  QuitDialogState createState() => QuitDialogState();
}

class QuitDialogState extends State<QuitDialog> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SlideTransition(
      position: _offsetAnimation,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: const BorderSide(color: orangePerso, width: 4),
        ),
        backgroundColor: theme.cardColor,
        title: Text('Confirmation',
          style: TextStyle(
            color: theme.textTheme.bodyLarge?.color,
            fontWeight: FontWeight.bold,
            fontFamily: 'NotoSans',
          ),
        ),
        content: Text('Voulez-vous vraiment quitter l\'application ?',
          style: TextStyle(
            color: theme.textTheme.bodyLarge?.color,
            fontWeight: FontWeight.bold,
            fontFamily: 'NotoSans',
          ),
        ),
        actions: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: theme.primaryColor,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: TextButton(
              onPressed: () => Navigator.pop(context, 'Non'),
              child: const Text('Non',
                style: TextStyle(
                  color: orangePerso,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NotoSans',
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: theme.primaryColor,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: TextButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              child: const Text('Oui',
                style: TextStyle(
                  color: orangePerso,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NotoSans',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WelcomeBanner extends StatefulWidget {
  final String prenom;
  final String nom;

  const WelcomeBanner({required this.prenom, required this.nom, Key? key,}) : super(key: key);

  @override
  _WelcomeBannerState createState() => _WelcomeBannerState();
}

class _WelcomeBannerState extends State<WelcomeBanner> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: tempsAnimationWelcomeBar),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color getAnimatedColor(double offset) { // TODO: Faire en sorte que ça revient en arrière après pour éviter le saut de couleur
    return HSVColor.lerp(
      HSVColor.fromColor(Colors.red),
      HSVColor.fromColor(Colors.purple),
      (_controller.value + offset) % 1,
    )!.toColor();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                getAnimatedColor((1.0/6.0)),
                getAnimatedColor(0),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow,
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Text(
            "Bienvenue ${widget.prenom} ${widget.nom}",
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis, // Ajoutez cette ligne
            maxLines: 1, // Assurez-vous que le texte ne s'enroule pas sur plusieurs lignes
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        );
      },
    );
  }
}


class CustomBody extends StatefulWidget {
  const CustomBody({this.userType = "default", Key? key,}) : super(key: key);

  final String userType;

  @override
  _CustomBodyState createState() => _CustomBodyState();
}

class _CustomBodyState extends State<CustomBody> {

  final facebookService = FacebookService();
  final youtubeService = YoutubeService();

  static const String _url_facebook = 'https://www.facebook.com/easystudies';
  static const String _url_tel = 'tel:0664021773';
  final Uri _url_mail = Uri(scheme: 'mailto', path: 'easystudies@outlook.fr',);

  void _launchURL(String url) async {
    if (!await canLaunch(url)) throw 'Could not launch $_url_facebook';
    await launch(url);
  }

  void _launchmail(Uri url) async {
    final String urlString = url.toString();
    if(await canLaunch(urlString)){
      await launch(urlString);
    } else {
      throw 'Could not launch $urlString';
    }
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => const QuitDialog(),
    )) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final authState = Provider.of<AuthState>(context, listen: false);
    final prenom = authState.prenom ?? '';
    final nom = (authState.nom ?? '').replaceAll('ë', 'Ë');

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 10),
              if (widget.userType == "eleve" || widget.userType == "prof")
                if (prenom.isNotEmpty && nom.isNotEmpty)
                  WelcomeBanner(prenom: prenom, nom: nom),
              if (widget.userType == "eleve" || widget.userType == "prof")
                if (prenom.isNotEmpty && nom.isNotEmpty)
                  const SizedBox(height: 10),

              if (widget.userType != "eleve" && widget.userType != "prof")
                const SizedBox(height: 16),

              FractionallySizedBox(
                widthFactor: 0.95,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      decoration: const BoxDecoration(
                        color: orangePerso,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Dernière News - செய்திகள்',
                          style: TextStyle(
                              color: theme.primaryColor,
                              fontFamily: 'Noto Sans',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2), // Couleur de l'ombre
                            offset: const Offset(0, 3), // Position de l'ombre
                            blurRadius: 6, // Flou de l'ombre
                            spreadRadius: 2, // Taille de l'ombre
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: FutureBuilder<String?>(
                        future: facebookService.fetchLatestNewsData(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final latestNewsData = snapshot.data!;
                            return Text(latestNewsData);
                          } else if (snapshot.hasError) {
                            return Text(
                              'Failed to fetch news data',
                              style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(orangePerso),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              FractionallySizedBox(
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
                          'Vidéos',
                          style: TextStyle(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'NotoSans',
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: FutureBuilder<List<VideoDetail>>(
                        future: youtubeService.fetchAllVideoDetails(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final videoDetails = snapshot.data!;
                            final pageController = PageController(initialPage: 1);

                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  height: 300,
                                  child: PageView.builder(
                                    controller: pageController,
                                    itemCount: videoDetails.length * 10,
                                    itemBuilder: (context, index) {
                                      final videoDetail = videoDetails[index % videoDetails.length];
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => VideoPlayerPage(videoId: videoDetail.videoId, videoDetail: videoDetail),
                                            ),
                                          );
                                        },
                                        child: Card(
                                          color: theme.cardColor,
                                          elevation: 3,
                                          clipBehavior: Clip.antiAlias,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 200,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: NetworkImage(videoDetail.thumbnailUrl),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.all(8),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      videoDetail.title,
                                                      style: TextStyle(
                                                        color:theme.textTheme.bodyLarge?.color,
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: 'NotoSans',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                // Navigation buttons
                                Positioned(
                                  left: 0,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: orangePerso,
                                    ),
                                    child: IconButton(
                                      icon: Icon(Icons.arrow_back,
                                        color: theme.iconTheme.color,
                                      ),
                                      onPressed: () {
                                        int currentPage = pageController.page?.toInt() ?? 0;
                                        if (currentPage == 0) {
                                          // If we're at the first page (duplicate last video), jump without animation to the last "real" page
                                          pageController.jumpToPage(videoDetails.length - 2);
                                        } else {
                                          pageController.previousPage(
                                            duration: const Duration(milliseconds: 400),
                                            curve: Curves.easeInOut,
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: orangePerso,
                                    ),
                                    child: IconButton(
                                      icon: Icon(Icons.arrow_forward,
                                        color: theme.iconTheme.color,
                                      ),
                                      onPressed: () {
                                        int currentPage = pageController.page?.toInt() ?? 0;
                                        if (currentPage == videoDetails.length - 1) {
                                          // If we're at the last page (duplicate first video), jump without animation to the first "real" page
                                          pageController.jumpToPage(1);
                                        } else {
                                          pageController.nextPage(
                                            duration: const Duration(milliseconds: 400),
                                            curve: Curves.easeInOut,
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else if (snapshot.hasError) {
                            return Text('Failed to fetch video details: ${snapshot.error}');
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(orangePerso),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              FractionallySizedBox(
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
                          'Contact',
                          style: TextStyle(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'NotoSans',
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: theme.cardColor,
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
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () async {
                                _launchmail(_url_mail);
                              },
                              child: const Icon(Icons.mail, color: orangePerso),
                            ),
                            GestureDetector(
                              onTap: () async {
                                _launchURL(_url_tel);
                              },
                              child: const Icon(Icons.phone, color: orangePerso),
                            ),
                            GestureDetector(
                              onTap: () async {
                                _launchURL(_url_facebook);
                              },
                              child: const Icon(Icons.facebook, color: orangePerso),
                            ),
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              ),

              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }
}
