import 'package:flutter/foundation.dart';
import 'package:flutter_video_cast/src/chrome_cast/models/device_entity.dart';

/// Generic Event coming from the native side.
///
/// All ChromeCastEvents
class ChromeCastEvent {}

/// An event fired on a session
class SessionEvent extends ChromeCastEvent {}

/// An event fired when a session started.
class SessionStartedEvent extends SessionEvent {}

/// An event fired when a session ended.
class SessionEndedEvent extends SessionEvent {}

/// An event fired when a session is connecting.
class SessionConnectingEvent extends SessionEvent {}

/// An event fired when a session is already connected.
class SessionAlreadyConnectedEvent extends SessionEvent {}

/// An event fired on a device discovery
class DeviceDiscoveryEvent extends ChromeCastEvent {}

/// An event fired when a new device detected or an old one detached.
class DidUpdateDeviceListEvent extends DeviceDiscoveryEvent {
  final List<DeviceEntity> devices;

  DidUpdateDeviceListEvent(this.devices);
}

/// An event fired when local network permission is not granted
class LocalNetworkDeniedEvent extends DeviceDiscoveryEvent {}

/// An event fired on a request.
class RequestEvent extends ChromeCastEvent {}

/// An event fired when a request completed.
class RequestDidCompleteEvent extends RequestEvent {}

/// An event fired when a request failed.
class RequestDidFailEvent extends RequestEvent {
  /// The error message.
  final String error;

  /// Build a RequestDidFail Event.
  RequestDidFailEvent(this.error);
}

enum PlaybackState {
  unknown,
  playing,
  buffering,
  idle,
  loading,
  paused,
}

enum PlaybackIdleReason {
  none,
  cancelled,
  error,
  finished,
  interrupted,
}

/// An event fired on playback update.
/// duration == null hence it's not initialized yet
class DidUpdatePlaybackEvent extends ChromeCastEvent {
  final Duration duration;
  final Duration position;
  final PlaybackState state;
  final PlaybackIdleReason idleReason;

  DidUpdatePlaybackEvent(
      {@required this.duration,
      @required this.position,
      @required this.state,
      @required this.idleReason});

  @override
  String toString() {
    return 'DidUpdatePlaybackEvent: duration: $duration; position: $position; state: $state, idleReason: $idleReason';
  }
}
