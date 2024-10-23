import 'package:cloud_firestore/cloud_firestore.dart';

class Song {
  final String songName;
  final String artistName;
  final String albumArtImagePath;
  final String audioPath;

  Song({
    required this.songName,
    required this.artistName,
    required this.albumArtImagePath,
    required this.audioPath,
  });

  // mapping firestore objects into song objects
  factory Song.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Song(
      songName: data['songName'] ?? '',
      artistName: data['artistName'] ?? '',
      albumArtImagePath: data['albumArtImagePath'] ?? '',
      audioPath: data['audioPath'] ?? '',
    );
  }
}
