part of flutter_video_cast;

final ChromeCastPlatform _chromeCastPlatform = ChromeCastPlatform.instance;

/// Controller for all ChromeCastSessions
class ChromeCastController {
  const ChromeCastController._();

  Stream<ChromeCastEvent> get events => _chromeCastPlatform.events;

  List<DeviceEntity> get devices => _chromeCastPlatform.devices;

  SessionEvent get sessionEvent => _chromeCastPlatform.sessionEvent;

  DeviceDiscoveryEvent get deviceDiscoveryEvent =>
      _chromeCastPlatform.deviceDiscoveryEvent;

  /// Initialize control of a [ChromeCastButton].
  static ChromeCastController init() {
    _chromeCastPlatform.init();
    return ChromeCastController._();
  }

  /// open native MediaRouterDialog (only Android)
  Future<void> androidOpenMediaRouter() {
    return _chromeCastPlatform.androidOpenMediaRouter();
  }

  /// This method is necessary for discoverDevices and getting devices list
  Future<void> startDeviceDiscovery() {
    return _chromeCastPlatform.startDeviceDiscovery();
  }

  /// Load a new media by providing an [url].
  Future<void> loadMedia(String url,
      {String title,
      description,
      studio,
      thumbnailUrl,
      int position,
      bool autoPlay = true}) {
    return _chromeCastPlatform.loadMedia(url,
        title: title,
        description: description,
        studio: studio,
        thumbnailUrl: thumbnailUrl,
        position: position,
        autoPlay: autoPlay);
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

  Future<double> getPosition() {
    return _chromeCastPlatform.getPosition();
  }

  /// Get available devices
  Future<List<DeviceEntity>> discoverDevices() async {
    final res = await _chromeCastPlatform.discoverDevices();
    final result = <DeviceEntity>[];

    final data = List.from(jsonDecode(res.devicesData));
    data.forEach((element) {
      result.add(DeviceEntity.fromJson(element));
    });

    return result;
  }

  /// Get current connected device or null
  Future<DeviceEntity> getCurrentDevice() async {
    final res = await _chromeCastPlatform.getCurrentDevice();

    if (res.devicesData?.isEmpty ?? true) return null;

    final data = List.from(jsonDecode(res.devicesData));
    return DeviceEntity.fromJson(data.first);
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

  Stream<SessionEvent> onSessionEvent() => _chromeCastPlatform.onSessionEvent();

  Stream<SessionStartedEvent> onSessionStarted() =>
      _chromeCastPlatform.onSessionStarted();

  Stream<SessionEndedEvent> onSessionEnded() =>
      _chromeCastPlatform.onSessionEnded();

  Stream<SessionConnectingEvent> onSessionConnecting() =>
      _chromeCastPlatform.onSessionConnecting();

  Stream<RequestEvent> onRequestEvent() => _chromeCastPlatform.onRequestEvent();

  Stream<RequestDidCompleteEvent> onRequestCompleted() =>
      _chromeCastPlatform.onRequestCompleted();

  Stream<RequestDidFailEvent> onRequestFailed() =>
      _chromeCastPlatform.onRequestFailed();

  Stream<DeviceDiscoveryEvent> onDeviceDiscovery() =>
      _chromeCastPlatform.onDeviceDiscovery();

  Stream<DidUpdateDeviceListEvent> onDidUpdateDeviceList() =>
      _chromeCastPlatform.onDidUpdateDeviceList();

  Stream<DidUpdatePlaybackEvent> onDidUpdatePlayback() =>
      _chromeCastPlatform.onDidUpdatePlayback();
}
