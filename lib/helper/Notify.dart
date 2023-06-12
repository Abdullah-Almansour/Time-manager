import 'dart:async';
import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:time_manager/helper/DateHelper.dart';
import 'package:time_manager/helper/FileHelper.dart';
import 'package:time_manager/helper/MyColors.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:time_manager/helper/Pref.dart';


class Notify {

  static Future<bool> schedule(task_id,name,String date,String time) async {
    time = DateHelper.convertTime_to_24hours(time);
    DateTime dateTime = DateHelper.scheduleDateTime(date, time);
    int id = Random().nextInt(100);
    Map<String,dynamic> list = Pref.get_notifyList();
    list[task_id] = id;
    Pref.set_notifyList(list);
    if(dateTime.isAfter(DateTime.now())) {
      Timer(dateTime.difference(DateTime.now()), () async {
        await FileHelper.playNotify();
      });
    }
    return AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        title:name,
        body: "View task",
        channelKey: 'basic_channel',
        color: MyColors.primary,
        backgroundColor: MyColors.primary,
        largeIcon:'asset://assets/images/logo.png',
          notificationLayout: NotificationLayout.BigText,
        payload: {'task_id':task_id,'type':'task'},
        category: NotificationCategory.Navigation,
      ),
        schedule: NotificationCalendar.fromDate(date:dateTime),

    );
  }

  static Future<void> cancel_schedule(task_id) async {
    Map<String,dynamic> list = Pref.get_notifyList();
    if(list.containsKey(task_id)){
      int id = list[task_id];
      list.remove(task_id);
      Pref.set_notifyList(list);
      await AwesomeNotifications().cancelSchedule(id);
    }
  }

  static Future<bool> send_adan(title) async {
    return AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: Random().nextInt(100),
        title:title,
        body: "",
        channelKey: 'basic_channel',
        color: MyColors.primary,
        backgroundColor: MyColors.primary,
        largeIcon:'asset://assets/images/logo.png',
        notificationLayout: NotificationLayout.BigText,
        payload: {'type':'adan'},
        actionType: ActionType.Default,

      ),
    );
  }

  @pragma("vm:entry-point")
  static Future <void> onActionReceivedMethod(ReceivedAction received) async {
    var type = received.payload?['type'];
    if(type != "adan") {
      var task_id = received.payload?['task_id'];
      navService.pushNamed('/view_task', args: task_id);
    }
  }





}
