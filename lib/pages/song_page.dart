import 'package:flutter/material.dart';
import 'package:music_player/components/neu_box.dart';
import 'package:music_player/models/playlist_provider.dart';
import 'package:provider/provider.dart';

class SongPage extends StatefulWidget {
  const SongPage({super.key});

  @override
  State<SongPage> createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  // convert duration into min:sec
  String formatTime(Duration duration) {
    String twoDigitSeconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    String formattedTime = "${duration.inMinutes}:$twoDigitSeconds";

    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistProvider>(
      builder: (context, value, child) {
        // get playlist
        final playlist = value.playlist;

        // get current song index
        final currentSong = playlist[value.currentSongIndex ?? 0];

        // return scaffold UI
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // album artwork
                  NeuBox(
                    child: Column(
                      children: [
                        // image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(currentSong.albumArtImagePath),
                        ),

                        // song and artist name and icon
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    currentSong.songName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  Text(currentSong.artistName),
                                ],
                              ),

                              // heart icon
                              const Icon(Icons.favorite, color: Colors.red),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // song duration progress
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // start time
                        Text(formatTime(value.currentDuration)),

                        // shuffle icon
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              value.shuffleSong();
                            });
                          },
                          child: Icon(Icons.shuffle,
                              color: value.isShuffle
                                  ? Colors.red
                                  : Theme.of(context).colorScheme.onSurface),
                        ),

                        // repeat icon
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              value.repeatCurrentSong();
                            });
                          },
                          child: Icon(
                            Icons.repeat,
                            color: value.isRepeat
                                ? Colors.red
                                : Theme.of(context).colorScheme.onSurface,
                          ),
                        ),

                        // end time
                        Text(formatTime(value.totalDuation)),
                      ],
                    ),
                  ),

                  // song duration progress
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                        thumbShape:
                            const RoundSliderThumbShape(enabledThumbRadius: 5)),
                    child: Slider(
                      min: 0,
                      max: value.totalDuation.inSeconds.toDouble(),
                      value: value.currentDuration.inSeconds.toDouble(),
                      activeColor: Colors.green,
                      inactiveColor: Theme.of(context).colorScheme.secondary,
                      onChanged: (double double) {
                        // during when the use is sliding around
                      },
                      onChangeEnd: (double double) {
                        // sliding has finished, go to that position in song duration
                        value.seek(Duration(seconds: double.toInt()));
                      },
                    ),
                  ),

                  const SizedBox(height: 25),

                  // playback controls
                  Row(
                    children: [
                      // skip previous
                      Expanded(
                        child: GestureDetector(
                          onTap: value.playPreviousSong,
                          child: const NeuBox(
                            child: Icon(Icons.skip_previous),
                          ),
                        ),
                      ),

                      const SizedBox(width: 25),

                      // play pause
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: value.pauseOrResume,
                          child: NeuBox(
                            child: Icon(value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow),
                          ),
                        ),
                      ),

                      const SizedBox(width: 25),

                      // skip forward
                      Expanded(
                        child: GestureDetector(
                          onTap: value.playNextSong,
                          child: const NeuBox(
                            child: Icon(Icons.skip_next),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
