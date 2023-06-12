import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'helper/DesignHelper.dart';
import 'helper/MyColors.dart';
import 'helper/Pref.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TimerPageState();
}

class TimerPageState extends State<TimerPage> {
  String timer_text = Pref.get_num().toString();
  int num = Pref.get_num();
  late Timer timer;
  bool isStart = false;

  @override
  void initState() {
    super.initState();
    Pref.set_nav(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: DesignHelper.appBar('Timer'.tr(), true),
        body: Container(
            width: double.infinity,
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 45,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: MyColors.primary, width: 3),
                        ),
                        child: CircleAvatar(
                            radius: (65),
                            backgroundColor: MyColors.white,
                            child: AutoSizeText(
                              timer_text,
                              style: TextStyle(
                                  fontSize: 30,
                                  color: MyColors.primary,
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                      SizedBox(
                        height: 55,
                      ),
                      SizedBox(
                          width: DesignHelper.buttonWidth2,
                          height: DesignHelper.buttonHeight2,
                          child: ElevatedButton(
                            onPressed: isStart
                                ? null
                                : () {
                                    start();
                                  },
                            child: Text("Start".tr()),
                            style: DesignHelper.buttonStyle,
                          )),
                      SizedBox(height: 55),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                                width: DesignHelper.buttonWidth3,
                                height: DesignHelper.buttonHeight3,
                                child: ElevatedButton(
                                    onPressed: !isStart
                                        ? null
                                        : () {
                                            reset();
                                          },
                                    child: FittedBox(child: Text("Reset".tr())),
                                    style: DesignHelper.buttonStyle)),
                            SizedBox(
                                width: DesignHelper.buttonWidth3,
                                height: DesignHelper.buttonHeight3,
                                child: ElevatedButton(
                                  onPressed: !isStart
                                      ? null
                                      : () {
                                          pause();
                                        },
                                  child: FittedBox(child: Text("Pause")),
                                  style: DesignHelper.buttonStyle,
                                )),
                          ]),
                    ]))));
  }

  start() {
    timer = Timer.periodic(new Duration(seconds: 1), (timer) {
      num++;
      Pref.set_num(num);
      setState(() {
        timer_text = num.toString();
      });
    });
    isStart = true;
  }

  reset() {
    if (timer.isActive) {
      timer.cancel();
      setState(() {
        timer_text = "0";
        num = 0;
        Pref.set_num(num);
        isStart = false;
      });
    }
  }

  pause() {
    if (timer.isActive) {
      timer.cancel();
      setState(() {
        isStart = false;
      });
    }
  }
}
