import 'package:filegallery/viewer/screens/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class PdfsPreview extends StatefulWidget {
  final String fileUrl;
  final String fileName;

  const PdfsPreview({
    super.key,
    required this.fileUrl,
    required this.fileName,
  });

  @override
  State<PdfsPreview> createState() => _PdfsPreviewState();
}

class _PdfsPreviewState extends State<PdfsPreview> {
  late Future<String> _pdfFilePath;

  @override
  void initState() {
    super.initState();
    _pdfFilePath = _loadFile(widget.fileUrl, widget.fileName);
  }

Future<String> _loadFile(String url, String fileName) async {
  final dir = await getApplicationDocumentsDirectory(); // works on Android/iOS
  final filePath = '${dir.path}/$fileName';

  final dio = Dio();
  final response = await dio.get(
    url,
    options: Options(responseType: ResponseType.bytes),
  );

  final file = File(filePath);
  await file.writeAsBytes(response.data, flush: true);
  return file.path;
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:  Text(
          widget.fileName,
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
      body: FutureBuilder<String>(
        future: _pdfFilePath,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error loading PDF: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            return PDFView(filePath: snapshot.data!);
          } else {
            return const Center(child: Text('PDF not available'));
          }
        },
      ),
    );
  }
}
