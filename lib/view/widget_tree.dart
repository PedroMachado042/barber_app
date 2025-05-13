import 'package:barber_app/data/dummy_data.dart';
import 'package:barber_app/data/notifiers.dart';
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
    if (user != null) {
      isLogged.value = true;
      FirestoreService().getAppointments();
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
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.black,
        onPressed: () {
          print(user);
          print(isLogged);
          //bookingsBox.clear();
          print(horariosBox.values);
          print(bookingsBox.values);
          print(servicesBox.values);
          loadHorarios();
          FirestoreService().changeHorarios(
            'rose@gmail.com',
            DummyData.horarios,
          );
        },
      ),
    );
  }
}
