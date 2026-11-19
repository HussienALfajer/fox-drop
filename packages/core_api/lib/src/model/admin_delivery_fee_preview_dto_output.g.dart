// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_delivery_fee_preview_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminDeliveryFeePreviewDtoOutputScopeEnum
_$adminDeliveryFeePreviewDtoOutputScopeEnum_city =
    const AdminDeliveryFeePreviewDtoOutputScopeEnum._('city');
const AdminDeliveryFeePreviewDtoOutputScopeEnum
_$adminDeliveryFeePreviewDtoOutputScopeEnum_restaurant =
    const AdminDeliveryFeePreviewDtoOutputScopeEnum._('restaurant');

AdminDeliveryFeePreviewDtoOutputScopeEnum
_$adminDeliveryFeePreviewDtoOutputScopeEnumValueOf(String name) {
  switch (name) {
    case 'city':
      return _$adminDeliveryFeePreviewDtoOutputScopeEnum_city;
    case 'restaurant':
      return _$adminDeliveryFeePreviewDtoOutputScopeEnum_restaurant;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminDeliveryFeePreviewDtoOutputScopeEnum>
_$adminDeliveryFeePreviewDtoOutputScopeEnumValues =
    BuiltSet<AdminDeliveryFeePreviewDtoOutputScopeEnum>(
      const <AdminDeliveryFeePreviewDtoOutputScopeEnum>[
        _$adminDeliveryFeePreviewDtoOutputScopeEnum_city,
        _$adminDeliveryFeePreviewDtoOutputScopeEnum_restaurant,
      ],
    );

Serializer<AdminDeliveryFeePreviewDtoOutputScopeEnum>
_$adminDeliveryFeePreviewDtoOutputScopeEnumSerializer =
    _$AdminDeliveryFeePreviewDtoOutputScopeEnumSerializer();

class _$AdminDeliveryFeePreviewDtoOutputScopeEnumSerializer
    implements PrimitiveSerializer<AdminDeliveryFeePreviewDtoOutputScopeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'city': 'city',
    'restaurant': 'restaurant',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'city': 'city',
    'restaurant': 'restaurant',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminDeliveryFeePreviewDtoOutputScopeEnum,
  ];
  @override
  final String wireName = 'AdminDeliveryFeePreviewDtoOutputScopeEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminDeliveryFeePreviewDtoOutputScopeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminDeliveryFeePreviewDtoOutputScopeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminDeliveryFeePreviewDtoOutputScopeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminDeliveryFeePreviewDtoOutput
    extends AdminDeliveryFeePreviewDtoOutput {
  @override
  final String fee;
  @override
  final String currency;
  @override
  final bool free;
  @override
  final AdminDeliveryFeePreviewDtoOutputScopeEnum scope;
  @override
  final String ruleId;
  @override
  final String? freeDeliveryFrom;
  @override
  final AdminDeliveryFeePreviewDtoOutputDistance distance;
  @override
  final bool covers;
  @override
  final String? zoneName;

  factory _$AdminDeliveryFeePreviewDtoOutput([
    void Function(AdminDeliveryFeePreviewDtoOutputBuilder)? updates,
  ]) => (AdminDeliveryFeePreviewDtoOutputBuilder()..update(updates))._build();

  _$AdminDeliveryFeePreviewDtoOutput._({
    required this.fee,
    required this.currency,
    required this.free,
    required this.scope,
    required this.ruleId,
    this.freeDeliveryFrom,
    required this.distance,
    required this.covers,
    this.zoneName,
  }) : super._();
  @override
  AdminDeliveryFeePreviewDtoOutput rebuild(
    void Function(AdminDeliveryFeePreviewDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDeliveryFeePreviewDtoOutputBuilder toBuilder() =>
      AdminDeliveryFeePreviewDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDeliveryFeePreviewDtoOutput &&
        fee == other.fee &&
        currency == other.currency &&
        free == other.free &&
        scope == other.scope &&
        ruleId == other.ruleId &&
        freeDeliveryFrom == other.freeDeliveryFrom &&
        distance == other.distance &&
        covers == other.covers &&
        zoneName == other.zoneName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, fee.hashCode);
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, free.hashCode);
    _$hash = $jc(_$hash, scope.hashCode);
    _$hash = $jc(_$hash, ruleId.hashCode);
    _$hash = $jc(_$hash, freeDeliveryFrom.hashCode);
    _$hash = $jc(_$hash, distance.hashCode);
    _$hash = $jc(_$hash, covers.hashCode);
    _$hash = $jc(_$hash, zoneName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminDeliveryFeePreviewDtoOutput')
          ..add('fee', fee)
          ..add('currency', currency)
          ..add('free', free)
          ..add('scope', scope)
          ..add('ruleId', ruleId)
          ..add('freeDeliveryFrom', freeDeliveryFrom)
          ..add('distance', distance)
          ..add('covers', covers)
          ..add('zoneName', zoneName))
        .toString();
  }
}

class AdminDeliveryFeePreviewDtoOutputBuilder
    implements
        Builder<
          AdminDeliveryFeePreviewDtoOutput,
          AdminDeliveryFeePreviewDtoOutputBuilder
        > {
  _$AdminDeliveryFeePreviewDtoOutput? _$v;

  String? _fee;
  String? get fee => _$this._fee;
  set fee(String? fee) => _$this._fee = fee;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  bool? _free;
  bool? get free => _$this._free;
  set free(bool? free) => _$this._free = free;

  AdminDeliveryFeePreviewDtoOutputScopeEnum? _scope;
  AdminDeliveryFeePreviewDtoOutputScopeEnum? get scope => _$this._scope;
  set scope(AdminDeliveryFeePreviewDtoOutputScopeEnum? scope) =>
      _$this._scope = scope;

  String? _ruleId;
  String? get ruleId => _$this._ruleId;
  set ruleId(String? ruleId) => _$this._ruleId = ruleId;

  String? _freeDeliveryFrom;
  String? get freeDeliveryFrom => _$this._freeDeliveryFrom;
  set freeDeliveryFrom(String? freeDeliveryFrom) =>
      _$this._freeDeliveryFrom = freeDeliveryFrom;

  AdminDeliveryFeePreviewDtoOutputDistanceBuilder? _distance;
  AdminDeliveryFeePreviewDtoOutputDistanceBuilder get distance =>
      _$this._distance ??= AdminDeliveryFeePreviewDtoOutputDistanceBuilder();
  set distance(AdminDeliveryFeePreviewDtoOutputDistanceBuilder? distance) =>
      _$this._distance = distance;

  bool? _covers;
  bool? get covers => _$this._covers;
  set covers(bool? covers) => _$this._covers = covers;

  String? _zoneName;
  String? get zoneName => _$this._zoneName;
  set zoneName(String? zoneName) => _$this._zoneName = zoneName;

  AdminDeliveryFeePreviewDtoOutputBuilder() {
    AdminDeliveryFeePreviewDtoOutput._defaults(this);
  }

  AdminDeliveryFeePreviewDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _fee = $v.fee;
      _currency = $v.currency;
      _free = $v.free;
      _scope = $v.scope;
      _ruleId = $v.ruleId;
      _freeDeliveryFrom = $v.freeDeliveryFrom;
      _distance = $v.distance.toBuilder();
      _covers = $v.covers;
      _zoneName = $v.zoneName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDeliveryFeePreviewDtoOutput other) {
    _$v = other as _$AdminDeliveryFeePreviewDtoOutput;
  }

  @override
  void update(void Function(AdminDeliveryFeePreviewDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDeliveryFeePreviewDtoOutput build() => _build();

  _$AdminDeliveryFeePreviewDtoOutput _build() {
    _$AdminDeliveryFeePreviewDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminDeliveryFeePreviewDtoOutput._(
            fee: BuiltValueNullFieldError.checkNotNull(
              fee,
              r'AdminDeliveryFeePreviewDtoOutput',
              'fee',
            ),
            currency: BuiltValueNullFieldError.checkNotNull(
              currency,
              r'AdminDeliveryFeePreviewDtoOutput',
              'currency',
            ),
            free: BuiltValueNullFieldError.checkNotNull(
              free,
              r'AdminDeliveryFeePreviewDtoOutput',
              'free',
            ),
            scope: BuiltValueNullFieldError.checkNotNull(
              scope,
              r'AdminDeliveryFeePreviewDtoOutput',
              'scope',
            ),
            ruleId: BuiltValueNullFieldError.checkNotNull(
              ruleId,
              r'AdminDeliveryFeePreviewDtoOutput',
              'ruleId',
            ),
            freeDeliveryFrom: freeDeliveryFrom,
            distance: distance.build(),
            covers: BuiltValueNullFieldError.checkNotNull(
              covers,
              r'AdminDeliveryFeePreviewDtoOutput',
              'covers',
            ),
            zoneName: zoneName,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'distance';
        distance.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminDeliveryFeePreviewDtoOutput',
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
