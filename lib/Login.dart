import 'package:auto_direction/auto_direction.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'helper/FlutterA.dart';
import 'helper/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'helper/DesignHelper.dart';

import 'helper/Pref.dart';
import 'model/Database.dart';
import 'model/Users.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginState();
}

class LoginState extends State<Login> {
  late String email;
  late String password;
  GlobalKey<FormState> formState = new GlobalKey<FormState>();
  String text = "";

  login() async {
    var form = formState.currentState;
    if (form!.validate()) {
      form.save();

      AwesomeDialog progressDialog =
          FlutterA.progressDialog('Login'.tr(), context);

      if (!await FlutterA.isInternetAvailable()) {
        FlutterA.showErrorMsg(context, "No internet".tr());
      } else {
        progressDialog.show();
        try {
          await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: password);
          var snapshot =
              await Database.users().doc(Database.loggedUserId()).get();
          Users user = Users.fromMap(snapshot.data() as Map<String, dynamic>);
          Pref.setName(user.name);
          progressDialog.dismiss();
          Navigator.pushReplacementNamed(context, "home");
        } on FirebaseAuthException {
          progressDialog.dismiss();
          FlutterA.showErrorMsg(context, "Invalid email or password".tr());
        } catch (e) {
          progressDialog.dismiss();
          FlutterA.showErrorMsg(context, "Server error".tr());
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    return Scaffold(
        body: Form(
            key: formState,
            child: Container(
                alignment: Alignment.topCenter,
                width: double.infinity,
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 25),
                        Image(
                          image: AssetImage(
                            'assets/images/logo.png',
                          ),
                          height: 220,
                        ),
                        SizedBox(height: 45),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: AutoDirection(
                                text: text,
                                child: TextFormField(
                                    cursorColor: MyColors.filedColor,
                                    style: DesignHelper.fieldStyle,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                        labelText: "Email address".tr(),
                                        labelStyle: DesignHelper.fieldStyle,
                                        errorStyle:
                                            DesignHelper.fieldErrorStyle,
                                        prefixIcon: Icon(Icons.email,
                                            color: MyColors.filedColor),
                                        enabledBorder: DesignHelper.fieldBorder,
                                        focusedBorder: DesignHelper.fieldBorder,
                                        disabledBorder:
                                            DesignHelper.fieldBorder,
                                        errorBorder:
                                            DesignHelper.fieldErrorBorder,
                                        focusedErrorBorder:
                                            DesignHelper.fieldErrorBorder),
                                    validator: (text) {
                                      if (text!.trim().isEmpty) {
                                        return "Email address".tr() +
                                            " " +
                                            "is required".tr();
                                      }
                                      return null;
                                    },
                                    onSaved: (text) {
                                      email = text.toString();
                                    },
                                    onChanged: (str) {
                                      setState(() {
                                        text = str;
                                      });
                                    }))),
                        SizedBox(height: 30),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: TextFormField(
                              cursorColor: MyColors.filedColor,
                              style: DesignHelper.fieldStyle,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              decoration: InputDecoration(
                                  labelText: "Password".tr(),
                                  labelStyle: DesignHelper.fieldStyle,
                                  errorStyle: DesignHelper.fieldErrorStyle,
                                  prefixIcon: Icon(Icons.lock,
                                      color: MyColors.filedColor),
                                  //ايقونه بدتية الفيلد
                                  enabledBorder: DesignHelper.fieldBorder,
                                  focusedBorder: DesignHelper.fieldBorder,
                                  disabledBorder: DesignHelper.fieldBorder,
                                  errorBorder: DesignHelper.fieldErrorBorder,
                                  focusedErrorBorder:
                                      DesignHelper.fieldErrorBorder),
                              validator: (text) {
                                if (text!.trim().isEmpty) {
                                  return "Password".tr() +
                                      " " +
                                      "is required".tr();
                                }

                                return null;
                              },
                              onSaved: (text) {
                                password = text.toString();
                              },
                            )),
                        Container(
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: TextButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed("re_password");
                              },
                              child: Text("Forgot your password?".tr(),
                                  style:
                                      Theme.of(context).textTheme.headline6)),
                        ),
                        SizedBox(height: 35),
                        SizedBox(
                            width: DesignHelper.buttonWidth2,
                            height: DesignHelper.buttonHeight2,
                            child: ElevatedButton(
                              onPressed: () {
                                login();
                              },
                              child: Text("Sign in".tr()),
                              style: DesignHelper.buttonStyle,
                            )),
                        SizedBox(height: 40),
                        Text(
                          "____________  OR  ____________",
                          style: TextStyle(fontSize: 20, color: MyColors.gray),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("New Account ?".tr(),
                                style: Theme.of(context).textTheme.titleSmall),
                            TextButton(
                              child: Text("Create an account".tr(),
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                              onPressed: () {
                                Navigator.of(context).pushNamed("register");
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 50),
                      ],
                    )))));
  }
}
