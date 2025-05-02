import 'package:barber_app/view/widgets/booking_confirm_widget.dart';
import 'package:barber_app/view/widgets/service_dropdownitem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  @override
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
                  items: const [
                    //                                  / /ISSO É UM ITEM
                    DropdownMenuItem(
                      value: 0,
                      child: ServiceDropdownitem(
                        name: 'Corte',
                        icon: Icons.content_cut_sharp,
                        price: 'R\$ 25,00',
                        time: '45 min',
                      ),
                    ),
                    DropdownMenuItem(
                      value: 1,
                      child: ServiceDropdownitem(
                        name: 'Barba',
                        icon: Icons.face,
                        price: 'R\$ 15,00',
                        time: '30 min',
                      ),
                    ),
                    DropdownMenuItem(
                      value: 2,
                      child: ServiceDropdownitem(
                        name: 'Sobrancelha',
                        icon: Icons.face,
                        price: 'R\$ 8,00',
                        time: '20 min',
                      ),
                    ),
                    DropdownMenuItem(
                      value: 3,
                      child: ServiceDropdownitem(
                        name: 'Pézinho',
                        icon: Icons.face,
                        price: 'R\$ 5,00',
                        time: '10 min',
                      ),
                    ),
                    DropdownMenuItem(
                      value: 4,
                      child: ServiceDropdownitem(
                        name: 'Corte Navalhado',
                        icon: Icons.face,
                        price: 'R\$ 30,00',
                        time: '45 min',
                      ),
                    ),
                    DropdownMenuItem(
                      value: 5,
                      child: ServiceDropdownitem(
                        name: 'Desenho',
                        icon: Icons.face,
                        price: 'R\$ 3,00',
                        time: '10 min',
                      ),
                    ),
                  ],
                  onChanged: (int? value) {
                    setState(() {
                      selectedService = value;
                      hasService = true;
                    });
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
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                hasDay = true;
                                selectedDay = index;
                              });
                              print('aa');
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
                                      'Abril',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '${index + 1}',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      'seg',
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
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 24,
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            mainAxisExtent: 50,
                          ),
                      itemBuilder: (context, index) {
                        double time = index / 2 + 8.5;
                        int timer = time.toInt();
                        bool hasDecimalPlaces(double time) {
                          return time % 1 != 0;
                        }

                        return Padding(
                          padding: const EdgeInsets.all(5),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                hasHour = true;
                                selectedHour = index;
                              });
                              print(index);
                            },
                            child: Container(
                              color:
                                  selectedHour != index
                                      ? Colors.black87
                                      : Colors.white10,
                              child: Center(
                                child: Text(
                                  hasDecimalPlaces(time)
                                      ? '$timer:30'
                                      : '$timer:00',
                                  style: TextStyle(fontSize: 16),
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
                        return BookingConfirmWidget();
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
