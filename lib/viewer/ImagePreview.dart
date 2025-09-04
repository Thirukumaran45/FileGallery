import 'package:filegallery/viewer/homeScreen.dart';
import 'package:flutter/material.dart';
class ImagePreviewScreen extends StatelessWidget {
  final String imagePath; // Pass the image asset or network path
  final double maxWidth; // Max width for resizing
  final double maxHeight; // Max height for resizing

  const ImagePreviewScreen({
    super.key,
    required this.imagePath,
    this.maxWidth = 300,  // default max width
    this.maxHeight = 400, // default max height
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Image Preview",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Navigate back to HomeScreen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const HomeScreen(username: "Thiru")),
            );
          },
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxWidth,
            maxHeight: maxHeight,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain, // preserves aspect ratio
            ),
          ),
        ),
      ),
    );
  }
}
