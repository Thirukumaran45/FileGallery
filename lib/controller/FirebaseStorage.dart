import 'dart:developer' show log;
import 'dart:io';
import 'package:filegallery/enum/diaog.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

class FirebaseFileService extends ChangeNotifier{
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Upload a file (image or PDF) and store info in Firestore
  /// Upload a file (image or PDF) and store info in Firestore
  Future<void> uploadFile(File file, context, uid) async {
    try {
      String fileName = path.basename(file.path);
      String ext = path.extension(fileName).toLowerCase();

      if (ext != '.png' && ext != '.jpg' && ext != '.jpeg' && ext != '.pdf') {
        showTextDialog(context: context, message: "Please select images and PDF files!");
        throw Exception('Only images (png/jpg) and PDFs are allowed.');
      }

      // Choose folder based on extension
      String folder = (ext == '.pdf') ? 'pdfs' : 'images';
      Reference ref = _storage.ref().child('$folder/$fileName');
      UploadTask uploadTask = ref.putFile(file);

      // 🔹 Show dialog with progress bar
   showDialog(
  context: context,
  barrierDismissible: false,
  builder: (context) {
    return AlertDialog(
      backgroundColor: Colors.white, // 🔹 White background
      title: const Text(
        "Uploading ...",
        style: TextStyle(color: Colors.black), // ensure text is visible
      ),
      content: StreamBuilder<TaskSnapshot>(
        stream: uploadTask.snapshotEvents,
        builder: (context, snapshot) {
          double progress = 0;
          if (snapshot.hasData) {
            progress = snapshot.data!.bytesTransferred / snapshot.data!.totalBytes;
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LinearProgressIndicator(
                minHeight: 10,
                value: progress,
                backgroundColor: Colors.grey[300], // light grey track
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.green), // 🔹 green progress
              ),
              const SizedBox(height: 16),
              Text(
                "${(progress * 100).toStringAsFixed(0)} %",
                style: const TextStyle(color: Colors.black),
              ),
            ],
          );
        },
      ),
    );
  },
);

      TaskSnapshot snapshot = await uploadTask;
      Navigator.pop(context); // close dialog after upload finishes

      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Subcollection under the user document
      CollectionReference userFiles = _firestore
          .collection('filegallery')
          .doc(uid)
          .collection('files');

      // Prepare data based on extension
      Map<String, dynamic> data;
      if (ext == '.pdf') {
        data = {
          'pdfName': fileName,
          'pdfUrl': downloadUrl,
          'uploadedAt': FieldValue.serverTimestamp(),
        };
      } else {
        data = {
          'imageName': fileName,
          'imageUrl': downloadUrl,
          'uploadedAt': FieldValue.serverTimestamp(),
        };
      }

      await userFiles.add(data);
      log('File uploaded and data saved to Firestore.');
    } catch (e) {
      Navigator.pop(context); // make sure dialog closes on error
      log('Error uploading file: $e');
    }
  }

  /// Get all files for current user
   /// Get all files for current user, separated into images and pdfs
 Future<Map<String, List<Map<String, String>>>> getAllFiles(uid) async {
  try {
    QuerySnapshot snapshot = await _firestore
        .collection('filegallery')
        .doc(uid)
        .collection('files')
        .get();

    List<Map<String, String>> imageList = [];
    List<Map<String, String>> pdfList = [];

    for (var doc in snapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      if (data.containsKey('imageName') && data.containsKey('imageUrl')) {
        imageList.add({
          'name': data['imageName'],
          'url': data['imageUrl'],
        });
      } else if (data.containsKey('pdfName') && data.containsKey('pdfUrl')) {
        pdfList.add({
          'name': data['pdfName'],
          'url': data['pdfUrl'],
        });
      }
    }

    return {
      'images': imageList,
      'pdfs': pdfList,
    };
  } catch (e) {
    log('Error fetching files: $e');
    return {
      'images': [],
      'pdfs': [],
    };
  }
}
}