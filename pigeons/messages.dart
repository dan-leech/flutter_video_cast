// @dart = 2.9

import 'package:meta/meta.dart';
import 'package:pigeon/pigeon_lib.dart';

class DevicesMessage {
  /// json data
  String devicesData;
}

class ConnectMessage {
  String deviceId;
}

class IsConnectedMessage {
  int isConnected;
}

class LoadMediaMessage {
  String url;
  String title;
  String description;
  String studio; // replacer if device.friendlyName is not set
  String thumbnailUrl;
  int position;
}

@HostApi(dartHostTestHandler: 'TestHostVideoCastApi')
abstract class VideoCastApi {
  void initialize();
  DevicesMessage discoverDevices();
  void connect(ConnectMessage msg);
  void disconnect();
  IsConnectedMessage isConnected();
  void loadMedia(LoadMediaMessage msg);
}

void configurePigeon(PigeonOptions opts) {
  opts.dartOut = '../flutter_video_cast/lib/messages.dart';
  opts.objcHeaderOut = 'ios/Classes/messages.h';
  opts.objcSourceOut = 'ios/Classes/messages.m';
  opts.objcOptions.prefix = 'FLT';
  opts.javaOut =
      'android/src/main/kotlin/it/aesys/flutter_video_cast/Messages.java';
  opts.javaOptions.package = 'it.aesys.flutter_video_cast';
}
