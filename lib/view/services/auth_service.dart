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
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

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
      await FirestoreService().checkIsADM();
      await FirestoreService().setUsername();
      await FirestoreService().createAccountDoc();
      isLogged.value = true;
      print('signup');
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MenuPage()),
      );
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = 'Digite uma senha mais forte';
      } else if (e.code == 'email-already-in-use') {
        message = 'Ja existe uma conta com este e-mail';
      } else if (e.code == 'invalid-email') {
        message = 'Email inválido!';
      } else if (e.code == 'channel-error') {
        message = 'Por favor, preencha todos os campos';
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
      await FirestoreService().checkIsADM();
      isLogged.value = true;
      print('signin');
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MenuPage()),
      );
      await FirestoreService().getAppointments();
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'invalid-email') {
        message = 'Email inválido!';
      }else if (e.code == 'user-not-found') {
        message = 'Nenhum usuário encontrado com este e-mail';
      }else if (e.code == 'invalid-credential') {
        message = 'Nenhuma conta encontrada com estes dados!';
      } else if (e.code == 'channel-error') {
        message = 'Por favor, preencha todos os campos';
      }
      print(e.code);
      Fluttertoast.showToast(
        msg: message,
        backgroundColor: Colors.black87,
      );
    } catch (e) {}
  }

  //--------------------------------------------------------------------------

  Future<void> signout(bool delete, context) async {
    final User? user = FirebaseAuth.instance.currentUser;
    String providerId = '';
    for (final userInfo in user!.providerData) {
      providerId = userInfo.providerId;
      print('Provider ID: ${userInfo.providerId}');
    }
    //logar com o google para deletar
    if (providerId == 'google.com') {
      final gUser = await _googleSignIn.signIn();
      if (gUser == null) return;

      final gAuth = await gUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );
      await firebaseAuth.signInWithCredential(credential);
    }
    if (delete) {
      try {
        await FirestoreService().deleteCollection();
        await FirebaseAuth.instance.currentUser!.delete();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'requires-recent-login') {
          Fluttertoast.showToast(
            msg: 'Por favor, faça login novamente e delete a conta para finalizar a operação.',
            backgroundColor: Colors.black87,
          );
          return;
        }
      }
    } else
      await FirebaseAuth.instance.signOut();
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

    final gUser = await _googleSignIn.signIn();
    if (gUser == null) return;
    final gAuth = await gUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );
    await firebaseAuth.signInWithCredential(credential);
    await FirestoreService().checkIsADM();
    await FirestoreService().setUsername();
    await FirestoreService().createAccountDoc();
    isLogged.value = true;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MenuPage()),
    );
    await FirestoreService().getAppointments();
  }
}
