
// 🔹 Gradient Image Grid (5x2 style → 2 columns)
import 'package:filegallery/viewer/ImagePreview.dart';
import 'package:flutter/material.dart';

Widget buildImageList(List<String> files) {
  if (files.isEmpty) {
    return const Center(
      child: Text("No images uploaded yet"),
    );
  }
  return GridView.builder(
    padding: const EdgeInsets.all(12),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2, // 2 columns
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 0.8, // adjust height/width ratio
    ),
    itemCount: files.length,
    itemBuilder: (context, index) {
      final file = files[index];
      return Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.lightBlueAccent, Colors.lightBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(50),
              blurRadius: 6,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.asset(
                  file,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.visibility, color: Colors.white),
                    tooltip: "Preview",
                    onPressed: () {
                     Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => ImagePreviewScreen(
      imagePath: file,
      maxWidth: 250,
      maxHeight: 350,
    ),
  ),
);

                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.download, color: Colors.yellow),
                    tooltip: "Download",
                    onPressed: () {
                      // TODO: download resized image
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

// 🔹 File List (for PDFs with gradient shadow look)
Widget buildFileList(List<String> files, {required bool isImage}) {
  if (files.isEmpty) {
    return const Center(
      child: Text("No files uploaded yet"),
    );
  }
  return ListView.builder(
    padding: const EdgeInsets.all(8),
    itemCount: files.length,
    itemBuilder: (context, index) {
      final file = files[index];
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8,horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Colors.lightBlueAccent, Colors.lightBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.lightBlueAccent.withAlpha(200),
              offset: const Offset(0, 1),
              // blurRadius: 2,
            ),
            BoxShadow(
              color: Colors.lightBlue.withAlpha(200),
              offset: const Offset(0, 1),
              blurRadius: 4,
            ),
          ],
        ),
        child: Card(
          color: Colors.white,
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: Icon(
                Icons.picture_as_pdf,
                color: Colors.blue.shade800,
              ),
            ),
            title: Text(file, overflow: TextOverflow.ellipsis),
            subtitle: const Text("PDF document"),
            trailing: Wrap(
              spacing: 10,
              children: [
                IconButton(
                  icon: const Icon(Icons.visibility, color: Colors.green),
                  tooltip: "Preview",
                  onPressed: () {
                    // TODO: preview file
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.download, color: Colors.orange),
                  tooltip: "Download",
                  onPressed: () {
                    // TODO: download file
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
