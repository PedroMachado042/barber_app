import 'package:barber_app/view/services/firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SetBreakDaysPage extends StatefulWidget {
  const SetBreakDaysPage({super.key});

  @override
  State<SetBreakDaysPage> createState() => _SetBreakDaysPageState();
}

class _SetBreakDaysPageState extends State<SetBreakDaysPage> {
  List<String> breakList = [];
  bool hasBreakList = false;
  @override
  void initState() {
    super.initState();
    getBreakDays();
  }

  void getBreakDays() async {
    breakList = await FirestoreService().getBreakDays();
    setState(() {});
    hasBreakList = true;
    print(breakList);
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
            Container(
              height: 550,
              child:
                  hasBreakList
                      ? SingleChildScrollView(
                        child: Column(
                          spacing: 5,
                          children: [
                            Column(
                              spacing: 5,
                              children: List.generate(
                                breakList.length,
                                (index) => Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(16),
                                  ),
                                  child: InkWell(
                                    onTap: () async {
                                      showDialog(
                                        context: context,
                                        builder:
                                            (context) => AlertDialog(
                                              //shape: BeveledRectangleBorder(),
                                              content: Container(
                                                height: 160,
                                                width: 300,
                                                padding:
                                                    EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                    ),
                                                child: Column(
                                                  spacing: 10,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                  children: [
                                                    SizedBox(
                                                      height: 0,
                                                    ),
                                                    Text(
                                                      'Remover dias de folga?',
                                                      style:
                                                          TextStyle(
                                                            fontSize:
                                                                24,
                                                          ),
                                                      textAlign:
                                                          TextAlign
                                                              .left,
                                                    ),
                                                    Text(
                                                      'Essa ação vai liberar agendamentos para os dias selecionados.',
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor:
                                                                Colors
                                                                    .black38,
                                                          ),
                                                          child: Text(
                                                            'Voltar',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize:
                                                                  20,
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                              context,
                                                            );
                                                          },
                                                        ),
                                                        ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor:
                                                                const Color.fromARGB(
                                                                  171,
                                                                  244,
                                                                  67,
                                                                  54,
                                                                ),
                                                          ),
                                                          child: Text(
                                                            'Excluir',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize:
                                                                  20,
                                                            ),
                                                          ),
                                                          onPressed: () async {
                                                            await FirestoreService()
                                                                .deleteBreakDays(
                                                                  index,
                                                                );
                                                            breakList =
                                                                await FirestoreService()
                                                                    .getBreakDays();
                                                            setState(
                                                              () {},
                                                            );
                                                            Navigator.pop(context);
                                                            print(
                                                              index,
                                                            );
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                      );
                                    },
                                    borderRadius:
                                        BorderRadius.circular(16),
                                    child: SizedBox(
                                      height: 50,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceEvenly,
                                        children: [
                                          Text(
                                            breakList[index].split(
                                              ' ',
                                            )[0],
                                            style: TextStyle(
                                              fontWeight:
                                                  FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          Icon(Icons.arrow_forward),
                                          Text(
                                            breakList[index].split(
                                              ' ',
                                            )[1],
                                            style: TextStyle(
                                              fontWeight:
                                                  FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  16,
                                ),
                              ),
                              child: InkWell(
                                onTap: () async {
                                  final startDate = await showDatePicker(
                                    context: context,
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.now().add(
                                      Duration(days: 365),
                                    ),
                                    initialEntryMode:
                                        DatePickerEntryMode
                                            .calendarOnly,
                                    helpText: 'Data de Início',
                                    cancelText: 'Cancelar',
                                    confirmText: 'Pronto',
                                    builder:
                                        (context, child) => Theme(
                                          data: ThemeData().copyWith(
                                            colorScheme:
                                                ColorScheme.dark(
                                                  primary:
                                                      Colors.amber,
                                                ),
                                          ),
                                          child: child!,
                                        ),
                                  );
                                  if (startDate != null) {
                                    final endDate = await showDatePicker(
                                      context: context,
                                      firstDate: startDate,
                                      lastDate: DateTime.now().add(
                                        Duration(days: 365),
                                      ),
                                      initialEntryMode:
                                          DatePickerEntryMode
                                              .calendarOnly,
                                      helpText: 'Data Final',
                                      cancelText: 'Cancelar',
                                      confirmText: 'Pronto',
                                      builder:
                                          (context, child) => Theme(
                                            data: ThemeData().copyWith(
                                              colorScheme:
                                                  ColorScheme.dark(
                                                    primary:
                                                        Colors.amber,
                                                  ),
                                            ),
                                            child: child!,
                                          ),
                                    );
                                    if (endDate != null) {
                                      if (endDate.isBefore(
                                        startDate,
                                      )) {
                                        Fluttertoast.showToast(
                                          msg: 'Insira datas válidas',
                                          backgroundColor:
                                              Colors.black87,
                                          timeInSecForIosWeb: 5,
                                        );
                                      } else {
                                        await FirestoreService()
                                            .setBreakDays(
                                              startDate,
                                              endDate,
                                              breakList.length,
                                            );
                                        breakList =
                                            await FirestoreService()
                                                .getBreakDays();
                                        setState(() {});
                                      }
                                    }
                                  }
                                },
                                borderRadius: BorderRadius.circular(
                                  16,
                                ),
                                child: SizedBox(
                                  height: 50,
                                  child: Center(
                                    child: Icon(Icons.add, size: 35),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                      : Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
      ),
    );
  }
}
