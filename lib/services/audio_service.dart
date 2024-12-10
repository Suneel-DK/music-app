// lib/services/audio_service.dart
// ignore_for_file: use_build_context_synchronously

import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import '../models/song_model.dart';
import 'package:http/http.dart' as http;

class AudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  
  
  Future<void> playSong(Song song) async {
    if (song.isDownloaded) {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/${song.id}.mp3');
      await _audioPlayer.setFilePath(file.path);
    } else {
      // Get highest quality URL
      final downloadUrl = song.downloadUrls.isNotEmpty 
          ? song.downloadUrls.last.url 
          : song.url;
      await _audioPlayer.setUrl(downloadUrl);
    }
    await _audioPlayer.play();
  }

  Future<void> pauseSong() async {
    await _audioPlayer.pause();
  }

Future<void> downloadSong(Song song, BuildContext context) async {
  try {
    Directory? downloadsDir;
    
    // Get the downloads directory based on the platform
    if (Platform.isAndroid) {
      downloadsDir = Directory('/storage/emulated/0/Download');
    } else if (Platform.isIOS) {
      downloadsDir = await getApplicationDocumentsDirectory();
    }

    final filePath = '${downloadsDir!.path}/${song.id}.mp3';
    final file = File(filePath);

    // Get the highest quality URL for download
    final downloadUrl = song.downloadUrls.isNotEmpty
        ? song.downloadUrls.last.url
        : song.url;

    // Fetch the song data
    final response = await http.get(Uri.parse(downloadUrl));
    if (response.statusCode == 200) {
      await file.writeAsBytes(response.bodyBytes);
      song.isDownloaded = true;

      // Show success message with download path
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${song.name} downloaded successfully at:\n$filePath'),
          duration: const Duration(seconds: 5),
        ),
      );
    } else {
      // Log error if the download failed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to download song: ${song.name}'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error downloading song: $e'),
        duration: const Duration(seconds: 3),
      ),
    );
  }
} }