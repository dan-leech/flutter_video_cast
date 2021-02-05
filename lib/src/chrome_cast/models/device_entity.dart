import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_entity.freezed.dart';
part 'device_entity.g.dart';

@freezed
abstract class DeviceEntity with _$DeviceEntity {
  const factory DeviceEntity({
    @JsonKey(name: 'id', required: true, disallowNullValue: true)
    String id,
    @JsonKey(name: 'name', required: true, disallowNullValue: true)
    String name,
  }) = _DeviceEntity;

  factory DeviceEntity.fromJson(Map<String, dynamic> json) =>
      _$DeviceEntityFromJson(json);
}
