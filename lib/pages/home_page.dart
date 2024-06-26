import 'package:flutter/material.dart';
import 'package:music_player/components/my_drawer.dart';
import 'package:music_player/models/playlist_provider.dart';
import 'package:music_player/models/song.dart';
import 'package:music_player/pages/song_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  // get the playlist provider
  late final dynamic playlistProvider;

  @override
  void initState() {
    super.initState();

    // get playlist provider
    playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);

    // add listener to page controller
    _pageController.addListener(() {
      int nextPage = _pageController.page!.round();
      if (nextPage != _selectedIndex) {
        setState(() {
          _selectedIndex = nextPage;
        });
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  // play song
  void playSong(int songIndex) {
    // update current song index
    playlistProvider.currentSongIndex = songIndex;
    _onItemTapped(1);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.playlist_play_rounded), label: 'Playlist'),
          BottomNavigationBarItem(
              icon: Icon(Icons.music_note), label: "Now Playing"),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Theme.of(context).colorScheme.onBackground,
        unselectedItemColor: Theme.of(context).colorScheme.primary,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(title: const Text("My Music Player")),
      drawer: const MyDrawer(),
      body: PageView(
        controller: _pageController,
        children: [
          // original home page
          Consumer<PlaylistProvider>(
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
          ),

          // second page
          const SongPage()
        ],
      ),
    );
  }
}
