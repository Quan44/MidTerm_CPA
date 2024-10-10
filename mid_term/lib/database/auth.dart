import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mid_term/pages/loginPage.dart';

class FirebaseAuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = 
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } catch (e) {
      print("Some error occured");
      print(e);
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } catch (e) {
      print("Some error occured");
    }
    return null;
  }
}

signOutUser(BuildContext ctx) {
  FirebaseAuth.instance.signOut().then(
        // ignore: use_build_context_synchronously
        (value) => Navigator.of(ctx).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginPage()),
            (Route<dynamic> route) => false),
      );
}

// String? validateEmail(String? formEmail) {
//   if (formEmail == null || formEmail.isEmpty) {
//     return 'Email không được để trống';
//   }

//   return null;
// }

// String? validatePassword(String? formpass) {
//   if (formpass == null || formpass.isEmpty) {
//     return 'Mật khẩu không được để trống';
//   }
//   return null;
// }