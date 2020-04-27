import 'dart:async';

import 'package:flutter/services.dart';

class DeezerPlugin {
  static const MethodChannel _channel = const MethodChannel('deezer_plugin');

  static Future<bool> connect({String appId}) async {
    final bool connected =
        await _channel.invokeMethod('connectDeezer', {"appId": appId});
    return connected;
  }
  static Future<bool> get logout async {
    final bool logout =
    await _channel.invokeMethod('logoutDeezer');
    return logout;
  }
  static Future<bool> playTrack({String trackId}) async {
    final bool success =
    await _channel.invokeMethod('playTrack', {"trackId": trackId});
    return success;
  }
  static Future<bool> get play async {
    final bool success =
    await _channel.invokeMethod('play');
    return success;
  }
  static Future<bool> get pause async {
    final bool success =
    await _channel.invokeMethod('pause');
    return success;
  }
}
