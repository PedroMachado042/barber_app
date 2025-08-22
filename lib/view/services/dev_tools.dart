import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';

class DevTools {
  final User? user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final bookingsBox = Hive.box('bookingsBox');
  final calendarBox = Hive.box('calendarBox');

  Future<void> countProfessionalApointments() async {
    final query = FirebaseFirestore.instance
        .collection('Professionals')
        .doc('adm@gmail.com')
        .collection('agendamentos');
    final aggregateSnapshot = await query.count().get();
    print(
      "O profissional tem: ${aggregateSnapshot.count} agendamentos",
    );
  }

  Future<void> ReloadAllProfessionalAppointments(String prof) async {
    List<List<dynamic>> todosAgendamentos = [];
    int contadorDeAgendamentos = 0;
    int i = 0;

    final clientsSnapshot =
        await FirebaseFirestore.instance.collection('Clients').get();

    for (final clientDoc in clientsSnapshot.docs) {
      final user_email = clientDoc.id;
      //print(user_email);
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance
              .collection('Clients')
              .doc(user_email)
              .collection('agendamentos')
              .get();
      for (DocumentSnapshot doc in snapshot.docs) {
        if (doc['name'] == 'Corte') {
          await doc.reference.update({'price': '35,00'});
        }
        todosAgendamentos.add([
          user_email,
          doc['icon'],
          doc['name'],
          doc['price'],
          doc['time'],
          doc['timestamp'],
        ]);
        await firestore
            .collection('Professionals')
            .doc(prof)
            .collection('agendamentos')
            .doc('agendamento$i')
            .set({
              'icon': doc['icon'],
              'name': doc['name'],
              'price': doc['price'],
              'time': doc['time'],
              'client': user_email,
              'timestamp': doc['timestamp'],
            });
        i++;
        //email, icon, name, price, time, timestamp
      }
    }
    print(todosAgendamentos.length);
    print(contadorDeAgendamentos);
  }
}
