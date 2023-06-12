import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'helper/FlutterA.dart';
import 'helper/MyColors.dart';
import 'helper/DesignHelper.dart';

class RecoverPassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() =>RecoverPasswordState();
}

class RecoverPasswordState extends State<RecoverPassword>{

  late String email;

  GlobalKey<FormState> formState = new GlobalKey<FormState>();

  submit() async {
    var form = formState.currentState;
    if(form!.validate()){
      form.save();
      AwesomeDialog progressDialog = FlutterA.progressDialog('Recover'.tr(),context);
      if (!await FlutterA.isInternetAvailable()) {
        FlutterA.showErrorMsg(context, "No internet".tr());
      }
      else {
        progressDialog.show();
        try {
          await FirebaseAuth.instance
              .sendPasswordResetEmail(
            email: email,
          );
          progressDialog.dismiss();
          FlutterA.toast("Password recovery has been sent to your email".tr());
          Navigator.pop(context);
        } on FirebaseAuthException {
          progressDialog.dismiss();
          FlutterA.showErrorMsg(context,
              "User not found".tr());
        }
      }
    }
  }

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    return Scaffold(
        body:Form(key:formState,child:Container(alignment:Alignment.topCenter,width:double.infinity,child:SingleChildScrollView(scrollDirection: Axis.vertical,child:Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 25),
            Container(
                margin: EdgeInsets.only(left: 22),
                child:Image(
                  image: AssetImage('assets/images/logo.png',),
                  height: 220,
                )),
            SizedBox(height: 45),
            Container(

                child: Text("Restore Password".tr(),style: TextStyle(fontSize: 23,fontWeight:FontWeight.bold,color:MyColors.black))),
            SizedBox(height: 40),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child:TextFormField(
                  cursorColor: Theme.of(context).primaryColor,
                  style: DesignHelper.fieldStyle,
                  keyboardType: TextInputType.emailAddress,
                  decoration:  InputDecoration(
                      labelText: "Email address".tr(),
                      labelStyle: DesignHelper.fieldStyle,
                      errorStyle: DesignHelper.fieldErrorStyle,
                      prefixIcon: Icon(Icons.mail,color:Theme.of(context).primaryColor),
                      enabledBorder:DesignHelper.fieldBorder,
                      focusedBorder: DesignHelper.fieldBorder,
                      disabledBorder: DesignHelper.fieldBorder,
                      errorBorder: DesignHelper.fieldErrorBorder,
                      focusedErrorBorder: DesignHelper.fieldErrorBorder
                  ),
                  validator: (text){
                    if(text!.trim().isEmpty){
                      return "Email address".tr()+" "+"is required".tr();
                    }
                    if(! FlutterA.isEmailValid(text)){
                      return "Invalid email".tr();
                    }
                    return null;
                  },
                  onSaved: (text){email=text.toString();},
                )),
            SizedBox(height: 40),
            SizedBox(width:DesignHelper.buttonWidth,height:DesignHelper.buttonHeight,child:
            ElevatedButton(onPressed: (){
              submit();
            }, child: Text("Restore".tr()),
              style: DesignHelper.buttonStyle,
            )),
            SizedBox(height: 25),
            Row(mainAxisAlignment:MainAxisAlignment.center,children: [
              TextButton(child:Text("Back to login".tr(),style:Theme.of(context).textTheme.subtitle2),onPressed: (){
                Navigator.of(context).pushNamed("login".tr());
              },),
            ],),
            SizedBox(height: 15),
          ],))
        )));
  }


}