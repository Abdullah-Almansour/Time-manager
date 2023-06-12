import 'package:auto_size_text/auto_size_text.dart';
import 'package:chip_list/chip_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_manager/helper/DateHelper.dart';
import 'helper/DesignHelper.dart';
import 'helper/MyColors.dart';
import 'helper/Pref.dart';
import 'model/Database.dart';
import 'model/UserTask.dart';

class  YesterdayReport extends StatefulWidget {
  const YesterdayReport({Key? key}) : super(key: key);


  @override
  State<StatefulWidget> createState() =>YesterdayReportState();
}

class YesterdayReportState extends State<YesterdayReport> {

  final Stream<QuerySnapshot> stream = Database.tasks().orderBy("timestamp",descending: false).snapshots();
  List<DocumentSnapshot> documents = [];
  var status = 0;

  @override
  void initState() {
    super.initState();
    Pref.set_nav(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: DesignHelper.appBar("Yesterday's tasks report", false),
        body: Container(alignment:Alignment.topCenter,width:double.infinity,child:
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 15,),
            ChipList(
                listOfChipNames: ["Uncompleted".tr(),"Completed".tr()],
                activeBgColorList: [MyColors.primary],
                inactiveBgColorList: [Colors.white],
                activeTextColorList: [Colors.white],
                inactiveTextColorList: [Theme.of(context).primaryColor
                ],
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
            SizedBox(height: 25,),
            Expanded(child:StreamBuilder<QuerySnapshot>(
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
                              SizedBox(height: 300,),
                              CircularProgressIndicator()
                            ],
                          ));

                    default:
                      if (snapshot.hasData &&
                          snapshot.data!.docs.isEmpty) {
                        return Container(padding:EdgeInsets.only(top:30),
                            child:Center(child: Text("No tasks".tr())));
                      }
                      else {
                        documents = snapshot.data!.docs;
                        filter();
                        if (documents.length == 0) {
                          return Container(padding:EdgeInsets.only(top:30),
                              child:Center(child: Text("No tasks".tr())));
                        }
                        else{
                          return Container(
                              child:
                              ListView.separated(
                                  separatorBuilder: (context, i) {
                                    return  SizedBox(height:30);
                                  },
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  itemCount: documents.length,
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  itemBuilder: (context, i) {
                                    UserTask task = UserTask.fromMap(
                                        documents[i].data() as Map<String, dynamic>);

                                    return GestureDetector(
                                      child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 15,vertical: 20),
                                          margin: EdgeInsets.symmetric(horizontal: 15),
                                          decoration: BoxDecoration(
                                              border:
                                              Border.all(color: MyColors.primary,width: 2)),
                                          child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                Flexible(
                                                    child: AutoSizeText(task.name,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 18,
                                                            fontWeight:
                                                            FontWeight.bold))),
                                                Text(task.time,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold)),
                                                if(task.completed == false)
                                                SizedBox(
                                                    width: DesignHelper.buttonWidth3,
                                                    height:30,
                                                    child: ElevatedButton(
                                                      onPressed:() async {
                                                        await Database.tasks()
                                                            .doc(task.task_id)
                                                            .update({'date':DateHelper.next_day(task.date)});
                                                      },
                                                      child: FittedBox(child: Text("Move to next day")),
                                                      style: DesignHelper.buttonStyle,
                                                    )),

                                              ])),

                                    );

                                  }


                              ));
                        }}
                  }
                })),
            SizedBox(height: 20),
          ],)
        )
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
    bool result = task.date == DateHelper.yesterday_date();

    if (status == 0)
      result = result && task.completed == false;
    else
      result = result && task.completed == true;
    return result;
  }


}