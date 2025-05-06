import 'package:barber_app/view/pages/launch_page.dart';
import 'package:barber_app/view/services/firestore.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LaunchPage(),
      floatingActionButton: FloatingActionButton(foregroundColor: Colors.black,
        onPressed: () {
          bookingsBox.clear();
          print(bookingsBox.toMap());
        },
      ),
    );
  }
}
