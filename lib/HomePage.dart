import 'package:adhan/adhan.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:jiffy/jiffy.dart';
import 'package:time_manager/helper/Prayers.dart';
import 'package:time_manager/model/UserTask.dart';

import 'helper/DateHelper.dart';
import 'helper/DesignHelper.dart';
import 'helper/FlutterA.dart';
import 'helper/Lang.dart';
import 'helper/MyColors.dart';
import 'helper/Notify.dart';
import 'helper/Pref.dart';
import 'model/Database.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late PrayerTimes prayerTimes;
  bool load = false;
  late List<Placemark> placemarks;
  bool fajrNotify = Pref.get_fajarNotify();
  bool duhurNotify = Pref.get_dhuhrNotify();
  bool asrNotify = Pref.get_asrNotify();
  bool maghribNotify = Pref.get_maghribNotify();
  bool ishaNotify = Pref.get_ishaNotify();
  final TextEditingController taskNameEditing = TextEditingController();
  bool notifyTask = false;
  TimeOfDay selected_time = TimeOfDay.now();
  TextEditingController time_controller = new TextEditingController();
  final Stream<QuerySnapshot> stream =
      Database.tasks().orderBy("timestamp", descending: false).snapshots();
  List<DocumentSnapshot> documents = [];

  @override
  initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadTimes();
    });
    Pref.set_nav(0);
    super.initState();
  }

  loadTimes() async {
    Position position = await _determinePosition();
    final myCoordinates = Coordinates(position.latitude,
        position.longitude); // Replace with your own location lat, lng.
    placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    final params = CalculationMethod.umm_al_qura.getParameters();
    params.madhab = Madhab.hanafi;
    prayerTimes = PrayerTimes.today(myCoordinates, params);
    setState(() {
      load = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: load == false
          ? Center(child: CircularProgressIndicator())
          : Container(
              width: double.infinity,
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                        alignment: Alignment.topCenter,
                        child: city_date_info()),
                    Align(alignment: Alignment.center, child: prayers_times()),
                    Expanded(
                        child: Align(
                            alignment: Alignment.bottomCenter,
                            child: task_section())),
                  ])),
      floatingActionButton: load
          ? FloatingActionButton(
              child: Icon(
                Icons.add,
                color: MyColors.white,
              ),
              onPressed: () {
                add_task_dialog();
              },
            )
          : SizedBox.shrink(),
    );
  }

  city_date_info() {
    HijriCalendar.setLocal(Lang.arabic.languageCode);
    HijriCalendar todayHijri = HijriCalendar.now();
    return Container(
        color: MyColors.primary,
        child: Container(
            padding: EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 20),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                        AutoSizeText(
                          "${DateFormat('EEEE').format(DateTime.now())}",
                          style: TextStyle(fontSize: 15, color: MyColors.white),
                        ),
                        AutoSizeText(
                          "${todayHijri.getDayName()}",
                          style: TextStyle(fontSize: 15, color: MyColors.white),
                        ),
                      ])),
                  SizedBox(
                    height: 5,
                  ),
                  Flexible(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                        AutoSizeText(
                          "${DateFormat('d MMM yyyy').format(DateTime.now())}",
                          style: TextStyle(fontSize: 15, color: MyColors.white),
                        ),
                        AutoSizeText(
                          "${todayHijri.toFormat("dd MMMM yyyy")}",
                          style: TextStyle(fontSize: 15, color: MyColors.white),
                        ),
                      ])),
                ])));
  }

  prayers_times() {
    return Container(
        color: MyColors.prayer,
        child: Container(
            padding: EdgeInsets.only(top: 5, bottom: 0),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  space(10),
                  prayer(Prayers.FAJR, Prayers.FAJR_ARABIC, prayerTimes.fajr),
                  switchButton(Prayers.FAJR),
                  line(),
                  space(10),
                  prayer(
                      Prayers.DHUHR, Prayers.DHUHR_ARABIC, prayerTimes.dhuhr),
                  switchButton(Prayers.DHUHR),
                  line(),
                  space(10),
                  prayer(Prayers.ASR, Prayers.ASR_ARABIC, prayerTimes.asr),
                  switchButton(Prayers.ASR),
                  line(),
                  space(10),
                  prayer(Prayers.MAGHRIB, Prayers.MAGHRIB_ARABIC,
                      prayerTimes.maghrib),
                  switchButton(Prayers.MAGHRIB),
                  line(),
                  space(10),
                  prayer(Prayers.ISHA, Prayers.ISHA_ARABIC, prayerTimes.isha),
                  switchButton(Prayers.ISHA),
                  line(),
                ])));
  }

  task_section() {
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: double.infinity,
          margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
          padding: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            border: Border.all(color: MyColors.primary, width: 2),
            borderRadius: BorderRadius.circular(5),
            shape: BoxShape.rectangle,
          ),
          child: task_list(),
        ),
        Positioned(
          left: 50,
          top: 12,
          child: Container(
            padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
            color: Colors.white,
            child: Text(
              'Today Tasks',
              style: TextStyle(
                  color: MyColors.primary,
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  task_list() {
    return StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Server error"));
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Container(
                  height: double.infinity,
                  child: Center(child: CircularProgressIndicator()));
            default:
              if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
                return Container(
                    padding: EdgeInsets.only(top: 30),
                    child: Center(child: Text("No tasks")));
              } else {
                documents = snapshot.data!.docs;
                filter();
                if (documents.length == 0) {
                  return Container(
                      padding: EdgeInsets.only(top: 30),
                      child: Center(child: Text("No tasks".tr())));
                } else {
                  return Container(
                      margin: EdgeInsets.only(top: 20),
                      child: ListView.separated(
                          separatorBuilder: (context, i) {
                            return SizedBox(
                              height: 20,
                            );
                          },
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: documents.length,
                          padding: EdgeInsets.symmetric(vertical: 5),
                          itemBuilder: (context, i) {
                            UserTask task = UserTask.fromMap(
                                documents[i].data() as Map<String, dynamic>);

                            return GestureDetector(
                              child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  margin: EdgeInsets.symmetric(horizontal: 15),
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: MyColors.primary)),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                            child: AutoSizeText(task.name,
                                                maxLines: 1,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        Text(task.time,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                        Checkbox(
                                          value: task.completed,
                                          onChanged: (value) async {
                                            await Database.tasks()
                                                .doc(task.task_id)
                                                .update({'completed': value});
                                          },
                                        ),
                                      ])),
                              onTap: () {
                                Navigator.pushNamed(context, "view_task",
                                    arguments: {'task_id': task.task_id});
                              },
                            );
                          }));
                }
              }
          }
        });
  }

  prayer(prayer, prayer_ar, time) {
    return Flexible(
        child: Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text("${prayer}",
            style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        Text("${DateFormat.jm().format(time)}",
            style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        Text("${prayer_ar}",
            style: TextStyle(
                color: Colors.black, fontFamily: "Bold", fontSize: 16))
      ]),
    ));
  }

  switchButton(prayer) {
    if (prayer == Prayers.FAJR) {
      return Container(
          alignment: Alignment.center,
          child: SizedBox(
              width: 60,
              height: 45,
              child: FittedBox(
                  fit: BoxFit.fill,
                  child: Switch(
                    value: fajrNotify,
                    onChanged: (bool v) {
                      Pref.set_fajarNotify(v);
                      setState(() {
                        fajrNotify = v;
                      });
                    },
                  ))));
    } else if (prayer == Prayers.DHUHR) {
      return Container(
          alignment: Alignment.center,
          child: SizedBox(
              width: 60,
              height: 45,
              child: FittedBox(
                  fit: BoxFit.fill,
                  child: Switch(
                    value: duhurNotify,
                    onChanged: (bool v) {
                      setState(() {
                        Pref.set_dhuhrNotify(v);
                        duhurNotify = v;
                      });
                    },
                  ))));
    } else if (prayer == Prayers.ASR) {
      return Container(
          alignment: Alignment.center,
          child: SizedBox(
              width: 60,
              height: 45,
              child: FittedBox(
                  fit: BoxFit.fill,
                  child: Switch(
                    value: asrNotify,
                    onChanged: (bool v) {
                      Pref.set_asrNotify(v);
                      setState(() {
                        asrNotify = v;
                      });
                    },
                  ))));
    } else if (prayer == Prayers.MAGHRIB) {
      return Container(
          alignment: Alignment.center,
          child: SizedBox(
              width: 60,
              height: 45,
              child: FittedBox(
                  fit: BoxFit.fill,
                  child: Switch(
                    value: maghribNotify,
                    onChanged: (bool v) {
                      Pref.set_maghribNotify(v);
                      setState(() {
                        maghribNotify = v;
                      });
                    },
                  ))));
    } else if (prayer == Prayers.ISHA) {
      return Container(
          alignment: Alignment.center,
          child: SizedBox(
              width: 60,
              height: 45,
              child: FittedBox(
                  fit: BoxFit.fill,
                  child: Switch(
                    value: ishaNotify,
                    onChanged: (bool v) {
                      Pref.set_ishaNotify(v);
                      setState(() {
                        ishaNotify = v;
                      });
                    },
                  ))));
    } else {
      return SizedBox();
    }
  }

  add_task_dialog() {
    AwesomeDialog(
      context: context,
      body: add_task_content(),
      isDense: true,
      padding: EdgeInsets.only(bottom: 20),
      animType: AnimType.rightSlide,
      btnCancelColor: MyColors.primary,
      btnOkColor: MyColors.primary,
      dismissOnBackKeyPress: false,
      dismissOnTouchOutside: false,
      dialogType: DialogType.noHeader,
      btnOk: SizedBox(
          width: DesignHelper.buttonWidth3,
          height: DesignHelper.buttonHeight3,
          child: ElevatedButton(
            onPressed: () async {
              add_task();
            },
            child: FittedBox(child: Text("Add")),
            style: DesignHelper.buttonStyle,
          )),
      btnCancel: SizedBox(
          width: DesignHelper.buttonWidth3,
          height: DesignHelper.buttonHeight3,
          child: ElevatedButton(
            onPressed: () {
              FlutterA.close_current_page(context);
            },
            child: FittedBox(child: Text("Cancel")),
            style: DesignHelper.buttonStyle2,
          )),
    )..show();
  }

  add_task_content() {
    taskNameEditing.text = '';
    time_controller.text = '';
    notifyTask = false;
    return StatefulBuilder(builder: (context, setState) {
      return Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.task, size: 55, color: MyColors.primary),
            AutoSizeText("Add task",
                style: TextStyle(
                    color: MyColors.primary,
                    fontSize: 25,
                    fontWeight: FontWeight.bold)),
            SizedBox(
              height: 20,
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                  controller: taskNameEditing,
                  cursorColor: MyColors.filedColor,
                  style: DesignHelper.fieldStyle2,
                  keyboardType: TextInputType.text,
                  maxLength: 20,
                  decoration: InputDecoration(
                    labelText: "Enter task name",
                    labelStyle: DesignHelper.fieldStyle2,
                    prefixIcon: Icon(Icons.info, color: MyColors.primary),
                    enabledBorder: DesignHelper.fieldBorder2,
                    focusedBorder: DesignHelper.fieldBorder2,
                    disabledBorder: DesignHelper.fieldBorder2,
                  ),
                )),
            SizedBox(height: 25),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                  cursorColor: Theme.of(context).primaryColor,
                  style: DesignHelper.fieldStyle2,
                  keyboardType: TextInputType.none,
                  onTap: () async {
                    final TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: selected_time,
                      helpText: "Task time".tr(),
                    );
                    if (picked != null && picked != selected_time)
                      setState(() {
                        selected_time = picked;
                        time_controller.text =
                            DateHelper.format_TimeOfDay_12(selected_time);
                      });
                  },
                  controller: time_controller,
                  decoration: InputDecoration(
                      labelText: "Task time".tr(),
                      labelStyle: DesignHelper.fieldStyle2,
                      errorStyle: DesignHelper.fieldErrorStyle,
                      prefixIcon:
                          Icon(Icons.access_time, color: MyColors.primary),
                      enabledBorder: DesignHelper.fieldBorder2,
                      focusedBorder: DesignHelper.fieldBorder2,
                      disabledBorder: DesignHelper.fieldBorder2,
                      errorBorder: DesignHelper.fieldErrorBorder,
                      focusedErrorBorder: DesignHelper.fieldErrorBorder),
                )),
            SizedBox(height: 10),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 30,
                    ),
                    //SizedBox
                    AutoSizeText(
                      'Notify when time come',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    Checkbox(
                      value: notifyTask,
                      onChanged: (value) {
                        setState(() {
                          notifyTask = value!;
                        });
                      },
                    ),
                  ], //<Widget>[]
                )),
            SizedBox(
              height: 25,
            ),
          ]);
    });
  }

  add_task() async {
    String task_name = taskNameEditing.text;
    if (task_name.isEmpty) {
      FlutterA.toast("Enter task name");
      return;
    }
    String time = time_controller.text;
    if (time.isEmpty) {
      FlutterA.toast("Select task time");
      return;
    }
    AwesomeDialog progressDialog = FlutterA.progressDialog('Add task', context);
    progressDialog.show();
    String task_id = Database.tasks().doc().id;
    UserTask task = new UserTask(task_id,Database.loggedUserId(),task_name,DateHelper.today_date(),time, notifyTask);
    await Database.tasks().doc(task_id).set(task.toMap());
    if(notifyTask){
      await Notify.schedule(task_id,task_name,task.date, time);
    }
    progressDialog.dismiss();
    FlutterA.close_current_page(context);
  }

  space(double val) {
    return SizedBox(height: val);
  }

  line() {
    return Divider(thickness: 2, color: MyColors.gray4, height: 3);
  }

  filter() {
    Iterable<DocumentSnapshot<Object?>> filter = documents.where((element) {
      return checkFilter(element);
    });
    documents = filter.toList();
  }

  bool checkFilter(DocumentSnapshot<Object?> doc) {
    UserTask task = UserTask.fromDocument(doc);
    bool result = task.user_id == Database.loggedUserId() && task.date == DateHelper.today_date();
    return result;
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
