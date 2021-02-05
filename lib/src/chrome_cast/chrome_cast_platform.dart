import 'package:flutter/material.dart';
import 'package:flutter_video_cast/messages.dart';
import 'package:flutter_video_cast/src/chrome_cast/chrome_cast_event.dart';
import 'package:flutter_video_cast/src/chrome_cast/method_channel_chrome_cast.dart';

/// The interface that platform-specific implementations of `flutter_video_cast` must extend.
abstract class ChromeCastPlatform {
  static final ChromeCastPlatform _instance = MethodChannelChromeCast();

  Stream<ChromeCastEvent> get events;

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

  /// Starts devices discovery.
  ///
  /// Searches devices in the network
  Future<DevicesMessage> discoverDevices() {
    throw UnimplementedError('discoverDevices() has not been implemented.');
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

  /// A request has completed.
  Stream<RequestDidCompleteEvent> onRequestCompleted() {
    throw UnimplementedError('onRequestCompleted() has not been implemented.');
  }

  /// A request has failed.
  Stream<RequestDidFailEvent> onRequestFailed() {
    throw UnimplementedError('onSessionEnded() has not been implemented.');
  }

  /// Load a new media by providing an [url].
  Future<void> loadMedia(String url,
      {String title, description, studio, thumbnailUrl, int position}) {
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
}
