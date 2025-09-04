// import 'dart:convert' show utf8;
// import 'dart:io' show File;

// import 'package:flutter/material.dart';
// // import 'package:archive/archive.dart';
// // import 'package:dio/dio.dart' ;
// // import 'package:get/get.dart' show Get, GetNavigation;
// // import 'package:school_campus/extension/constants.dart';
// // import 'package:flutter_pdfview/flutter_pdfview.dart';
// // import 'package:path_provider/path_provider.dart' show getApplicationDocumentsDirectory;

// class PdfsPreview extends StatefulWidget {
//   const PdfsPreview(
//       {super.key, });

//   @override
//   State<PdfsPreview> createState() => _PdfsPreviewState();
// }

// class _PdfsPreviewState extends State<PdfsPreview> {
//     late final String fileUrl;
//   late final String fileName;
//   @override
//   void initState() {
//     super.initState();
//       final args = Get.arguments;
//   if (args != null && args is Map<String, dynamic>) {
//   fileUrl  = args["fileUrl"]??'';
//   fileName = args["fileName"]??'';
//   }
//   }
//   Future<String> _loadFile(final url) async {
//     try {
//       // Create a temporary directory
//       var dir = await getApplicationDocumentsDirectory();
//       final filePath =
//           '${dir.path}/${DateTime.now().millisecondsSinceEpoch}_$fileName';

//       // Check if the directory exists
//       if (!dir.existsSync()) {
//         dir.createSync(recursive: true);
//       }

//       // Use Dio for network request
//       Dio dio = Dio();
//       Response response = await dio.get(
//         url,
//         options: Options(responseType: ResponseType.bytes),
//       );

//       File file = File(filePath);
//       file.writeAsBytesSync(response.data, flush: true);
//       return file.path;
//     } catch (e) {
//       throw Exception('Error loading file: $e');
//     }
//   }

//   Future<String> _extractDocxText(String filePath) async {
//     try {
//       final File file = File(filePath);
//       final bytes = file.readAsBytesSync();
//       final archive = ZipDecoder().decodeBytes(bytes);

//       for (final file in archive) {
//         if (file.name == 'word/document.xml') {
//           final content = utf8.decode(file.content as List<int>);
//           return _extractPlainTextFromXml(content);
//         }
//       }
//       throw Exception('Document content not found');
//     } catch (e) {
//       throw Exception('Error extracting DOCX content: $e');
//     }
//   }

//   String _extractPlainTextFromXml(String xmlContent) {
//     // A simple method to extract plain text from the DOCX XML content
//     final RegExp bodyRegExp = RegExp(r'<w:t>([^<]+)</w:t>', multiLine: true);
//     final Iterable<Match> matches = bodyRegExp.allMatches(xmlContent);
//     final StringBuffer buffer = StringBuffer();
//     for (final Match match in matches) {
//       buffer.write(match.group(1));
//       buffer.write(' '); // Add space to separate words
//     }
//     return buffer.toString();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//       leading: IconButton(
//             icon: const Icon(Icons.arrow_back),
//             onPressed: () {
//               Get.back();
//             },
//           ),
//         title: Text(fileName),
//       ),
//       body: FutureBuilder<String>(
//         future: _loadFile(fileUrl),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(
//                 child: Text(
//               'Error loading file: ${snapshot.error}',
//               style: font5,
//             ));
//           } else if (snapshot.hasData) {
//             final filePath = snapshot.data!;
//             if (fileName.endsWith('.pdf')) {
//               return PDFView(
//                 filePath: filePath,
//               );
//             } else if (fileName.endsWith('.jpg') ||
//                 fileName.endsWith('.jpeg') ||
//                 fileName.endsWith('.png')) {
//               return Center(
//                 child: Image.file(File(filePath)),
//               );
//             } else if (fileName.endsWith('.docx')) {
//               return FutureBuilder<String>(
//                 future: _extractDocxText(filePath),
//                 builder: (context, textSnapshot) {
//                   if (textSnapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   } else if (textSnapshot.hasError) {
//                     return Center(
//                         child: Text(
//                       'Error loading document: ${textSnapshot.error}',
//                       style: font5,
//                     ));
//                   } else if (textSnapshot.hasData) {
//                     final docxText = textSnapshot.data!;
//                     return SingleChildScrollView(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Text(
//                         docxText,
//                         style: font5,
//                       ),
//                     );
//                   } else {
//                     return Center(
//                         child: Text(
//                       'No data available',
//                       style: font5,
//                     ));
//                   }
//                 },
//               );
//             } else {
//               return Center(child: Text('Unsupported file type', style: font5));
//             }
//           } else {
//             return Center(child: Text('No data available', style: font5));
//           }
//         },
//       ),
//     );
//   }
// }