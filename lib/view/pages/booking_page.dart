import 'package:barber_app/data/dummy_data.dart';
import 'package:barber_app/data/notifiers.dart';
import 'package:barber_app/view/services/firestore.dart';
import 'package:barber_app/view/widgets/booking_confirm_widget.dart';
import 'package:barber_app/view/widgets/service_dropdownitem.dart';
import 'package:barber_app/view/widgets/toomany_alertbox.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  int? selectedService = null;
  int? selectedDay;
  int? selectedHour;
  bool hasService = false;
  bool hasDay = false;
  bool hasHour = false;
  int passedHorarios = 0;
  String prof = 'adm@gmail.com';
  Map<String, dynamic> diasDeTrabalho = {};
  bool diaDeFolga = false;

  final servicesBox = Hive.box('servicesBox');
  @override
  void initState() {
    super.initState;
    checkAppointments();
  }

  void checkAppointments() async {
    int counter = await appointmentsCounter();
    diasDeTrabalho = await FirestoreService().getWorkdays(prof);
    if (counter >= 3 && !isADM.value) {
      await showDialog(
        context: context,
        builder: (context) {
          return TooManyAlertbox();
        },
      );
      Navigator.pop(context);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Agendar'),
        backgroundColor: CupertinoColors.placeholderText,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          spacing: 10,
          children: [
            Icon(Icons.edit, color: Colors.amber, size: 40),
            Divider(),
            SizedBox(height: 0),
            //                                         _\|/_  SELECIONAR SERVIÇO
            Container(
              color: Colors.black54,
              width: double.infinity,
              height: 80,
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  itemHeight: 80,
                  value: selectedService,
                  icon: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Icon(Icons.arrow_drop_down),
                  ),
                  hint: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                    ),
                    child: Text('Selecione um serviço'),
                  ),
                  iconSize: 40,
                  dropdownColor: const Color.fromARGB(
                    255,
                    12,
                    10,
                    15,
                  ),
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  items: List.generate(
                    servicesLenght.value,
                    (index) => DropdownMenuItem(
                      value: index,
                      child: ServiceDropdownitem(
                        icon: servicesBox.get(index)[0],
                        name: servicesBox.get(index)[1],
                        price: 'R\$ ${servicesBox.get(index)[2]}',
                        time: servicesBox.get(index)[3],
                      ),
                    ),
                  ),
                  //                                  / /ISSO É UM ITEM
                  onChanged: (int? value) {
                    setState(() {
                      selectedService = value;
                      hasService = true;
                      selectedDay = null;
                      selectedHour = null;
                      hasDay = false;
                      hasHour = false;
                    });
                    horariosLenght.value = horariosBox.length;
                    horariosBox.clear(); //pra atualizar sempre
                  },
                ),
              ),
            ),
            SizedBox(height: 5),
            hasService
                ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    height: 100,
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: 30,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8),
                          child: InkWell(
                            onTap: () async {
                              selectedDay = index;
                              await FirestoreService().loadHorarios(
                                prof,
                                '${DateTime.now().add(Duration(days: index)).day.toString().padLeft(2, '0')}-${DateTime.now().add(Duration(days: index)).month.toString().padLeft(2, '0')}-${DateTime.now().add(Duration(days: index)).year.toString().padLeft(2, '0')}',
                              );
                              setState(() {
                                hasDay = true;
                                selectedHour = null;
                                hasHour = false;
                              });
                            },
                            child: Container(
                              width: 80,
                              color:
                                  selectedDay != index
                                      ? Colors.black87
                                      : Colors.white10,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${DummyData.months[DateTime.now().add(Duration(days: index)).month - 1]}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '${DateTime.now().add(Duration(days: index)).day}',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      '${DummyData.weekdays[DateTime.now().add(Duration(days: index)).weekday - 1]}',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
                : SizedBox(),
            SizedBox(height: 0),
            hasDay
                ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    color: Colors.black26,
                    height: 250,
                    child: ValueListenableBuilder<int>(
                      valueListenable: horariosLenght,
                      builder: (context, horariosLenght, child) {
                        passedHorarios = passedHorariosCounter(
                          selectedDay,
                        );
                        horariosLenght -= passedHorarios;
                        return horariosLenght == 0 ||
                                !diasDeTrabalho['${DummyData.weekdays[DateTime.now().add(Duration(days: selectedDay!)).weekday - 1]}']
                            ? Center(
                              child: Text(
                                'Não há mais horários para hoje!',
                                style: TextStyle(fontSize: 18),
                              ),
                            )
                            : GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: horariosLenght,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 5,
                                    mainAxisExtent: 50,
                                  ),
                              itemBuilder: (context, index) {
                                /*double time = index / 2 + 8.5;
                            int timer = time.toInt();
                            bool hasDecimalPlaces(double time) {
                              return time % 1 != 0;
                            }*/
                                index += passedHorarios;
                                return Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        hasHour = true;
                                        selectedHour = index;
                                      });
                                    },
                                    child: Container(
                                      color:
                                          selectedHour != index
                                              ? Colors.black87
                                              : Colors.white10,
                                      child: Center(
                                        child: Text(
                                          '${horariosBox.get(index)}',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                      },
                    ),
                  ),
                )
                : SizedBox(),
            SizedBox(height: 10),
            hasHour
                ? ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(330, 60),
                    backgroundColor: const Color.fromARGB(
                      255,
                      196,
                      135,
                      5,
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return BookingConfirmWidget(
                          time: DateTime.now().add(
                            Duration(days: selectedDay!),
                          ),
                          hour: selectedHour!,
                          service: selectedService,
                          prof: prof,
                        );
                      },
                    );
                  },
                  child: Text(
                    'Confirmar Agendamento',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      inherit: true,
                    ),
                  ),
                )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}

int appointmentsCounter() {
  int counter = 0;
  final bookingsBox = Hive.box('bookingsBox');
  for (int i = 0; i < bookingsBox.length; i++) {
    DateTime date =
        bookingsBox.get(i)[2] is String
            ? DateTime.parse(bookingsBox.get(i)[2])
            : bookingsBox.get(i)[2];
    if (!date.isBefore(DateTime.now())) {
      counter++;
    }
  }
  return counter;
}

int passedHorariosCounter(int? selectedDay) {
  int counter = 0;
  final selectedDate = DateTime.now().add(
    Duration(days: selectedDay!),
  );
  final horariosBox = Hive.box('horariosBox');
  for (int i = 0; i < horariosBox.length; i++) {
    final horarioStr = horariosBox.get(i); // e.g., '14:00'
    final parts = horarioStr.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    final horarioTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      hour,
      minute,
    );

    if (horarioTime.isBefore(DateTime.now())) {
      counter++;
    }
  }
  return counter;
}
