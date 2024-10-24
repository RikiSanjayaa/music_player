import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
import 'package:music_player/models/song.dart';

class PlaylistProvider extends ChangeNotifier {
  final songs = FirebaseFirestore.instance.collection('songs');
  final storageRef = FirebaseStorage.instance.ref();

  // playlist of songs
  List<Song> _playlist = [
    // remove assets songs and store them into firebase firestore
  ];

  // current song playing index
  int? _currentSongIndex;

  /* AUDIO PLAYERS */
  // audio player
  final AudioPlayer _audioPlayer = AudioPlayer();

  // durations
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;

  // constructor
  PlaylistProvider() {
    fetchSongsFromFirestore();
    listenToDuration();
  }

  // fetching songs from firestore
  Future<void> fetchSongsFromFirestore() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('songs').get();
      _playlist =
          querySnapshot.docs.map((doc) => Song.fromFirestore(doc)).toList();
      if (_playlist.isNotEmpty) {
        _currentSongIndex =
            0; // Set to the first song if the playlist is not empty
      }
      notifyListeners(); // Notify listeners to update UI
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching songs: $e');
      }
    }
  }

  // initially not playing
  bool _isPlaying = false;
  bool _repeat = false;
  bool _shuffle = false;

  // play the song
  void play() async {
    final String path = _playlist[_currentSongIndex!].audioPath;
    await _audioPlayer.stop();
    await _audioPlayer.play(UrlSource(path));
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

  // update song
  void updateSong(int index, String songName, String artistName,
      String albumArtImagePath) async {
    String songId = _playlist[index].id;
    // Update the song in Firestore
    try {
      await FirebaseFirestore.instance
          .collection('songs')
          .doc(_playlist[index].id) // Assuming each song has a unique ID
          .update({
        'songName': songName,
        'artistName': artistName,
        'albumArtImagePath': albumArtImagePath,
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error updating song in Firestore: $e');
      }
    }
    _playlist[index] = Song(
      id: songId,
      songName: songName,
      artistName: artistName,
      albumArtImagePath: albumArtImagePath,
      audioPath: _playlist[index].audioPath,
    );
    notifyListeners();
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
