import 'dart:developer' show log;
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:filegallery/controller/FirebaseCloud.dart';
import 'package:filegallery/controller/FirebaseStorage.dart';
import 'package:filegallery/controller/registerController.dart';
import 'package:filegallery/viewer/screens/Login.dart';
import 'package:filegallery/viewer/widgets/layouts.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key,});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {


  String? userName,uid;
  late final RegisterController controller ;
  late final FirebaseCloud cloudController ;
  late final FirebaseFileService _firebaseService ;
  List<Map<String,String>> images = [];
  List<Map<String,String>> pdfs = [];
   bool isLoading = true; 

@override
  void initState() {
    super.initState();
   controller = RegisterController();
   cloudController = FirebaseCloud();
  _firebaseService = FirebaseFileService();
    userData();
  }

void userData() async {
  final user = controller.getCurrentUser();
  String? name = await cloudController.getuserName(uid: user!.uid);

  var files = await _firebaseService.getAllFiles(user.uid);

  setState(() {
    userName = name;
    uid = user.uid;
    images = files['images'] ?? []; // List<Map<String,String>>
    pdfs = files['pdfs'] ?? [];     // List<Map<String,String>>
     isLoading = false; 
  });
}




Future<void> _pickAndUploadFile() async {
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg', 'pdf'],
    );

    if (result != null && result.files.isNotEmpty) {
      File file = File(result.files.single.path!);

      // Upload file
      await _firebaseService.uploadFile(file, context, uid);

      // 🔹 Refresh list
      var files = await _firebaseService.getAllFiles(uid);
      setState(() {
        images = files['images'] ?? [];
        pdfs = files['pdfs'] ?? [];
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'File uploaded successfully!',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
      );
    }
  } catch (e) {
    log("Error picking/uploading file: $e");
  }
}


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Images | PDFs
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          leadingWidth: 180, // make space for profile + name
          leading: Row(
            children: [
              const SizedBox(width: 30),
              const CircleAvatar(
                backgroundImage: AssetImage("assets/profile.jpg"),
                radius: 24,
              ),
              const SizedBox(width:18),
              Expanded(
                child: Text(
                 "Hi, there !",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          actions: [
            InkWell(
              onTap: () {
               showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) {
                return Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  height: 180,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 🔹 Username at top
                      Text( "Hey , $userName are sure about to log out 😔 ? ",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // 🔹 Logout button at bottom
                      ElevatedButton.icon(
                        onPressed: ()async {
                          await controller.acctSignOut(context);
                          Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>  LoginScreen()),
                        (route) => false);
                        },
                        icon: const Icon(Icons.logout,color: Colors.white,),
                        label: const Text("Log Out",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                color: Colors.white,
                  shape: BoxShape.circle
                ),
                child:const Icon(Icons.logout,color: Colors.red,) ,
              ),
             
            ),
            SizedBox(width: 20,)
          ],
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white, // selected tab color
            unselectedLabelColor: Colors.white70, // non-selected color
            tabs:  [
              Tab(child: Row(
                
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Icon(Icons.image),
                 ),Text("Images",style: TextStyle(fontSize: 16),)
              ],),),
              Tab(child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Icon(Icons.picture_as_pdf),
                 ),Text("PDFs",style: TextStyle(fontSize: 16),)
              ],),),
            ],
          ),
        ),
        body:  isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.blue,)) // 🔹 Loader while fetching
            :
        TabBarView(
          children: [
            // Images Tab
            buildImageList(images),
            // PDFs Tab
            buildFileList(pdfs),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            _pickAndUploadFile();
          },
          backgroundColor: const Color.fromARGB(255, 230, 86, 86),
          foregroundColor: Colors.white,
          label: const Text("File",style: TextStyle(fontSize: 20),),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }
}
