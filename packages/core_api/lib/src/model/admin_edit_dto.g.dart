// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_edit_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminEditDtoResponsibleEnum _$adminEditDtoResponsibleEnum_restaurant =
    const AdminEditDtoResponsibleEnum._('restaurant');
const AdminEditDtoResponsibleEnum _$adminEditDtoResponsibleEnum_captain =
    const AdminEditDtoResponsibleEnum._('captain');
const AdminEditDtoResponsibleEnum _$adminEditDtoResponsibleEnum_platform =
    const AdminEditDtoResponsibleEnum._('platform');

AdminEditDtoResponsibleEnum _$adminEditDtoResponsibleEnumValueOf(String name) {
  switch (name) {
    case 'restaurant':
      return _$adminEditDtoResponsibleEnum_restaurant;
    case 'captain':
      return _$adminEditDtoResponsibleEnum_captain;
    case 'platform':
      return _$adminEditDtoResponsibleEnum_platform;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminEditDtoResponsibleEnum>
_$adminEditDtoResponsibleEnumValues =
    BuiltSet<AdminEditDtoResponsibleEnum>(const <AdminEditDtoResponsibleEnum>[
      _$adminEditDtoResponsibleEnum_restaurant,
      _$adminEditDtoResponsibleEnum_captain,
      _$adminEditDtoResponsibleEnum_platform,
    ]);

Serializer<AdminEditDtoResponsibleEnum>
_$adminEditDtoResponsibleEnumSerializer =
    _$AdminEditDtoResponsibleEnumSerializer();

class _$AdminEditDtoResponsibleEnumSerializer
    implements PrimitiveSerializer<AdminEditDtoResponsibleEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'restaurant': 'restaurant',
    'captain': 'captain',
    'platform': 'platform',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'restaurant': 'restaurant',
    'captain': 'captain',
    'platform': 'platform',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminEditDtoResponsibleEnum];
  @override
  final String wireName = 'AdminEditDtoResponsibleEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminEditDtoResponsibleEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminEditDtoResponsibleEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminEditDtoResponsibleEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminEditDto extends AdminEditDto {
  @override
  final BuiltList<AdminEditDtoKeepInner> keep;
  @override
  final BuiltList<AdminEditDtoAddInner> add;
  @override
  final String? deliveryFee;
  @override
  final int? extraPrepMin;
  @override
  final AdminEditDtoResponsibleEnum? responsible;
  @override
  final int version;
  @override
  final String reason;

  factory _$AdminEditDto([void Function(AdminEditDtoBuilder)? updates]) =>
      (AdminEditDtoBuilder()..update(updates))._build();

  _$AdminEditDto._({
    required this.keep,
    required this.add,
    this.deliveryFee,
    this.extraPrepMin,
    this.responsible,
    required this.version,
    required this.reason,
  }) : super._();
  @override
  AdminEditDto rebuild(void Function(AdminEditDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminEditDtoBuilder toBuilder() => AdminEditDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminEditDto &&
        keep == other.keep &&
        add == other.add &&
        deliveryFee == other.deliveryFee &&
        extraPrepMin == other.extraPrepMin &&
        responsible == other.responsible &&
        version == other.version &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, keep.hashCode);
    _$hash = $jc(_$hash, add.hashCode);
    _$hash = $jc(_$hash, deliveryFee.hashCode);
    _$hash = $jc(_$hash, extraPrepMin.hashCode);
    _$hash = $jc(_$hash, responsible.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminEditDto')
          ..add('keep', keep)
          ..add('add', add)
          ..add('deliveryFee', deliveryFee)
          ..add('extraPrepMin', extraPrepMin)
          ..add('responsible', responsible)
          ..add('version', version)
          ..add('reason', reason))
        .toString();
  }
}

class AdminEditDtoBuilder
    implements Builder<AdminEditDto, AdminEditDtoBuilder> {
  _$AdminEditDto? _$v;

  ListBuilder<AdminEditDtoKeepInner>? _keep;
  ListBuilder<AdminEditDtoKeepInner> get keep =>
      _$this._keep ??= ListBuilder<AdminEditDtoKeepInner>();
  set keep(ListBuilder<AdminEditDtoKeepInner>? keep) => _$this._keep = keep;

  ListBuilder<AdminEditDtoAddInner>? _add;
  ListBuilder<AdminEditDtoAddInner> get add =>
      _$this._add ??= ListBuilder<AdminEditDtoAddInner>();
  set add(ListBuilder<AdminEditDtoAddInner>? add) => _$this._add = add;

  String? _deliveryFee;
  String? get deliveryFee => _$this._deliveryFee;
  set deliveryFee(String? deliveryFee) => _$this._deliveryFee = deliveryFee;

  int? _extraPrepMin;
  int? get extraPrepMin => _$this._extraPrepMin;
  set extraPrepMin(int? extraPrepMin) => _$this._extraPrepMin = extraPrepMin;

  AdminEditDtoResponsibleEnum? _responsible;
  AdminEditDtoResponsibleEnum? get responsible => _$this._responsible;
  set responsible(AdminEditDtoResponsibleEnum? responsible) =>
      _$this._responsible = responsible;

  int? _version;
  int? get version => _$this._version;
  set version(int? version) => _$this._version = version;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AdminEditDtoBuilder() {
    AdminEditDto._defaults(this);
  }

  AdminEditDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _keep = $v.keep.toBuilder();
      _add = $v.add.toBuilder();
      _deliveryFee = $v.deliveryFee;
      _extraPrepMin = $v.extraPrepMin;
      _responsible = $v.responsible;
      _version = $v.version;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminEditDto other) {
    _$v = other as _$AdminEditDto;
  }

  @override
  void update(void Function(AdminEditDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminEditDto build() => _build();

  _$AdminEditDto _build() {
    _$AdminEditDto _$result;
    try {
      _$result =
          _$v ??
          _$AdminEditDto._(
            keep: keep.build(),
            add: add.build(),
            deliveryFee: deliveryFee,
            extraPrepMin: extraPrepMin,
            responsible: responsible,
            version: BuiltValueNullFieldError.checkNotNull(
              version,
              r'AdminEditDto',
              'version',
            ),
            reason: BuiltValueNullFieldError.checkNotNull(
              reason,
              r'AdminEditDto',
              'reason',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'keep';
        keep.build();
        _$failedField = 'add';
        add.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminEditDto',
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
