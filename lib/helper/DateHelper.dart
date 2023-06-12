import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DateHelper {
  static String today_date() {
    final now = DateTime.now();
    return DateFormat('dd/MM/yyyy').format(now);
  }

  static String yesterday_date() {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    return DateFormat('dd/MM/yyyy').format(yesterday);
  }

  static String next_day(String date) {
    List<String> ar = date.split('/');
    final next =
        DateTime(int.parse(ar[2]), int.parse(ar[1]), int.parse(ar[0]) + 1);
    return DateFormat('dd/MM/yyyy').format(next);
  }

  static String format(date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String format_TimeOfDay_12(TimeOfDay timeOfDay) {
    final now = new DateTime.now();
    final dt = DateTime(
        now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    final format = DateFormat.jm();
    return format.format(dt);
  }

  static String format_TimeOfDay_24(TimeOfDay timeOfDay) {
    final now = new DateTime.now();
    final dt = DateTime(
        now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    return DateFormat('HH:mm').format(dt);
  }

  static String convertTime_to_24hours(String time){
    DateTime date= DateFormat.jm().parse(time);
    return DateFormat("HH:mm").format(date);
  }

  static bool isDateAfterToday(String date) {
    if (date == today_date()) {
      return true;
    } else {
      final now = new DateTime.now();
      List<String> ar = date.split('/');
      final dateTime =
          DateTime(int.parse(ar[2]), int.parse(ar[1]), int.parse(ar[0]));
      return dateTime.isAfter(now);
    }
  }

  static bool isDateBeforeToday(String date) {
    final now = new DateTime.now();
    List<String> ar = date.split('/');
    final dateTime = DateTime(int.parse(ar[2]), int.parse(ar[1]), int.parse(ar[0]));
    return dateTime.isBefore(now);
  }

  static DateTime scheduleDateTime(String date,String time) {
    List<String> tr = time.split(':');
    List<String> ar = date.split('/');
    final scheduleDate = DateTime(int.parse(ar[2]), int.parse(ar[1]), int.parse(ar[0]),int.parse(tr[0]),int.parse(tr[1]));
    return scheduleDate;
  }
}
