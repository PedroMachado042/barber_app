import 'package:barber_app/data/notifiers.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

final servicesBox = Hive.box('servicesBox');
final horariosBox = Hive.box('horariosBox');

class DummyData {
  static List months = [
    'Jan',
    'Fev',
    'Mar',
    'Abr',
    'Mai',
    'Jun',
    'Jul',
    'Ago',
    'Set',
    'Out',
    'Nov',
    'Dez',
  ];
  static List weekdays = [
    'Seg',
    'Ter',
    'Qua',
    'Qui',
    'Sex',
    'Sab',
    'Dom',
  ];

  static List s = [
    [Icons.content_cut_sharp.codePoint, 'Corte', '25,00', '45:00'],
    [Icons.content_cut_sharp.codePoint, 'Barba', '15,00', '30:00'],
    [
      Icons.content_cut_sharp.codePoint,
      'Sobrancelha',
      '8,00',
      '20:00',
    ],
    [Icons.content_cut_sharp.codePoint, 'Pézinho', '5,00', '10:00'],
    [
      Icons.content_cut_sharp.codePoint,
      'Corte Navalhado',
      '30,00',
      '45:00',
    ],
    [Icons.content_cut_sharp.codePoint, 'Desenho', '3,00', '10:00'],
  ];
  static List horarios = [
    '08:30',
    '09:00',
    '09:30',
    '10:00',
    '10:30',
    '11:00',
    '11:30',
    '12:00',
    '12:30',
    '13:00',
    '13:30',
    '14:00',
    '14:30',
    '15:00',
    '15:30',
    '16:00',
    '16:30',
    '17:00',
    '17:30',
    '18:00',
    '18:30',
    '19:00',
    '19:30',
    '20:00',
  ];
}

void loadServicess() async {
  await servicesBox.clear();
  List s = [
    [Icons.content_cut_sharp.codePoint, 'Corte', '25,00', '45:00'],
    [Icons.content_cut_sharp.codePoint, 'Barba', '15,00', '30:00'],
    [Icons.content_cut_sharp.codePoint, 'Sobrancelha', '8,00', '20:00'],
    [Icons.content_cut_sharp.codePoint, 'Pézinho', '5,00', '10:00'],
    [
      Icons.content_cut_sharp.codePoint,
      'Corte Navalhado',
      '30,00',
      '45:00',
    ],
    [Icons.content_cut_sharp.codePoint, 'Desenho', '3,00', '10:00'],
  ];
  for (var i in s) {
    servicesBox.put(s.indexOf(i), s[s.indexOf(i)]);
  }
  servicesLenght.value = servicesBox.length;
}