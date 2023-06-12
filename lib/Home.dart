
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_manager/Calendar.dart';
import 'package:time_manager/YesterdayReport.dart';

import 'HomePage.dart';
import 'Profile.dart';
import 'helper/MyColors.dart';
import 'helper/Pref.dart';



class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() =>HomeState();
}

class HomeState extends State<Home>{

  int selectedNav=Pref.get_nav();
  List<Widget> pages = [HomePage(),YesterdayReport(),Calendar(),Profile()];

  @override
  void initState(){
    super.initState();

  }



  @override
  Widget build(BuildContext context) {
    selectedNav==0?
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive):
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
      SystemUiOverlay.top
    ]);

    return WillPopScope(
        onWillPop:(){
          exit();
      return Future.value(false);
    },
    child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: MyColors.primary,
          selectedItemColor: Colors.white,
          unselectedItemColor: MyColors.gray5,
          currentIndex: selectedNav,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          
          iconSize: 45,
          onTap: (index){
            setState(() {
              selectedNav = index;
            });
          },
          items:[
            BottomNavigationBarItem(
                icon: Padding(padding: EdgeInsets.all(6.0),child:Icon(Icons.home))
                ,label: ""
            ),
            BottomNavigationBarItem(
                icon: Padding(padding: EdgeInsets.all(6.0),child:Icon(Icons.task_outlined))
                ,label: ""
            ),
            BottomNavigationBarItem(
                icon: Padding(padding: EdgeInsets.all(6.0),child:Icon(Icons.calendar_today_outlined))
                ,label: ""
            ),
            BottomNavigationBarItem(
                icon: Padding(padding: EdgeInsets.all(6.0),child:Icon(Icons.person))
                ,label: ""
            )
          ],
        ),
        body:pages.elementAt(selectedNav)
    ));



  }

   exit() {
    return AwesomeDialog(
      context: context,
      body: Text("Are you sure to close the application?".tr(),
        style: TextStyle(fontSize: 19, color: MyColors.primary),),
      isDense: true,
      btnCancelText: "no".tr(),
      btnCancelOnPress: () {},
      btnCancelColor: MyColors.primary,
      btnOkText: "yes".tr(),
      btnOkColor: MyColors.primary,
      dismissOnBackKeyPress: false,
      dismissOnTouchOutside: false,
      customHeader: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Icon(Icons.warning, color: MyColors.primary, size: 50),
        ],),
      btnOkOnPress: () {
        SystemNavigator.pop();
      },
    )
      ..show();
  }




}