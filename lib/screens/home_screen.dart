import 'package:flutter/material.dart';
import 'package:music_app/models/song_model.dart';
import 'package:music_app/services/audio_service.dart';
import 'package:music_app/services/saavn_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SaavnService _saavnService = SaavnService();
  final AudioService _audioService = AudioService();
  List<Song> _songs = [];
  bool isPlaying = false;

   _onPlayPressed(Song song) async {
    await _audioService.playSong(song);
  }

  _onPausePressed() async {
    await _audioService.pauseSong();
  }

  _onDownloadPressed(Song song) async {
    await _audioService.downloadSong(song, context);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music App'),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration:const InputDecoration(
                  hintText: 'Search songs...',
                  border: OutlineInputBorder(),
                ),
                onChanged: (query) async {
                  if (query.length > 2) {
                    final songs = await _saavnService.searchSongs(query);
                    setState(() => _songs = songs);
                  }
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
          itemCount: _songs.length,
          itemBuilder: (context, index) {
            final song = _songs[index];
            return ListTile(
          leading: song.images.isNotEmpty
        ? Image.network(
            song.images.first.url,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          )
        : const Icon(Icons.music_note),
          title: Text(song.name),
          subtitle: Text(song.language),
          trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                 IconButton(
          icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
          onPressed: () {
            if (isPlaying) {
        _onPausePressed();
            } else {
        _onPlayPressed(song);
            }
            setState(() {
        isPlaying = !isPlaying;
            });
          },
        ),
                  IconButton(
                    icon: Icon(
                      song.isDownloaded ? Icons.download_done : Icons.download,
                    ),
                    onPressed: () => _onDownloadPressed(song),
                  ),
                ],
              ),
        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}