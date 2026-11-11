// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_device_released_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminDeviceReleasedDtoOutputStatusEnum
_$adminDeviceReleasedDtoOutputStatusEnum_released =
    const AdminDeviceReleasedDtoOutputStatusEnum._('released');

AdminDeviceReleasedDtoOutputStatusEnum
_$adminDeviceReleasedDtoOutputStatusEnumValueOf(String name) {
  switch (name) {
    case 'released':
      return _$adminDeviceReleasedDtoOutputStatusEnum_released;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminDeviceReleasedDtoOutputStatusEnum>
_$adminDeviceReleasedDtoOutputStatusEnumValues =
    BuiltSet<AdminDeviceReleasedDtoOutputStatusEnum>(
      const <AdminDeviceReleasedDtoOutputStatusEnum>[
        _$adminDeviceReleasedDtoOutputStatusEnum_released,
      ],
    );

Serializer<AdminDeviceReleasedDtoOutputStatusEnum>
_$adminDeviceReleasedDtoOutputStatusEnumSerializer =
    _$AdminDeviceReleasedDtoOutputStatusEnumSerializer();

class _$AdminDeviceReleasedDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<AdminDeviceReleasedDtoOutputStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'released': 'released',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'released': 'released',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminDeviceReleasedDtoOutputStatusEnum,
  ];
  @override
  final String wireName = 'AdminDeviceReleasedDtoOutputStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminDeviceReleasedDtoOutputStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminDeviceReleasedDtoOutputStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminDeviceReleasedDtoOutputStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminDeviceReleasedDtoOutput extends AdminDeviceReleasedDtoOutput {
  @override
  final AdminDeviceReleasedDtoOutputStatusEnum status;

  factory _$AdminDeviceReleasedDtoOutput([
    void Function(AdminDeviceReleasedDtoOutputBuilder)? updates,
  ]) => (AdminDeviceReleasedDtoOutputBuilder()..update(updates))._build();

  _$AdminDeviceReleasedDtoOutput._({required this.status}) : super._();
  @override
  AdminDeviceReleasedDtoOutput rebuild(
    void Function(AdminDeviceReleasedDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDeviceReleasedDtoOutputBuilder toBuilder() =>
      AdminDeviceReleasedDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDeviceReleasedDtoOutput && status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminDeviceReleasedDtoOutput',
    )..add('status', status)).toString();
  }
}

class AdminDeviceReleasedDtoOutputBuilder
    implements
        Builder<
          AdminDeviceReleasedDtoOutput,
          AdminDeviceReleasedDtoOutputBuilder
        > {
  _$AdminDeviceReleasedDtoOutput? _$v;

  AdminDeviceReleasedDtoOutputStatusEnum? _status;
  AdminDeviceReleasedDtoOutputStatusEnum? get status => _$this._status;
  set status(AdminDeviceReleasedDtoOutputStatusEnum? status) =>
      _$this._status = status;

  AdminDeviceReleasedDtoOutputBuilder() {
    AdminDeviceReleasedDtoOutput._defaults(this);
  }

  AdminDeviceReleasedDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDeviceReleasedDtoOutput other) {
    _$v = other as _$AdminDeviceReleasedDtoOutput;
  }

  @override
  void update(void Function(AdminDeviceReleasedDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDeviceReleasedDtoOutput build() => _build();

  _$AdminDeviceReleasedDtoOutput _build() {
    final _$result =
        _$v ??
        _$AdminDeviceReleasedDtoOutput._(
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'AdminDeviceReleasedDtoOutput',
            'status',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
