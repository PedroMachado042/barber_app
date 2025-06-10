import 'package:barber_app/data/notifiers.dart';
import 'package:barber_app/view/widgets/appointment_tile_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key});

  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  final bookingsBox = Hive.box('bookingsBox');
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    print(bookingsBox.values.toList());
    sortByDate(bookingsBox.values.toList());
  }

  @override
  Widget build(BuildContext context) {
    bookingsLenght.value = bookingsBox.length;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Meus Horários'),
        backgroundColor: CupertinoColors.placeholderText,
      ),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: SizedBox(
          height: 600,
          child: SingleChildScrollView(
            child: Column(
              spacing: 5,
              children: [
                Icon(
                  Icons.calendar_month,
                  color: Colors.amber,
                  size: 40,
                ),
                Divider(),
                ValueListenableBuilder<int>(
                  valueListenable: bookingsLenght,
                  builder: (context, value, child) {
                    print(bookingsBox.values.toList());
                    return bookingsLenght.value != 0
                        ? Column(
                          children: List.generate(
                            value,
                            (index) => AppointmentsTile(
                              id: (bookingsLenght.value - 1) - index,email: user!.email!
                            ),
                          ),
                        )
                        : Column(
                          children: [
                            SizedBox(height: 50),
                            Text(
                              'Ainda não há agendamentos',
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.white38,
                              ),
                            ),
                          ],
                        );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

List<dynamic> sortByDate(List<dynamic> dados) {
  final bookingsBox = Hive.box('bookingsBox');
  for (int i = 0; i < dados.length; i++) {
    DateTime date =
        dados[i][2] is String
            ? DateTime.parse(dados[i][2])
            : dados[i][2];
    if (date.isBefore(DateTime.now())) {
      dados[i][3] = true;
    } else {
      dados[i][3] = false;
    }
    bookingsBox.put(i, dados[i]);
  }
  dados.sort((a, b) {
    DateTime dateA = a[2] is String ? DateTime.parse(a[2]) : a[2];
    DateTime dateB = b[2] is String ? DateTime.parse(b[2]) : b[2];
    return dateB.compareTo(dateA);
  });
  List<dynamic> future =
      dados.where((item) => item[3] == false).toList();
  List<dynamic> past =
      dados.where((item) => item[3] == true).toList();
  List<dynamic> sorted = [...past, ...future];
  for (int i = 0; i < sorted.length; i++) {
    bookingsBox.put(i, sorted[i]);
  }
  return sorted;
}
