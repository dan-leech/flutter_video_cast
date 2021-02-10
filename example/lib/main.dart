import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_video_cast/flutter_video_cast.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: CastSample());
  }
}

class CastSample extends StatefulWidget {
  static const _iconSize = 50.0;

  @override
  _CastSampleState createState() => _CastSampleState();
}

class _CastSampleState extends State<CastSample> {
  ChromeCastController _controller;
  AppState _state = AppState.idle;
  bool _playing = false;

  StreamSubscription _onSessionStartedSubscription;
  StreamSubscription _onSessionEndedSubscription;

  @override
  void initState() {
    super.initState();

    _controller = ChromeCastController.init();
    _onSessionStartedSubscription =
        _controller.onSessionStarted().listen((event) => _onSessionStarted());
    _onSessionEndedSubscription = _controller
        .onSessionEnded()
        .listen((event) => setState(() => _state = AppState.idle));
  }

  @override
  void dispose() {
    _onSessionStartedSubscription?.cancel();
    _onSessionEndedSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plugin example app'),
        actions: <Widget>[
          AirPlayButton(
            size: CastSample._iconSize,
            color: Colors.white,
            activeColor: Colors.amber,
            onRoutesOpening: () => print('opening'),
            onRoutesClosed: () => print('closed'),
            onConnectionStatusChanged: (status) =>
                print('AirPlay status: $status'),
          ),
          ChromeCastButton(
            controller: _controller,
            size: CastSample._iconSize * 0.6,
            color: Colors.white,
            connectingColor: Colors.amber,
          ),
          SizedBox(width: 50)
        ],
      ),
      body: Center(child: _handleState()),
    );
  }

  Widget _handleState() {
    switch (_state) {
      case AppState.idle:
        return Text('ChromeCast not connected');
      case AppState.connected:
        return Text('No media loaded');
      case AppState.mediaLoaded:
        return _mediaControls();
      case AppState.error:
        return Text('An error has occurred');
      default:
        return Container();
    }
  }

  Widget _mediaControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _RoundIconButton(
          icon: Icons.replay_10,
          onPressed: () => _controller.seek(relative: true, interval: -10.0),
        ),
        _RoundIconButton(
            icon: _playing ? Icons.pause : Icons.play_arrow,
            onPressed: _playPause),
        _RoundIconButton(
          icon: Icons.forward_10,
          onPressed: () => _controller.seek(relative: true, interval: 10.0),
        )
      ],
    );
  }

  Future<void> _playPause() async {
    final playing = await _controller.isPlaying();
    if (playing) {
      await _controller.pause();
    } else {
      await _controller.play();
    }
    setState(() => _playing = !playing);
  }

  Future<void> _onSessionStarted() async {
    setState(() => _state = AppState.connected);
    _controller
        .loadMedia(
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
            title: 'title',
            description: 'description',
            studio: 'studio',
            thumbnailUrl:
                'https://miro.medium.com/max/9216/1*BMMyf99KlbX0ZPhbuqPlIQ.jpeg')
        .then((value) => _onRequestCompleted())
        .catchError((e) {
      // fixme: wrong argument type exception
      return _onRequestFailed(e);
    });
  }

  Future<void> _onRequestCompleted() async {
    final playing = await _controller.isPlaying();
    setState(() {
      _state = AppState.mediaLoaded;
      _playing = playing;
    });
  }

  Future<void> _onRequestFailed(String error) async {
    setState(() => _state = AppState.error);
    print(error);
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  _RoundIconButton({@required this.icon, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        child: Icon(icon, color: Colors.white),
        padding: EdgeInsets.all(16.0),
        color: Colors.blue,
        shape: CircleBorder(),
        onPressed: onPressed);
  }
}

enum AppState { idle, connected, mediaLoaded, error }
