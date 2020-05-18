import 'dart:async';

import 'package:flutter/services.dart';

class DeezerPlugin {
  static const MethodChannel _channel = const MethodChannel('deezer_plugin');
  static Future<bool> start() async {
    final bool started = await _channel.invokeMethod('startDeezer');
    return started;
  }

  static Future<bool> connect() async {
    final bool connected = await _channel.invokeMethod('connectDeezer');
    return connected;
  }

  static Future<bool> get logout async {
    final bool logout = await _channel.invokeMethod('logoutDeezer');
    return logout;
  }

  static Future<bool> playTrack({String trackId}) async {
    final bool success =
    await _channel.invokeMethod('playTrack', {"trackId": trackId});
    return success;
  }

  static Future<bool> isSessionValid() async {
    final bool success = await _channel.invokeMethod('isSessionValid');
    return success;
  }

  static Future<bool> get play async {
    final bool success = await _channel.invokeMethod('play');
    return success;
  }

  static Future<bool> get pause async {
    final bool success = await _channel.invokeMethod('pause');
    return success;
  }

  static Future<bool> seekTo({String time}) async {
    final bool success = await _channel.invokeMethod('seekTo', {"time": time});
    return success;
  }
}