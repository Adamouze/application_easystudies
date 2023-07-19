// ignore_for_file: deprecated_member_use, constant_identifier_names, non_constant_identifier_names, duplicate_ignore, library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';


import '../screens/action_buttons_eleve/qrcode_screen.dart';
import '../screens/action_buttons_prof/scanner.dart';

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
                                      color: Colors.orangeAccent,
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
                                      color: Colors.orangeAccent,
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
                                  status = await Permission.camera.request();
                        }
                        if (status.isGranted) {
                          String? scanResult = await Scanner(context: context).scanBarcode();
                  if (scanResult != null && scanResult.isNotEmpty && scanResult != '-1') {
                    showDialog(
                      context: context,
                      builder: (context) {
                        final formKey = GlobalKey<FormState>();
                        String? selectedLocation;
                        String? selectedDuration;
                        TextEditingController identifierController =
                        TextEditingController(text: scanResult);

                        return Theme(
                          data: ThemeData(
                            textSelectionTheme: const TextSelectionThemeData(cursorColor: Colors.orangeAccent),
                          ),
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
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Déclaration d\'un cours',
                                    style: TextStyle(
                                      fontFamily: 'NotoSans',
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Form(
                                    key: formKey,
                                    child: Column(
                                      children: <Widget>[
                                        TextFormField(
                                          controller: identifierController,
                                          decoration: const InputDecoration(
                                            fillColor: Colors.white,
                                            filled: true,
                                            labelText: 'Identifiant',
                                            labelStyle: TextStyle(
                                              color: Colors.orangeAccent,
                                              fontFamily: 'NotoSans',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          enabled: false,
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
                                          ),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Veuillez choisir un lieu';
                                            }
                                            return null;
                                          },
                                          items: ['Paris', 'Villeneuve-Saint-Georges']
                                              .map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value, overflow: TextOverflow.ellipsis),
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            selectedLocation = newValue;
                                          },
                                        ),
                                        const SizedBox(height: 15),
                                        DropdownButtonFormField<String>(
                                          decoration: const InputDecoration(
                                            fillColor: Colors.white,
                                            filled: true,
                                            labelText: 'Durée',
                                            labelStyle: TextStyle(
                                              color: Colors.orangeAccent,
                                              fontFamily: 'NotoSans',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Veuillez choisir une durée';
                                            }
                                            return null;
                                          },
                                          items: List<String>.generate(20, (i) {
                                            int minutes = (i + 1) * 30;
                                            if (minutes < 60) {
                                              return '$minutes minute${minutes > 1 ? "s" : ""}';
                                            } else {
                                              int hours = minutes ~/ 60;
                                              int remainingMinutes = minutes % 60;
                                              return remainingMinutes > 0 ? '$hours heure${hours > 1 ? "s" : ""} $remainingMinutes minute${remainingMinutes > 1 ? "s" : ""}' : '$hours heure${hours > 1 ? "s" : ""}';
                                            }
                                          }).map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            selectedDuration = newValue;
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
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
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Annuler',
                                          style: TextStyle(
                                            fontFamily: 'NotoSans',
                                            color: Colors.orangeAccent,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                        ),
                                        onPressed: () {
                                          if (formKey.currentState!.validate()) {
                                            int selectedDurationInMinutes = 0;
                                            RegExp regExp = RegExp(r'(\d+)\s*(heure|minutes)');
                                            Iterable<RegExpMatch> matches = regExp.allMatches(selectedDuration!);
                                            for (RegExpMatch match in matches) {
                                              int value = int.parse(match.group(1)!);
                                              String unit = match.group(2)!;
                                              if (unit == 'heure') {
                                                selectedDurationInMinutes += value * 60;
                                              } else {
                                                selectedDurationInMinutes += value;
                                              }
                                            }
                                            print('Identifiant: $scanResult, Lieu: $selectedLocation, Durée: $selectedDurationInMinutes');
                                          }
                                        },
                                        child: const Text('Déclarer',
                                          style: TextStyle(
                                            fontFamily: 'NotoSans',
                                            color: Colors.orangeAccent,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );

                  }
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
                          ));
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

              const SizedBox(height: 20),

    ],
        ),
      ),
    ),
    );
  }
}
