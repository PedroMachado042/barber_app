import 'package:barber_app/view/pages/launch_page.dart';
import 'package:barber_app/view/services/firestore.dart';
import 'package:flutter/material.dart';


class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {

  FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LaunchPage(),
    );
  }
}
