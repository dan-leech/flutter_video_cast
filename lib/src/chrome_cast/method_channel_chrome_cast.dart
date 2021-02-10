import 'dart:async';
import 'dart:convert';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video_cast/flutter_video_cast.dart';
import 'package:flutter_video_cast/messages.dart';
import 'package:flutter_video_cast/src/chrome_cast/chrome_cast_event.dart';
import 'package:flutter_video_cast/src/chrome_cast/chrome_cast_platform.dart';
import 'package:stream_transform/stream_transform.dart';

import 'models/device_entity.dart';

/// An implementation of [ChromeCastPlatform] that uses [MethodChannel] to communicate with the native code.
class MethodChannelChromeCast extends ChromeCastPlatform {
  final VideoCastApi _api = VideoCastApi();

  // The stream to broadcast the different events coming
  // from native api.
  // It's important to call receiveBroadcastStream once.
  final _eventStream = EventChannel('flutter_video_cast/chromeCastEvent')
      .receiveBroadcastStream();

  List<DeviceEntity> _devices;
  SessionEvent _sessionEvent;

  @override
  List<DeviceEntity> get devices => _devices;

  @override
  Stream<ChromeCastEvent> get events =>
      _eventStream.map((event) => _handleEvent(event));

  @override
  SessionEvent get sessionEvent => _sessionEvent;

  @override
  Future<void> init() {
    onDidUpdateDeviceList().listen((event) => _devices = event.devices);
    onSessionEvent().listen((event) {
      if (event is SessionAlreadyConnectedEvent) return;
      _sessionEvent = event;
    });
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
  Stream<SessionEvent> onSessionEvent() {
    return events.whereType<SessionEvent>();
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
  Stream<RequestEvent> onRequestEvent() {
    return events.whereType<RequestEvent>();
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
  Stream<DidUpdateDeviceListEvent> onDidUpdateDeviceList() {
    return events.whereType<DidUpdateDeviceListEvent>();
  }

  @override
  Stream<DidUpdatePlaybackEvent> onDidUpdatePlayback() {
    return events.whereType<DidUpdatePlaybackEvent>();
  }

  @override
  Future<void> loadMedia(String url,
          {String title,
          description,
          studio,
          thumbnailUrl,
          int position,
          bool autoPlay = true}) =>
      _requestFnWrapper(_api.loadMedia(LoadMediaMessage()
        ..url = url
        ..title = title
        ..descr = description
        ..studio = studio
        ..thumbnailUrl = thumbnailUrl
        ..position = position
        ..autoPlay = autoPlay));

  @override
  Future<void> play() => _requestFnWrapper(_api.play());

  @override
  Future<void> pause() => _requestFnWrapper(_api.pause());

  @override
  Future<void> stop() => _requestFnWrapper(_api.stop());

  @override
  Future<void> seek(bool relative, double interval) =>
      _requestFnWrapper(_api.seek(SeekMessage()
        ..relative = relative
        ..interval = interval));

  @override
  Future<bool> isPlaying() async {
    final msg = await _api.isPlaying();
    return msg.isPlaying == 1;
  }

  @override
  Future<double> getPosition() async {
    final msg = await _api.getPosition();
    return msg.position ?? 0.0;
  }

  ChromeCastEvent _handleEvent(Map<dynamic, dynamic> event) {
    final eventName = event['event'].toString();
    switch (eventName) {
      case 'didStartSession':
      case 'resumedSession':
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
      case 'alreadyConnectedSession':
        return SessionAlreadyConnectedEvent();
      case 'didUpdateDeviceList':
        final devices = <DeviceEntity>[];

        final data = List.from(jsonDecode(event['data'].toString()));
        data.forEach((element) {
          devices.add(DeviceEntity.fromJson(element));
        });

        return DidUpdateDeviceListEvent(devices);
      case 'didUpdatePlayback':
        // print('didUpdatePlayback: $event');
        final state =
            EnumToString.fromString(PlaybackState.values, event['state']);
        double duration;
        final position = event['position'];

        if (state != null &&
            state != PlaybackState.loading &&
            state != PlaybackState.idle &&
            state != PlaybackState.unknown &&
            event['duration'] > 0.0) {
          duration = event['duration'];
        }

        return DidUpdatePlaybackEvent(
            duration: duration != null
                ? Duration(microseconds: (duration * 1000000).round())
                : null,
            position: position != null
                ? Duration(microseconds: (position * 1000000).round())
                : null,
            state: state,
            idleReason: EnumToString.fromString(
                PlaybackIdleReason.values, event['idleReason']));
      default:
        throw MissingPluginException();
    }
  }

  Future<void> _requestFnWrapper(Future<void> request) async {
    final completer = Completer();
    StreamSubscription subscription;
    subscription = onRequestEvent().listen((event) {
      if (event is RequestDidCompleteEvent) {
        completer.complete();
      } else if (event is RequestDidFailEvent) {
        completer.completeError(RequestFailedException(event.error));
      }

      subscription?.cancel();
    });

    await request;

    return completer.future;
  }
}
