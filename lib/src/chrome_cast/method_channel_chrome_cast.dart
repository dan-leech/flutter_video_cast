import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video_cast/messages.dart';
import 'package:flutter_video_cast/src/chrome_cast/chrome_cast_event.dart';
import 'package:flutter_video_cast/src/chrome_cast/chrome_cast_platform.dart';
import 'package:stream_transform/stream_transform.dart';

/// An implementation of [ChromeCastPlatform] that uses [MethodChannel] to communicate with the native code.
class MethodChannelChromeCast extends ChromeCastPlatform {
  final VideoCastApi _api = VideoCastApi();
  final _eventChannel = EventChannel('flutter_video_cast/chromeCastEvent');

  // The stream to broadcast the different events coming
  // from native api.
  @override
  Stream<ChromeCastEvent> get events => _eventChannel
      // fixme: fix broadcasting
      .receiveBroadcastStream()
      .map((event) => _handleEvent(event));

  @override
  Future<void> init() {
    return _api.initialize();
  }

  @override
  Future<DevicesMessage> discoverDevices() {
    return _api.discoverDevices();
  }

  @override
  Future<void> connect({@required String deviceId}) {
    return _api.connect(ConnectMessage()..deviceId = deviceId);
  }

  @override
  Future<void> disconnect() {
    return _api.disconnect();
  }

  @override
  Future<bool> isConnected() async {
    final msg = await _api.isConnected();
    return msg.isConnected == 1;
  }

  @override
  Stream<SessionStartedEvent> onSessionStarted() {
    return events.whereType<SessionStartedEvent>();
  }

  @override
  Stream<SessionEndedEvent> onSessionEnded() {
    return events.whereType<SessionEndedEvent>();
  }

  @override
  Stream<SessionConnectingEvent> onSessionConnecting() {
    return events.whereType<SessionConnectingEvent>();
  }

  @override
  Stream<RequestDidCompleteEvent> onRequestCompleted() {
    return events.whereType<RequestDidCompleteEvent>();
  }

  @override
  Stream<RequestDidFailEvent> onRequestFailed() {
    return events.whereType<RequestDidFailEvent>();
  }

  @override
  Future<void> loadMedia(String url,
      {String title, description, studio, thumbnailUrl, int position}) async {
    return _api.loadMedia(LoadMediaMessage()
      ..url = url
      ..title = title
      ..description = description
      ..studio = studio
      ..thumbnailUrl = thumbnailUrl
      ..position = position);
  }

  @override
  Future<void> play() async {
    // return channel(id).invokeMethod<void>('chromeCast#play');
  }

  @override
  Future<void> pause() async {
    // return channel(id).invokeMethod<void>('chromeCast#pause');
  }

  @override
  Future<void> seek(bool relative, double interval) async {
    // final Map<String, dynamic> args = {
    //   'relative': relative,
    //   'interval': interval
    // };
    // return channel(id).invokeMethod<void>('chromeCast#seek', args);
  }

  @override
  Future<void> stop() async {
    // return channel(id).invokeMethod<void>('chromeCast#stop');
  }

  @override
  Future<bool> isPlaying() async {
    // return channel(id).invokeMethod<bool>('chromeCast#isPlaying');
    return false;
  }

  // Future<dynamic> _handleMethodCall(MethodCall call, int id) async {
  //   switch (call.method) {
  //     case 'chromeCast#didStartSession':
  //       _eventStreamController.add(SessionStartedEvent(id));
  //       break;
  //     case 'chromeCast#didEndSession':
  //       _eventStreamController.add(SessionEndedEvent(id));
  //       break;
  //     case 'chromeCast#requestDidComplete':
  //       _eventStreamController.add(RequestDidCompleteEvent(id));
  //       break;
  //     case 'chromeCast#requestDidFail':
  //       _eventStreamController
  //           .add(RequestDidFailEvent(id, call.arguments['error']));
  //       break;
  //     default:
  //       throw MissingPluginException();
  //   }
  // }

  ChromeCastEvent _handleEvent(Map<dynamic, dynamic> event) {
    final eventName = event['event'].toString();
    switch (eventName) {
      case 'didStartSession':
      case 'resumedSession':
      case 'alreadyConnectedSession':
        return SessionStartedEvent();
      case 'didEndSession':
      case 'failedToStartSession':
        return SessionEndedEvent();
      case 'connectingSession':
        return SessionConnectingEvent();
      case 'requestDidComplete':
        return RequestDidCompleteEvent();
      case 'requestDidFail':
        return RequestDidFailEvent(event['error']);
      default:
        throw MissingPluginException();
    }
  }
}
