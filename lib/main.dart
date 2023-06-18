import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Audio Player Demo',
      home: AudioPlayerPage(),
    );
  }
}

class AudioPlayerPage extends StatefulWidget {
  const AudioPlayerPage({Key? key}) : super(key: key);

  @override
  AudioPlayerPageState createState() => AudioPlayerPageState();
}

class AudioPlayerPageState extends State<AudioPlayerPage> {
  final leftPlayer = AudioPlayer();
  final rightPlayer = AudioPlayer();
  late final ConcatenatingAudioSource audioSource;

  @override
  void initState() {
    super.initState();
    audioSource = ConcatenatingAudioSource(children: [
      AudioSource.uri(Uri.parse('asset:///betawave_30_left.mp3')),
      AudioSource.uri(Uri.parse('asset:///betawave_30_right.mp3')),
    ]);
    // ..setShuffleModeEnabled(false)
    // ..setLoopMode(LoopMode.all)
    // ..shuffle();
    leftPlayer.setShuffleModeEnabled(false);
    leftPlayer.setLoopMode(LoopMode.all);
    leftPlayer.shuffle();
    leftPlayer.setAudioSource(audioSource);
    rightPlayer.setShuffleModeEnabled(false);
    rightPlayer.setLoopMode(LoopMode.all);
    rightPlayer.shuffle();
    rightPlayer.setAudioSource(audioSource);
  }

  @override
  void dispose() {
    leftPlayer.dispose();
    rightPlayer.dispose();
    super.dispose();
  }

  Future<void> _playPause() async {
    if (leftPlayer.playing && rightPlayer.playing) {
      await leftPlayer.pause();
      await rightPlayer.pause();
    } else {
      await leftPlayer.play();
      await rightPlayer.play();
    }
    setState(() {});
  }

  IconData get _playPauseIcon {
    if (leftPlayer.playing && rightPlayer.playing) {
      return Icons.pause;
    } else {
      return Icons.play_arrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Player Demo'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _playPause,
          child: Icon(_playPauseIcon),
        ),
      ),
    );
  }
}
