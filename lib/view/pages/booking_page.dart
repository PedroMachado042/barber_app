import 'package:barber_app/data/dummy_data.dart';
import 'package:barber_app/data/notifiers.dart';
import 'package:barber_app/view/services/firestore.dart';
import 'package:barber_app/view/widgets/booking_confirm_widget.dart';
import 'package:barber_app/view/widgets/service_dropdownitem.dart';
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

  final servicesBox = Hive.box('servicesBox');
  @override
  void initState() {
    super.initState;
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
                  items: [
                    //                                  / /ISSO É UM ITEM
                    DropdownMenuItem(
                      value: 0,
                      child: ServiceDropdownitem(
                        name: servicesBox.get(0)[1],
                        icon: servicesBox.get(0)[0],
                        price: 'R\$ ${servicesBox.get(0)[2]}',
                        time: servicesBox.get(0)[3],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 1,
                      child: ServiceDropdownitem(
                        name: servicesBox.get(1)[1],
                        icon: servicesBox.get(1)[0],
                        price: 'R\$ ${servicesBox.get(1)[2]}',
                        time: servicesBox.get(1)[3],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 2,
                      child: ServiceDropdownitem(
                        name: servicesBox.get(2)[1],
                        icon: servicesBox.get(2)[0],
                        price: 'R\$ ${servicesBox.get(2)[2]}',
                        time: servicesBox.get(2)[3],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 3,
                      child: ServiceDropdownitem(
                        name: servicesBox.get(3)[1],
                        icon: servicesBox.get(3)[0],
                        price: 'R\$ ${servicesBox.get(3)[2]}',
                        time: servicesBox.get(3)[3],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 4,
                      child: ServiceDropdownitem(
                        name: servicesBox.get(4)[1],
                        icon: servicesBox.get(4)[0],
                        price: 'R\$ ${servicesBox.get(4)[2]}',
                        time: servicesBox.get(4)[3],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 5,
                      child: ServiceDropdownitem(
                        name: servicesBox.get(5)[1],
                        icon: servicesBox.get(5)[0],
                        price: 'R\$ ${servicesBox.get(5)[2]}',
                        time: servicesBox.get(5)[3],
                      ),
                    ),
                  ],
                  onChanged: (int? value) {
                    setState(() {
                      selectedService = value;
                      hasService = true;
                      selectedDay = null;
                      selectedHour = null;
                      hasDay = false;
                      hasHour = false;
                      horariosLenght.value = horariosBox.length;
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
                            onTap: () async{
                              selectedDay = index;
                              await FirestoreService().loadHorarios(
                                  'rose@gmail.com',
                                  '${DateTime.now().add(Duration(days: index)).day.toString().padLeft(2, '0')}-${DateTime.now().add(Duration(days: index)).month.toString().padLeft(2, '0')}',
                                );
                              setState((){
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
                      builder: (context, value, child) {
                        return GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: value,
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
                                      style: TextStyle(fontSize: 16),
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
