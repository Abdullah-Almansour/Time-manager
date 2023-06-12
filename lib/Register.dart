import 'package:auto_direction/auto_direction.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'helper/FlutterA.dart';
import 'helper/MyColors.dart';
import 'helper/Pref.dart';
import 'model/Database.dart';
import 'helper/DesignHelper.dart';
import 'model/Users.dart';

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RegisterState();
}

class RegisterState extends State<Register> {
  late String email;
  late String password;
  final TextEditingController passwordEditing = TextEditingController();
  late String name;
  late String phone;
  String text = "";
  GlobalKey<FormState> formState = new GlobalKey<FormState>();

  register() async {
    var form = formState.currentState;
    if (form!.validate()) {
      form.save();
      AwesomeDialog progressDialog =
          FlutterA.progressDialog('Register'.tr(), context);
      if (!await FlutterA.isInternetAvailable()) {
        FlutterA.showErrorMsg(context, "No internet".tr());
      } else {
        progressDialog.show();
        try {
          await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: password);
          Users user =
              new Users(Database.loggedUserId(), email, password, name, phone);
          Database.users()
              .doc(Database.loggedUserId())
              .set(user.toMap())
              .then((value) async {
            Pref.setName(user.name);
            progressDialog.dismiss();
            Navigator.pushReplacementNamed(context, "home");
          }).catchError((error) {
            progressDialog.dismiss();
            FlutterA.showErrorMsg(context, "Server error".tr());
          });
          progressDialog.dismiss();
          Navigator.pushReplacementNamed(context, "home");
        } on FirebaseAuthException catch (e) {
          progressDialog.dismiss();
          if (e.code == 'email-already-in-use') {
            FlutterA.showErrorMsg(context, "Email already exists".tr());
          } else {
            FlutterA.showErrorMsg(context, "Server error".tr());
          }
        } catch (e) {
          progressDialog.dismiss();
          FlutterA.showErrorMsg(context, e.toString());
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
                        Container(
                            margin: EdgeInsets.only(left: 22),
                            child: Image(
                              image: AssetImage(
                                'assets/images/logo.png',
                              ),
                              height: 200,
                            )),
                        SizedBox(height: 30),
                        Text(
                          "Create New Account",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 40),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: AutoDirection(
                                text: text,
                                child: TextFormField(
                                    cursorColor: Theme.of(context).primaryColor,
                                    style: DesignHelper.fieldStyle,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                        labelText: "Email address".tr(),
                                        labelStyle: DesignHelper.fieldStyle,
                                        errorStyle:
                                            DesignHelper.fieldErrorStyle,
                                        prefixIcon: Icon(Icons.mail,
                                            color:
                                                Theme.of(context).primaryColor),
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
                                      if (!FlutterA.isEmailValid(text)) {
                                        return "Invalid email";
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
                        SizedBox(height: 25),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: TextFormField(
                              cursorColor: Theme.of(context).primaryColor,
                              style: DesignHelper.fieldStyle,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              //وضع نجوم
                              controller: passwordEditing,
                              decoration: InputDecoration(
                                  labelText: "Password".tr(),
                                  labelStyle: DesignHelper.fieldStyle,
                                  errorStyle: DesignHelper.fieldErrorStyle,
                                  prefixIcon: Icon(Icons.lock,
                                      color: Theme.of(context).primaryColor),
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
                                if (text.length < 8) {
                                  return "Password must be equal or grater than 8"
                                      .tr();
                                }
                                return null;
                              },
                              onSaved: (text) {
                                password = text.toString();
                              },
                            )),
                        SizedBox(height: 25),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: TextFormField(
                              cursorColor: Theme.of(context).primaryColor,
                              style: DesignHelper.fieldStyle,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              decoration: InputDecoration(
                                  labelText: "Re-Password".tr(),
                                  labelStyle: DesignHelper.fieldStyle,
                                  errorStyle: DesignHelper.fieldErrorStyle,
                                  prefixIcon: Icon(Icons.lock,
                                      color: Theme.of(context).primaryColor),
                                  //ايقونه بدتية الفيلد
                                  enabledBorder: DesignHelper.fieldBorder,
                                  focusedBorder: DesignHelper.fieldBorder,
                                  disabledBorder: DesignHelper.fieldBorder,
                                  errorBorder: DesignHelper.fieldErrorBorder,
                                  focusedErrorBorder:
                                      DesignHelper.fieldErrorBorder),
                              validator: (text) {
                                if (text!.trim().isEmpty) {
                                  return "Re-Password".tr() +
                                      " " +
                                      "is required".tr();
                                }
                                if (text.compareTo(passwordEditing.text) != 0) {
                                  return "Password not match".tr();
                                }
                                return null;
                              },
                            )),
                        SizedBox(height: 25),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: TextFormField(
                              cursorColor: Theme.of(context).primaryColor,
                              style: DesignHelper.fieldStyle,
                              inputFormatters: FlutterA.letterFormat(),
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                  labelText: "Full name".tr(),
                                  labelStyle: DesignHelper.fieldStyle,
                                  errorStyle: DesignHelper.fieldErrorStyle,
                                  prefixIcon: Icon(Icons.person,
                                      color: Theme.of(context).primaryColor),
                                  //ايقونه بدتية الفيلد
                                  enabledBorder: DesignHelper.fieldBorder,
                                  focusedBorder: DesignHelper.fieldBorder,
                                  disabledBorder: DesignHelper.fieldBorder,
                                  errorBorder: DesignHelper.fieldErrorBorder,
                                  focusedErrorBorder:
                                      DesignHelper.fieldErrorBorder),
                              validator: (text) {
                                if (text!.trim().isEmpty) {
                                  return "Full name".tr() +
                                      " " +
                                      "is required".tr();
                                }

                                return null;
                              },
                              onSaved: (text) {
                                name = text.toString();
                              },
                            )),
                        SizedBox(height: 25),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: IntlPhoneField(
                              decoration: InputDecoration(
                                labelText: 'Phone Number',
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                ),
                              ),
                              initialCountryCode: 'SA',
                              initialValue: '5',
                              countries: ['SA'],
                              onSaved: (phoneFiled) {
                                phone = phoneFiled!.completeNumber.toString();
                              },
                            )),
                        SizedBox(height: 35),
                        SizedBox(
                            width: DesignHelper.buttonWidth,
                            height: DesignHelper.buttonHeight,
                            child: ElevatedButton(
                              onPressed: () {
                                register();
                              },
                              child: Text("Register".tr()),
                              style: DesignHelper.buttonStyle,
                            )),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Do you have an account?".tr(),
                                style: Theme.of(context).textTheme.titleSmall),
                            TextButton(
                              child: Text("Login".tr(),
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                              onPressed: () {
                                Navigator.of(context).pushNamed("login");
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 100),
                      ],
                    )))));
  }
}
