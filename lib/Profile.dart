import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_manager/helper/DateHelper.dart';
import 'package:time_manager/helper/FlutterA.dart';

import 'helper/DesignHelper.dart';
import 'helper/FileHelper.dart';
import 'helper/MyColors.dart';
import 'helper/Notify.dart';
import 'helper/Pref.dart';
import 'model/Database.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
    Pref.set_nav(3);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);
    return Scaffold(
        appBar: DesignHelper.appBar('Profile'.tr(), false),
        body: Container(
            width: double.infinity,
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 5),
                      Container(
                          width: double.infinity,
                          color: Colors.white,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 10,
                              ),
                              CircleAvatar(
                                  radius: (50),
                                  backgroundColor: MyColors.primary,
                                  child: ClipRRect(
                                    // borderRadius:BorderRadius.circular(100),
                                    child:
                                        Image.asset("assets/images/userr.png"),
                                  )),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                Pref.getName(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 24,
                                    color: MyColors.primary,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )),
                      SizedBox(height: 10),
                      Divider(
                        height: 1,
                      ),
                      DesignHelper.profileItem(
                          icon: Icons.person,
                          title: 'Update profile'.tr(),
                          onTap: () {
                            Navigator.of(context)
                                .pushReplacementNamed("profile_edit");
                          }),
                      Divider(
                        height: 1,
                      ),
                      DesignHelper.profileItem(
                          icon: Icons.timer_sharp,
                          title: 'Timer'.tr(),
                          onTap: () {
                            Navigator.of(context).pushNamed("timer");
                          }),
                      Divider(
                        height: 1,
                      ),
                      DesignHelper.profileItem(
                          icon: Icons.quick_contacts_dialer_outlined,
                          title: 'Contact us'.tr(),
                          onTap: () {
                            Navigator.of(context).pushNamed("contact");
                          }),
                      Divider(
                        height: 1,
                      ),
                      DesignHelper.profileItem(
                          icon: Icons.logout,
                          title: 'Logout'.tr(),
                          onTap: () async
                          {
                            logout();
                          }),
                    ]))));
  }

  logout() {
    AwesomeDialog(
      context: context,
      body: Text(
        "Do you want to sign out?".tr(),
        style: TextStyle(fontSize: 19, color: MyColors.primary),
      ),
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
        ],
      ),
      btnOkOnPress: () {
        Database.logout();
        Pref.set_nav(0);
        Navigator.pushReplacementNamed(context, "login");
      },
    )..show();
  }
}
