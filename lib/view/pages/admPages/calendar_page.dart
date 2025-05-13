import 'package:barber_app/data/dummy_data.dart';
import 'package:barber_app/view/pages/admPages/calendar_day_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_heatmap_calendar/simple_heatmap_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  int monthControl = 0;
  @override
  Widget build(BuildContext context) {
    final selectedMap = {
      DateTime(2025, 5, 19): 1,
      DateTime(2025, 5, 20): 2,
      DateTime(2025, 5, 21): 3,
      DateTime(2025, 5, 22): 4,
      DateTime(2025, 5, 13): 3,
      DateTime(2025, 5, 15): 1,
      DateTime(2025, 5, 16): 4,
      DateTime(2025, 5, 30): 2,
      DateTime(2025, 6, 3): 2,
      DateTime(2025, 6, 1): 1,
    };
    final colorMap = {
      1: const Color.fromARGB(255, 100, 200, 100),
      2: const Color.fromARGB(255, 66, 180, 66),
      3: const Color.fromARGB(255, 33, 160, 33),
      4: const Color.fromARGB(255, 0, 140, 0),
    };
    DateTime now = DateTime.now();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Meus Horários'),
        backgroundColor: CupertinoColors.placeholderText,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(30),
            child: Column(
              spacing: 5,
              children: [
                Icon(
                  Icons.calendar_month,
                  color: Colors.amber,
                  size: 40,
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (monthControl > 0) {
                          monthControl -= 1;
                        }
                        setState(() {});
                      },
                      icon: Icon(Icons.arrow_back, size: 35),
                    ),
                    Text(
                      '${DummyData.months[DateTime.now().month + monthControl - 1]} - ${DateTime.now().year}',
                      style: TextStyle(fontSize: 25),
                    ),
                    IconButton(
                      onPressed: () {
                        monthControl += 1;
                        setState(() {});
                      },
                      icon: Icon(Icons.arrow_forward, size: 35),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: HeatmapCalendar<num>(
              startDate: DateTime(
                now.year,
                now.month + monthControl,
                1,
              ),
              endedDate: DateTime(
                now.year,
                now.month + monthControl + 1,
                0,
              ),
              colorMap: colorMap,
              selectedMap: selectedMap,
              monthLabelItemBuilder: (context, date, defaultFormat) {
                //mês
                const nomesMeses = {
                  1: 'Jan',
                  2: 'Fev',
                  3: 'Mar',
                  4: 'Abr',
                  5: 'Mai',
                  6: 'Jun',
                  7: 'Jul',
                  8: 'Ago',
                  9: 'Set',
                  10: 'Out',
                  11: 'Nov',
                  12: 'Dez',
                };
                return Text(
                  '${nomesMeses[date.month] ?? ''} ${date.year}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
              weekLabelValueBuilder: (
                //semana
                context,
                protoDate,
                defaultFormat,
              ) {
                const diasSemana = {
                  DateTime.monday: 'Seg',
                  DateTime.tuesday: 'Ter',
                  DateTime.wednesday: 'Qua',
                  DateTime.thursday: 'Qui',
                  DateTime.friday: 'Sex',
                  DateTime.saturday: 'Sáb',
                  DateTime.sunday: 'Dom',
                };
                return Text(
                  '${diasSemana[protoDate.weekday]}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
              weekLabalCellSize: Size(30, 62),
              cellSize: const Size.square(70),
              style: const HeatmapCalendarStyle.defaults(
                weekLabelValueAlignment: Alignment.centerRight,
                cellRadius: BorderRadius.all(Radius.circular(4.0)),
                weekLabelColor: Colors.white,
              ),
              cellBuilder: (
                context,
                childBuilder,
                columnIndex,
                rowIndex,
                date,
              ) {
                final normalizedDate = DateTime(
                  date.year,
                  date.month,
                  date.day,
                );
                final value = selectedMap[normalizedDate];
                final color = colorMap[value];
                final dateExist;
                if (normalizedDate.isBefore(
                      DateTime(now.year, now.month + monthControl, 1),
                    ) ||
                    normalizedDate.isAfter(
                      DateTime(
                        now.year,
                        now.month + monthControl + 1,
                        0,
                      ),
                    )) {
                  dateExist = false;
                } else {
                  dateExist = true;
                }
                return Padding(
                  padding: const EdgeInsets.all(3),
                  child: GestureDetector(
                    onTap: () {
                      print(value);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  CalendarDayPage(date: '${DummyData.weekdays[date.weekday-1]} - ${date.day}/${date.month}/${date.year}'),
                        ),
                      );
                    },
                    child:
                        dateExist
                            ? Stack(
                              children: [
                                Container(
                                  height: 58,
                                  width: 55,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color:
                                        color ??
                                        const Color.fromARGB(255, 197, 198, 202),
                                    borderRadius:
                                        BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    '${date.day}',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            )
                            : SizedBox(height: 58),
                  ),
                );
              },
              layoutParameters:
                  const HeatmapLayoutParameters.defaults(
                    weekLabelPosition: CalendarWeekLabelPosition.left,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
