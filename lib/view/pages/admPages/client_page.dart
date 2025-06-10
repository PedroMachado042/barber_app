import 'package:barber_app/data/notifiers.dart';
import 'package:barber_app/view/widgets/appointment_tile_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ClientPage extends StatefulWidget {
  const ClientPage({super.key, required this.userData});
  final Map userData;

  @override
  State<ClientPage> createState() => _ClientPageState();
}

class _ClientPageState extends State<ClientPage> {
  final bookingsBox = Hive.box('bookingsBox');
  @override
  void initState() {
    super.initState();
    sortByDate(bookingsBox.values.toList());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Clientes'),
        backgroundColor: CupertinoColors.placeholderText,
      ),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            Icon(Icons.people_alt, color: Colors.amber, size: 40),
            Divider(),
            SizedBox(height: 20),
            Column(
              spacing: 10,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.black45,
                  foregroundImage: AssetImage(
                    'assets/images/guestPic.png',
                  ),
                ),
                Text(
                  widget.userData['username'],
                  style: TextStyle(fontSize: 25),
                ),
                Text(
                  widget.userData['email'],
                  style: TextStyle(color: Colors.white60),
                ),
                SizedBox(height: 10,),
                ValueListenableBuilder<int>(
                  valueListenable: bookingsLenght,
                  builder: (context, value, child) {
                    print(bookingsBox.values.toList());
                    return bookingsLenght.value != 0
                        ? Container(
                          height: 290,
                          child: SingleChildScrollView(
                            child: Column(
                              children: List.generate(
                                value,
                                (index) => AppointmentsTile(
                                  id:
                                      (bookingsLenght.value - 1) -
                                      index,
                                  email: widget.userData['email'],
                                ),
                              ),
                            ),
                          ),
                        )
                        : Container(
                          height: 290,
                          child: Column(
                            children: [
                              Text(
                                'Ainda não há agendamentos',
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.white38,
                                ),
                              ),
                            ],
                          ),
                        );
                  },
                ),/*
                SizedBox(height: 10),
                SizedBox(
                  width: 250,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(
                        159,
                        128,
                        9,
                        9,
                      ),
                    ),
                    child: Text(
                      'Deletar Conta',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),*/
              ],
            ),
          ],
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
