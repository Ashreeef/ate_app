import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../utils/image_utils.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  // ----- STEP 1: VARIABLES -----
  final List<File> _pickedImages = [];
  final TextEditingController _captionController = TextEditingController();

  // ----- STEP 2: IMAGE PICK FUNCTION -----
  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage(imageQuality: 80);

    // Limit to 3 images + compress each one
    for (var x in images.take(3)) {
      final file = File(x.path);
      final compressed = await ImageUtils.compressAndGetFile(
        file,
        quality: 65,
      );
      _pickedImages.add(compressed);
    }

    setState(() {});
  }

  // ----- STEP 3: SUBMIT POST (to be filled after DB setup) -----
  void _submitPost() {
    // We'll fill this after DB + blocs are ready
  }

  // ----- STEP 4: UI -----
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Post')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- PICK IMAGES BUTTON ---
            ElevatedButton.icon(
              onPressed: _pickImages,
              icon: const Icon(Icons.photo_library),
              label: const Text("Pick Images (max 3)"),
            ),

            const SizedBox(height: 10),

            // --- SHOW SELECTED IMAGES ---
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _pickedImages
                  .map((file) => Image.file(
                        file,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ))
                  .toList(),
            ),

            const SizedBox(height: 20),

            // --- CAPTION INPUT ---
            TextField(
              controller: _captionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Caption",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // --- SUBMIT BUTTON ---
            ElevatedButton(
              onPressed: _submitPost,
              child: const Text("Post"),
            ),
          ],
        ),
      ),
    );
  }
}
