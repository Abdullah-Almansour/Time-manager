import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Pref{
  static late SharedPreferences pref;

  static clear() {
  pref.clear();
  }


  static String _nav_key = "nav";
  static set_nav(int value) {
    pref.setInt(_nav_key,value);
  }
  static int get_nav() {
    int? value = pref.getInt(_nav_key);
    return value==null?0:value;
  }

  static String _name_key = "name";
  static setName(String value) {
    pref.setString(_name_key,value);
  }
  static String getName() {
    String? value = pref.getString(_name_key);
    return value==null?"":value;
  }

  static String _num_key = "num";
  static set_num(int value) {
    pref.setInt(_num_key,value);
  }
  static int get_num() {
    int? value = pref.getInt(_num_key);
    return value==null?0:value;
  }

  static final String _fajar_notify = "fajar_notify";
  static set_fajarNotify(bool value) {
    pref.setBool(_fajar_notify,value);
  }
  static bool get_fajarNotify() {
    bool? value = pref.getBool(_fajar_notify);
    return value==null?true:value;
  }

  static final String _dhuhr_notify = "dhuhr_notify";
  static set_dhuhrNotify(bool value) {
    pref.setBool(_dhuhr_notify,value);
  }
  static bool get_dhuhrNotify() {
    bool? value = pref.getBool(_dhuhr_notify);
    return value==null?true:value;
  }

  static final String _asr_notify = "asr_notify";
  static set_asrNotify(bool value) {
    pref.setBool(_asr_notify,value);
  }
  static bool get_asrNotify() {
    bool? value = pref.getBool(_asr_notify);
    return value==null?true:value;
  }

  static final String _maghrib_notify = "maghrib_notify";
  static set_maghribNotify(bool value) {
    pref.setBool(_maghrib_notify,value);
  }
  static bool get_maghribNotify() {
    bool? value = pref.getBool(_maghrib_notify);
    return value==null?true:value;
  }

  static final String _isha_notify = "isha_notify";
  static set_ishaNotify(bool value) {
    pref.setBool(_isha_notify,value);
  }
  static bool get_ishaNotify() {
    bool? value = pref.getBool(_isha_notify);
    return value==null?true:value;
  }

  static String _notify_list = "notify_list";
  static set_notifyList(Map<String, dynamic> list) {
    String encodedMap = json.encode(list);
    pref.setString(_notify_list, encodedMap);
  }
  static Map<String, dynamic> get_notifyList() {
    String? encodedMap = pref.getString(_notify_list);
    if(encodedMap==null){
      return new Map<String,dynamic>();
    }else {
      Map<String, dynamic> decodedMap = json.decode(encodedMap);
      return decodedMap;
    }
  }

}

