import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_video_cast/messages.dart';
import 'package:flutter_video_cast/src/chrome_cast/chrome_cast_event.dart';
import 'package:flutter_video_cast/src/chrome_cast/method_channel_chrome_cast.dart';
import 'package:flutter_video_cast/src/chrome_cast/models/device_entity.dart';

/// The interface that platform-specific implementations of `flutter_video_cast` must extend.
abstract class ChromeCastPlatform {
  static final ChromeCastPlatform _instance = MethodChannelChromeCast();

  Stream<ChromeCastEvent> get events;

  List<DeviceEntity> get devices;

  SessionEvent get sessionEvent;

  DeviceDiscoveryEvent get deviceDiscoveryEvent;

  /// The default instance of [ChromeCastPlatform] to use.
  ///
  /// Defaults to [MethodChannelChromeCast].
  static ChromeCastPlatform get instance => _instance;

  /// Initializes the platform interface.
  ///
  /// This method is called when the plugin is first initialized.
  Future<void> init() {
    throw UnimplementedError('init() has not been implemented.');
  }

  /// Starts device discovery
  ///
  /// This method is necessary for discoverDevices and getting devices list
  Future<void> startDeviceDiscovery() {
    throw UnimplementedError(
        'startDeviceDiscovery() has not been implemented.');
  }

  /// Get available discovered devices
  Future<DevicesMessage> discoverDevices() {
    throw UnimplementedError('discoverDevices() has not been implemented.');
  }

  /// Get current connected device
  Future<DevicesMessage> getCurrentDevice() {
    throw UnimplementedError('getCurrentDevice() has not been implemented.');
  }

  /// Connects to device
  Future<void> connect({@required String deviceId}) {
    throw UnimplementedError('connect() has not been implemented.');
  }

  /// Disconnects from session
  Future<void> disconnect() {
    throw UnimplementedError('disconnect() has not been implemented.');
  }

  /// Returns `true` when a cast session is connected, `false` otherwise.
  Future<bool> isConnected() {
    throw UnimplementedError('isConnected() has not been implemented.');
  }

  /// All session events.
  Stream<SessionEvent> onSessionEvent() {
    throw UnimplementedError('onSessionEvent() has not been implemented.');
  }

  /// A session is started.
  Stream<SessionStartedEvent> onSessionStarted() {
    throw UnimplementedError('onSessionStarted() has not been implemented.');
  }

  /// A session is ended.
  Stream<SessionEndedEvent> onSessionEnded() {
    throw UnimplementedError('onSessionEnded() has not been implemented.');
  }

  /// A session is connecting.
  Stream<SessionConnectingEvent> onSessionConnecting() {
    throw UnimplementedError('onSessionConnecting() has not been implemented.');
  }

  /// A request has occurred.
  Stream<RequestEvent> onRequestEvent() {
    throw UnimplementedError('onRequestEvent() has not been implemented.');
  }

  /// A request has completed.
  Stream<RequestDidCompleteEvent> onRequestCompleted() {
    throw UnimplementedError('onRequestCompleted() has not been implemented.');
  }

  /// A request has failed.
  Stream<RequestDidFailEvent> onRequestFailed() {
    throw UnimplementedError('onSessionEnded() has not been implemented.');
  }

  /// Device Discovery
  Stream<DeviceDiscoveryEvent> onDeviceDiscovery() {
    throw UnimplementedError('onDeviceDiscovery() has not been implemented.');
  }

  /// Devices list changed
  Stream<DidUpdateDeviceListEvent> onDidUpdateDeviceList() {
    throw UnimplementedError(
        'onDidUpdateDeviceList() has not been implemented.');
  }

  /// Playback update
  Stream<DidUpdatePlaybackEvent> onDidUpdatePlayback() {
    throw UnimplementedError('onDidUpdatePlayback() has not been implemented.');
  }

  /// Load a new media by providing an [url].
  Future<void> loadMedia(String url,
      {String title,
      description,
      studio,
      thumbnailUrl,
      int position,
      bool autoPlay}) {
    throw UnimplementedError('loadMedia() has not been implemented.');
  }

  /// Plays the video playback.
  Future<void> play() {
    throw UnimplementedError('play() has not been implemented.');
  }

  /// Pauses the video playback.
  Future<void> pause() {
    throw UnimplementedError('pause() has not been implemented.');
  }

  /// If [relative] is set to false sets the video position to an [interval] from the start.
  ///
  /// If [relative] is set to true sets the video position to an [interval] from the current position.
  Future<void> seek(bool relative, double interval) {
    throw UnimplementedError('pause() has not been implemented.');
  }

  /// Stop the current video.
  Future<void> stop() {
    throw UnimplementedError('stop() has not been implemented.');
  }

  /// Returns `true` when a cast session is playing, `false` otherwise.
  Future<bool> isPlaying() {
    throw UnimplementedError('isPlaying() has not been implemented.');
  }

  /// Returns current playback position
  Future<double> getPosition() {
    throw UnimplementedError('getPosition() has not been implemented.');
  }
}
