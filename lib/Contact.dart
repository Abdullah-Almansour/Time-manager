import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'helper/DesignHelper.dart';
import 'helper/FlutterA.dart';
import 'helper/MyColors.dart';
import 'helper/Pref.dart';


class Contact extends StatefulWidget {
  const Contact({Key? key}) : super(key: key);


  @override
  State<StatefulWidget> createState() =>ContactState();
}

class ContactState extends State<Contact>{

  @override
  void initState() {
    super.initState();
    Pref.set_nav(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:DesignHelper.appBar('Contact us'.tr(),true),
        body: Container(width:double.infinity,child:SingleChildScrollView(scrollDirection: Axis.vertical,child:Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Icon(Icons.contact_phone_outlined,size:105,color:MyColors.primary),
              Divider(height: 1,),
              SizedBox(height: 30),
              DesignHelper.contactItem(icon: Icons.email_outlined, title:'time_manager@hotmail.com', onTap: (){
            Clipboard.setData(ClipboardData(text: "time_manager@hotmail.com"));
            FlutterA.toast("Email copied".tr());
            launchUrl(Uri.parse("mailto:<time_manager@hotmail.com>?subject=<>&body=<>"));
              }),
            ])))
    );
  }



}