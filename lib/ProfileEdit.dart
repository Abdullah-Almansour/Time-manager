import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'helper/DesignHelper.dart';
import 'helper/FlutterA.dart';
import 'helper/Pref.dart';
import 'model/Database.dart';
import 'model/Users.dart';

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ProfileEditState();
}

class ProfileEditState extends State<ProfileEdit> {
  late String email;
  late String name;
  late String phone;
  late Users user;

  GlobalKey<FormState> formState = new GlobalKey<FormState>();

  submit() async {
    var form = formState.currentState;
    if (form!.validate()) {
      form.save();
      AwesomeDialog progressDialog =
          FlutterA.progressDialog('Save'.tr(), context);
      if (!await FlutterA.isInternetAvailable()) {
        FlutterA.showErrorMsg(context, "No internet".tr());
      } else {
        progressDialog.show();
        user.name = name;
        user.phone = phone;
        Database.users()
            .doc(user.user_id)
            .set(user.toMap())
            .then((value) async {
          Pref.setName(user.name);
          progressDialog.dismiss();
          FlutterA.toast("Save done".tr());
        }).catchError((error) {
          progressDialog.dismiss();
          FlutterA.toast("Server error".tr());
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () {
          Navigator.pushReplacementNamed(context, "home");
          return Future.value(false);
        },
        child: Scaffold(
            appBar: DesignHelper.appBarLeading(
                "Update profile".tr(),
                IconButton(
                    icon: new Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, "home");
                    })),
            body: FutureBuilder(
                future: Database.users().doc(Database.loggedUserId()).get(),
                builder: (context,
                    AsyncSnapshot<DocumentSnapshot<Object?>> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator());
                    default:
                      if (snapshot.hasData) {
                        user = Users.fromMap(
                            snapshot.data!.data() as Map<String, dynamic>);

                        return Form(
                            key: formState,
                            child: Container(
                                alignment: Alignment.topCenter,
                                width: double.infinity,
                                child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 55),
                                        Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: TextFormField(
                                              cursorColor: Theme.of(context)
                                                  .primaryColor,
                                              style: DesignHelper.fieldStyle,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              textAlign: TextAlign.left,
                                              readOnly: true,
                                              initialValue: user.email,
                                              decoration: InputDecoration(
                                                  labelText:
                                                      "Email address".tr(),
                                                  labelStyle:
                                                      DesignHelper.fieldStyle,
                                                  errorStyle: DesignHelper
                                                      .fieldErrorStyle,
                                                  prefixIcon: Icon(Icons.mail,
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                  enabledBorder:
                                                      DesignHelper.fieldBorder,
                                                  focusedBorder:
                                                      DesignHelper.fieldBorder,
                                                  disabledBorder:
                                                      DesignHelper.fieldBorder,
                                                  errorBorder: DesignHelper
                                                      .fieldErrorBorder,
                                                  focusedErrorBorder:
                                                      DesignHelper
                                                          .fieldErrorBorder),
                                            )),
                                        SizedBox(height: 25),
                                        Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: TextFormField(
                                              cursorColor: Theme.of(context)
                                                  .primaryColor,
                                              style: DesignHelper.fieldStyle,
                                              inputFormatters:
                                                  FlutterA.letterFormat(),
                                              keyboardType: TextInputType.name,
                                              initialValue: user.name,
                                              decoration: InputDecoration(
                                                  labelText: "Full name".tr(),
                                                  labelStyle:
                                                      DesignHelper.fieldStyle,
                                                  errorStyle: DesignHelper
                                                      .fieldErrorStyle,
                                                  prefixIcon: Icon(Icons.person,
                                                      color: Theme.of(context)
                                                          .primaryColor), //ايقونه بدتية الفيلد
                                                  enabledBorder:
                                                      DesignHelper.fieldBorder,
                                                  focusedBorder:
                                                      DesignHelper.fieldBorder,
                                                  disabledBorder:
                                                      DesignHelper.fieldBorder,
                                                  errorBorder: DesignHelper
                                                      .fieldErrorBorder,
                                                  focusedErrorBorder:
                                                      DesignHelper
                                                          .fieldErrorBorder),
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
                                        SizedBox(height: 35),
                                        Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: IntlPhoneField(
                                              decoration: InputDecoration(
                                                labelText: 'Phone Number',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(30)),
                                                ),
                                              ),
                                              initialCountryCode: 'SA',
                                              initialValue: user.phone
                                                  .toString()
                                                  .substring(4, 13),
                                              countries: ['SA'],
                                              onSaved: (phoneFiled) {
                                                phone = phoneFiled!
                                                    .completeNumber
                                                    .toString();
                                              },
                                            )),
                                        SizedBox(height: 40),
                                        SizedBox(
                                            width: DesignHelper.buttonWidth,
                                            height: DesignHelper.buttonHeight,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                submit();
                                              },
                                              child: Text("Save".tr()),
                                              style: DesignHelper.buttonStyle,
                                            )),
                                        SizedBox(height: 15),
                                      ],
                                    ))));
                      } else {
                        return SizedBox.shrink();
                      }
                  }
                })));
  }
}
