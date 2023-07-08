// ignore_for_file: deprecated_member_use, constant_identifier_names, non_constant_identifier_names, duplicate_ignore, library_private_types_in_public_api, use_build_context_synchronously

import 'package:EasyStudies/screens/action_buttons_eleve/qrcode_screen.dart';
import 'package:EasyStudies/screens/action_buttons_prof/scanner.dart';
import 'package:EasyStudies/utilities/constantes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import '../utilities/video_youtube.dart';
import '../utilities/facebook_news.dart';
import 'package:url_launcher/url_launcher.dart';


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
    return SlideTransition(
      position: _offsetAnimation,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: const BorderSide(color: Colors.white, width: 8),
        ),
        backgroundColor: Colors.orangeAccent,
        title: const Text('Confirmation',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'NotoSans',
          ),
        ),
        content: const Text('Voulez-vous vraiment quitter l\'application ?',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'NotoSans',
          ),
        ),
        actions: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: TextButton(
              onPressed: () => Navigator.pop(context, 'Non'),
              child: const Text('Non',
                style: TextStyle(
                  color: Colors.orangeAccent,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NotoSans',
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: TextButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              child: const Text('Oui',
                style: TextStyle(
                  color: Colors.orangeAccent,
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

    return WillPopScope(
      onWillPop: _onWillPop,
    child: Align(
    alignment: Alignment.topCenter,
    child: SingleChildScrollView(
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[

    const SizedBox(height: 20),

            FractionallySizedBox(
              widthFactor: 0.95,


              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Dernière News - செய்திகள்',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Noto Sans',
                            fontWeight: FontWeight.bold),
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
                          return const Text('Failed to fetch news data');
                        } else {
                          return const CircularProgressIndicator();
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
                      color: Colors.orangeAccent,
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
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Vidéos',
                        style: TextStyle(
                          color: Colors.white,
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
                                              color: Colors.grey[200],
                                              padding: const EdgeInsets.all(8),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    videoDetail.title,
                                                    style: const TextStyle(
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
                                    color: Colors.orangeAccent,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.arrow_back,
                                      color: Colors.white,
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
                                    color: Colors.orangeAccent,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.arrow_forward,
                                      color: Colors.white,
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
                          return const CircularProgressIndicator();
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
                      color: Colors.orangeAccent,
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
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () async {
                              _launchmail(_url_mail);
                            },
                            child: const Icon(Icons.mail, color: Colors.orangeAccent),
                          ),
                          GestureDetector(
                            onTap: () async {
                              _launchURL(_url_tel);
                            },
                            child: const Icon(Icons.phone, color: Colors.orangeAccent),
                          ),
                          GestureDetector(
                            onTap: () async {
                              _launchURL(_url_facebook);
                              },
                            child: const Icon(Icons.facebook, color: Colors.orangeAccent),
                          ),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),

      const SizedBox(height: 16),

      if (widget.userType == "eleve")
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Transform.scale(
            scale: 1.4,
            child: FloatingActionButton(
              backgroundColor: Colors.blue,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QRCodeScreen()),
                );
              },
              tooltip: 'QR Code',
              elevation: 6.0,
              shape: const CircleBorder(),
              child: const Icon(
                Icons.qr_code_2_sharp,
                color: couleurIcone,
                size: 32.0,
              ),
            ),
          ),
        ),

      if (widget.userType == "prof")
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Transform.scale(
            scale: 1.4,
            child: FloatingActionButton(
              backgroundColor: Colors.blue,
              onPressed: () async {
                var status = await Permission.camera.status;
                if (status.isDenied) {
                  // We didn't ask for permission yet or the permission has been denied before but not permanently.
                  status = await Permission.camera.request();
                }
                if (status.isGranted) {
                  String? scanResult = await Scanner(context: context).scanBarcode();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    backgroundColor: Colors.yellow,
                    content: Text('Permission d\'accès à la caméra de votre appareil nécessaire',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'NotoSans',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    duration: Duration(seconds: 2),
                  ),);
                }
              },
              tooltip: 'Scanner',
              elevation: 6.0,
              shape: const CircleBorder(),
              child: const Icon(
                Icons.photo_camera,
                color: couleurIcone,
                size: 32.0,
              ),
            ),
          ),
        ),
          ],
        ),
      ),
    ),
    );
  }
}
