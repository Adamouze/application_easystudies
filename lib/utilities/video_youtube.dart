import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class VideoDetail {
  final String thumbnailUrl;
  final String title;
  final String description;
  final String videoId;

  VideoDetail(this.thumbnailUrl, this.title, this.description, this.videoId);
}


class YoutubeService {
  List<VideoDetail>? _cachedVideos;
  static final YoutubeService _singleton = YoutubeService._internal();

  factory YoutubeService() {
    return _singleton;
  }

  YoutubeService._internal();

  Future<List<VideoDetail>> fetchAllVideoDetails() async {
    if (_cachedVideos != null) {
      return _cachedVideos!;
    }

    const String channelId = 'UCm19VoVNI76RHqpaRbS1kgw';
    const String apiKey = 'AIzaSyD1E2sQsSIXbFMJpYUnHEpR8LwHnigjhHA';
    const int maxResults = 3;

    final response = await http.get(Uri.parse(
        'https://www.googleapis.com/youtube/v3/search?order=date&part=snippet&channelId=$channelId&maxResults=$maxResults&key=$apiKey'));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body)['items'] as List;

      List<VideoDetail> videoDetails = [];

      for (var data in jsonData) {
        if (data['id'].containsKey('videoId')) {
          String thumbnailUrl = data['snippet']['thumbnails']['medium']['url'] ?? '';
          String title = data['snippet']['title'] ?? '';
          String description = data['snippet']['description'] ?? '';
          String videoId = data['id']['videoId'] ?? '';

          videoDetails.add(VideoDetail(thumbnailUrl, title, description, videoId));
        }
      }

      if(videoDetails.isNotEmpty) {
        videoDetails.insert(0, videoDetails.last); // Duplicate last video at start
        videoDetails.add(videoDetails[1]); // Duplicate first video at end
      }

      _cachedVideos = videoDetails;
      return videoDetails;
    } else {
      throw Exception('Failed to load video');
    }
  }
}






class VideoPlayerPage extends StatefulWidget {
  final String videoId;
  final VideoDetail videoDetail;
  const VideoPlayerPage({Key? key, required this.videoId, required this.videoDetail}) : super(key: key);

  @override
  // Warning qui ne pose pas de problème ici.
  // ignore: library_private_types_in_public_api
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.deepOrange, // Couleur de la barre de lecture
          progressColors: const ProgressBarColors(
            playedColor: Colors.deepOrange, // Couleur de la barre de progression jouée
            handleColor: Colors.deepOrange, // Couleur de la poignée de la barre de progression
          ),
        ),
        builder: (context, player) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.grey[900],
              child: Center(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: player,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}