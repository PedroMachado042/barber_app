import 'package:barber_app/data/dummy_data.dart';
import 'package:barber_app/data/notifiers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';

class FirestoreService {
  final User? user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final bookingsBox = Hive.box('bookingsBox');
  final calendarBox = Hive.box('calendarBox');

  Future<void> loadServices() async {
    int i = 0;
    servicesBox.clear();
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('Services').get();
    for (DocumentSnapshot doc in snapshot.docs) {
      servicesBox.put(i, [
        doc['icon'],
        doc['name'],
        doc['value'],
        doc['time'],
      ]);
      i += 1;
    }
  }

  Future<void> loadHorarios(String prof, String date) async {
    int i = 0;
    horariosBox.clear();
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance
            .collection('Professionals')
            .doc(prof)
            .collection('horarios')
            .doc('horariosLivres')
            .get();
    final data = snapshot.data() as Map<String, dynamic>?;
    //print(data!.length);
    //print(data[date]);
    //print(horariosBox.values);
    if (data![date] == null) {
      await createHorarios(prof, date);
      return;
    }
    for (String s in data[date]) {
      // adicionar do firebase pra box
      horariosBox.put(i, s);
      i += 1;
    }
    horariosLenght.value = horariosBox.length;
  }

  Future<void> createHorarios(String prof, String date) async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance
            .collection('Professionals')
            .doc(prof)
            .collection('horarios')
            .doc('horariosTotal')
            .get();
    await FirebaseFirestore.instance
        .collection('Professionals')
        .doc(prof)
        .collection('horarios')
        .doc('horariosLivres')
        .set({date: snapshot.get('total')}, SetOptions(merge: true));
    await FirestoreService().loadHorarios(prof, date);
  }

  Future<void> reservarHorario(
    String prof,
    String date,
    String time,
    int serviceNum,
    String preparedTime,
  ) async {
    await FirebaseFirestore.instance
        .collection('Professionals')
        .doc(prof)
        .collection('horarios')
        .doc('horariosLivres')
        .update({
          date: FieldValue.arrayRemove([time]),
        });
    QuerySnapshot agendamentosLenght =
        await FirebaseFirestore.instance
            .collection('Professionals')
            .doc(prof)
            .collection('agendamentos')
            .get();
    await firestore
        .collection('Professionals')
        .doc(prof)
        .collection('agendamentos')
        .doc('agendamento${agendamentosLenght.docs.length}')
        .set({
          'icon': servicesBox.get(serviceNum)[0],
          'name': servicesBox.get(serviceNum)[1],
          'time': preparedTime,
          'client': user!.email,
          'timestamp': Timestamp.now(),
        });
  }

  Future<void> changeHorarios(String prof, List newHorarios) async {
    await firestore
        .collection('Professionals')
        .doc(prof)
        .collection('horarios')
        .doc('horariosTotal')
        .set({'total': newHorarios});
  }

  Future<void> setAppointments(
    int serviceNum,
    String time,
    String prof,
  ) async {
    await firestore
        .collection('Clients')
        .doc(user!.email!)
        .collection('agendamentos')
        .doc('agendamento${bookingsBox.length - 1}')
        .set({
          'icon': servicesBox.get(serviceNum)[0],
          'name': servicesBox.get(serviceNum)[1],
          'time': time,
          'prof': prof,
          'timestamp': Timestamp.now(),
        });
  }

  Future<void> getAppointments() async {
    int i = 0;
    bookingsBox.clear();
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance
            .collection('Clients')
            .doc(user!.email!)
            .collection('agendamentos')
            .get();
    for (DocumentSnapshot doc in snapshot.docs) {
      bookingsBox.put(i, [
        doc['icon'],
        doc['name'],
        DateTime.parse(doc['time']),
        false,
      ]);
      i += 1;
    }
    bookingsLenght.value = i;
  }

  Future<void> deleteCollection() async {
    /*
    final collection = FirebaseFirestore.instance.collection(
      user!.email!,
    );

    final snapshot = await collection.get();
    for (DocumentSnapshot doc in snapshot.docs) {
      await doc.reference.delete();
    }
  */
  }

  Future<void> checkIsADM() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance
            .collection('Professionals')
            .get();
    for (DocumentSnapshot doc in snapshot.docs) {
      if (user != null)
        if (doc.id == user!.email!) {
          isADM.value = true;
          return;
        }
    }
    isADM.value = false;
  }

  Future<void> setUsername() async {
    await FirebaseFirestore.instance
        .collection(isADM.value ? 'Professionals' : 'Clients')
        .doc(user!.email)
        .collection('username')
        .doc('username')
        .set({'name': user!.displayName});
  }

  Future<void> getCalendarPage(
    int pageDay,
    int pageMonth,
    int pageYear,
  ) async {
    //pegar todos os agendamentos de um dia especifico e botar na box calendarBox
    int i = 0;
    calendarBox.clear();
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance
            .collection('Professionals')
            .doc(user!.email!)
            .collection('agendamentos')
            .get();
    for (DocumentSnapshot doc in snapshot.docs) {
      DateTime bookingTime = DateTime.parse(doc['time']);
      if (bookingTime.day == pageDay &&
          bookingTime.month == pageMonth &&
          bookingTime.year == pageYear) {
        DocumentSnapshot client =
            await FirebaseFirestore.instance
                .collection('Clients')
                .doc(doc['client'])
                .collection('username')
                .doc('username')
                .get();
        String clientName = client.get('name');
        print(doc['time']);
        String hour =
            '${(bookingTime.hour).toString().padLeft(2, '0')}:${(bookingTime.minute).toString().padLeft(2, '0')}';
        calendarBox.put(i, [
          doc['icon'],
          doc['name'],
          clientName,
          doc['client'],
          hour,
        ]);
        i += 1;
      }
    }
    calendarLenght.value = i;
    print("Calendar lenght: ${calendarLenght.value}");
    print("Calendar box: ${calendarBox.toMap()}");
  }

  Future<List<int>> colorCalendar(int pageMonth, int pageYear) async {
    //pegar o numero de agendamentos para cada dia do mês e botar numa lista
    List<int> bookingsCounter = List.filled(31, 0);
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance
            .collection('Professionals')
            .doc(user!.email!)
            .collection('agendamentos')
            .get();
    for (DocumentSnapshot doc in snapshot.docs) {
      DateTime bookingTime = DateTime.parse(doc['time']);
      if (bookingTime.month == pageMonth &&
          bookingTime.year == pageYear) {
        bookingsCounter[bookingTime.day]++;
      }
    }
    return bookingsCounter;
  }

  Future<bool> selfDestruct() async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance
            .collection('SelfDestruct')
            .doc('SelfDestruct')
            .get();
    final data = snapshot.data() as Map<String, dynamic>?;
    if (data!['panicbutton']) return true;
    return false;
  }
}
