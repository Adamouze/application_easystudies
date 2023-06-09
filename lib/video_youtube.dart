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
  Future<VideoDetail> fetchLatestVideoDetails() async {
    const String channelId = 'UCm19VoVNI76RHqpaRbS1kgw';
    const String apiKey = 'AIzaSyAbIR-eFQwQ6ESK_9OKhHYLo08Hn24MQwo';
    final response = await http.get(Uri.parse(
        'https://www.googleapis.com/youtube/v3/search?order=date&part=snippet&channelId=$channelId&maxResults=1&key=$apiKey'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['items'][0];
      return VideoDetail(
        data['snippet']['thumbnails']['high']['url'],
        data['snippet']['title'],
        data['snippet']['description'],
        data['id']['videoId'], // ajout de l'ID de la vidéo
      );
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