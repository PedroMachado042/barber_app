import 'package:barber_app/data/notifiers.dart';
import 'package:barber_app/view/pages/menu_page.dart';
import 'package:barber_app/view/services/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final bookingsBox = Hive.box('bookingsBox');

  Future<void> signup({
    required String username,
    required String email,
    required String password,
    required context,
  }) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
      await userCredential.user!.updateDisplayName(username);
      isLogged.value = true;
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MenuPage()),
      );
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists with that email.';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is not valid.';
      } else if (e.code == 'channel-error') {
        message = 'Please fill both fields';
      }
      print(e.code);
      Fluttertoast.showToast(
        msg: message,
        backgroundColor: Colors.black87,
      );
    } catch (e) {}
  }

  //--------------------------------------------------------------------------

  Future<void> signin({
    required String email,
    required String password,
    required context,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      isLogged.value = true;
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MenuPage()),
      );
      await FirestoreService().getAppointments();
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'user-not-found' || e.code == 'invalid-email') {
        message = 'No user found for that email';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password!';
      } else if (e.code == 'channel-error') {
        message = 'Please fill both fields';
      }
      print(e.code);
      Fluttertoast.showToast(
        msg: message,
        backgroundColor: Colors.black87,
      );
    } catch (e) {}
  }

  //--------------------------------------------------------------------------

  Future<void> signout(bool delete,context) async {
    delete
        ? [
          await FirestoreService().deleteCollection(),
          await FirebaseAuth.instance.currentUser!.delete(),
        ]
        : await FirebaseAuth.instance.signOut();
    isLogged.value = false;
    bookingsLenght.value = 0;
    bookingsBox.clear();
    print('signout');
    Phoenix.rebirth(context);
  }

  //--------------------------------------------------------------------------

  Future<void> noUsername() async {
    Fluttertoast.showToast(
      msg: 'Type a username',
      backgroundColor: Colors.black87,
    );
  }

  Future<void> updateUsername(String newUsername) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await user.updateDisplayName(newUsername);
      await user.reload();
      user = FirebaseAuth.instance.currentUser;
    }
  }

  Future<void> signInWithGoogle(context) async {
    await GoogleSignIn().signOut();

    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    if (gUser == null) return;

    final GoogleSignInAuthentication gAuth =
        await gUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );
    await firebaseAuth.signInWithCredential(credential);
    isLogged.value = true;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MenuPage()),
    );
    await FirestoreService().getAppointments();
  }
}
