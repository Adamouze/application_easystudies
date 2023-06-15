import 'package:flutter/material.dart';
import 'video_youtube.dart';
import 'news.dart';

class CustomBody extends StatelessWidget {
  CustomBody({Key? key}) : super(key: key);
  final newsService = NewsService();
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
              child: Container(
                padding: const EdgeInsets.all(16),
                color: Colors.grey[200],
                child: FutureBuilder<List<String>>(
                  future: newsService.simulateNewsData(), // newsService.fetchNewsData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final newsData = snapshot.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: newsData.map((data) => Text(data)).toList(),
                      );
                    } else if (snapshot.hasError) {
                      return const Text('Failed to fetch news data');
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),

            FractionallySizedBox(
              widthFactor: 0.95,
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
                          height:300,
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
                                    builder: (context) => VideoPlayerPage(videoId: videoDetail.videoId, videoDetail: videoDetail),
                                  ),
                                );
                              },
                              child: Card(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 200,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                                        image: DecorationImage(
                                          image: NetworkImage(videoDetail.thumbnailUrl),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            videoDetail.title,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
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


            const SizedBox(height: 16),

            FractionallySizedBox(
              widthFactor: 0.95,
              child: ElevatedButton(
                onPressed: () {
                  // Action pour le bouton "Autre Site"
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink, // Couleur de fond du bouton
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Arrondi des bords
                  ),
                ),
                child: const Text('Autre Potentiel Site'),
              ),
            ),
            const Text(
              "TODO : Boutons des différents réseaux",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
