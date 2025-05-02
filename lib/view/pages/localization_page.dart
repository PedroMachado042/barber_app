import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LocalizationPage extends StatelessWidget {
  const LocalizationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Sobre Nós'),
        backgroundColor: CupertinoColors.placeholderText,
      ),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          spacing: 5,
          children: [
            Icon(
              Icons.location_on_sharp,
              color: Colors.amber,
              size: 40,
            ),
            Divider(),
            Column(
              children: [
                CircleAvatar(
                  radius: 100,
                  foregroundImage: AssetImage('assets/images/front.png')
                  ),
                SizedBox(height: 10),
                Text(
                  'Barbearia Premium',
                  style: TextStyle(fontSize: 28),
                ),
                SizedBox(height: 20),
                Text(
                  'Quem somos nós?',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 196, 134, 2),
                    fontSize: 22,
                  ),
                ),
                Text(
                  textAlign: TextAlign.center,
                  'A premium é uma barbearia que preza pelo bem estar do cliente em um ambiente acolhedor.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  'Endereço:',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 196, 134, 2),
                    fontSize: 22,
                  ),
                ),
                Text(
                  textAlign: TextAlign.center,
                  'Rua Santo Antonio, 217 Sala 01, Barros Cassal, RS',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 90),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt_outlined),
                    Text(
                      ' barbearia_premium.bc',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.phone),
                    Text(
                      ' (54) 996999462',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
