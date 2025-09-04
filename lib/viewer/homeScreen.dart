import 'package:filegallery/viewer/Login.dart';
import 'package:filegallery/viewer/widgets/layouts.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final String username; // pass from login
  const HomeScreen({super.key, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  // Dummy lists for now (replace with Firebase data later)
  final List<String> images = ["assets/profile.jpg", "assets/profile.jpg","assets/profile.jpg",
  "assets/profile.jpg","assets/profile.jpg","assets/profile.jpg","assets/profile.jpg"];
  final List<String> pdfs = ["notes.pdf", "resume.pdf"];

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
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  height: 180,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 🔹 Username at top
                      Text( " Are you sure, ${widget.username} ?",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // 🔹 Logout button at bottom
                      ElevatedButton.icon(
                        onPressed: () {
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
        body: TabBarView(
          children: [
            // Images Tab
            buildImageList(images),
            // PDFs Tab
            buildFileList(pdfs, isImage: false),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // TODO: file_picker + Firebase Storage upload
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
