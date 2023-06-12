import 'package:flutter/material.dart';
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
  Future<List<VideoDetail>> fetchAllVideoDetails() async {
    const String channelId = 'UCm19VoVNI76RHqpaRbS1kgw';
    const String apiKey = 'AIzaSyDXJhWtOn-ZehPdn5MsVSpOxWBItSH8svQ';
    const int maxResults = 3; // Choisissez le nombre maximum de vidéos que vous voulez récupérer

    final response = await http.get(Uri.parse(
        'https://www.googleapis.com/youtube/v3/search?order=date&part=snippet&channelId=$channelId&maxResults=$maxResults&key=$apiKey'));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body)['items'] as List;

      List<VideoDetail> videoDetails = [];

      for (var data in jsonData) {
        // Vérifier si 'videoId' existe dans 'id'
        if (data['id'].containsKey('videoId')) {
          String thumbnailUrl = data['snippet']['thumbnails']['medium']['url'] ?? '';
          String title = data['snippet']['title'] ?? '';
          String description = data['snippet']['description'] ?? '';
          String videoId = data['id']['videoId'] ?? '';

          videoDetails.add(
              VideoDetail(thumbnailUrl, title, description, videoId));
        }
      }

      return videoDetails;
    } else {
      throw Exception('Failed to load video');
    }
  }
}





    class VideoPlayerPage extends StatefulWidget {
  final String videoId;
  const VideoPlayerPage({Key? key, required this.videoId}) : super(key: key);

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Player'),
      ),
      body: YoutubePlayer(
        controller: _controller,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}