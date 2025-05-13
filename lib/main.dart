import 'package:barber_app/data/notifiers.dart';
import 'package:barber_app/view/services/firestore.dart';
import 'package:barber_app/view/widget_tree.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // initialize hive;
  await Hive.initFlutter();
  // ignore: unused_local_variable
  var servicesBox = await Hive.openBox('servicesBox');
  // ignore: unused_local_variable
  var bookingsBox = await Hive.openBox('bookingsBox');
  // ignore: unused_local_variable
  var horariosBox = await Hive.openBox('horariosBox');
  servicesLenght.value = servicesBox.length;
  bookingsLenght.value = bookingsBox.length;
  await FirestoreService().loadServices();
  print(DateTime.now());
  runApp(Phoenix(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      debugShowCheckedModeBanner: false,
      home: WidgetTree(),
    );
  }
}
