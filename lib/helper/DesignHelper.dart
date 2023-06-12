
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import '../model/Database.dart';
import 'Lang.dart';
import 'MyColors.dart';
import 'Pref.dart';

class DesignHelper {
  static const fieldBorder = OutlineInputBorder(
    borderSide: BorderSide(
      color: MyColors.primary,
      width: 1,

    ),
    borderRadius: BorderRadius.all(Radius.circular(30)),
  );
  static const fieldErrorBorder = OutlineInputBorder(
    borderSide: BorderSide(
      color: MyColors.errorColor,
      width: 1,

    ),
    borderRadius: BorderRadius.all(Radius.circular(30)),
  );

  static const fieldStyle = TextStyle(
    fontSize: 20,
    color: MyColors.primary,

  );
  static const fieldErrorStyle = TextStyle(
    fontSize: 14,
    color: MyColors.errorColor,

  );

  static const fieldStyle2 = TextStyle(
    fontSize: 16,
    color: MyColors.primary,

  );
  static const fieldBorder2 = OutlineInputBorder(
    borderSide: BorderSide(
      color: MyColors.primary,
      width: 2,

    ),
  );



  static ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: MyColors.buttonColor,
      foregroundColor: Colors.white,
      textStyle: TextStyle(
        fontSize: 21,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
  );

  static ButtonStyle buttonStyle2 = ElevatedButton.styleFrom(
      backgroundColor: MyColors.buttonColor2,
      foregroundColor: Colors.white,
      textStyle: TextStyle(
        fontSize: 19,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
  );


  static ButtonStyle buttonStyle3 = ElevatedButton.styleFrom(
      padding: EdgeInsets.only(top: 5),
      backgroundColor: MyColors.buttonColor,
      foregroundColor: MyColors.white,
      textStyle: TextStyle(
        fontSize: 26,
        fontFamily: "Bold",
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30),side: BorderSide(color: MyColors.primary,width: 3))
  );

  static ButtonStyle buttonStyle4 = ElevatedButton.styleFrom(
      padding: EdgeInsets.only(top: 5),
      backgroundColor: MyColors.buttonColor,
      foregroundColor: MyColors.white,
      textStyle: TextStyle(
        fontSize: 20,
        fontFamily: "Bold",
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0),side: BorderSide(color: MyColors.primary,width: 2))
  );


  static ButtonStyle buttonStyle5 = ElevatedButton.styleFrom(
      padding: EdgeInsets.only(top: 5),
      backgroundColor: MyColors.buttonColor,
      foregroundColor: MyColors.white,
      textStyle: TextStyle(
        fontSize: 16,
        fontFamily: "Bold",
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30),side: BorderSide(color: MyColors.primary,width: 2))
  );

  static ButtonStyle buttonStyle6 = ElevatedButton.styleFrom(
      backgroundColor: MyColors.white,
      foregroundColor: MyColors.primary,
      textStyle: TextStyle(
        fontSize: 21,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
  );

  static ButtonStyle buttonStyle7 = ElevatedButton.styleFrom(
      backgroundColor: MyColors.white,
      foregroundColor: MyColors.errorColor,
      textStyle: TextStyle(
        fontSize: 21,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
  );

  static double buttonWidth = 200;
  static double buttonHeight = 45;
  static double buttonWidth2 = 210;
  static double buttonHeight2 = 50;
  static double buttonWidth3 = 120;
  static double buttonHeight3 = 45;
  static double buttonWidth4 = 100;
  static double buttonHeight4 = 45;
  static TextStyle barTitleStyle = TextStyle(color: Colors.white, fontSize: 18);


  static TextStyle drawerTextStyle = TextStyle(color: MyColors.white,fontSize: 18);
  static double drawerIconSize = 42;

  static dropDownTitleText(text) {
    return Text(text,
        style: TextStyle(fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black
        ));
  }

  static dropDownText(text) {
    return Text(text, textAlign: TextAlign.center, style: TextStyle(
      color: Colors.white,
      fontSize: 16,
    ));
  }

  static double dropDownHeight = 48;
  static double dropDownIconSize = 27;
  static double dropDownMargin = 30;
  static double dropDownPadding = 30;
  static Color dropDownColor = MyColors.primary;

  static Alignment startAlignment(locale){
    if(Lang.isEnglish(locale))
      return Alignment.centerLeft;
    else
      return Alignment.centerRight;
  }

  static Alignment endAlignment(locale){
    if(Lang.isEnglish(locale))
      return Alignment.centerRight;
    else
      return Alignment.centerLeft;
  }

  static EdgeInsets startPadding(double num,locale){
    if(Lang.isEnglish(locale))
      return EdgeInsets.only(left: num);
    else
      return EdgeInsets.only(right: num);
  }

  static EdgeInsets endPadding(double num,locale){
    if(Lang.isEnglish(locale))
      return EdgeInsets.only(right: num);
    else
      return EdgeInsets.only(left: num);
  }

  static AppBar appBar(title, show_leading,[action_leading]) {
    return AppBar(
      elevation: 0.0,
      centerTitle: true,
      automaticallyImplyLeading: show_leading,
      actions: action_leading,
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 21,
        ),
      ),
    );
  }
  static AppBar appBarLeading(title,leading) {
    return AppBar(
      elevation: 0.0,
      centerTitle: true,
      automaticallyImplyLeading: true,
      leading: leading,
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 21,
        ),
      ),
    );
  }

  static Widget profileItem({required IconData icon,
    required String title,
    required VoidCallback onTap, double? font_size, double? icon_size}) {
    return ListTile(
      tileColor: Colors.white,
      minVerticalPadding: 25,
      minLeadingWidth: 10,
      leading: Icon(
        icon,
        color: MyColors.primary,
        size: 45,
      ),
      title: Text(
        title,
        style: TextStyle(
            color: MyColors.gray,
            fontSize: 22
        ),

      ),
      onTap: onTap,
    );
  }



  static Widget contactItem({required IconData icon,
    required String title,
    required VoidCallback onTap}) {
    return ListTile(
      tileColor: Colors.white,
      minVerticalPadding: 0,
      minLeadingWidth: 10,
      leading: Icon(
        icon,
        color: MyColors.gray,
        size: 45,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: MyColors.gray,
          fontSize: 24,

        ),

      ),
      onTap: onTap,
    );
  }




}




