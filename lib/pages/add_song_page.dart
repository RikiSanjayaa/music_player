import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:music_player/models/playlist_provider.dart';

class AddSongPage extends StatefulWidget {
  const AddSongPage({super.key});

  @override
  State<AddSongPage> createState() => _AddSongPageState();
}

class _AddSongPageState extends State<AddSongPage> {
  final _titleController = TextEditingController();
  final _artistController = TextEditingController();
  final defaultAlbumImage =
      'https://firebasestorage.googleapis.com/v0/b/music-player-app-cc4d1.appspot.com/o/img_file%2Fdefault_album_image.jpg?alt=media&token=285e235a-618d-4067-baa2-ac19b17dfb4f';
  File? albumImage;
  File? audioFile;
  String? selectedFile;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _pickAudioFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3'],
    );

    if (result != null) {
      audioFile = File(result.files.single.path!);
      setState(() {
        selectedFile = result.files.single.name;
      });
      if (_titleController.text == "") {
        _titleController.text = result.files.single.name.split(".mp3")[0];
      }
    } else {
      // user cancel file picker
    }
  }

  Future<File?> _cropImage(File imageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
    );

    if (croppedFile != null) {
      return File(croppedFile.path);
    }
    return null;
  }

  Future<void> _pickAlbumImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
    );

    if (result != null) {
      File? croppedFile = await _cropImage(File(result.files.single.path!));
      setState(() {
        albumImage = croppedFile;
      });
    } else {
      // User canceled the picker
    }
  }

  void _saveSong() {
    if (audioFile != null && _titleController.text.isNotEmpty) {
      final provider = Provider.of<PlaylistProvider>(context, listen: false);
      // TODO: Make loading view when uploading Audio, CircularProgressIndicator not working properly
      provider.addSong(
        _titleController.text,
        audioFile!,
        _artistController.text.isNotEmpty ? _artistController.text : "-",
        albumImage,
      );
      Navigator.of(context).pop();
    } else {
      // Show an error message if audioFile or title is not provided
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide both a song title and an audio file.'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _artistController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a New Song'),
      ),
      body: Consumer<PlaylistProvider>(
        builder: (context, provider, child) {
          return provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[400]),
                          icon: Icon(
                            Icons.audio_file,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          label: Text("Import Audio File",
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary)),
                          onPressed: () {
                            _pickAudioFile();
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        selectedFile != null
                            ? Text("Selected File: $selectedFile")
                            : const Text("No audio file selected"),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: _titleController,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface),
                          decoration: const InputDecoration(
                            labelText: 'Title',
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _artistController,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface),
                          decoration: const InputDecoration(
                            labelText: 'Artist',
                          ),
                        ),
                        const SizedBox(height: 40),
                        Column(
                          children: [
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[400]),
                              icon: Icon(
                                Icons.image,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                              label: Text("Change album Image",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary)),
                              onPressed: () {
                                _pickAlbumImage();
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            albumImage == null
                                ? Image.network(
                                    defaultAlbumImage,
                                    width: 250,
                                  )
                                : Image.file(
                                    File(albumImage!.path),
                                    width: 250,
                                  ),
                            const SizedBox(height: 20),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[400]),
                          onPressed: () {
                            _saveSong();
                          },
                          icon: Icon(
                            Icons.add,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          label: Text(
                            'Add Song',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }
}
