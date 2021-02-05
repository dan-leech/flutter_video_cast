part of flutter_video_cast;

final ChromeCastPlatform _chromeCastPlatform = ChromeCastPlatform.instance;

/// Controller for all ChromeCastSessions
class ChromeCastController {
  const ChromeCastController._();

  Stream<ChromeCastEvent> get events => _chromeCastPlatform.events;

  /// Initialize control of a [ChromeCastButton].
  static ChromeCastController init() {
    _chromeCastPlatform.init();
    return ChromeCastController._();
  }

  /// Load a new media by providing an [url].
  Future<void> loadMedia(String url,
      {String title, description, studio, thumbnailUrl, int position}) {
    return _chromeCastPlatform.loadMedia(url,
        title: title,
        description: description,
        studio: studio,
        thumbnailUrl: thumbnailUrl,
        position: position);
  }

  /// Plays the video playback.
  Future<void> play() {
    return _chromeCastPlatform.play();
  }

  /// Pauses the video playback.
  Future<void> pause() {
    return _chromeCastPlatform.pause();
  }

  /// If [relative] is set to false sets the video position to an [interval] from the start.
  ///
  /// If [relative] is set to true sets the video position to an [interval] from the current position.
  Future<void> seek({bool relative = false, double interval = 10.0}) {
    return _chromeCastPlatform.seek(relative, interval);
  }

  /// Stop the current video.
  Future<void> stop() {
    return _chromeCastPlatform.stop();
  }

  /// Returns `true` when a cast session is playing, `false` otherwise.
  Future<bool> isPlaying() {
    return _chromeCastPlatform.isPlaying();
  }

  /// Get available devices
  Future<List<DeviceEntity>> discoverDevices() async {
    final res = await _chromeCastPlatform.discoverDevices();
    final result = <DeviceEntity>[];

    print('discoverDevices -> ${res.devicesData}');
    final data = List.from(jsonDecode(res.devicesData));
    data.forEach((element) {
      result.add(DeviceEntity.fromJson(element));
    });

    return result;
  }

  /// connect to device with id
  Future<void> connect({@required String deviceId}) {
    return _chromeCastPlatform.connect(deviceId: deviceId);
  }

  /// connect to device with id
  Future<void> disconnect() {
    return _chromeCastPlatform.disconnect();
  }

  /// Returns `true` when a cast session is connected, `false` otherwise.
  Future<bool> isConnected() {
    return _chromeCastPlatform.isConnected();
  }

  Stream<SessionStartedEvent> onSessionStarted() =>
      _chromeCastPlatform.onSessionStarted();

  Stream<SessionEndedEvent> onSessionEnded() =>
      _chromeCastPlatform.onSessionEnded();

  Stream<SessionConnectingEvent> onSessionConnecting() =>
      _chromeCastPlatform.onSessionConnecting();

  Stream<RequestDidCompleteEvent> onRequestCompleted() =>
      _chromeCastPlatform.onRequestCompleted();

  Stream<RequestDidFailEvent> onRequestFailed() =>
      _chromeCastPlatform.onRequestFailed();
}
