// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_resolve_shortfall_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminResolveShortfallDtoResponsibleEnum
_$adminResolveShortfallDtoResponsibleEnum_captain =
    const AdminResolveShortfallDtoResponsibleEnum._('captain');
const AdminResolveShortfallDtoResponsibleEnum
_$adminResolveShortfallDtoResponsibleEnum_customer =
    const AdminResolveShortfallDtoResponsibleEnum._('customer');
const AdminResolveShortfallDtoResponsibleEnum
_$adminResolveShortfallDtoResponsibleEnum_platform =
    const AdminResolveShortfallDtoResponsibleEnum._('platform');

AdminResolveShortfallDtoResponsibleEnum
_$adminResolveShortfallDtoResponsibleEnumValueOf(String name) {
  switch (name) {
    case 'captain':
      return _$adminResolveShortfallDtoResponsibleEnum_captain;
    case 'customer':
      return _$adminResolveShortfallDtoResponsibleEnum_customer;
    case 'platform':
      return _$adminResolveShortfallDtoResponsibleEnum_platform;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminResolveShortfallDtoResponsibleEnum>
_$adminResolveShortfallDtoResponsibleEnumValues =
    BuiltSet<AdminResolveShortfallDtoResponsibleEnum>(
      const <AdminResolveShortfallDtoResponsibleEnum>[
        _$adminResolveShortfallDtoResponsibleEnum_captain,
        _$adminResolveShortfallDtoResponsibleEnum_customer,
        _$adminResolveShortfallDtoResponsibleEnum_platform,
      ],
    );

Serializer<AdminResolveShortfallDtoResponsibleEnum>
_$adminResolveShortfallDtoResponsibleEnumSerializer =
    _$AdminResolveShortfallDtoResponsibleEnumSerializer();

class _$AdminResolveShortfallDtoResponsibleEnumSerializer
    implements PrimitiveSerializer<AdminResolveShortfallDtoResponsibleEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'captain': 'captain',
    'customer': 'customer',
    'platform': 'platform',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'captain': 'captain',
    'customer': 'customer',
    'platform': 'platform',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminResolveShortfallDtoResponsibleEnum,
  ];
  @override
  final String wireName = 'AdminResolveShortfallDtoResponsibleEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminResolveShortfallDtoResponsibleEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminResolveShortfallDtoResponsibleEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminResolveShortfallDtoResponsibleEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminResolveShortfallDto extends AdminResolveShortfallDto {
  @override
  final AdminResolveShortfallDtoResponsibleEnum responsible;
  @override
  final String reason;

  factory _$AdminResolveShortfallDto([
    void Function(AdminResolveShortfallDtoBuilder)? updates,
  ]) => (AdminResolveShortfallDtoBuilder()..update(updates))._build();

  _$AdminResolveShortfallDto._({
    required this.responsible,
    required this.reason,
  }) : super._();
  @override
  AdminResolveShortfallDto rebuild(
    void Function(AdminResolveShortfallDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminResolveShortfallDtoBuilder toBuilder() =>
      AdminResolveShortfallDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminResolveShortfallDto &&
        responsible == other.responsible &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, responsible.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminResolveShortfallDto')
          ..add('responsible', responsible)
          ..add('reason', reason))
        .toString();
  }
}

class AdminResolveShortfallDtoBuilder
    implements
        Builder<AdminResolveShortfallDto, AdminResolveShortfallDtoBuilder> {
  _$AdminResolveShortfallDto? _$v;

  AdminResolveShortfallDtoResponsibleEnum? _responsible;
  AdminResolveShortfallDtoResponsibleEnum? get responsible =>
      _$this._responsible;
  set responsible(AdminResolveShortfallDtoResponsibleEnum? responsible) =>
      _$this._responsible = responsible;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AdminResolveShortfallDtoBuilder() {
    AdminResolveShortfallDto._defaults(this);
  }

  AdminResolveShortfallDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _responsible = $v.responsible;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminResolveShortfallDto other) {
    _$v = other as _$AdminResolveShortfallDto;
  }

  @override
  void update(void Function(AdminResolveShortfallDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminResolveShortfallDto build() => _build();

  _$AdminResolveShortfallDto _build() {
    final _$result =
        _$v ??
        _$AdminResolveShortfallDto._(
          responsible: BuiltValueNullFieldError.checkNotNull(
            responsible,
            r'AdminResolveShortfallDto',
            'responsible',
          ),
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'AdminResolveShortfallDto',
            'reason',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
