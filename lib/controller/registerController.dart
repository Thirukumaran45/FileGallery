import 'package:filegallery/enum/diaog.dart' show showTextDialog;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Create user with email & password
  Future<String> createEmailPassword(String email, String password,context) async {
    try {
      final user = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
     return user.user!.uid;
    } on FirebaseAuthException catch (e) {
      showTextDialog(context: context,message:"Error ! ${e.code}");
      throw Exception(e.message ?? "Something went wrong");
    }
  }

  /// Sign in with email & password
  Future<void> signInEmailPassword(String email, String password,context) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      showTextDialog(context: context,message:"Error ! ${e.code}");
      throw Exception(e.message ?? "Invalid email or password");
    }
  }


  Future<void> resetPassword({required String email,context}) async {
      try {
        await _auth.sendPasswordResetEmail(email: email.trim());
        showTextDialog(context: context, message: "Check mail for reset link ✅");
      } on FirebaseAuthException catch (e) {
       showTextDialog(context: context,message:"Error ! ${e.code}");
      throw Exception(e.message ?? "Invalid email");
      }
    
  }

  Future<void> acctSignOut(context)async{
     try {
        await _auth.signOut();
      } on FirebaseAuthException catch (e) {
       showTextDialog(context: context,message:"Error ! ${e.code}");
      throw Exception(e.message ?? "unknown error");
      }
  }

  /// Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
