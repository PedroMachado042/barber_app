import 'package:barber_app/data/dummy_data.dart';
import 'package:barber_app/data/notifiers.dart';
import 'package:barber_app/view/services/firestore.dart';
import 'package:barber_app/view/widgets/graphs/month_graph.dart';
import 'package:barber_app/view/widgets/graphs/pie_graph.dart';
import 'package:barber_app/view/widgets/graphs/week_graph.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GraphsPage extends StatefulWidget {
  const GraphsPage({super.key});

  @override
  State<GraphsPage> createState() => _GraphsPageState();
}

class _GraphsPageState extends State<GraphsPage> {
  List<Map<String, String>> allConcludedAppointments = [];
  List<int> weeklyAppoints = [0, 0, 0, 0, 0, 0, 0];
  double maxWeekdayAppoints = 6.0;
  List<double> monthRevenue = [4, 6, 12, 16, 15, 20];
  double maxMonthRevenue = 10.0;
  double totalRevenue = 0;
  double percentRevenue = 0;
  Map<int, Map<String, int>> servicesCount = {};
  int totalServices = 0;

  @override
  void initState() {
    super.initState();
    generateGraphs();
  }

  void generateGraphs() async {
    allConcludedAppointments =
        await FirestoreService().getAllConcludedAppointments();

    weeklyAppoints = await countWeeklyAppoints(
      allConcludedAppointments,
    );
    maxWeekdayAppoints =
        (weeklyAppoints.reduce((a, b) => a > b ? a : b)).toDouble() +
        1;
    //tirar do comentario quando parar de testar
    monthRevenue = await countMonthRevenue(allConcludedAppointments);
    maxMonthRevenue =
        (monthRevenue.reduce((a, b) => a > b ? a : b)).toDouble();
    calculateTotalRevenue();
    servicesCount = await countServices(allConcludedAppointments);
    totalServices = servicesCount.values
    .map((serviceMap) => serviceMap.values.first)
    .fold(0, (sum, count) => sum + count);

    print(allConcludedAppointments);
    setState(() {});
  }

  Future<List<int>> countWeeklyAppoints(
    List<Map<String, String>> appointments,
  ) async {
    List<int> days = [0, 0, 0, 0, 0, 0, 0];
    for (Map item in appointments) {
      if (DateTime.parse(item['time']).weekday == 7)
        days[0]++;
      else
        days[DateTime.parse(item['time']).weekday]++;
    }
    return days;
  }

  Future<List<double>> countMonthRevenue(
    List<Map<String, String>> appointments,
  ) async {
    print(servicesBox.toMap());
    List<double> months = [0, 0, 0, 0, 0, 0];
    for (Map item in appointments) {
      double price = double.parse(item['price'].replaceAll(',', '.'));
      int position = 0;
      if (DateTime.parse(item['time']).month <=
          DateTime.now().month) {
        position =
            5 -
            (DateTime.now().month -
                DateTime.parse(item['time']).month);
      } else {
        position =
            5 -
            (DateTime.now().month -
                DateTime.parse(item['time']).month +
                12);
        print('position: $position');
      }
      if (position >= 0 && position < 6) months[position] += price;
      print(months);
    }
    return months;
  }

  void calculateTotalRevenue() {
    totalRevenue = monthRevenue.reduce((a, b) => a + b);
    percentRevenue = (monthRevenue[5] / monthRevenue[4]) * 100 - 100;
    percentRevenue = (percentRevenue * 100).truncateToDouble() / 100;
    //ajustando pra +100%, 0 e -100% quando for 0
    if (monthRevenue[4] == 0) {
      if (monthRevenue[5] == 0)
        percentRevenue = 0;
      else
        percentRevenue = 100;
    } else if (monthRevenue[5] == 0)
      percentRevenue = -100;
  }

  Future<Map<int, Map<String, int>>> countServices(
    List<Map<String, String>> appointments,
  ) async {
    final Map<String, int> serviceCounts = {};

    for (var item in appointments) {
      final name = item['name'];
      if (name != null) {
        serviceCounts[name] = (serviceCounts[name] ?? 0) + 1;
      }
    }

    // Ordena por valor decrescente
    final sortedEntries =
        serviceCounts.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    // Cria o mapa final indexado
    final Map<int, Map<String, int>> indexed = {
      for (int i = 0; i < sortedEntries.length; i++)
        i: {sortedEntries[i].key: sortedEntries[i].value},
    };
    print(indexed);
    return indexed;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Gráficos'),
        backgroundColor: CupertinoColors.placeholderText,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(30),
            child: Column(
              spacing: 5,
              children: [
                Icon(Icons.auto_graph, color: Colors.amber, size: 40),
                Divider(),
              ],
            ),
          ),
          allConcludedAppointments == []
              ? Center(child: CircularProgressIndicator())
              : Container(
                height: 550,
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 22,
                    children: [
                      Text(
                        'Total de Lucros no mês',
                        style: TextStyle(fontSize: 20),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 150,
                              width: 200,
                              child: MonthGraph(
                                monthRevenue: monthRevenue,
                                maxMonthRevenue: maxMonthRevenue,
                              ),
                            ),
                            Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    showRevenue.value =
                                        !showRevenue.value;
                                    setState(() {});
                                  },
                                  icon: Icon(
                                    Icons.remove_red_eye_outlined,
                                  ),
                                ),
                                showRevenue.value
                                    ? Text(
                                      'R\$ ${totalRevenue.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                    : Text(
                                      'R\$ ---',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                SizedBox(height: 5),
                                showRevenue.value
                                    ? Text(
                                      percentRevenue >= 0
                                          ? '+$percentRevenue%'
                                          : '$percentRevenue%',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color:
                                            percentRevenue >= 0
                                                ? Colors.green
                                                : Colors.red,
                                      ),
                                    )
                                    : Text(
                                      '---%',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                SizedBox(height: 50, width: 170),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(),
                      Text(
                        'Serviços por dia da semana',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        height: 180,
                        width: 360,
                        child: WeekGraph(
                          weeklyAppoints: weeklyAppoints,
                          maxWeekdayAppoints: maxWeekdayAppoints,
                        ),
                      ),
                      SizedBox(),
                      Text(
                        'Serviços mais agendados',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(),
                      totalServices!=0?
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            spacing: 10,
                            children: [
                              Text(
                                'Total: $totalServices',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                color: Colors.black38,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: List.generate(
                                      servicesCount.length,
                                      (index) {
                                        return Row(
                                          children: [
                                            Icon(
                                              Icons.square,
                                              color:
                                                  DummyData
                                                      .barColor[index],
                                              size: 18,
                                            ),
                                            Text(
                                              ' ${servicesCount[index]!.keys.first}',
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(),//separar um pouco só
                          SizedBox(
                            height: 150,
                            width: 150,
                            child: PieGraph(
                              servicesCount: servicesCount,
                            ),
                          ),
                        ],
                      ):Column(
                        children: [
                          SizedBox(height: 40,),
                          Text('Nenhum serviço encontrado...',style: TextStyle(fontSize: 16,color: Colors.white54)),
                        ],
                      ),
                      SizedBox(height: 150),
                    ],
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
