// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_emergency_stop_resumed_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminEmergencyStopResumedDtoOutputResumedEnum
_$adminEmergencyStopResumedDtoOutputResumedEnum_true_ =
    const AdminEmergencyStopResumedDtoOutputResumedEnum._('true_');

AdminEmergencyStopResumedDtoOutputResumedEnum
_$adminEmergencyStopResumedDtoOutputResumedEnumValueOf(String name) {
  switch (name) {
    case 'true_':
      return _$adminEmergencyStopResumedDtoOutputResumedEnum_true_;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminEmergencyStopResumedDtoOutputResumedEnum>
_$adminEmergencyStopResumedDtoOutputResumedEnumValues =
    BuiltSet<AdminEmergencyStopResumedDtoOutputResumedEnum>(
      const <AdminEmergencyStopResumedDtoOutputResumedEnum>[
        _$adminEmergencyStopResumedDtoOutputResumedEnum_true_,
      ],
    );

Serializer<AdminEmergencyStopResumedDtoOutputResumedEnum>
_$adminEmergencyStopResumedDtoOutputResumedEnumSerializer =
    _$AdminEmergencyStopResumedDtoOutputResumedEnumSerializer();

class _$AdminEmergencyStopResumedDtoOutputResumedEnumSerializer
    implements
        PrimitiveSerializer<AdminEmergencyStopResumedDtoOutputResumedEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'true_': 'true',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'true': 'true_',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminEmergencyStopResumedDtoOutputResumedEnum,
  ];
  @override
  final String wireName = 'AdminEmergencyStopResumedDtoOutputResumedEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminEmergencyStopResumedDtoOutputResumedEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminEmergencyStopResumedDtoOutputResumedEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminEmergencyStopResumedDtoOutputResumedEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminEmergencyStopResumedDtoOutput
    extends AdminEmergencyStopResumedDtoOutput {
  @override
  final AdminEmergencyStopResumedDtoOutputResumedEnum resumed;

  factory _$AdminEmergencyStopResumedDtoOutput([
    void Function(AdminEmergencyStopResumedDtoOutputBuilder)? updates,
  ]) => (AdminEmergencyStopResumedDtoOutputBuilder()..update(updates))._build();

  _$AdminEmergencyStopResumedDtoOutput._({required this.resumed}) : super._();
  @override
  AdminEmergencyStopResumedDtoOutput rebuild(
    void Function(AdminEmergencyStopResumedDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminEmergencyStopResumedDtoOutputBuilder toBuilder() =>
      AdminEmergencyStopResumedDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminEmergencyStopResumedDtoOutput &&
        resumed == other.resumed;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, resumed.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminEmergencyStopResumedDtoOutput',
    )..add('resumed', resumed)).toString();
  }
}

class AdminEmergencyStopResumedDtoOutputBuilder
    implements
        Builder<
          AdminEmergencyStopResumedDtoOutput,
          AdminEmergencyStopResumedDtoOutputBuilder
        > {
  _$AdminEmergencyStopResumedDtoOutput? _$v;

  AdminEmergencyStopResumedDtoOutputResumedEnum? _resumed;
  AdminEmergencyStopResumedDtoOutputResumedEnum? get resumed => _$this._resumed;
  set resumed(AdminEmergencyStopResumedDtoOutputResumedEnum? resumed) =>
      _$this._resumed = resumed;

  AdminEmergencyStopResumedDtoOutputBuilder() {
    AdminEmergencyStopResumedDtoOutput._defaults(this);
  }

  AdminEmergencyStopResumedDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _resumed = $v.resumed;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminEmergencyStopResumedDtoOutput other) {
    _$v = other as _$AdminEmergencyStopResumedDtoOutput;
  }

  @override
  void update(
    void Function(AdminEmergencyStopResumedDtoOutputBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminEmergencyStopResumedDtoOutput build() => _build();

  _$AdminEmergencyStopResumedDtoOutput _build() {
    final _$result =
        _$v ??
        _$AdminEmergencyStopResumedDtoOutput._(
          resumed: BuiltValueNullFieldError.checkNotNull(
            resumed,
            r'AdminEmergencyStopResumedDtoOutput',
            'resumed',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
