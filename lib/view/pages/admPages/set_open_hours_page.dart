import 'package:barber_app/view/services/firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SetOpenHoursPage extends StatefulWidget {
  const SetOpenHoursPage({super.key});

  @override
  State<SetOpenHoursPage> createState() => _EditServicesPageState();
}

class _EditServicesPageState extends State<SetOpenHoursPage> {
  List<String> workHoursData = [];
  int startingHour = 0;
  int endingHour = 0;
  int startingIntervalHour = 0;
  int endingIntervalHour = 0;
  bool hasHours = false;
  bool hasInterval = false;
  Map<String, dynamic> dias = {
    'Seg': false,
    'Ter': false,
    'Qua': false,
    'Qui': false,
    'Sex': false,
    'Sab': false,
    'Dom': false,
  };
  bool test = true;
  @override
  void initState() {
    super.initState();
    getWorktime();
  }

  void getWorktime() async {
    workHoursData = await FirestoreService().getWorkhours();
    startingHour = reverseIndex(workHoursData[0], true);
    endingHour = reverseIndex(workHoursData[1], false);
    if (workHoursData[2] != '') {
      startingIntervalHour = reverseIndex(workHoursData[2], true);
      endingIntervalHour = reverseIndex(workHoursData[3], false);
      hasInterval = true;
    }

    hasHours = true;
    dias = await FirestoreService().getWorkdays();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Configurar'),
        backgroundColor: CupertinoColors.placeholderText,
      ),
      body: Padding(
        padding: EdgeInsets.all(28),
        child: Column(
          spacing: 5,
          children: [
            Icon(Icons.settings, color: Colors.amber, size: 40),
            Divider(),
            Column(
              spacing: 5,
              children: [
                Text('Horários', style: TextStyle(fontSize: 25)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      spacing: 5,
                      children: [
                        Text(
                          'Início',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          hasHours
                              ? '${6 + (startingHour / 2.floor()).toInt()}:${startingHour % 2 == 0 ? 0 : 3}0'
                              : '--:--',
                          style: TextStyle(fontSize: 24),
                        ),
                      ],
                    ),
                    Column(
                      spacing: 5,
                      children: [
                        Text('Final', style: TextStyle(fontSize: 20)),
                        Text(
                          hasHours
                              ? '${21 + (-endingHour / 2.floor()).toInt()}:${endingHour % 2 == 0 ? 3 : 0}0'
                              : '--:--',
                          style: TextStyle(fontSize: 24),
                        ),
                      ],
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    showCupertinoModalPopup(
                      context: context,
                      builder:
                          (context) => Center(
                            child: Container(
                              width: 300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  16,
                                ),
                                color:
                                    CupertinoColors
                                        .darkBackgroundGray,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    height: 200,
                                    width: 150,
                                    child: CupertinoPicker(
                                      itemExtent: 40,
                                      scrollController:
                                          FixedExtentScrollController(
                                            initialItem: startingHour,
                                          ),
                                      onSelectedItemChanged: (value) {
                                        setState(() {
                                          startingHour = value;
                                        });
                                      },
                                      children: List.generate(
                                        25,
                                        (index) => Center(
                                          child: Text(
                                            '${6 + (index / 2.floor()).toInt()}:${index % 2 == 0 ? 0 : 3}0',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 200,
                                    width: 150,
                                    child: CupertinoPicker(
                                      itemExtent: 40,
                                      scrollController:
                                          FixedExtentScrollController(
                                            initialItem: endingHour,
                                          ),
                                      onSelectedItemChanged: (value) {
                                        setState(() {
                                          endingHour = value;
                                        });
                                      },
                                      children: List.generate(
                                        25,
                                        (index) => Center(
                                          child: Text(
                                            '${21 + (-index / 2.floor()).toInt()}:${index % 2 == 0 ? 3 : 0}0',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    );
                  },
                  style: ElevatedButton.styleFrom(),
                  child: Text(
                    'Alterar Horários',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Divider(),
                Text(
                  'Horário de Intervalo',
                  style: TextStyle(fontSize: 25),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    minTileHeight: 8,
                    title: Center(
                      child: Text(
                        hasInterval
                            ? '${6 + (startingIntervalHour / 2.floor()).toInt()}:${startingIntervalHour % 2 == 0 ? 0 : 3}0  ->  ${21 + (-endingIntervalHour / 2.floor()).toInt()}:${endingIntervalHour % 2 == 0 ? 3 : 0}0'
                            : '---',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    tileColor: CupertinoColors.placeholderText,
                  ),
                ),
                hasInterval
                    ? ElevatedButton(
                      onPressed: () {
                        startingIntervalHour = 0;
                        endingIntervalHour = 0;
                        setState(() {
                          hasInterval = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
                          110,
                          25,
                          19,
                        ),
                      ),
                      child: Text(
                        'Remover intervalo',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                    : ElevatedButton(
                      onPressed: () {
                        showCupertinoModalPopup(
                          context: context,
                          builder:
                              (context) => Center(
                                child: Container(
                                  width: 300,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(16),
                                    color:
                                        CupertinoColors
                                            .darkBackgroundGray,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(
                                        height: 200,
                                        width: 150,
                                        child: CupertinoPicker(
                                          itemExtent: 40,
                                          scrollController:
                                              FixedExtentScrollController(
                                                initialItem: 0,
                                              ),
                                          onSelectedItemChanged: (
                                            value,
                                          ) {
                                            setState(() {
                                              startingIntervalHour =
                                                  value;
                                            });
                                          },
                                          children: List.generate(
                                            25,
                                            (index) => Center(
                                              child: Text(
                                                '${6 + (index / 2.floor()).toInt()}:${index % 2 == 0 ? 0 : 3}0',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 200,
                                        width: 150,
                                        child: CupertinoPicker(
                                          itemExtent: 40,
                                          scrollController:
                                              FixedExtentScrollController(
                                                initialItem: 0,
                                              ),
                                          onSelectedItemChanged: (
                                            value,
                                          ) {
                                            setState(() {
                                              endingIntervalHour =
                                                  value;
                                            });
                                          },
                                          children: List.generate(
                                            25,
                                            (index) => Center(
                                              child: Text(
                                                '${21 + (-index / 2.floor()).toInt()}:${index % 2 == 0 ? 3 : 0}0',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        );
                        setState(() {
                          hasInterval = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(),
                      child: Text(
                        'Adicionar Intervalo',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),

                Divider(),
                Text(
                  'Dias de Trabalho',
                  style: TextStyle(fontSize: 25),
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        Text('Seg', style: TextStyle(fontSize: 17)),
                        Transform.scale(
                          scale: 1.5,
                          child: Checkbox(
                            activeColor: Colors.white,
                            value: dias['Seg'],
                            onChanged: (value) {
                              setState(() {
                                dias['Seg'] = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text('Ter', style: TextStyle(fontSize: 17)),
                        Transform.scale(
                          scale: 1.5,
                          child: Checkbox(
                            activeColor: Colors.white,
                            value: dias['Ter'],
                            onChanged: (value) {
                              setState(() {
                                dias['Ter'] = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text('Qua', style: TextStyle(fontSize: 17)),
                        Transform.scale(
                          scale: 1.5,
                          child: Checkbox(
                            activeColor: Colors.white,
                            value: dias['Qua'],
                            onChanged: (value) {
                              setState(() {
                                dias['Qua'] = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text('Qui', style: TextStyle(fontSize: 17)),
                        Transform.scale(
                          scale: 1.5,
                          child: Checkbox(
                            activeColor: Colors.white,
                            value: dias['Qui'],
                            onChanged: (value) {
                              setState(() {
                                dias['Qui'] = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text('Sex', style: TextStyle(fontSize: 17)),
                        Transform.scale(
                          scale: 1.5,
                          child: Checkbox(
                            activeColor: Colors.white,
                            value: dias['Sex'],
                            onChanged: (value) {
                              setState(() {
                                dias['Sex'] = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text('Sab', style: TextStyle(fontSize: 17)),
                        Transform.scale(
                          scale: 1.5,
                          child: Checkbox(
                            activeColor: Colors.white,
                            value: dias['Sab'],
                            onChanged: (value) {
                              setState(() {
                                dias['Sab'] = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text('Dom', style: TextStyle(fontSize: 17)),
                        Transform.scale(
                          scale: 1.5,
                          child: Checkbox(
                            activeColor: Colors.white,
                            value: dias['Dom'],
                            onChanged: (value) {
                              setState(() {
                                dias['Dom'] = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 30),
                SizedBox(
                  height: 55,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(
                        255,
                        221,
                        148,
                        38,
                      ),
                    ),
                    onPressed: () async {
                      await FirestoreService().setWorktime(dias, [
                          '${6 + (startingHour / 2.floor()).toInt()}:${startingHour % 2 == 0 ? 0 : 3}0',
                          '${21 + (-endingHour / 2.floor()).toInt()}:${endingHour % 2 == 0 ? 3 : 0}0',
                          hasInterval
                              ? '${6 + (startingIntervalHour / 2.floor()).toInt()}:${startingIntervalHour % 2 == 0 ? 0 : 3}0'
                              : '',
                          hasInterval
                              ? '${21 + (-endingIntervalHour / 2.floor()).toInt()}:${endingIntervalHour % 2 == 0 ? 3 : 0}0'
                              : '',
                        ]);
                        Navigator.pop(context);
                        print(DateTime.now().weekday);
                      Fluttertoast.showToast(
                        msg: 'Horários alterados com sucesso!',
                        backgroundColor: Colors.black87,
                      );
                    },
                    child: Text(
                      'Confirmar',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//big brain gpt
int reverseIndex(String time, bool InicioFinal) {
  final parts = time.split(':');
  int hour = int.parse(parts[0]);
  int minute = int.parse(parts[1]);

  int base = InicioFinal ? (hour - 6) * 2 : (21 - hour) * 2;
  int index =
      InicioFinal
          ? (minute == 0 ? base : base + 1)
          : (minute == 30 ? base : base + 1);

  return index;
}
