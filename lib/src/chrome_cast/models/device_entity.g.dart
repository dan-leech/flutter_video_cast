// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_DeviceEntity _$_$_DeviceEntityFromJson(Map json) {
  $checkKeys(json,
      requiredKeys: const ['id', 'name'],
      disallowNullValues: const ['id', 'name']);
  return _$_DeviceEntity(
    id: json['id'] as String,
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$_$_DeviceEntityToJson(_$_DeviceEntity instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('name', instance.name);
  return val;
}
