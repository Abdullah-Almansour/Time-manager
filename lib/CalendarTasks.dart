import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chip_list/chip_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_manager/helper/DateHelper.dart';
import 'package:time_manager/helper/FlutterA.dart';
import 'helper/DesignHelper.dart';
import 'helper/MyColors.dart';
import 'helper/Notify.dart';
import 'helper/Pref.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'model/Database.dart';
import 'model/UserTask.dart';

class CalendarTasks extends StatefulWidget {
  const CalendarTasks({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CalendarTasksState();
}

class CalendarTasksState extends State<CalendarTasks> {
  final Stream<QuerySnapshot> stream =
      Database.tasks().orderBy("timestamp", descending: false).snapshots();
  List<DocumentSnapshot> documents = [];
  var status = 0;
  late String date;
  final TextEditingController taskNameEditing = TextEditingController();
  bool notifyTask = false;
  TimeOfDay selected_time = TimeOfDay.now();
  TextEditingController time_controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    Pref.set_nav(1);
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> receivedData =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    date = receivedData['date'] as String;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: DesignHelper.appBar("Tasks - " + date, true),
      body: Container(
          alignment: Alignment.topCenter,
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 15,
              ),
              ChipList(
                  listOfChipNames: ["Uncompleted".tr(), "Completed".tr()],
                  activeBgColorList: [MyColors.primary],
                  inactiveBgColorList: [Colors.white],
                  activeTextColorList: [Colors.white],
                  inactiveTextColorList: [Theme.of(context).primaryColor],
                  listOfChipIndicesCurrentlySeclected: [status],
                  activeBorderColorList: [MyColors.primary],
                  inactiveBorderColorList: [MyColors.primary],
                  style: TextStyle(fontSize: 19),
                  shouldWrap: true,
                  runSpacing: 10,
                  spacing: 50,
                  extraOnToggle: ((index) {
                    setState(() {
                      status = index;
                    });
                  })),
              SizedBox(
                height: 25,
              ),
              Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: stream,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Center(child: Text("Server error".tr()));
                        }
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Container(
                                height: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 300,
                                    ),
                                    CircularProgressIndicator()
                                  ],
                                ));

                          default:
                            if (snapshot.hasData &&
                                snapshot.data!.docs.isEmpty) {
                              return Container(
                                  padding: EdgeInsets.only(top: 30),
                                  child: Center(child: Text("No tasks".tr())));
                            } else {
                              documents = snapshot.data!.docs;
                              filter();
                              if (documents.length == 0) {
                                return Container(
                                    padding: EdgeInsets.only(top: 30),
                                    child:
                                        Center(child: Text("No tasks".tr())));
                              } else {
                                return Container(
                                    child: ListView.separated(
                                        separatorBuilder: (context, i) {
                                          return SizedBox(height: 30);
                                        },
                                        shrinkWrap: true,
                                        physics: ScrollPhysics(),
                                        itemCount: documents.length,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5),
                                        itemBuilder: (context, i) {
                                          UserTask task = UserTask.fromMap(
                                              documents[i].data()
                                                  as Map<String, dynamic>);

                                          return GestureDetector(
                                            child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 15,
                                                    vertical: 20),
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 15),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: MyColors.primary,
                                                        width: 2)),
                                                child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Flexible(
                                                          child: AutoSizeText(
                                                              task.name,
                                                              maxLines: 1,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold))),
                                                      Text(task.time,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ])),
                                            onTap: (){
                                              if(DateHelper.isDateAfterToday(date)){
                                                Navigator.pushNamed(context, "view_task",
                                                    arguments: {'task_id': task.task_id});
                                              }
                                            },
                                          );
                                        }));
                              }
                            }
                        }
                      })),
              SizedBox(height: 20),
            ],
          )),
      floatingActionButton: DateHelper.isDateAfterToday(date)
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

  filter() {
    Iterable<DocumentSnapshot<Object?>> filter = documents.where((element) {
      return checkFilter(element);
    });
    documents = filter.toList();
  }

  bool checkFilter(DocumentSnapshot<Object?> doc) {
    UserTask task = UserTask.fromDocument(doc);
    bool result = task.user_id == Database.loggedUserId() && task.date == date;

    if (status == 0)
      result = result && task.completed == false;
    else
      result = result && task.completed == true;
    return result;
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
    UserTask task = new UserTask(
        task_id, Database.loggedUserId(), task_name, date, time, notifyTask);
    await Database.tasks().doc(task_id).set(task.toMap());
    if(notifyTask){
      await Notify.schedule(task_id,task_name,task.date, time);
    }
    progressDialog.dismiss();
    FlutterA.close_current_page(context);
  }
}
