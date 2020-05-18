import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:deezer_plugin/deezer_plugin.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  static const platform = const MethodChannel("");

  @override
  _MyAppState createState() => _MyAppState();
}

const _channel = const EventChannel('events');

class _MyAppState extends State<MyApp> {

  bool _isConnected = false;
  bool _isTrackPlaying = false;
  double _position = 0.0;
  double _duration = 283000.0;

  Timer _updatePosition;

  @override
  void initState() {
    super.initState();

    connectDeezer();
    _updatePosition = Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (_isTrackPlaying && _position + 1000.0 < _duration) {
        setState(() {
          _position = _position + 1000.0;
        });
      }
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> connectDeezer() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final bool started = await DeezerPlugin.start();
      final bool connected = await DeezerPlugin.connect();
      if (!mounted) return;
      setState(() {
        _isConnected = connected;
      });
    } catch (e) {
      setState(() {
        _isConnected = false;
      });
      print(e.toString());
    }
  }

  Future<void> logoutDeezer() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final bool connected = await DeezerPlugin.logout;
      if (!mounted) return;
      setState(() {
        _isConnected = false;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> playTrack(String trackId) async {
    try {
      final bool success = await DeezerPlugin.playTrack(trackId: trackId);
      if (!mounted) return;
      setState(() {
        // _position = 0.0;
        _isTrackPlaying = success;
      });
    } catch (e) {
      setState(() {
        _isTrackPlaying = false;
      });
      print(e.toString());
    }
  }

  Future<void> play() async {
    try {
      await DeezerPlugin.play;
      if (!mounted) return;
      setState(() {
        _isTrackPlaying = true;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> pause() async {
    try {
      await DeezerPlugin.pause;
      if (!mounted) return;
      setState(() {
        _isTrackPlaying = false;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  // Future<void> seekTo(int time) async {
  //   try {
  //     await DeezerPlugin.seekTo(time: time.toString());
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Text(_isConnected ? 'Connected' : 'Not connected'),
              Text(_isTrackPlaying ? 'playing' : 'Not playing'),
              RaisedButton(
                onPressed: connectDeezer,
                child: Text("Connect"),
              ),
              RaisedButton(
                onPressed: logoutDeezer,
                child: Text("Log out"),
              ),
              AppBar(
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.play_arrow),
                    onPressed: () => play(),
                  ),
                  IconButton(
                    icon: Icon(Icons.pause),
                    onPressed: () => pause(),
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.red[700],
                      inactiveTrackColor: Colors.red[100],
                      trackShape: RectangularSliderTrackShape(),
                      trackHeight: 4.0,
                      thumbColor: Colors.redAccent,
                      thumbShape:
                          RoundSliderThumbShape(enabledThumbRadius: 0.0),
                      overlayColor: Colors.red.withAlpha(32),
                      overlayShape:
                          RoundSliderOverlayShape(overlayRadius: 28.0),
                    ),
                    child: Slider(
                      value: _position,
                      min: 0.0,
                      max: _duration,
                      onChanged: (value) {},
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => playTrack("478079022"),
        ),
      ),
    );
  }
}
