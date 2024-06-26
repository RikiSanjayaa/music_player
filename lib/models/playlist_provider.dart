import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_player/models/song.dart';

class PlaylistProvider extends ChangeNotifier {
  // playlist of songs
  final List<Song> _playlist = [
    // song 1
    Song(
      songName: "Drunk Text",
      artistName: "Henry Moodie",
      albumArtImagePath: "assets/images/drunk-text.jpg",
      audioPath: "audio/drunk-text.mp3",
    ),

    // song 2
    Song(
      songName: "Levitating",
      artistName: "Dua Lipa",
      albumArtImagePath: "assets/images/levitating.jpg",
      audioPath: "audio/levitating.mp3",
    ),

    // song 3
    Song(
      songName: "Firefly",
      artistName: "Owl City",
      albumArtImagePath: "assets/images/firefly.jpeg",
      audioPath: "audio/firefly.mp3",
    ),
  ];

  // current song playing index
  int? _currentSongIndex = 0;

  /* AUDIO PLAYERS */
  // audio player
  final AudioPlayer _audioPlayer = AudioPlayer();

  // durations
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;

  // constructor
  PlaylistProvider() {
    listenToDuration();
  }

  // initially not playing
  bool _isPlaying = false;
  bool _repeat = false;
  bool _shuffle = false;

  // play the song
  void play() async {
    final String path = _playlist[_currentSongIndex!].audioPath;
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(path));
    _isPlaying = true;
    notifyListeners();
  }

  // pause the song
  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  // resume playing
  void resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  // pause or resume
  void pauseOrResume() async {
    if (_isPlaying) {
      pause();
    } else if (!_isPlaying && (_currentSongIndex == 0)) {
      play();
    } else {
      resume();
    }
    notifyListeners();
  }

  // seek to a specific position in the current song
  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  // play next song
  void playNextSong() {
    if (_repeat) {
      seek(Duration.zero);
      _repeat = false;
      play();
    } else if (_shuffle) {
      int nextIndex;
      do {
        nextIndex = Random().nextInt(_playlist.length);
      } while (_playlist.length > 1 && nextIndex == _currentSongIndex);
      currentSongIndex = nextIndex;
    } else if (_currentSongIndex != null) {
      if (_currentSongIndex! < _playlist.length - 1) {
        // go to the next song if it's not the last song
        currentSongIndex = _currentSongIndex! + 1;
      } else {
        // if it's the last song, loop back to first song
        currentSongIndex = 0;
      }
    }
  }

  // play previous song
  void playPreviousSong() async {
    // if more than 2 seconds have passed, restart the current song
    if (_currentDuration.inSeconds > 2) {
      seek(Duration.zero);
    }
    // if it's within first 2 second of the song, go to previous song
    else {
      if (_currentSongIndex! > 0) {
        currentSongIndex = _currentSongIndex! - 1;
      } else {
        // if it's the first song, loop back to last song
        currentSongIndex = _playlist.length - 1;
      }
    }
  }

  // repeat current song
  void repeatCurrentSong() async {
    _repeat = !_repeat;
    notifyListeners();
  }

  void shuffleSong() async {
    _shuffle = !_shuffle;
    notifyListeners();
  }

  // listen to duration
  void listenToDuration() {
    // listen for total duration
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });

    // listen for current duration
    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentDuration = newPosition;
      notifyListeners();
    });

    // listen for song completion
    _audioPlayer.onPlayerComplete.listen((event) {
      playNextSong();
    });
  }

  /* GETTERS */
  List<Song> get playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  bool get isRepeat => _repeat;
  bool get isShuffle => _shuffle;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuation => _totalDuration;

  /* SETTERS */
  set currentSongIndex(int? newIndex) {
    // update song index
    _currentSongIndex = newIndex;

    if (newIndex != null) {
      play();
    }

    // update UI
    notifyListeners();
  }
}
