import 'package:flutter/material.dart';

class ConfirmedAlertbox extends StatelessWidget {
  const ConfirmedAlertbox({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      //shape: BeveledRectangleBorder(),
      content: Container(
        height: 190,
        width: 260,
        padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
        child: Column(
          spacing: 15,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(Icons.check, size: 100,color: Colors.green,), Text('Agendado!', style: TextStyle(fontSize: 40),)],
        ),
      ),
    );
  }
}