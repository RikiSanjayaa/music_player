import 'package:cloud_firestore/cloud_firestore.dart';

class Song {
  final String id;
  final String songName;
  final String artistName;
  final String albumArtImagePath;
  final String audioUrl;

  Song({
    required this.id,
    required this.songName,
    required this.artistName,
    required this.albumArtImagePath,
    required this.audioUrl,
  });

  // mapping firestore objects into song objects
  factory Song.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Song(
      id: doc.id,
      songName: data['songName'] ?? '',
      artistName: data['artistName'] ?? '',
      albumArtImagePath: data['albumArtImagePath'] ?? '',
      audioUrl: data['audioUrl'] ?? '',
    );
  }
}
