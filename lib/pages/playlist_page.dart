import 'package:flutter/material.dart';
import 'package:music_player/components/neu_box.dart';
import 'package:music_player/models/playlist_provider.dart';
import 'package:music_player/models/song.dart';
import 'package:music_player/themes/theme_provider.dart';
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
        final int? currentSongIndex = value.currentSongIndex;

        // return list view UI
        return Column(
          children: [
            // preview playing song
            Padding(
              padding: const EdgeInsets.only(
                  top: 20, bottom: 50, left: 40, right: 40),
              child: NeuBox(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        playlist[currentSongIndex!].albumArtImagePath,
                        width: 100,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Now Playing:",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            playlist[currentSongIndex].songName,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(playlist[currentSongIndex].artistName),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // playlist start
            Expanded(
              child: ListView.builder(
                itemCount: playlist.length,
                itemBuilder: (context, index) {
                  // get individual song
                  final Song song = playlist[index];

                  bool isCurrentSong = index == currentSongIndex;

                  // Create a custom widget for the current song with inner shadow
                  Widget currentSongWidget() {
                    return Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Provider.of<ThemeProvider>(context,
                                        listen: true)
                                    .isDarkMode
                                ? Colors.grey.shade800
                                : Colors.grey.shade200,
                          ),
                        ],
                      ),
                      child: ListTile(
                        key: ValueKey("${song.songName}-${song.artistName}"),
                        title: Text(song.songName),
                        subtitle: Text(song.artistName),
                        leading: Image.asset(song.albumArtImagePath),
                        trailing: isCurrentSong && value.isPlaying
                            ? const Icon(Icons.pause)
                            : const Icon(Icons.play_arrow),
                        onTap: () {
                          if (isCurrentSong) {
                            value.pauseOrResume();
                          } else {
                            playSong(index);
                          }
                        },
                      ),
                    );
                  }

                  // return list tile UI
                  return isCurrentSong
                      ? currentSongWidget()
                      : ListTile(
                          key: ValueKey("${song.songName}-${song.artistName}"),
                          title: Text(song.songName),
                          subtitle: Text(song.artistName),
                          leading: Image.asset(song.albumArtImagePath),
                          trailing: isCurrentSong && value.isPlaying
                              ? const Icon(Icons.pause)
                              : const Icon(Icons.play_arrow),
                          onTap: () {
                            if (isCurrentSong) {
                              value.pauseOrResume();
                            } else {
                              playSong(index);
                            }
                          },
                        );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
