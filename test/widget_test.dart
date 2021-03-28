// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

void main() {
  test('Counter increments smoke test', () async {
    print(getTime('11:00', '12:30', 12));
  });
}

String handleTime(String time) {
  var value = time.split(':');
  int hours = int.parse(value[0]);
  return hours >= 12
      ? '${time.replaceFirst(hours.toString(), (hours - 12).toString().padLeft(2, '0'))} PM'
      : '$time AM';
}

getTime(String start, String end, int duration) {
  List list = [];

  var split = end.split(':');
  int eMin = int.parse(split[1]) + (int.parse(split[0]) * 60);

  var split2 = start.split(':');
  int sMin = int.parse(split2[1]) + (int.parse(split2[0]) * 60);

  String newTime = DateFormat('HH:mm a').format(
      DateTime.fromMillisecondsSinceEpoch(
          sMin.floor() * 60000 - 60 * 60 * 2 * 1000));
  int tMin = sMin;
  while (tMin < eMin) {
    list.add(newTime);
    tMin += duration;
    print(tMin);

    newTime = DateFormat('HH:mm a').format(DateTime.fromMillisecondsSinceEpoch(
        tMin.floor() * 60000 - 60 * 60 * 2 * 1000));
  }
  print('done');
  return list;
}

date(day) {
  var lowerCase = day?.toLowerCase();
  final now = DateTime.now();
  final tomorrow = DateTime(now.year, now.month, now.day + 1);
  if (lowerCase == 'today') {
    return DateFormat('dd/MM/yyyy').format(now);
  }
  if (lowerCase == 'tomorrow') {
    return DateFormat('dd/MM/yyyy').format(tomorrow);
  } else
    return day?.split(' ').last ?? '';
}
