// Autogenerated from Pigeon (v0.1.19), do not edit directly.
// See also: https://pub.dev/packages/pigeon

package it.aesys.flutter_video_cast;

import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import java.util.ArrayList;
import java.util.HashMap;

/** Generated class from Pigeon. */
@SuppressWarnings("unused")
public class Messages {

  /** Generated class from Pigeon that represents data sent in messages. */
  public static class DevicesMessage {
    private String devicesData;
    public String getDevicesData() { return devicesData; }
    public void setDevicesData(String setterArg) { this.devicesData = setterArg; }

    HashMap toMap() {
      HashMap<String, Object> toMapResult = new HashMap<>();
      toMapResult.put("devicesData", devicesData);
      return toMapResult;
    }
    static DevicesMessage fromMap(HashMap map) {
      DevicesMessage fromMapResult = new DevicesMessage();
      Object devicesData = map.get("devicesData");
      fromMapResult.devicesData = (String)devicesData;
      return fromMapResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static class ConnectMessage {
    private String deviceId;
    public String getDeviceId() { return deviceId; }
    public void setDeviceId(String setterArg) { this.deviceId = setterArg; }

    HashMap toMap() {
      HashMap<String, Object> toMapResult = new HashMap<>();
      toMapResult.put("deviceId", deviceId);
      return toMapResult;
    }
    static ConnectMessage fromMap(HashMap map) {
      ConnectMessage fromMapResult = new ConnectMessage();
      Object deviceId = map.get("deviceId");
      fromMapResult.deviceId = (String)deviceId;
      return fromMapResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static class IsConnectedMessage {
    private Long isConnected;
    public Long getIsConnected() { return isConnected; }
    public void setIsConnected(Long setterArg) { this.isConnected = setterArg; }

    HashMap toMap() {
      HashMap<String, Object> toMapResult = new HashMap<>();
      toMapResult.put("isConnected", isConnected);
      return toMapResult;
    }
    static IsConnectedMessage fromMap(HashMap map) {
      IsConnectedMessage fromMapResult = new IsConnectedMessage();
      Object isConnected = map.get("isConnected");
      fromMapResult.isConnected = (isConnected == null) ? null : ((isConnected instanceof Integer) ? (Integer)isConnected : (Long)isConnected);
      return fromMapResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static class LoadMediaMessage {
    private String url;
    public String getUrl() { return url; }
    public void setUrl(String setterArg) { this.url = setterArg; }

    private String title;
    public String getTitle() { return title; }
    public void setTitle(String setterArg) { this.title = setterArg; }

    private String descr;
    public String getDescr() { return descr; }
    public void setDescr(String setterArg) { this.descr = setterArg; }

    private String studio;
    public String getStudio() { return studio; }
    public void setStudio(String setterArg) { this.studio = setterArg; }

    private String thumbnailUrl;
    public String getThumbnailUrl() { return thumbnailUrl; }
    public void setThumbnailUrl(String setterArg) { this.thumbnailUrl = setterArg; }

    private Long position;
    public Long getPosition() { return position; }
    public void setPosition(Long setterArg) { this.position = setterArg; }

    private Boolean autoPlay;
    public Boolean getAutoPlay() { return autoPlay; }
    public void setAutoPlay(Boolean setterArg) { this.autoPlay = setterArg; }

    HashMap toMap() {
      HashMap<String, Object> toMapResult = new HashMap<>();
      toMapResult.put("url", url);
      toMapResult.put("title", title);
      toMapResult.put("descr", descr);
      toMapResult.put("studio", studio);
      toMapResult.put("thumbnailUrl", thumbnailUrl);
      toMapResult.put("position", position);
      toMapResult.put("autoPlay", autoPlay);
      return toMapResult;
    }
    static LoadMediaMessage fromMap(HashMap map) {
      LoadMediaMessage fromMapResult = new LoadMediaMessage();
      Object url = map.get("url");
      fromMapResult.url = (String)url;
      Object title = map.get("title");
      fromMapResult.title = (String)title;
      Object descr = map.get("descr");
      fromMapResult.descr = (String)descr;
      Object studio = map.get("studio");
      fromMapResult.studio = (String)studio;
      Object thumbnailUrl = map.get("thumbnailUrl");
      fromMapResult.thumbnailUrl = (String)thumbnailUrl;
      Object position = map.get("position");
      fromMapResult.position = (position == null) ? null : ((position instanceof Integer) ? (Integer)position : (Long)position);
      Object autoPlay = map.get("autoPlay");
      fromMapResult.autoPlay = (Boolean)autoPlay;
      return fromMapResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static class SeekMessage {
    private Boolean relative;
    public Boolean getRelative() { return relative; }
    public void setRelative(Boolean setterArg) { this.relative = setterArg; }

    private Double interval;
    public Double getInterval() { return interval; }
    public void setInterval(Double setterArg) { this.interval = setterArg; }

    HashMap toMap() {
      HashMap<String, Object> toMapResult = new HashMap<>();
      toMapResult.put("relative", relative);
      toMapResult.put("interval", interval);
      return toMapResult;
    }
    static SeekMessage fromMap(HashMap map) {
      SeekMessage fromMapResult = new SeekMessage();
      Object relative = map.get("relative");
      fromMapResult.relative = (Boolean)relative;
      Object interval = map.get("interval");
      fromMapResult.interval = (Double)interval;
      return fromMapResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static class IsPlayingMessage {
    private Long isPlaying;
    public Long getIsPlaying() { return isPlaying; }
    public void setIsPlaying(Long setterArg) { this.isPlaying = setterArg; }

    HashMap toMap() {
      HashMap<String, Object> toMapResult = new HashMap<>();
      toMapResult.put("isPlaying", isPlaying);
      return toMapResult;
    }
    static IsPlayingMessage fromMap(HashMap map) {
      IsPlayingMessage fromMapResult = new IsPlayingMessage();
      Object isPlaying = map.get("isPlaying");
      fromMapResult.isPlaying = (isPlaying == null) ? null : ((isPlaying instanceof Integer) ? (Integer)isPlaying : (Long)isPlaying);
      return fromMapResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static class PositionMessage {
    private Double position;
    public Double getPosition() { return position; }
    public void setPosition(Double setterArg) { this.position = setterArg; }

    HashMap toMap() {
      HashMap<String, Object> toMapResult = new HashMap<>();
      toMapResult.put("position", position);
      return toMapResult;
    }
    static PositionMessage fromMap(HashMap map) {
      PositionMessage fromMapResult = new PositionMessage();
      Object position = map.get("position");
      fromMapResult.position = (Double)position;
      return fromMapResult;
    }
  }

  /** Generated interface from Pigeon that represents a handler of messages from Flutter.*/
  public interface VideoCastApi {
    void initialize();
    DevicesMessage discoverDevices();
    void connect(ConnectMessage arg);
    void disconnect();
    IsConnectedMessage isConnected();
    void loadMedia(LoadMediaMessage arg);
    void play();
    void pause();
    void stop();
    void seek(SeekMessage arg);
    IsPlayingMessage isPlaying();
    PositionMessage getPosition();

    /** Sets up an instance of `VideoCastApi` to handle messages through the `binaryMessenger` */
    static void setup(BinaryMessenger binaryMessenger, VideoCastApi api) {
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.VideoCastApi.initialize", new StandardMessageCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            HashMap<String, HashMap> wrapped = new HashMap<>();
            try {
              api.initialize();
              wrapped.put("result", null);
            }
            catch (Exception exception) {
              wrapped.put("error", wrapError(exception));
            }
            reply.reply(wrapped);
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.VideoCastApi.discoverDevices", new StandardMessageCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            HashMap<String, HashMap> wrapped = new HashMap<>();
            try {
              DevicesMessage output = api.discoverDevices();
              wrapped.put("result", output.toMap());
            }
            catch (Exception exception) {
              wrapped.put("error", wrapError(exception));
            }
            reply.reply(wrapped);
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.VideoCastApi.connect", new StandardMessageCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            HashMap<String, HashMap> wrapped = new HashMap<>();
            try {
              @SuppressWarnings("ConstantConditions")
              ConnectMessage input = ConnectMessage.fromMap((HashMap)message);
              api.connect(input);
              wrapped.put("result", null);
            }
            catch (Exception exception) {
              wrapped.put("error", wrapError(exception));
            }
            reply.reply(wrapped);
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.VideoCastApi.disconnect", new StandardMessageCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            HashMap<String, HashMap> wrapped = new HashMap<>();
            try {
              api.disconnect();
              wrapped.put("result", null);
            }
            catch (Exception exception) {
              wrapped.put("error", wrapError(exception));
            }
            reply.reply(wrapped);
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.VideoCastApi.isConnected", new StandardMessageCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            HashMap<String, HashMap> wrapped = new HashMap<>();
            try {
              IsConnectedMessage output = api.isConnected();
              wrapped.put("result", output.toMap());
            }
            catch (Exception exception) {
              wrapped.put("error", wrapError(exception));
            }
            reply.reply(wrapped);
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.VideoCastApi.loadMedia", new StandardMessageCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            HashMap<String, HashMap> wrapped = new HashMap<>();
            try {
              @SuppressWarnings("ConstantConditions")
              LoadMediaMessage input = LoadMediaMessage.fromMap((HashMap)message);
              api.loadMedia(input);
              wrapped.put("result", null);
            }
            catch (Exception exception) {
              wrapped.put("error", wrapError(exception));
            }
            reply.reply(wrapped);
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.VideoCastApi.play", new StandardMessageCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            HashMap<String, HashMap> wrapped = new HashMap<>();
            try {
              api.play();
              wrapped.put("result", null);
            }
            catch (Exception exception) {
              wrapped.put("error", wrapError(exception));
            }
            reply.reply(wrapped);
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.VideoCastApi.pause", new StandardMessageCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            HashMap<String, HashMap> wrapped = new HashMap<>();
            try {
              api.pause();
              wrapped.put("result", null);
            }
            catch (Exception exception) {
              wrapped.put("error", wrapError(exception));
            }
            reply.reply(wrapped);
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.VideoCastApi.stop", new StandardMessageCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            HashMap<String, HashMap> wrapped = new HashMap<>();
            try {
              api.stop();
              wrapped.put("result", null);
            }
            catch (Exception exception) {
              wrapped.put("error", wrapError(exception));
            }
            reply.reply(wrapped);
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.VideoCastApi.seek", new StandardMessageCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            HashMap<String, HashMap> wrapped = new HashMap<>();
            try {
              @SuppressWarnings("ConstantConditions")
              SeekMessage input = SeekMessage.fromMap((HashMap)message);
              api.seek(input);
              wrapped.put("result", null);
            }
            catch (Exception exception) {
              wrapped.put("error", wrapError(exception));
            }
            reply.reply(wrapped);
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.VideoCastApi.isPlaying", new StandardMessageCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            HashMap<String, HashMap> wrapped = new HashMap<>();
            try {
              IsPlayingMessage output = api.isPlaying();
              wrapped.put("result", output.toMap());
            }
            catch (Exception exception) {
              wrapped.put("error", wrapError(exception));
            }
            reply.reply(wrapped);
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.VideoCastApi.getPosition", new StandardMessageCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            HashMap<String, HashMap> wrapped = new HashMap<>();
            try {
              PositionMessage output = api.getPosition();
              wrapped.put("result", output.toMap());
            }
            catch (Exception exception) {
              wrapped.put("error", wrapError(exception));
            }
            reply.reply(wrapped);
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
    }
  }
  private static HashMap wrapError(Exception exception) {
    HashMap<String, Object> errorMap = new HashMap<>();
    errorMap.put("message", exception.toString());
    errorMap.put("code", exception.getClass().getSimpleName());
    errorMap.put("details", null);
    return errorMap;
  }
}