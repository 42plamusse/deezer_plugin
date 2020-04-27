import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:deezer_plugin/deezer_plugin.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isConnected = false;
  bool _isTrackPlaying = false;

  @override
  void initState() {
    super.initState();
    connectDeezer();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> connectDeezer() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final bool connected = await DeezerPlugin.connect(appId: "404304");
      if (!mounted) return;
      setState(() {
        _isConnected = connected;
      });
      print("here");
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
      print("here");
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> playTrack(String trackId) async {
    try {
      final bool success = await DeezerPlugin.playTrack(trackId: trackId);
      if (!mounted) return;
      setState(() {
        _isTrackPlaying = success;
      });
      print("here");
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
      print("here");
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
      print("here");
    } catch (e) {
      print(e.toString());
    }
  }

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
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.play_arrow),
                    onPressed: () => play(),
                  ),
                  IconButton(
                    icon: Icon(Icons.pause),
                    onPressed: () => pause(),
                  )
                ],
              )
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
