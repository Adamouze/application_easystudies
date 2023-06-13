import 'package:flutter/material.dart';
import 'video_youtube.dart';
import 'facebook_news.dart';

class CustomBody extends StatelessWidget {
  CustomBody({Key? key}) : super(key: key);
  final facebookService = FacebookService();
  final youtubeService = YoutubeService();

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
                        'Dernière News',
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
                          final pageController = PageController();

                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                height: 300,
                                child: PageView.builder(
                                  controller: pageController,
                                  itemCount: videoDetails.length,
                                  itemBuilder: (context, index) {
                                    final videoDetail = videoDetails[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => VideoPlayerPage(videoId: videoDetail.videoId),
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

                              // Boutons de navigation
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
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.mail, color: Colors.orangeAccent),
                          SizedBox(width: 10),
                          Text(
                            'atchuthen@outlook.fr',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'NotoSans',
                            ),
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
