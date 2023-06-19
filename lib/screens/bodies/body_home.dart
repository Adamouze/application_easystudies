// ignore_for_file: deprecated_member_use, constant_identifier_names, non_constant_identifier_names, duplicate_ignore

import 'package:flutter/material.dart';
import '../../utilities/video_youtube.dart';
import '../../utilities/facebook_news.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomBody extends StatelessWidget {
  CustomBody({Key? key}) : super(key: key);
  final facebookService = FacebookService();
  final youtubeService = YoutubeService();

  static const String _url_facebook = 'https://www.facebook.com/easystudies';
  static const String _url_tel = 'tel:0664021773';
  final Uri _url_mail = Uri(scheme: 'mailto', path: 'easystudies@outlook.fr',);
  //ignore: non_constant_identifier_names
  void _launchURL(String url) async {
    if (!await launch(url)) throw 'Could not launch $_url_facebook';
  }
  void _launchmail(Uri url) async {
    if(await canLaunchUrl(url)){
      launchUrl(url);
    }
    else {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
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
                          final pageController = PageController(initialPage: videoDetails.length * 1000);

                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                height: 300,
                                child: PageView.builder(
                                  controller: pageController,
                                  itemCount: videoDetails.length * 100000,
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
                                      pageController.previousPage(
                                        duration: const Duration(milliseconds: 400),
                                        curve: Curves.easeInOut,
                                      );
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
                                      pageController.nextPage(
                                        duration: const Duration(milliseconds: 400),
                                        curve: Curves.easeInOut,
                                      );
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
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Contact',
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
            )
          ],
        ),
      ),
    );
  }
}
