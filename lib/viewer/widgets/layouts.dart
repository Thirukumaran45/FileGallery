// 🔹 Gradient Image Grid
import 'package:filegallery/viewer/preview/ImagePreview.dart';
import 'package:filegallery/viewer/preview/PdfsPreview.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

void downloadFileToExternal(String url, String fileName, BuildContext context) async {
  final scaffold = ScaffoldMessenger.of(context);

  try {
    // Request storage permission for Android
    if (Platform.isAndroid) {
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        scaffold.showSnackBar(const SnackBar(content: Text('Storage permission denied')));
        return;
      }
    }

    // Get external storage directory
    Directory? dir;
    if (Platform.isAndroid) {
      dir = Directory('/storage/emulated/0/Download'); // Downloads folder
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
    } else {
      dir = await getApplicationDocumentsDirectory();
    }

    final savePath = '${dir.path}/$fileName';

    // Show progress dialog
    double progress = 0;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
               backgroundColor: Colors.white,
            title: const Text("Downloading..."),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LinearProgressIndicator(
                minHeight: 10,
                value: progress,
                backgroundColor: Colors.grey[300], // light grey track
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.green), // 🔹 green progress
              ),
                const SizedBox(height: 16),
                Text('${(progress * 100).toStringAsFixed(0)}%'),
              ],
            ),
          );
        },
      ),
    );

    // Download file
    final dio = Dio();
    await dio.download(
      url,
      savePath,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          progress = received / total;
          (context as Element).markNeedsBuild();
        }
      },
    );

    Navigator.pop(context);
    scaffold.showSnackBar(SnackBar(content: Text('Downloaded succesfully')));

  } catch (e) {
    try { Navigator.pop(context); } catch (_) {}
    scaffold.showSnackBar(SnackBar(content: Text('Error downloading file: $e')));
  }
}



Widget buildImageList(List<Map<String, String>> files,) {
  if (files.isEmpty) {
    return const Center(
      child: Text("No images uploaded yet"),
    );
  }
  return GridView.builder(
    padding: const EdgeInsets.all(12),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 0.8,
    ),
    itemCount: files.length,
    itemBuilder: (context, index) {
      final file = files[index];
      final fileName = file['name'] ?? "Unknown";
      final fileUrl = file['url'] ?? "";

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
                child: Image.network(
                  fileUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      fileName,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Wrap(
                    children: [
                      IconButton(
                        icon:
                            const Icon(Icons.visibility, color: Colors.white),
                        tooltip: "Preview",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ImagePreviewScreen(
                                imagePath: fileUrl,fileName: fileName,
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.download, color: Colors.yellow),
                        tooltip: "Download",
                        onPressed: ()=> downloadFileToExternal(fileUrl, fileName, context)
                      ),
                    ],
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

// 🔹 File List (PDFs)
Widget buildFileList(List<Map<String, String>> files,
   ) {
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
      final fileName = file['name'] ?? "Unknown";
      final fileUrl = file['url'] ?? "";

      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
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
            title: Text(fileName, overflow: TextOverflow.ellipsis),
            subtitle: const Text("PDF document"),
            trailing: Wrap(
              spacing: 10,
              children: [
                IconButton(
                  icon: const Icon(Icons.visibility, color: Colors.green),
                  tooltip: "Preview",
                  onPressed: () {
                     Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PdfsPreview(
                                fileUrl: fileUrl,fileName: fileName,
                              ),
                            ),
                          );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.download, color: Colors.orange),
                  tooltip: "Download",
                  onPressed: ()=>downloadFileToExternal(fileUrl, fileName, context)
                  ,
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
