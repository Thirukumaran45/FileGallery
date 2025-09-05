import 'package:filegallery/controller/FirebaseCloud.dart';
import 'package:filegallery/controller/FirebaseStorage.dart';
import 'package:filegallery/controller/registerController.dart';
import 'package:filegallery/viewer/screens/Login.dart';
import 'package:filegallery/viewer/screens/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart' show ChangeNotifierProvider, MultiProvider;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=> FirebaseCloud() ),
        ChangeNotifierProvider(create: (context)=> FirebaseFileService() ),
        ChangeNotifierProvider(create: (context)=> RegisterController() ),
      ],
      child: MaterialApp(
        title: 'Firebase Auth Check',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: AuthWrapper(), // <-- Wrapper to decide where to go
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if user is already logged in
    final user = RegisterController().getCurrentUser();

    if (user != null) {
      // User is logged in, go to HomePage
      return HomeScreen();
    } else {
      // User is NOT logged in, go to LoginPage
      return LoginScreen();
    }
  }
}
