import 'package:barber_app/view/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DrawerPage extends StatefulWidget {
  const DrawerPage({super.key});

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  final User? user = FirebaseAuth.instance.currentUser;

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
                    user!.displayName!,
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    user!.email!,
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
            AuthService().signout(false, context);
          },
        ),/*
        ListTile(
          leading: Icon(Icons.delete_forever, color: Colors.red),
          title: Text(
            "Deletar Conta",
            style: TextStyle(color: Colors.red),
          ),
          onTap: () {
            print(bookingsLenght.value);
            bookingsLenght.value>0?showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  actionsAlignment: MainAxisAlignment.center,
                  title: Text('Deletar Conta?'),
                  content: Text('Cancele todos os agendamentos pendentes antes de deletar a conta'),
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
            ):
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  actionsAlignment: MainAxisAlignment.spaceBetween,
                  title: Text('Deletar Conta?'),
                  content: Text('Tem certeza? A conta será permanentemente deletada do sistema.'),
                  actions: [
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
                      child: Text('Cancelar'),
                    ),
                  ],
                );
              },
            );
          },
        ),*/
      ],
    );
  }
}
