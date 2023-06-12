import 'package:flutter/cupertino.dart';

class Lang{

  static Locale english =  Locale('en','US');
  static Locale arabic =  Locale('ar','SA');

  static isEnglish(locale){
    return (locale.languageCode == english.languageCode);
  }

  static isArabic(locale){
    return (locale.languageCode == arabic.languageCode);
  }

}