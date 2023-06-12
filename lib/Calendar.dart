import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_manager/helper/DateHelper.dart';
import 'helper/DesignHelper.dart';
import 'helper/Pref.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CalendarState();
}

class CalendarState extends State<Calendar> {
  DateRangePickerController controller = new DateRangePickerController();

  @override
  void initState() {
    super.initState();
    Pref.set_nav(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: DesignHelper.appBar('Calendar'.tr(), false),
        body: Container(
          child: SfDateRangePicker(
            onSelectionChanged: (date) {
              String selected_date = DateHelper.format(date.value);
              Navigator.pushNamed(context, "tasks_calendar",
                  arguments: {'date': selected_date});
              controller.selectedDate = null;
            },
            selectionMode: DateRangePickerSelectionMode.single,
            navigationMode: DateRangePickerNavigationMode.none,
            controller: controller,
          ),
        ));
  }
}
