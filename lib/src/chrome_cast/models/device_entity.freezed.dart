// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'device_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
DeviceEntity _$DeviceEntityFromJson(Map<String, dynamic> json) {
  return _DeviceEntity.fromJson(json);
}

/// @nodoc
class _$DeviceEntityTearOff {
  const _$DeviceEntityTearOff();

// ignore: unused_element
  _DeviceEntity call(
      {@JsonKey(name: 'id', required: true, disallowNullValue: true)
          String id,
      @JsonKey(name: 'name', required: true, disallowNullValue: true)
          String name}) {
    return _DeviceEntity(
      id: id,
      name: name,
    );
  }

// ignore: unused_element
  DeviceEntity fromJson(Map<String, Object> json) {
    return DeviceEntity.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $DeviceEntity = _$DeviceEntityTearOff();

/// @nodoc
mixin _$DeviceEntity {
  @JsonKey(name: 'id', required: true, disallowNullValue: true)
  String get id;
  @JsonKey(name: 'name', required: true, disallowNullValue: true)
  String get name;

  Map<String, dynamic> toJson();
  @JsonKey(ignore: true)
  $DeviceEntityCopyWith<DeviceEntity> get copyWith;
}

/// @nodoc
abstract class $DeviceEntityCopyWith<$Res> {
  factory $DeviceEntityCopyWith(
          DeviceEntity value, $Res Function(DeviceEntity) then) =
      _$DeviceEntityCopyWithImpl<$Res>;
  $Res call(
      {@JsonKey(name: 'id', required: true, disallowNullValue: true)
          String id,
      @JsonKey(name: 'name', required: true, disallowNullValue: true)
          String name});
}

/// @nodoc
class _$DeviceEntityCopyWithImpl<$Res> implements $DeviceEntityCopyWith<$Res> {
  _$DeviceEntityCopyWithImpl(this._value, this._then);

  final DeviceEntity _value;
  // ignore: unused_field
  final $Res Function(DeviceEntity) _then;

  @override
  $Res call({
    Object id = freezed,
    Object name = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed ? _value.id : id as String,
      name: name == freezed ? _value.name : name as String,
    ));
  }
}

/// @nodoc
abstract class _$DeviceEntityCopyWith<$Res>
    implements $DeviceEntityCopyWith<$Res> {
  factory _$DeviceEntityCopyWith(
          _DeviceEntity value, $Res Function(_DeviceEntity) then) =
      __$DeviceEntityCopyWithImpl<$Res>;
  @override
  $Res call(
      {@JsonKey(name: 'id', required: true, disallowNullValue: true)
          String id,
      @JsonKey(name: 'name', required: true, disallowNullValue: true)
          String name});
}

/// @nodoc
class __$DeviceEntityCopyWithImpl<$Res> extends _$DeviceEntityCopyWithImpl<$Res>
    implements _$DeviceEntityCopyWith<$Res> {
  __$DeviceEntityCopyWithImpl(
      _DeviceEntity _value, $Res Function(_DeviceEntity) _then)
      : super(_value, (v) => _then(v as _DeviceEntity));

  @override
  _DeviceEntity get _value => super._value as _DeviceEntity;

  @override
  $Res call({
    Object id = freezed,
    Object name = freezed,
  }) {
    return _then(_DeviceEntity(
      id: id == freezed ? _value.id : id as String,
      name: name == freezed ? _value.name : name as String,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_DeviceEntity implements _DeviceEntity {
  const _$_DeviceEntity(
      {@JsonKey(name: 'id', required: true, disallowNullValue: true)
          this.id,
      @JsonKey(name: 'name', required: true, disallowNullValue: true)
          this.name});

  factory _$_DeviceEntity.fromJson(Map<String, dynamic> json) =>
      _$_$_DeviceEntityFromJson(json);

  @override
  @JsonKey(name: 'id', required: true, disallowNullValue: true)
  final String id;
  @override
  @JsonKey(name: 'name', required: true, disallowNullValue: true)
  final String name;

  @override
  String toString() {
    return 'DeviceEntity(id: $id, name: $name)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _DeviceEntity &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name);

  @JsonKey(ignore: true)
  @override
  _$DeviceEntityCopyWith<_DeviceEntity> get copyWith =>
      __$DeviceEntityCopyWithImpl<_DeviceEntity>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_DeviceEntityToJson(this);
  }
}

abstract class _DeviceEntity implements DeviceEntity {
  const factory _DeviceEntity(
      {@JsonKey(name: 'id', required: true, disallowNullValue: true)
          String id,
      @JsonKey(name: 'name', required: true, disallowNullValue: true)
          String name}) = _$_DeviceEntity;

  factory _DeviceEntity.fromJson(Map<String, dynamic> json) =
      _$_DeviceEntity.fromJson;

  @override
  @JsonKey(name: 'id', required: true, disallowNullValue: true)
  String get id;
  @override
  @JsonKey(name: 'name', required: true, disallowNullValue: true)
  String get name;
  @override
  @JsonKey(ignore: true)
  _$DeviceEntityCopyWith<_DeviceEntity> get copyWith;
}
