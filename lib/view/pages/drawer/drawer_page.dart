import 'package:barber_app/data/notifiers.dart';
import 'package:barber_app/view/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:hive/hive.dart';

class DrawerPage extends StatefulWidget {
  const DrawerPage({super.key});

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  final User? user = FirebaseAuth.instance.currentUser;
  final bookingsBox = Hive.box('bookingsBox');
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: double.infinity,
              height: 220,
              color: Colors.teal,
            ),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 50),
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: const Color.fromARGB(
                      255,
                      143,
                      98,
                      2,
                    ),
                    backgroundImage:
                        user?.photoURL != null
                            ? NetworkImage(user!.photoURL!)
                            : AssetImage(
                              'assets/images/guestPic.png',
                            ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    isLogged.value ? user!.displayName! : "Convidado",
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    isLogged.value ? user!.email! : "",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text("Sair"),
          onTap: () {
            isLogged.value
                ? AuthService().signout(false, context)
                : Phoenix.rebirth(context);
          },
        ),
        isLogged.value?
        ListTile(
          leading: Icon(Icons.delete_forever, color: Colors.red),
          title: Text(
            "Deletar Conta",
            style: TextStyle(color: Colors.red),
          ),
          onTap: () {
            List<dynamic> appointments = sortByDate(
              bookingsBox.values.toList(),
            );
            print(appointments);
            bool hasPendingAppointments = false;
            for (int i = 0; i < appointments.length; i++) {
              if (appointments[i][3] == false) {
                print('ESSE AQUI TA MARCADO AINDA');
                hasPendingAppointments = true;
              }
            }
            hasPendingAppointments
                ? showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      actionsAlignment: MainAxisAlignment.center,
                      title: Text('Deletar Conta?'),
                      content: Text(
                        'Cancele todos os agendamentos pendentes antes de deletar a conta',
                      ),
                      actions: [
                        FilledButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              255,
                              190,
                              189,
                              192,
                            ), // soft lavender
                            foregroundColor: Colors.black87,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 28,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                          child: Text('Voltar'),
                        ),
                      ],
                    );
                  },
                )
                : showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      actionsAlignment:
                          MainAxisAlignment.spaceBetween,
                      title: Text('Deletar Conta?'),
                      content: Text(
                        'Tem certeza? A conta será permanentemente deletada do sistema.',
                      ),
                      actions: [
                        FilledButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              255,
                              190,
                              189,
                              192,
                            ), // soft lavender
                            foregroundColor: Colors.black45,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 28,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: Text(
                            'Cancelar',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        FilledButton(
                          onPressed: () async {
                            AuthService().signout(true, context);
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              255,
                              26,
                              26,
                              26,
                            ),
                            foregroundColor: Colors.redAccent,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 28,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                          child: Text(
                            'Deletar',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    );
                  },
                );
          },
        ):SizedBox(),
      ],
    );
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
}
