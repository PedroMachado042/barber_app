import 'package:flutter/material.dart';

class TooManyAlertbox extends StatelessWidget {
  const TooManyAlertbox({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      //shape: BeveledRectangleBorder(),
      content: Container(
        height: 190,
        width: 260,
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: Column(
          spacing: 15,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cancel_outlined, size: 100, color: Colors.red),
            Text(
              'Você já possui muitos agendamentos pendentes!',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
