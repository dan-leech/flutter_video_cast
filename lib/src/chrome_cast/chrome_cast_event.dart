/// Generic Event coming from the native side.
///
/// All ChromeCastEvents
class ChromeCastEvent {}

/// An event fired when a session started.
class SessionStartedEvent extends ChromeCastEvent {
  /// Build a SessionStarted Event triggered.
  SessionStartedEvent();
}

/// An event fired when a session ended.
class SessionEndedEvent extends ChromeCastEvent {
  /// Build a SessionEnded Event.
  SessionEndedEvent();
}

/// An event fired when a session is connecting.
class SessionConnectingEvent extends ChromeCastEvent {
  /// Build a SessionConnecting Event.
  SessionConnectingEvent();
}

/// An event fired when a request completed.
class RequestDidCompleteEvent extends ChromeCastEvent {
  /// Build a RequestDidComplete Event.
  RequestDidCompleteEvent();
}

/// An event fired when a request failed.
class RequestDidFailEvent extends ChromeCastEvent {
  /// The error message.
  final String error;

  /// Build a RequestDidFail Event.
  RequestDidFailEvent(this.error);
}
