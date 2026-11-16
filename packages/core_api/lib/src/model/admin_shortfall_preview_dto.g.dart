// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_shortfall_preview_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminShortfallPreviewDtoResponsibleEnum
_$adminShortfallPreviewDtoResponsibleEnum_captain =
    const AdminShortfallPreviewDtoResponsibleEnum._('captain');
const AdminShortfallPreviewDtoResponsibleEnum
_$adminShortfallPreviewDtoResponsibleEnum_customer =
    const AdminShortfallPreviewDtoResponsibleEnum._('customer');
const AdminShortfallPreviewDtoResponsibleEnum
_$adminShortfallPreviewDtoResponsibleEnum_platform =
    const AdminShortfallPreviewDtoResponsibleEnum._('platform');

AdminShortfallPreviewDtoResponsibleEnum
_$adminShortfallPreviewDtoResponsibleEnumValueOf(String name) {
  switch (name) {
    case 'captain':
      return _$adminShortfallPreviewDtoResponsibleEnum_captain;
    case 'customer':
      return _$adminShortfallPreviewDtoResponsibleEnum_customer;
    case 'platform':
      return _$adminShortfallPreviewDtoResponsibleEnum_platform;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminShortfallPreviewDtoResponsibleEnum>
_$adminShortfallPreviewDtoResponsibleEnumValues =
    BuiltSet<AdminShortfallPreviewDtoResponsibleEnum>(
      const <AdminShortfallPreviewDtoResponsibleEnum>[
        _$adminShortfallPreviewDtoResponsibleEnum_captain,
        _$adminShortfallPreviewDtoResponsibleEnum_customer,
        _$adminShortfallPreviewDtoResponsibleEnum_platform,
      ],
    );

Serializer<AdminShortfallPreviewDtoResponsibleEnum>
_$adminShortfallPreviewDtoResponsibleEnumSerializer =
    _$AdminShortfallPreviewDtoResponsibleEnumSerializer();

class _$AdminShortfallPreviewDtoResponsibleEnumSerializer
    implements PrimitiveSerializer<AdminShortfallPreviewDtoResponsibleEnum> {
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
    AdminShortfallPreviewDtoResponsibleEnum,
  ];
  @override
  final String wireName = 'AdminShortfallPreviewDtoResponsibleEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminShortfallPreviewDtoResponsibleEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminShortfallPreviewDtoResponsibleEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminShortfallPreviewDtoResponsibleEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminShortfallPreviewDto extends AdminShortfallPreviewDto {
  @override
  final AdminShortfallPreviewDtoResponsibleEnum responsible;

  factory _$AdminShortfallPreviewDto([
    void Function(AdminShortfallPreviewDtoBuilder)? updates,
  ]) => (AdminShortfallPreviewDtoBuilder()..update(updates))._build();

  _$AdminShortfallPreviewDto._({required this.responsible}) : super._();
  @override
  AdminShortfallPreviewDto rebuild(
    void Function(AdminShortfallPreviewDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminShortfallPreviewDtoBuilder toBuilder() =>
      AdminShortfallPreviewDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminShortfallPreviewDto &&
        responsible == other.responsible;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, responsible.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminShortfallPreviewDto',
    )..add('responsible', responsible)).toString();
  }
}

class AdminShortfallPreviewDtoBuilder
    implements
        Builder<AdminShortfallPreviewDto, AdminShortfallPreviewDtoBuilder> {
  _$AdminShortfallPreviewDto? _$v;

  AdminShortfallPreviewDtoResponsibleEnum? _responsible;
  AdminShortfallPreviewDtoResponsibleEnum? get responsible =>
      _$this._responsible;
  set responsible(AdminShortfallPreviewDtoResponsibleEnum? responsible) =>
      _$this._responsible = responsible;

  AdminShortfallPreviewDtoBuilder() {
    AdminShortfallPreviewDto._defaults(this);
  }

  AdminShortfallPreviewDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _responsible = $v.responsible;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminShortfallPreviewDto other) {
    _$v = other as _$AdminShortfallPreviewDto;
  }

  @override
  void update(void Function(AdminShortfallPreviewDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminShortfallPreviewDto build() => _build();

  _$AdminShortfallPreviewDto _build() {
    final _$result =
        _$v ??
        _$AdminShortfallPreviewDto._(
          responsible: BuiltValueNullFieldError.checkNotNull(
            responsible,
            r'AdminShortfallPreviewDto',
            'responsible',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
