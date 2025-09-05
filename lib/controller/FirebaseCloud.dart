import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filegallery/enum/diaog.dart' show showTextDialog;
import 'package:flutter/material.dart';

class FirebaseCloud extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Creates a user with email & password and stores additional data in Firestore
  Future<void> createUser({
    required String name,
    required String email,
    required String uid,
    context
  }) async {
    try {

      await _firestore.collection('filegallery').doc(uid).set({
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      showTextDialog(context: context,message: e.code);
      throw Exception(e.message ?? "Something went wrong");
    } catch (e) {
      showTextDialog(context: context,message: e.toString());
    }
  }

  Future<String> getuserName({required uid})async{
 final data =  await _firestore.collection('filegallery').doc(uid).get();
 String name = data["name"]??"";
 return name;
  }
}
