import 'package:barber_app/view/services/firestore.dart';
import 'package:flutter/material.dart';

class CancelAlertbox extends StatelessWidget {
  const CancelAlertbox({super.key, required this.id});
  final int id;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      //shape: BeveledRectangleBorder(),
      content: Container(
        height: 160,
        width: 300,
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          spacing: 15,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Cancelar Horário?',
              style: TextStyle(fontSize: 25),
              textAlign: TextAlign.left,
            ),
            Text(
              'Favor cancelar com pelo menos uma hora de antecedência',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black38,
                  ),
                  child: Text(
                    'Voltar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                      171,
                      244,
                      67,
                      54,
                    ),
                  ),
                  child: Text(
                    'Cancelar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    FirestoreService().cancelHorario(id);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
