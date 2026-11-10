// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_active_order_dto_output_order_handover.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CaptainActiveOrderDtoOutputOrderHandoverRoleEnum
_$captainActiveOrderDtoOutputOrderHandoverRoleEnum_giving =
    const CaptainActiveOrderDtoOutputOrderHandoverRoleEnum._('giving');
const CaptainActiveOrderDtoOutputOrderHandoverRoleEnum
_$captainActiveOrderDtoOutputOrderHandoverRoleEnum_receiving =
    const CaptainActiveOrderDtoOutputOrderHandoverRoleEnum._('receiving');

CaptainActiveOrderDtoOutputOrderHandoverRoleEnum
_$captainActiveOrderDtoOutputOrderHandoverRoleEnumValueOf(String name) {
  switch (name) {
    case 'giving':
      return _$captainActiveOrderDtoOutputOrderHandoverRoleEnum_giving;
    case 'receiving':
      return _$captainActiveOrderDtoOutputOrderHandoverRoleEnum_receiving;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CaptainActiveOrderDtoOutputOrderHandoverRoleEnum>
_$captainActiveOrderDtoOutputOrderHandoverRoleEnumValues =
    BuiltSet<CaptainActiveOrderDtoOutputOrderHandoverRoleEnum>(
      const <CaptainActiveOrderDtoOutputOrderHandoverRoleEnum>[
        _$captainActiveOrderDtoOutputOrderHandoverRoleEnum_giving,
        _$captainActiveOrderDtoOutputOrderHandoverRoleEnum_receiving,
      ],
    );

Serializer<CaptainActiveOrderDtoOutputOrderHandoverRoleEnum>
_$captainActiveOrderDtoOutputOrderHandoverRoleEnumSerializer =
    _$CaptainActiveOrderDtoOutputOrderHandoverRoleEnumSerializer();

class _$CaptainActiveOrderDtoOutputOrderHandoverRoleEnumSerializer
    implements
        PrimitiveSerializer<CaptainActiveOrderDtoOutputOrderHandoverRoleEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'giving': 'giving',
    'receiving': 'receiving',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'giving': 'giving',
    'receiving': 'receiving',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CaptainActiveOrderDtoOutputOrderHandoverRoleEnum,
  ];
  @override
  final String wireName = 'CaptainActiveOrderDtoOutputOrderHandoverRoleEnum';

  @override
  Object serialize(
    Serializers serializers,
    CaptainActiveOrderDtoOutputOrderHandoverRoleEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CaptainActiveOrderDtoOutputOrderHandoverRoleEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CaptainActiveOrderDtoOutputOrderHandoverRoleEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CaptainActiveOrderDtoOutputOrderHandover
    extends CaptainActiveOrderDtoOutputOrderHandover {
  @override
  final CaptainActiveOrderDtoOutputOrderHandoverRoleEnum role;
  @override
  final bool assigned;
  @override
  final CaptainActiveOrderDtoOutputOrderHandoverCaptain captain;

  factory _$CaptainActiveOrderDtoOutputOrderHandover([
    void Function(CaptainActiveOrderDtoOutputOrderHandoverBuilder)? updates,
  ]) => (CaptainActiveOrderDtoOutputOrderHandoverBuilder()..update(updates))
      ._build();

  _$CaptainActiveOrderDtoOutputOrderHandover._({
    required this.role,
    required this.assigned,
    required this.captain,
  }) : super._();
  @override
  CaptainActiveOrderDtoOutputOrderHandover rebuild(
    void Function(CaptainActiveOrderDtoOutputOrderHandoverBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainActiveOrderDtoOutputOrderHandoverBuilder toBuilder() =>
      CaptainActiveOrderDtoOutputOrderHandoverBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainActiveOrderDtoOutputOrderHandover &&
        role == other.role &&
        assigned == other.assigned &&
        captain == other.captain;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jc(_$hash, assigned.hashCode);
    _$hash = $jc(_$hash, captain.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CaptainActiveOrderDtoOutputOrderHandover',
          )
          ..add('role', role)
          ..add('assigned', assigned)
          ..add('captain', captain))
        .toString();
  }
}

class CaptainActiveOrderDtoOutputOrderHandoverBuilder
    implements
        Builder<
          CaptainActiveOrderDtoOutputOrderHandover,
          CaptainActiveOrderDtoOutputOrderHandoverBuilder
        > {
  _$CaptainActiveOrderDtoOutputOrderHandover? _$v;

  CaptainActiveOrderDtoOutputOrderHandoverRoleEnum? _role;
  CaptainActiveOrderDtoOutputOrderHandoverRoleEnum? get role => _$this._role;
  set role(CaptainActiveOrderDtoOutputOrderHandoverRoleEnum? role) =>
      _$this._role = role;

  bool? _assigned;
  bool? get assigned => _$this._assigned;
  set assigned(bool? assigned) => _$this._assigned = assigned;

  CaptainActiveOrderDtoOutputOrderHandoverCaptainBuilder? _captain;
  CaptainActiveOrderDtoOutputOrderHandoverCaptainBuilder get captain =>
      _$this._captain ??=
          CaptainActiveOrderDtoOutputOrderHandoverCaptainBuilder();
  set captain(
    CaptainActiveOrderDtoOutputOrderHandoverCaptainBuilder? captain,
  ) => _$this._captain = captain;

  CaptainActiveOrderDtoOutputOrderHandoverBuilder() {
    CaptainActiveOrderDtoOutputOrderHandover._defaults(this);
  }

  CaptainActiveOrderDtoOutputOrderHandoverBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _role = $v.role;
      _assigned = $v.assigned;
      _captain = $v.captain.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainActiveOrderDtoOutputOrderHandover other) {
    _$v = other as _$CaptainActiveOrderDtoOutputOrderHandover;
  }

  @override
  void update(
    void Function(CaptainActiveOrderDtoOutputOrderHandoverBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainActiveOrderDtoOutputOrderHandover build() => _build();

  _$CaptainActiveOrderDtoOutputOrderHandover _build() {
    _$CaptainActiveOrderDtoOutputOrderHandover _$result;
    try {
      _$result =
          _$v ??
          _$CaptainActiveOrderDtoOutputOrderHandover._(
            role: BuiltValueNullFieldError.checkNotNull(
              role,
              r'CaptainActiveOrderDtoOutputOrderHandover',
              'role',
            ),
            assigned: BuiltValueNullFieldError.checkNotNull(
              assigned,
              r'CaptainActiveOrderDtoOutputOrderHandover',
              'assigned',
            ),
            captain: captain.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'captain';
        captain.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainActiveOrderDtoOutputOrderHandover',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
