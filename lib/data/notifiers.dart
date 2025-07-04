import 'package:flutter/material.dart';

ValueNotifier<int> servicesLenght = ValueNotifier(0);
ValueNotifier<int> bookingsLenght = ValueNotifier(0);
ValueNotifier<int> horariosLenght = ValueNotifier(0);
ValueNotifier<int> calendarLenght = ValueNotifier(0);

ValueNotifier<bool> isLogged = ValueNotifier(false);
ValueNotifier<bool> isADM = ValueNotifier(false);
ValueNotifier<bool> showRevenue = ValueNotifier(false);

ValueNotifier<Map<DateTime, int>> bookingMapNotifier = ValueNotifier({});