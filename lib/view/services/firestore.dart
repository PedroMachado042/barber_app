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

  Future<void> createAccountDoc() async {
    //burla pra criar o documento do email do cliente
    await firestore
        .collection('Clients')
        .doc(isADM.value ? 'AAAdmin@gmail.com' : user!.email!)
        .set(
          {'createdAt': Timestamp.now()},
          SetOptions(merge: true), // não sobrescreve subcoleções
        );
  }

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
    servicesLenght.value = servicesBox.length;
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
          'price': servicesBox.get(serviceNum)[2],
          'time': preparedTime,
          'client': isADM.value ? 'AAAdmin@gmail.com' : user!.email,
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
        .doc(isADM.value ? 'AAAdmin@gmail.com' : user!.email!)
        .collection('agendamentos')
        .doc('agendamento${bookingsBox.length - 1}')
        .set({
          'icon': servicesBox.get(serviceNum)[0],
          'name': servicesBox.get(serviceNum)[1],
          'time': time,
          'prof': prof,
          'timestamp': Timestamp.now(),
        });
    isADM.value ? setUsername(true) : '';
    isADM.value ? createAccountDoc() : '';
  }

  Future<void> getAppointments([String email = '']) async {
    int i = 0;
    bookingsBox.clear();
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance
            .collection('Clients')
            .doc(isADM.value ? email : user!.email!)
            .collection('agendamentos')
            .get();
    for (DocumentSnapshot doc in snapshot.docs) {
      bookingsBox.put(i, [
        doc['icon'],
        doc['name'],
        DateTime.parse(doc['time']),
        false,
        doc['prof'],
      ]);
      i += 1;
    }
    bookingsLenght.value = i;
  }

  Future<void> deleteCollection() async {
    final docRef = FirebaseFirestore.instance
        .collection('Clients')
        .doc(user!.email!);
    // List of known subcollections to delete
    final subcollections = ['username', 'agendamentos'];
    for (final sub in subcollections) {
      final subSnapshot = await docRef.collection(sub).get();
      for (final doc in subSnapshot.docs) {
        await doc.reference.delete();
      }
    }
    // Finally, delete the parent document
    await docRef.delete();
    print('All subcollections and main document deleted');
  }

  Future<void> checkIsADM() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance
            .collection('Professionals')
            .get();
    for (DocumentSnapshot doc in snapshot.docs) {
      if (user != null && doc.id == user!.email!) {
        isADM.value = true;
        return;
      }
    }
    isADM.value = false;
  }

  Future<void> setUsername([bool anonimo = false]) async {
    await FirebaseFirestore.instance
        .collection(
          isADM.value && !anonimo ? 'Professionals' : 'Clients',
        )
        .doc(anonimo ? 'AAAdmin@gmail.com' : user!.email)
        .collection('username')
        .doc('username')
        .set({'name': anonimo ? '-=Admin=-' : user!.displayName});
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
        print(pageDay);
        String clientName = client.get('name');
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
  }

  Future<List<int>> colorCalendar(int pageMonth, int pageYear) async {
    //pegar o numero de agendamentos para cada dia do mês e botar numa lista
    List<int> bookingsCounter = List.filled(32, 0);
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

  Future<bool> checkSelfDestruct() async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance
            .collection('SelfDestruct')
            .doc('SelfDestruct')
            .get();
    final data = snapshot.data() as Map<String, dynamic>?;
    if (data!['panicbutton']) return true;
    return false;
  }

  Future<void> cancelHorario(int id, [String email = '']) async {
    // Essa é a função mais longa de todos os tempos, em parte eu me orgulho pois ela funciona, porém reconheço sua ineficiência, deixo ela aqui como uma forma de expressão artística que retrata a rebeldia em decorrência do sofrimento do programador.
    DateTime time = bookingsBox.get(id)[2];
    String prof = bookingsBox.get(id)[4];
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance
            .collection('Clients')
            .doc(isADM.value ? email : user!.email!)
            .collection('agendamentos')
            .get();
    for (DocumentSnapshot doc in snapshot.docs) {
      var docTime = DateTime.parse(doc['time']);
      if (docTime.hour == time.hour &&
          docTime.minute == time.minute &&
          docTime.day == time.day &&
          docTime.month == time.month &&
          docTime.year == time.year) {
        await doc.reference.delete();
      }
    }
    CollectionReference appointmentRef = firestore
        .collection('Clients')
        .doc(isADM.value ? email : user!.email!)
        .collection('agendamentos');
    int i = id + 1;
    while (true) {
      final currentDoc =
          await appointmentRef.doc('agendamento$i').get();
      if (!currentDoc.exists) break;
      final data = currentDoc.data();
      if (data != null) {
        await appointmentRef
            .doc('agendamento${i - 1}')
            .set(data as Map<String, dynamic>);
        await currentDoc.reference.delete();
      }
      i++;
    }
    QuerySnapshot snapshot2 =
        await FirebaseFirestore.instance
            .collection('Professionals')
            .doc(prof)
            .collection('agendamentos')
            .get();
    i = 0;
    for (DocumentSnapshot doc in snapshot2.docs) {
      i +=
          1; //essa aqui foi tricky (contar os documentos no do prof, que tem de todos clientes)
      var docTime = DateTime.parse(doc['time']);
      if (docTime.hour == time.hour &&
          docTime.minute == time.minute &&
          docTime.day == time.day &&
          docTime.month == time.month &&
          docTime.year == time.year) {
        await doc.reference.delete();
        CollectionReference appointmentRef = firestore
            .collection('Professionals')
            .doc(prof)
            .collection('agendamentos');
        while (true) {
          final currentDoc =
              await appointmentRef.doc('agendamento$i').get();
          if (!currentDoc.exists) break;
          final data = currentDoc.data();
          if (data != null) {
            await appointmentRef
                .doc('agendamento${i - 1}')
                .set(data as Map<String, dynamic>);
            await currentDoc.reference.delete();
          }
          i++;
        }
        // ADICIONA O HORÁRIO ORDENADO
        final docRef = FirebaseFirestore.instance
            .collection('Professionals')
            .doc(prof)
            .collection('horarios')
            .doc('horariosLivres');

        final dateKey =
            '${time.day.toString().padLeft(2, '0')}-${time.month.toString().padLeft(2, '0')}-${time.year.toString().padLeft(2, '0')}';
        final novoHorario =
            '${docTime.hour.toString().padLeft(2, '0')}:${docTime.minute.toString().padLeft(2, '0')}';

        final horarioDoc = await docRef.get();
        List<String> horarios = [];

        if (horarioDoc.exists &&
            horarioDoc.data()!.containsKey(dateKey)) {
          horarios = List<String>.from(horarioDoc[dateKey]);
        }

        if (!horarios.contains(novoHorario)) {
          horarios.add(novoHorario);
          horarios.sort(); // mantém a ordem tipo ['08:00', '09:30']
          await docRef.update({dateKey: horarios});
        }
        isADM.value ? '' : getAppointments();
      }
    }
  }

  Future<int?> countUsers() async {
    final query = FirebaseFirestore.instance.collection('Clients');
    final aggregateSnapshot = await query.count().get();
    return aggregateSnapshot.count;
  }

  Future<List<Map<String, String>>> getAllUsers() async {
    final clientsSnapshot =
        await FirebaseFirestore.instance.collection('Clients').get();
    List<Map<String, String>> users = [];
    for (final clientDoc in clientsSnapshot.docs) {
      final email = clientDoc.id;

      final usernameDoc =
          await FirebaseFirestore.instance
              .collection('Clients')
              .doc(email)
              .collection('username')
              .doc('username')
              .get();
      String username = 'No username found';
      if (usernameDoc.exists) {
        final data = usernameDoc.data();
        if (data != null && data.containsKey('name')) {
          username = data['name'];
        }
      }
      users.add({'email': email, 'username': username});
    }
    return users;
  }

  Future<List<Map<String, String>>>
  getAllConcludedAppointments() async {
    final appointmentsSnapshot =
        await FirebaseFirestore.instance
            .collection('Professionals')
            .doc(user!.email!)
            .collection('agendamentos')
            .get();
    List<Map<String, String>> users = [];
    for (final appointmentDoc in appointmentsSnapshot.docs) {
      final data = appointmentDoc.data();
      if (DateTime.parse(data['time']).isBefore(DateTime.now())) {
        //botar aqui dentro quando parar de testar
      }
      users.add({
        'client': data['client'],
        'name': data['name'],
        'time': data['time'],
        'price': data['price'],
      });
    }
    return users;
  }

  Future<void> setService(
    int id,
    int icon,
    String name,
    String value,
    String time,
  ) async {
    await FirebaseFirestore.instance
        .collection('Services')
        .doc('service$id')
        .set({
          'icon': icon,
          'name': name,
          'time': time,
          'value': value,
        });
  }

  Future<void> deleteService(int id) async {
    final CollectionReference servicesRef = firestore.collection(
      'Services',
    );
    final docToDelete = await servicesRef.doc('service$id').get();
    if (docToDelete.exists) {
      await docToDelete.reference.delete();
    }
    //Reordenar serviços na firestore
    int i = id + 1;
    while (true) {
      final currentDoc = await servicesRef.doc('service$i').get();
      if (!currentDoc.exists) break;
      final data = currentDoc.data();
      if (data != null) {
        await servicesRef
            .doc('service${i - 1}')
            .set(data as Map<String, dynamic>);
        await currentDoc.reference.delete();
      }
      i++;
    }
    await FirestoreService().loadServices();
  }

  Future<void> deleteAllData() async {
    final profDoc = await firestore
        .collection('Professionals')
        .doc(user!.email!);

    await profDoc
        .collection('horarios')
        .doc('horariosLivres')
        .delete();
    await profDoc
        .collection('horarios')
        .doc('horariosLivres')
        .set({});
    final snapshot = await profDoc.collection('agendamentos').get();
    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }
    final clientsSnapshot =
        await firestore.collection('Clients').get();

    for (final clientDoc in clientsSnapshot.docs) {
      final agendamentosSnapshot =
          await clientDoc.reference.collection('agendamentos').get();
      for (final agendamentoDoc in agendamentosSnapshot.docs) {
        await agendamentoDoc.reference.delete();
      }
    }
  }

  Future<Map<String, dynamic>> getWorkdays([String? prof]) async {
    final diasSnapshot =
        await FirebaseFirestore.instance
            .collection('Professionals')
            .doc(isADM.value ? user!.email! : prof)
            .collection('horarios')
            .doc('diasDeTrabalho')
            .get();
    return diasSnapshot.data()!;
  }

  Future<List<String>> getWorkhours() async {
    final diasSnapshot =
        await FirebaseFirestore.instance
            .collection('Professionals')
            .doc(user!.email!)
            .collection('horarios')
            .doc('horasDeTrabalho')
            .get();
    return [
      diasSnapshot['inicio'],
      diasSnapshot['final'],
      diasSnapshot['inicioIntervalo'],
      diasSnapshot['finalIntervalo'],
    ];
  }

  Future<void> setWorktime(
    Map<String, dynamic> dias,
    List<String> horas,
  ) async {
    print('Horas: $horas');
    //mudar dias de trabalho
    await FirebaseFirestore.instance
        .collection('Professionals')
        .doc(user!.email!)
        .collection('horarios')
        .doc('diasDeTrabalho')
        .set(dias);
    //mudar hora de inicio e final
    await FirebaseFirestore.instance
        .collection('Professionals')
        .doc(user!.email!)
        .collection('horarios')
        .doc('horasDeTrabalho')
        .set({
          'inicio': horas[0],
          'final': horas[1],
          'inicioIntervalo': horas[2],
          'finalIntervalo': horas[3],
        });
    //deletar dias sem agendamentos em horariosLivres
    final horariosLivres =
        await FirebaseFirestore.instance
            .collection('Professionals')
            .doc(user!.email!)
            .collection('horarios')
            .doc('horariosLivres')
            .get();
    final horariosTotal =
        await FirebaseFirestore.instance
            .collection('Professionals')
            .doc(user!.email!)
            .collection('horarios')
            .doc('horariosTotal')
            .get();

    final data = horariosLivres.data() as Map<String, dynamic>;

    final listaComparacao = horariosTotal['total'];

    for (var entry in data.entries) {
      final chave = entry.key;
      final valor = (entry.value as List).cast<String>();

      if (_listasIguais(valor, listaComparacao)) {
        await horariosLivres.reference.update({
          chave: FieldValue.delete(),
        });
        print('Campo $chave é igual à lista de comparação');
      } else {
        print('Campo $chave é diferente');
      }
    }
    //atualizar horariosTotal
    List<String> times = [];
    List<String> intervals = [];
    DateTime parseTime(String s) {
      var parts = s.split(':');
      return DateTime(
        0,
        1,
        1,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );
    }

    //adicionar os horarios um por um para 'times'
    var current = parseTime(horas[0]);
    var last = parseTime(horas[1]);
    while (current != last) {
      times.add(
        '${current.hour.toString().padLeft(2, '0')}:${current.minute.toString().padLeft(2, '0')}',
      );
      current = current.add(Duration(minutes: 30));
    }
    //subtrair os horarios de intervalo um por um
    current = parseTime(horas[2]);
    last = parseTime(horas[3]);
    while (current != last) {
      intervals.add(
        '${current.hour.toString().padLeft(2, '0')}:${current.minute.toString().padLeft(2, '0')}',
      );
      current = current.add(Duration(minutes: 30));
    }
    times = (times.toSet().difference(intervals.toSet())).toList();
    print(times);
    print(times.length);
    FirestoreService().changeHorarios(user!.email!, times);
    print('sus');
  }

  void SelfDestruct() async {
    await FirebaseFirestore.instance
        .collection('SelfDestruct')
        .doc('SelfDestruct')
        .update({'panicbutton': true});
  }
}

bool _listasIguais(List<dynamic> a, List<dynamic> b) {
  if (a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
