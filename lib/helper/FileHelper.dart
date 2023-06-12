
import 'dart:io';
import 'FlutterA.dart' as FA;
import 'package:audioplayers/audioplayers.dart';

import 'FlutterA.dart';

class FileHelper{

  static Future<void> playAdan() async {
    final player = AudioPlayer();
    File file = await  FlutterA.getFile("assets/audios/adan.mp3");
    await player.play(DeviceFileSource(file.path));
  }

  static Future<void> playNotify() async {
    final player = AudioPlayer();
    File file = await  FlutterA.getFile("assets/audios/notify.mp3");
    await player.play(DeviceFileSource(file.path));
  }

}