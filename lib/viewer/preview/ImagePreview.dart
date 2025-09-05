import 'package:filegallery/viewer/screens/homeScreen.dart';
import 'package:flutter/material.dart';
class ImagePreviewScreen extends StatelessWidget {
  final String imagePath; // Pass the image asset or network path
  final String fileName;
  const ImagePreviewScreen({
    super.key,
    required this.fileName,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(
          fileName,
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Navigate back to HomeScreen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const HomeScreen()),
            );
          },
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(
  child: SizedBox(
    width: MediaQuery.of(context).size.width*1,  // fixed width
    height: MediaQuery.of(context).size.height*0.6, // fixed height
    child: ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.network(
        imagePath,
        fit: BoxFit.fill, // force to fill 300x200
      ),
    ),
  ),
),

    );
  }
}
