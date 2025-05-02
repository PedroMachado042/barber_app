import 'package:flutter/material.dart';

class BookingConfirmWidget extends StatelessWidget {
  const BookingConfirmWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      //shape: BeveledRectangleBorder(),
      content: Container(
        height: 245,
        width: 260,
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Column(
          spacing: 15,
          children: [
            Row(
              children: [
                Icon(Icons.content_cut_sharp, size: 35),
                SizedBox(width: 25),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Corte'),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'R\$ 25,00',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(width: 40),
                        Icon(Icons.lock_clock, size: 18),
                        SizedBox(width: 5),
                        Text(
                          '45 min',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Center(
                  child: Text(
                    '19:00 -> 19:45',
                    style: TextStyle(fontSize: 22),
                  ),
                ),
                Container(
                  width: 80,
                  height: 80,
                  color: Colors.white10,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Abril', style: TextStyle(fontSize: 16)),
                        Text('30', style: TextStyle(fontSize: 20)),
                        Text('seg', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(200, 60),
                backgroundColor: const Color.fromARGB(
                  255,
                  196,
                  135,
                  5,
                ),
              ),
              onPressed: () {
              },
              child: Text(
                'Confirmar',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  inherit: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
