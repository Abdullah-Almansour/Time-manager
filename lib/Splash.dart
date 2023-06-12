import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'helper/MyColors.dart';
import 'helper/Notify.dart';
import 'model/Database.dart';

class Splash extends StatefulWidget {
  @override
  State<StatefulWidget> createState() =>SplashState();
}

class SplashState extends State<Splash>{

  @override
  void initState(){
    WidgetsBinding.instance.addPostFrameCallback((_){
      notification_listener();
      Future.delayed(const Duration(seconds: 2), () {
      if(Database.loggedUserId() == "logout"){
        Navigator.pushReplacementNamed(context,"login");
      }
      else{
        Navigator.pushReplacementNamed(context,"home");
      }
    });
    });
    super.initState();
  }


  notification_listener(){

    AwesomeNotifications().isNotificationAllowed().then((isAllowed){
      if(!isAllowed){
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    AwesomeNotifications().setListeners(
      onActionReceivedMethod: (ReceivedAction receivedAction){
        return Notify.onActionReceivedMethod(receivedAction);
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    return Scaffold(
        body:Container(
            width: double.infinity,
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage('assets/images/logo.png',),
                  height: 280,
                ),
                SizedBox(height:25),
                SpinKitThreeBounce(
                  color: MyColors.primary,
                  size: 13.0,
                ),
                SizedBox(height:100)
              ],))
    );
  }


}