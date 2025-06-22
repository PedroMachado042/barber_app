import 'package:barber_app/data/notifiers.dart';
import 'package:barber_app/view/pages/SelfDestruct_page.dart';
import 'package:barber_app/view/pages/launch_page.dart';
import 'package:barber_app/view/pages/menu_page.dart';
import 'package:barber_app/view/services/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  FirestoreService firestoreService = FirestoreService();
  final bookingsBox = Hive.box('bookingsBox');
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    checkSelfDestruct();
    if (user != null) {
      isLogged.value = true;
      if(isADM==false)
      {
        FirestoreService().getAppointments();
      }
    }
  }

  void checkSelfDestruct() async {
    if (await FirestoreService().checkSelfDestruct()) {
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => SelfdestructPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: isLogged,
        builder: (context, isLogged, child) {
          return !isLogged ? LaunchPage() : MenuPage();
        },
      ),
      /*
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.black,
        onPressed: () async {
          //print(user);
          //print(isLogged);
          //print(horariosBox.values);
          //print(bookingsBox.values);
          //print(servicesBox.values);
          FirestoreService().changeHorarios(
            'adm@gmail.com',
            DummyData.horarios,
          );
          print(await FirestoreService().countUsers());
          await FirestoreService().checkIsADM();
        },
      ),*/
    );
  }
}
