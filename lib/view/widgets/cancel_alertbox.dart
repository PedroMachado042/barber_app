import 'package:barber_app/data/notifiers.dart';
import 'package:barber_app/view/services/firestore.dart';
import 'package:flutter/material.dart';

class CancelAlertbox extends StatelessWidget {
  const CancelAlertbox({
    super.key,
    required this.id,
    required this.email,
    required this.excludingPastBooking,
  });
  final int id;
  final String email;
  final bool excludingPastBooking;
  @override
  Widget build(BuildContext context) {
    print(excludingPastBooking);
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
              excludingPastBooking?'Excluir Horário': 'Cancelar Horário?',
              style: TextStyle(fontSize: 25),
              textAlign: TextAlign.left,
            ),
            Text(
              isADM.value
                  ? (excludingPastBooking?'Deseja excluir o horário do sistema?': 'Deseja cancelar o horário desse cliente?')
                  : 'Favor cancelar com pelo menos uma hora de antecedência',
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
                    excludingPastBooking?'Excluir': 'Cancelar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    FirestoreService().cancelHorario(id, email);
                    Navigator.pop(context);
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
