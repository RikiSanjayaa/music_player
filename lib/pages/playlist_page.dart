import 'package:flutter/material.dart';
import 'package:music_player/models/playlist_provider.dart';
import 'package:music_player/models/song.dart';
import 'package:provider/provider.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({super.key});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  // get the playlist provider
  late final dynamic playlistProvider;

  @override
  void initState() {
    super.initState();
    // get playlist provider
    playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
  }

  // play song
  void playSong(int songIndex) {
    // update current song index
    playlistProvider.currentSongIndex = songIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistProvider>(
      builder: (context, value, child) {
        // get the playlist
        final List<Song> playlist = value.playlist;

        // return list view UI
        return ListView.builder(
          itemCount: playlist.length,
          itemBuilder: (context, index) {
            // get individual song
            final Song song = playlist[index];

            // return list tile UI
            return ListTile(
              title: Text(song.songName),
              subtitle: Text(song.artistName),
              leading: Image.asset(song.albumArtImagePath),
              onTap: () {
                playSong(index);
              },
            );
          },
        );
      },
    );
  }
}
