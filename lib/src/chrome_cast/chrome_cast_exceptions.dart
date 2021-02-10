part of flutter_video_cast;

class RequestFailedException implements Exception {
  final dynamic message;

  RequestFailedException([this.message]);

  @override
  String toString() {
    Object message = this.message;
    if (message == null) return 'RequestFailedException';
    return 'RequestFailedException: $message';
  }
}
