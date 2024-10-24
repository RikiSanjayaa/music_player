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
        // default page if no song is available
        if (value.playlist.isEmpty || value.currentSongIndex == null) {
          return const Center(child: Text('No songs available'));
        }

        // edit song view
        Future<void> showEditForm(BuildContext context, Song song, int index,
            PlaylistProvider provider) async {
          final TextEditingController songNameController =
              TextEditingController(text: song.songName);
          final TextEditingController artistNameController =
              TextEditingController(text: song.artistName);
          String albumArtImagePath = song.albumArtImagePath;

          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return AlertDialog(
                    title: const Center(child: Text("Edit Song")),
                    content: SingleChildScrollView(
                      child: SizedBox(
                        width: 700,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            TextField(
                              controller: songNameController,
                              decoration:
                                  const InputDecoration(labelText: "Song Name"),
                            ),
                            TextField(
                              controller: artistNameController,
                              decoration: const InputDecoration(
                                  labelText: "Artist Name"),
                            ),
                            const SizedBox(height: 20),
                            albumArtImagePath.isNotEmpty
                                ? Image.network(albumArtImagePath, height: 300)
                                : Container(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    // Remove album image
                                    setState(() {
                                      albumArtImagePath =
                                          'https://firebasestorage.googleapis.com/v0/b/music-player-app-cc4d1.appspot.com/o/img_file%2Fdefault_album_image.jpg?alt=media&token=285e235a-618d-4067-baa2-ac19b17dfb4f';
                                    });
                                  },
                                  child: Text(
                                    "Remove Image",
                                    style: TextStyle(color: Colors.red[400]),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    // TODO: Update album image
                                    // Implement your image picker logic here
                                    // For example, using image_picker package
                                    // final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
                                    // if (pickedFile != null) {
                                    //   albumArtImagePath = pickedFile.path;
                                    // }
                                    Navigator.of(context).pop();
                                    showEditForm(context, song, index,
                                        provider); // Reopen the dialog to reflect changes
                                  },
                                  child: Text(
                                    "Update Image",
                                    style: TextStyle(color: Colors.blue[400]),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          // Update the song details
                          provider.updateSong(index, songNameController.text,
                              artistNameController.text, albumArtImagePath);
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          "Save",
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          );
        }

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
                      child: Image.network(
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
                        leading: Image.network(song.albumArtImagePath),
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
                  return Dismissible(
                    key: ValueKey("${song.songName}-${song.artistName}"),
                    background: Container(
                      color: Colors.red.shade400,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    secondaryBackground: Container(
                      color: Colors.blue.shade400,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.edit, color: Colors.white),
                    ),
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.startToEnd) {
                        // Show a confirmation dialog before deleting
                        return await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Delete Song"),
                              content: Text(
                                  "Are you sure you want to delete ${song.songName}?"),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text("Delete"),
                                ),
                              ],
                            );
                          },
                        );
                      } else if (direction == DismissDirection.endToStart) {
                        // Handle edit action without dismissing the widget
                        showEditForm(context, song, index, value);
                        return false; // Return false to prevent the widget from being dismissed
                      }
                      return false;
                    },
                    onDismissed: (direction) {
                      if (direction == DismissDirection.startToEnd) {
                        // Handle delete action
                        // value.deleteSong(index);
                      }
                    },
                    child: isCurrentSong
                        ? currentSongWidget()
                        : ListTile(
                            key:
                                ValueKey("${song.songName}-${song.artistName}"),
                            title: Text(song.songName),
                            subtitle: Text(song.artistName),
                            leading: Image.network(song.albumArtImagePath),
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
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
