import 'package:barber_app/view/pages/admPages/client_page.dart';
import 'package:barber_app/view/services/firestore.dart';
import 'package:flutter/material.dart';

class ClientTileWidget extends StatelessWidget {
  const ClientTileWidget({super.key, required this.userData});
  final Map userData;
  @override
  Widget build(BuildContext context) {
    List<String> names = userData['username']!.split(' ');
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () async{
            await FirestoreService().getAppointments(userData['email']);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ClientPage(userData: userData),
              ),
            );
          },
          child: Column(
            children: [
              SizedBox(height: 20),
              CircleAvatar(
                radius: 25,
                foregroundImage: AssetImage(
                  'assets/images/guestPic.png',
                ),
              ),
              SizedBox(height: 5),
              SizedBox(
                height: 40,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(names[0], style: TextStyle(fontSize: 13)),
                    if (names.length > 1)
                      Text(names[1], style: TextStyle(fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
