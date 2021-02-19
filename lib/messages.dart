// Autogenerated from Pigeon (v0.1.19), do not edit directly.
// See also: https://pub.dev/packages/pigeon
// ignore_for_file: public_member_api_docs, non_constant_identifier_names, avoid_as, unused_import
// @dart = 2.8
import 'dart:async';
import 'dart:typed_data' show Uint8List, Int32List, Int64List, Float64List;

import 'package:flutter/services.dart';

class DevicesMessage {
  String devicesData;

  Object encode() {
    final Map<Object, Object> pigeonMap = <Object, Object>{};
    pigeonMap['devicesData'] = devicesData;
    return pigeonMap;
  }

  static DevicesMessage decode(Object message) {
    final Map<Object, Object> pigeonMap = message as Map<Object, Object>;
    return DevicesMessage()
      ..devicesData = pigeonMap['devicesData'] as String;
  }
}

class ConnectMessage {
  String deviceId;

  Object encode() {
    final Map<Object, Object> pigeonMap = <Object, Object>{};
    pigeonMap['deviceId'] = deviceId;
    return pigeonMap;
  }

  static ConnectMessage decode(Object message) {
    final Map<Object, Object> pigeonMap = message as Map<Object, Object>;
    return ConnectMessage()
      ..deviceId = pigeonMap['deviceId'] as String;
  }
}

class IsConnectedMessage {
  int isConnected;

  Object encode() {
    final Map<Object, Object> pigeonMap = <Object, Object>{};
    pigeonMap['isConnected'] = isConnected;
    return pigeonMap;
  }

  static IsConnectedMessage decode(Object message) {
    final Map<Object, Object> pigeonMap = message as Map<Object, Object>;
    return IsConnectedMessage()
      ..isConnected = pigeonMap['isConnected'] as int;
  }
}

class LoadMediaMessage {
  String url;
  String title;
  String descr;
  String studio;
  String thumbnailUrl;
  int position;
  bool autoPlay;

  Object encode() {
    final Map<Object, Object> pigeonMap = <Object, Object>{};
    pigeonMap['url'] = url;
    pigeonMap['title'] = title;
    pigeonMap['descr'] = descr;
    pigeonMap['studio'] = studio;
    pigeonMap['thumbnailUrl'] = thumbnailUrl;
    pigeonMap['position'] = position;
    pigeonMap['autoPlay'] = autoPlay;
    return pigeonMap;
  }

  static LoadMediaMessage decode(Object message) {
    final Map<Object, Object> pigeonMap = message as Map<Object, Object>;
    return LoadMediaMessage()
      ..url = pigeonMap['url'] as String
      ..title = pigeonMap['title'] as String
      ..descr = pigeonMap['descr'] as String
      ..studio = pigeonMap['studio'] as String
      ..thumbnailUrl = pigeonMap['thumbnailUrl'] as String
      ..position = pigeonMap['position'] as int
      ..autoPlay = pigeonMap['autoPlay'] as bool;
  }
}

class SeekMessage {
  bool relative;
  double interval;

  Object encode() {
    final Map<Object, Object> pigeonMap = <Object, Object>{};
    pigeonMap['relative'] = relative;
    pigeonMap['interval'] = interval;
    return pigeonMap;
  }

  static SeekMessage decode(Object message) {
    final Map<Object, Object> pigeonMap = message as Map<Object, Object>;
    return SeekMessage()
      ..relative = pigeonMap['relative'] as bool
      ..interval = pigeonMap['interval'] as double;
  }
}

class IsPlayingMessage {
  int isPlaying;

  Object encode() {
    final Map<Object, Object> pigeonMap = <Object, Object>{};
    pigeonMap['isPlaying'] = isPlaying;
    return pigeonMap;
  }

  static IsPlayingMessage decode(Object message) {
    final Map<Object, Object> pigeonMap = message as Map<Object, Object>;
    return IsPlayingMessage()
      ..isPlaying = pigeonMap['isPlaying'] as int;
  }
}

class PositionMessage {
  double position;

  Object encode() {
    final Map<Object, Object> pigeonMap = <Object, Object>{};
    pigeonMap['position'] = position;
    return pigeonMap;
  }

  static PositionMessage decode(Object message) {
    final Map<Object, Object> pigeonMap = message as Map<Object, Object>;
    return PositionMessage()
      ..position = pigeonMap['position'] as double;
  }
}

class VideoCastApi {
  Future<void> initialize() async {
    const BasicMessageChannel<Object> channel =
        BasicMessageChannel<Object>('dev.flutter.pigeon.VideoCastApi.initialize', StandardMessageCodec());
    final Map<Object, Object> replyMap = await channel.send(null) as Map<Object, Object>;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
        details: null,
      );
    } else if (replyMap['error'] != null) {
      final Map<Object, Object> error = replyMap['error'] as Map<Object, Object>;
      throw PlatformException(
        code: error['code'] as String,
        message: error['message'] as String,
        details: error['details'],
      );
    } else {
      // noop
    }
  }

  Future<void> startDeviceDiscovery() async {
    const BasicMessageChannel<Object> channel =
        BasicMessageChannel<Object>('dev.flutter.pigeon.VideoCastApi.startDeviceDiscovery', StandardMessageCodec());
    final Map<Object, Object> replyMap = await channel.send(null) as Map<Object, Object>;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
        details: null,
      );
    } else if (replyMap['error'] != null) {
      final Map<Object, Object> error = replyMap['error'] as Map<Object, Object>;
      throw PlatformException(
        code: error['code'] as String,
        message: error['message'] as String,
        details: error['details'],
      );
    } else {
      // noop
    }
  }

  Future<DevicesMessage> discoverDevices() async {
    const BasicMessageChannel<Object> channel =
        BasicMessageChannel<Object>('dev.flutter.pigeon.VideoCastApi.discoverDevices', StandardMessageCodec());
    final Map<Object, Object> replyMap = await channel.send(null) as Map<Object, Object>;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
        details: null,
      );
    } else if (replyMap['error'] != null) {
      final Map<Object, Object> error = replyMap['error'] as Map<Object, Object>;
      throw PlatformException(
        code: error['code'] as String,
        message: error['message'] as String,
        details: error['details'],
      );
    } else {
      return DevicesMessage.decode(replyMap['result']);
    }
  }

  Future<DevicesMessage> getCurrentDevice() async {
    const BasicMessageChannel<Object> channel =
        BasicMessageChannel<Object>('dev.flutter.pigeon.VideoCastApi.getCurrentDevice', StandardMessageCodec());
    final Map<Object, Object> replyMap = await channel.send(null) as Map<Object, Object>;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
        details: null,
      );
    } else if (replyMap['error'] != null) {
      final Map<Object, Object> error = replyMap['error'] as Map<Object, Object>;
      throw PlatformException(
        code: error['code'] as String,
        message: error['message'] as String,
        details: error['details'],
      );
    } else {
      return DevicesMessage.decode(replyMap['result']);
    }
  }

  Future<void> connect(ConnectMessage arg) async {
    final Object encoded = arg.encode();
    const BasicMessageChannel<Object> channel =
        BasicMessageChannel<Object>('dev.flutter.pigeon.VideoCastApi.connect', StandardMessageCodec());
    final Map<Object, Object> replyMap = await channel.send(encoded) as Map<Object, Object>;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
        details: null,
      );
    } else if (replyMap['error'] != null) {
      final Map<Object, Object> error = replyMap['error'] as Map<Object, Object>;
      throw PlatformException(
        code: error['code'] as String,
        message: error['message'] as String,
        details: error['details'],
      );
    } else {
      // noop
    }
  }

  Future<void> disconnect() async {
    const BasicMessageChannel<Object> channel =
        BasicMessageChannel<Object>('dev.flutter.pigeon.VideoCastApi.disconnect', StandardMessageCodec());
    final Map<Object, Object> replyMap = await channel.send(null) as Map<Object, Object>;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
        details: null,
      );
    } else if (replyMap['error'] != null) {
      final Map<Object, Object> error = replyMap['error'] as Map<Object, Object>;
      throw PlatformException(
        code: error['code'] as String,
        message: error['message'] as String,
        details: error['details'],
      );
    } else {
      // noop
    }
  }

  Future<IsConnectedMessage> isConnected() async {
    const BasicMessageChannel<Object> channel =
        BasicMessageChannel<Object>('dev.flutter.pigeon.VideoCastApi.isConnected', StandardMessageCodec());
    final Map<Object, Object> replyMap = await channel.send(null) as Map<Object, Object>;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
        details: null,
      );
    } else if (replyMap['error'] != null) {
      final Map<Object, Object> error = replyMap['error'] as Map<Object, Object>;
      throw PlatformException(
        code: error['code'] as String,
        message: error['message'] as String,
        details: error['details'],
      );
    } else {
      return IsConnectedMessage.decode(replyMap['result']);
    }
  }

  Future<void> loadMedia(LoadMediaMessage arg) async {
    final Object encoded = arg.encode();
    const BasicMessageChannel<Object> channel =
        BasicMessageChannel<Object>('dev.flutter.pigeon.VideoCastApi.loadMedia', StandardMessageCodec());
    final Map<Object, Object> replyMap = await channel.send(encoded) as Map<Object, Object>;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
        details: null,
      );
    } else if (replyMap['error'] != null) {
      final Map<Object, Object> error = replyMap['error'] as Map<Object, Object>;
      throw PlatformException(
        code: error['code'] as String,
        message: error['message'] as String,
        details: error['details'],
      );
    } else {
      // noop
    }
  }

  Future<void> play() async {
    const BasicMessageChannel<Object> channel =
        BasicMessageChannel<Object>('dev.flutter.pigeon.VideoCastApi.play', StandardMessageCodec());
    final Map<Object, Object> replyMap = await channel.send(null) as Map<Object, Object>;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
        details: null,
      );
    } else if (replyMap['error'] != null) {
      final Map<Object, Object> error = replyMap['error'] as Map<Object, Object>;
      throw PlatformException(
        code: error['code'] as String,
        message: error['message'] as String,
        details: error['details'],
      );
    } else {
      // noop
    }
  }

  Future<void> pause() async {
    const BasicMessageChannel<Object> channel =
        BasicMessageChannel<Object>('dev.flutter.pigeon.VideoCastApi.pause', StandardMessageCodec());
    final Map<Object, Object> replyMap = await channel.send(null) as Map<Object, Object>;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
        details: null,
      );
    } else if (replyMap['error'] != null) {
      final Map<Object, Object> error = replyMap['error'] as Map<Object, Object>;
      throw PlatformException(
        code: error['code'] as String,
        message: error['message'] as String,
        details: error['details'],
      );
    } else {
      // noop
    }
  }

  Future<void> stop() async {
    const BasicMessageChannel<Object> channel =
        BasicMessageChannel<Object>('dev.flutter.pigeon.VideoCastApi.stop', StandardMessageCodec());
    final Map<Object, Object> replyMap = await channel.send(null) as Map<Object, Object>;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
        details: null,
      );
    } else if (replyMap['error'] != null) {
      final Map<Object, Object> error = replyMap['error'] as Map<Object, Object>;
      throw PlatformException(
        code: error['code'] as String,
        message: error['message'] as String,
        details: error['details'],
      );
    } else {
      // noop
    }
  }

  Future<void> seek(SeekMessage arg) async {
    final Object encoded = arg.encode();
    const BasicMessageChannel<Object> channel =
        BasicMessageChannel<Object>('dev.flutter.pigeon.VideoCastApi.seek', StandardMessageCodec());
    final Map<Object, Object> replyMap = await channel.send(encoded) as Map<Object, Object>;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
        details: null,
      );
    } else if (replyMap['error'] != null) {
      final Map<Object, Object> error = replyMap['error'] as Map<Object, Object>;
      throw PlatformException(
        code: error['code'] as String,
        message: error['message'] as String,
        details: error['details'],
      );
    } else {
      // noop
    }
  }

  Future<IsPlayingMessage> isPlaying() async {
    const BasicMessageChannel<Object> channel =
        BasicMessageChannel<Object>('dev.flutter.pigeon.VideoCastApi.isPlaying', StandardMessageCodec());
    final Map<Object, Object> replyMap = await channel.send(null) as Map<Object, Object>;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
        details: null,
      );
    } else if (replyMap['error'] != null) {
      final Map<Object, Object> error = replyMap['error'] as Map<Object, Object>;
      throw PlatformException(
        code: error['code'] as String,
        message: error['message'] as String,
        details: error['details'],
      );
    } else {
      return IsPlayingMessage.decode(replyMap['result']);
    }
  }

  Future<PositionMessage> getPosition() async {
    const BasicMessageChannel<Object> channel =
        BasicMessageChannel<Object>('dev.flutter.pigeon.VideoCastApi.getPosition', StandardMessageCodec());
    final Map<Object, Object> replyMap = await channel.send(null) as Map<Object, Object>;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
        details: null,
      );
    } else if (replyMap['error'] != null) {
      final Map<Object, Object> error = replyMap['error'] as Map<Object, Object>;
      throw PlatformException(
        code: error['code'] as String,
        message: error['message'] as String,
        details: error['details'],
      );
    } else {
      return PositionMessage.decode(replyMap['result']);
    }
  }
}
