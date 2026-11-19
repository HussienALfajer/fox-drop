// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_set_restaurant_delivery_fee_dto_rule.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminSetRestaurantDeliveryFeeDtoRuleKindEnum
_$adminSetRestaurantDeliveryFeeDtoRuleKindEnum_flat =
    const AdminSetRestaurantDeliveryFeeDtoRuleKindEnum._('flat');
const AdminSetRestaurantDeliveryFeeDtoRuleKindEnum
_$adminSetRestaurantDeliveryFeeDtoRuleKindEnum_distanceBands =
    const AdminSetRestaurantDeliveryFeeDtoRuleKindEnum._('distanceBands');

AdminSetRestaurantDeliveryFeeDtoRuleKindEnum
_$adminSetRestaurantDeliveryFeeDtoRuleKindEnumValueOf(String name) {
  switch (name) {
    case 'flat':
      return _$adminSetRestaurantDeliveryFeeDtoRuleKindEnum_flat;
    case 'distanceBands':
      return _$adminSetRestaurantDeliveryFeeDtoRuleKindEnum_distanceBands;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminSetRestaurantDeliveryFeeDtoRuleKindEnum>
_$adminSetRestaurantDeliveryFeeDtoRuleKindEnumValues =
    BuiltSet<AdminSetRestaurantDeliveryFeeDtoRuleKindEnum>(
      const <AdminSetRestaurantDeliveryFeeDtoRuleKindEnum>[
        _$adminSetRestaurantDeliveryFeeDtoRuleKindEnum_flat,
        _$adminSetRestaurantDeliveryFeeDtoRuleKindEnum_distanceBands,
      ],
    );

Serializer<AdminSetRestaurantDeliveryFeeDtoRuleKindEnum>
_$adminSetRestaurantDeliveryFeeDtoRuleKindEnumSerializer =
    _$AdminSetRestaurantDeliveryFeeDtoRuleKindEnumSerializer();

class _$AdminSetRestaurantDeliveryFeeDtoRuleKindEnumSerializer
    implements
        PrimitiveSerializer<AdminSetRestaurantDeliveryFeeDtoRuleKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'flat': 'flat',
    'distanceBands': 'distance_bands',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'flat': 'flat',
    'distance_bands': 'distanceBands',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminSetRestaurantDeliveryFeeDtoRuleKindEnum,
  ];
  @override
  final String wireName = 'AdminSetRestaurantDeliveryFeeDtoRuleKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminSetRestaurantDeliveryFeeDtoRuleKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminSetRestaurantDeliveryFeeDtoRuleKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminSetRestaurantDeliveryFeeDtoRuleKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminSetRestaurantDeliveryFeeDtoRule
    extends AdminSetRestaurantDeliveryFeeDtoRule {
  @override
  final AdminSetRestaurantDeliveryFeeDtoRuleKindEnum kind;
  @override
  final String? flatFee;
  @override
  final String currency;
  @override
  final String? minimumFee;
  @override
  final String? freeDeliveryFrom;
  @override
  final BuiltList<AdminSetDeliveryFeeDtoRuleBandsInner>? bands;

  factory _$AdminSetRestaurantDeliveryFeeDtoRule([
    void Function(AdminSetRestaurantDeliveryFeeDtoRuleBuilder)? updates,
  ]) =>
      (AdminSetRestaurantDeliveryFeeDtoRuleBuilder()..update(updates))._build();

  _$AdminSetRestaurantDeliveryFeeDtoRule._({
    required this.kind,
    this.flatFee,
    required this.currency,
    this.minimumFee,
    this.freeDeliveryFrom,
    this.bands,
  }) : super._();
  @override
  AdminSetRestaurantDeliveryFeeDtoRule rebuild(
    void Function(AdminSetRestaurantDeliveryFeeDtoRuleBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminSetRestaurantDeliveryFeeDtoRuleBuilder toBuilder() =>
      AdminSetRestaurantDeliveryFeeDtoRuleBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSetRestaurantDeliveryFeeDtoRule &&
        kind == other.kind &&
        flatFee == other.flatFee &&
        currency == other.currency &&
        minimumFee == other.minimumFee &&
        freeDeliveryFrom == other.freeDeliveryFrom &&
        bands == other.bands;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, flatFee.hashCode);
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, minimumFee.hashCode);
    _$hash = $jc(_$hash, freeDeliveryFrom.hashCode);
    _$hash = $jc(_$hash, bands.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminSetRestaurantDeliveryFeeDtoRule')
          ..add('kind', kind)
          ..add('flatFee', flatFee)
          ..add('currency', currency)
          ..add('minimumFee', minimumFee)
          ..add('freeDeliveryFrom', freeDeliveryFrom)
          ..add('bands', bands))
        .toString();
  }
}

class AdminSetRestaurantDeliveryFeeDtoRuleBuilder
    implements
        Builder<
          AdminSetRestaurantDeliveryFeeDtoRule,
          AdminSetRestaurantDeliveryFeeDtoRuleBuilder
        > {
  _$AdminSetRestaurantDeliveryFeeDtoRule? _$v;

  AdminSetRestaurantDeliveryFeeDtoRuleKindEnum? _kind;
  AdminSetRestaurantDeliveryFeeDtoRuleKindEnum? get kind => _$this._kind;
  set kind(AdminSetRestaurantDeliveryFeeDtoRuleKindEnum? kind) =>
      _$this._kind = kind;

  String? _flatFee;
  String? get flatFee => _$this._flatFee;
  set flatFee(String? flatFee) => _$this._flatFee = flatFee;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  String? _minimumFee;
  String? get minimumFee => _$this._minimumFee;
  set minimumFee(String? minimumFee) => _$this._minimumFee = minimumFee;

  String? _freeDeliveryFrom;
  String? get freeDeliveryFrom => _$this._freeDeliveryFrom;
  set freeDeliveryFrom(String? freeDeliveryFrom) =>
      _$this._freeDeliveryFrom = freeDeliveryFrom;

  ListBuilder<AdminSetDeliveryFeeDtoRuleBandsInner>? _bands;
  ListBuilder<AdminSetDeliveryFeeDtoRuleBandsInner> get bands =>
      _$this._bands ??= ListBuilder<AdminSetDeliveryFeeDtoRuleBandsInner>();
  set bands(ListBuilder<AdminSetDeliveryFeeDtoRuleBandsInner>? bands) =>
      _$this._bands = bands;

  AdminSetRestaurantDeliveryFeeDtoRuleBuilder() {
    AdminSetRestaurantDeliveryFeeDtoRule._defaults(this);
  }

  AdminSetRestaurantDeliveryFeeDtoRuleBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _kind = $v.kind;
      _flatFee = $v.flatFee;
      _currency = $v.currency;
      _minimumFee = $v.minimumFee;
      _freeDeliveryFrom = $v.freeDeliveryFrom;
      _bands = $v.bands?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSetRestaurantDeliveryFeeDtoRule other) {
    _$v = other as _$AdminSetRestaurantDeliveryFeeDtoRule;
  }

  @override
  void update(
    void Function(AdminSetRestaurantDeliveryFeeDtoRuleBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminSetRestaurantDeliveryFeeDtoRule build() => _build();

  _$AdminSetRestaurantDeliveryFeeDtoRule _build() {
    _$AdminSetRestaurantDeliveryFeeDtoRule _$result;
    try {
      _$result =
          _$v ??
          _$AdminSetRestaurantDeliveryFeeDtoRule._(
            kind: BuiltValueNullFieldError.checkNotNull(
              kind,
              r'AdminSetRestaurantDeliveryFeeDtoRule',
              'kind',
            ),
            flatFee: flatFee,
            currency: BuiltValueNullFieldError.checkNotNull(
              currency,
              r'AdminSetRestaurantDeliveryFeeDtoRule',
              'currency',
            ),
            minimumFee: minimumFee,
            freeDeliveryFrom: freeDeliveryFrom,
            bands: _bands?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'bands';
        _bands?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminSetRestaurantDeliveryFeeDtoRule',
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
