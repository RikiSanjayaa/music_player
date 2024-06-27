import 'package:flutter/material.dart';
import 'package:music_player/components/my_drawer.dart';
import 'package:music_player/pages/playlist_page.dart';
import 'package:music_player/pages/song_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
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
        selectedItemColor: Theme.of(context).colorScheme.onSurface,
        unselectedItemColor: Theme.of(context).colorScheme.primary,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text("My Music Player"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            // TODO: implement add new song to playlist
            onPressed: () {},
          )
        ],
      ),
      drawer: const MyDrawer(),
      body: PageView(
        controller: _pageController,
        children: const [
          // playlist page
          PlaylistPage(),

          // now playing page
          SongPage()
        ],
      ),
    );
  }
}
