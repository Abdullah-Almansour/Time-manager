import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_manager/helper/FileHelper.dart';
import 'package:time_manager/helper/Notify.dart';
import 'package:time_manager/model/UserTask.dart';
import 'helper/DateHelper.dart';
import 'helper/DesignHelper.dart';
import 'helper/FlutterA.dart';
import 'helper/MyColors.dart';
import 'model/Database.dart';

class ViewTask extends StatefulWidget {
  final taskID;

  const ViewTask(this.taskID, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ViewTaskState();
}

class ViewTaskState extends State<ViewTask> {
  late String task_id;
  final TextEditingController taskNameEditing = TextEditingController();
  bool notifyTask = false;
  TimeOfDay selected_time = TimeOfDay.now();
  TextEditingController time_controller = new TextEditingController();
  bool isFirstTime = true;
  late UserTask task;

  @override
  Widget build(BuildContext context) {
    if (widget.taskID == null) {
      final Map<String, dynamic> receivedData =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      task_id = receivedData['task_id'] as String;
    } else {
      task_id = widget.taskID;
    }
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: DesignHelper.appBar("Task info".tr(),true,[
         IconButton(onPressed: (){delete_task();}, icon:Icon(Icons.delete))
        ]),
        body: FutureBuilder(
            future: Database.tasks().doc(task_id).get(),
            builder:
                (context, AsyncSnapshot<DocumentSnapshot<Object?>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Container(child:Center(child: CircularProgressIndicator()));
                default:
                  if (snapshot.hasData) {
                     task = UserTask.fromMap(
                        snapshot.data!.data() as Map<String, dynamic>);
                    if (isFirstTime) {
                      notifyTask = task.notify;
                      taskNameEditing.text = task.name;
                      time_controller.text = task.time;
                      isFirstTime = false;
                    }
                    return Container(
                        width: double.infinity,
                        child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,

                            child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: 20),
                                  Icon(
                                    Icons.task_outlined,
                                    color: MyColors.primary,
                                    size: 70,
                                  ),
                                  SizedBox(
                                    height: 35,
                                  ),
                                  Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: TextFormField(
                                        controller: taskNameEditing,
                                        cursorColor: MyColors.filedColor,
                                        style: DesignHelper.fieldStyle,
                                        keyboardType: TextInputType.text,
                                        maxLength: 20,
                                        decoration: InputDecoration(
                                          labelText: "Task name",
                                          labelStyle: DesignHelper.fieldStyle,
                                          prefixIcon: Icon(Icons.info,
                                              color: MyColors.primary),
                                          enabledBorder:
                                              DesignHelper.fieldBorder,
                                          focusedBorder:
                                              DesignHelper.fieldBorder,
                                          disabledBorder:
                                              DesignHelper.fieldBorder,
                                        ),
                                      )),
                                  SizedBox(height: 25),
                                  Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: TextFormField(
                                        cursorColor:
                                            Theme.of(context).primaryColor,
                                        style: DesignHelper.fieldStyle,
                                        keyboardType: TextInputType.none,
                                        onTap: () async {
                                          final TimeOfDay? picked =
                                              await showTimePicker(
                                            context: context,
                                            initialTime: selected_time,
                                            helpText: "Task time".tr(),
                                          );
                                          if (picked != null &&
                                              picked != selected_time)
                                            setState(() {
                                              selected_time = picked;
                                              time_controller.text = DateHelper
                                                  .format_TimeOfDay_12(
                                                      selected_time);
                                            });
                                        },
                                        controller: time_controller,
                                        decoration: InputDecoration(
                                            labelText: "Task time".tr(),
                                            labelStyle: DesignHelper.fieldStyle,
                                            errorStyle:
                                                DesignHelper.fieldErrorStyle,
                                            prefixIcon: Icon(Icons.access_time,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                            enabledBorder:
                                                DesignHelper.fieldBorder,
                                            focusedBorder:
                                                DesignHelper.fieldBorder,
                                            disabledBorder:
                                                DesignHelper.fieldBorder,
                                            errorBorder:
                                                DesignHelper.fieldErrorBorder,
                                            focusedErrorBorder:
                                                DesignHelper.fieldErrorBorder),
                                      )),
                                  SizedBox(height: 30),
                                  Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: Row(
                                        children: <Widget>[
                                          SizedBox(
                                            width: 30,
                                          ),
                                          //SizedBox
                                          Text(
                                            'Notify when time come',
                                            style: TextStyle(fontSize: 20.0),
                                          ),
                                          //TextSizedBox(width: 10), //SizedBox
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
                                  SizedBox(height: 40),
                                  SizedBox(
                                      width: DesignHelper.buttonWidth,
                                      height: DesignHelper.buttonHeight,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          save();
                                        },
                                        child: Text("Save".tr()),
                                        style: DesignHelper.buttonStyle,
                                      )),
                                  SizedBox(height: 15),
                                ])));
                  } else {
                    return SizedBox.shrink();
                  }
              }
            }));
  }

  save() async {
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
    AwesomeDialog progressDialog =
        FlutterA.progressDialog('Update task', context);
    progressDialog.show();
    await Database.tasks()
        .doc(task_id)
        .update({'name': task_name, 'time': time, 'notify': notifyTask});
    if(notifyTask){
      await Notify.cancel_schedule(task_id);
      await Notify.schedule(task_id,task_name,task.date, time);
    }
    else{
      await Notify.cancel_schedule(task_id);
    }
    progressDialog.dismiss();
    FlutterA.close_current_page(context);

  }

  delete_task() {
    AwesomeDialog(
      context: context,
      title: "Are you sure delete task?",
      isDense: true,
      btnCancelText: "no",
      btnCancelOnPress: () {},
      btnCancelColor: MyColors.primary,
      btnOkText: "yes",
      btnOkColor: MyColors.primary,
      dismissOnBackKeyPress: false,
      dismissOnTouchOutside: false,
      customHeader: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Icon(Icons.warning, color: MyColors.primary, size: 55),
        ],
      ),
      btnOkOnPress: () async {
        AwesomeDialog progressDialog =
        FlutterA.progressDialog('Delete task', context);
        progressDialog.show();
        await Database.tasks()
            .doc(task_id)
            .delete();
        progressDialog.dismiss();
        FlutterA.close_current_page(context);
      },
    )..show();
  }
}
