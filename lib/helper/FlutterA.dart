import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';



import 'MyColors.dart';

class FlutterA {


  static bool isEmailValid(text) {
    Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern.toString());
    return regex.hasMatch(text);
  }

  static bool isNumeric(String text) {
    return double.tryParse(text) != null;
  }


  static AwesomeDialog progressDialog(String msg, var context) {
    return new AwesomeDialog(
        context: context,
        body: Container(
          margin: EdgeInsets.only(bottom: 50),
          child:
          Text(msg, style: TextStyle(color: MyColors.primary,
              fontSize: 20,
              fontWeight: FontWeight.bold)),
        ),
        isDense: true,
        dismissOnBackKeyPress: false,
        dismissOnTouchOutside: false,
        customHeader: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 25),
                CircularProgressIndicator()
              ],)
        )
    );
  }

  static showInfoMsg(var context, String msg) {
    AwesomeDialog(
        context: context,
        body: Text(
          msg, style: TextStyle(fontSize: 16, color: MyColors.primary),),
        isDense: true,
        btnOkOnPress: () {},
        btnOkColor: MyColors.primary,
        dismissOnBackKeyPress: false,
        dismissOnTouchOutside: false,
        customHeader: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Icon(Icons.info, color: MyColors.primary, size: 50),
          ],)
    )
      ..show();
  }

  static showErrorMsg(var context, String msg) {
    AwesomeDialog(
        context: context,
        body: Text(
          msg, style: TextStyle(fontSize: 16, color: MyColors.primary),),
        isDense: true,
        btnOkOnPress: () {},
        btnOkColor: MyColors.primary,
        dismissOnBackKeyPress: false,
        dismissOnTouchOutside: false,
        customHeader: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            CircleAvatar(
              radius: 25,
              backgroundColor: MyColors.primary,
              child: Icon(
                Icons.clear,
                color: Colors.white,
                size: 30,
              ),
            ),
          ],)
    )
      ..show();
  }


  static toast(msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: MyColors.primary,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  static Future<bool> isInternetAvailable() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  static List<FilteringTextInputFormatter> letterFormat() {
    return [FilteringTextInputFormatter.allow(RegExp("[a-zA-Zأ-ي\\s]"))];
  }

  static String format(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 2);
  }

  static Future<File> writeToFile(Uint8List data, String path) {
    final buffer = data.buffer;
    return new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  static String format_Time12hours(TimeOfDay timeOfDay) {
    final now = new DateTime.now();
    final dt = DateTime(
        now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    final format = DateFormat.jm();
    return format.format(dt);
  }

  static close_current_page(context){
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      SystemNavigator.pop();
    }
  }


  static String format_fileSize(int size_input) {
    String formatSize;
    double size = size_input.toDouble();
    double b = size;
    double k = size / 1024.0;
    double m = ((size / 1024.0) / 1024.0);
    double g = (((size / 1024.0) / 1024.0) / 1024.0);
    double t = ((((size / 1024.0) / 1024.0) / 1024.0) / 1024.0);

    if (t > 1) {
      formatSize = ("${format(t)} TB");
    } else if (g > 1) {
      formatSize = ("${format(g)} GB");
    } else if (m > 1) {
      formatSize = ("${format(m)} MB");
    } else if (k > 1) {
      formatSize = ("${format(k)} KB");
    } else {
      formatSize = ("${format(b)} Bytes");
    }

    return formatSize;
  }


  static Future<File> getFile(String path) async {
    final byteData = await rootBundle.load(path);
    final file = File('${(await getTemporaryDirectory()).path}/d');
    await file.writeAsBytes(byteData.buffer.asUint8List(
        byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }



  static Future<bool> isPermissionStorage() async {
    if (Platform.isAndroid) {
      if (await Permission.storage.request().isGranted ||
          // access media location needed for android 10/Q
          await Permission.accessMediaLocation.request().isGranted ||
          // manage external storage needed for android 11/R
          await Permission.manageExternalStorage.request().isGranted) {
        return true;
      } else {
        return false;
      }
    }
    if (Platform.isIOS) {
      if (await Permission.photos.request().isGranted) {
        return true;
      } else {
        return false;
      }
    } else {
      // not android or ios
      return false;
    }
  }

  static Future<bool> isPermissionCamera() async {
    if (await Permission.camera.request().isGranted){
      return true;
    } else {
      return false;
    }
  }

  static Future<void> request_permissionStorage() async {
    if (Platform.isAndroid) {
      await Permission.storage.request();
      await Permission.accessMediaLocation.request();
      await Permission.manageExternalStorage.request();
      if(await Permission.storage.isPermanentlyDenied
        || await Permission.accessMediaLocation.isPermanentlyDenied
        ||await Permission.manageExternalStorage.isPermanentlyDenied
      ){
        await openAppSettings();
      }
    }
    if (Platform.isIOS) {
       await Permission.photos.request();
       if(await Permission.photos.isPermanentlyDenied){
         await openAppSettings();
       }
    }
  }

  static Future<void> request_PermissionCamera() async {
    await Permission.camera.request();
    if(await Permission.camera.isPermanentlyDenied){
      await openAppSettings();
    }
   }

}
