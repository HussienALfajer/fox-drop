// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_set_delivery_fee_dto_rule.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminSetDeliveryFeeDtoRuleKindEnum
_$adminSetDeliveryFeeDtoRuleKindEnum_flat =
    const AdminSetDeliveryFeeDtoRuleKindEnum._('flat');
const AdminSetDeliveryFeeDtoRuleKindEnum
_$adminSetDeliveryFeeDtoRuleKindEnum_distanceBands =
    const AdminSetDeliveryFeeDtoRuleKindEnum._('distanceBands');

AdminSetDeliveryFeeDtoRuleKindEnum _$adminSetDeliveryFeeDtoRuleKindEnumValueOf(
  String name,
) {
  switch (name) {
    case 'flat':
      return _$adminSetDeliveryFeeDtoRuleKindEnum_flat;
    case 'distanceBands':
      return _$adminSetDeliveryFeeDtoRuleKindEnum_distanceBands;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminSetDeliveryFeeDtoRuleKindEnum>
_$adminSetDeliveryFeeDtoRuleKindEnumValues =
    BuiltSet<AdminSetDeliveryFeeDtoRuleKindEnum>(
      const <AdminSetDeliveryFeeDtoRuleKindEnum>[
        _$adminSetDeliveryFeeDtoRuleKindEnum_flat,
        _$adminSetDeliveryFeeDtoRuleKindEnum_distanceBands,
      ],
    );

Serializer<AdminSetDeliveryFeeDtoRuleKindEnum>
_$adminSetDeliveryFeeDtoRuleKindEnumSerializer =
    _$AdminSetDeliveryFeeDtoRuleKindEnumSerializer();

class _$AdminSetDeliveryFeeDtoRuleKindEnumSerializer
    implements PrimitiveSerializer<AdminSetDeliveryFeeDtoRuleKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'flat': 'flat',
    'distanceBands': 'distance_bands',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'flat': 'flat',
    'distance_bands': 'distanceBands',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminSetDeliveryFeeDtoRuleKindEnum];
  @override
  final String wireName = 'AdminSetDeliveryFeeDtoRuleKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminSetDeliveryFeeDtoRuleKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminSetDeliveryFeeDtoRuleKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminSetDeliveryFeeDtoRuleKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminSetDeliveryFeeDtoRule extends AdminSetDeliveryFeeDtoRule {
  @override
  final AdminSetDeliveryFeeDtoRuleKindEnum kind;
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

  factory _$AdminSetDeliveryFeeDtoRule([
    void Function(AdminSetDeliveryFeeDtoRuleBuilder)? updates,
  ]) => (AdminSetDeliveryFeeDtoRuleBuilder()..update(updates))._build();

  _$AdminSetDeliveryFeeDtoRule._({
    required this.kind,
    this.flatFee,
    required this.currency,
    this.minimumFee,
    this.freeDeliveryFrom,
    this.bands,
  }) : super._();
  @override
  AdminSetDeliveryFeeDtoRule rebuild(
    void Function(AdminSetDeliveryFeeDtoRuleBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminSetDeliveryFeeDtoRuleBuilder toBuilder() =>
      AdminSetDeliveryFeeDtoRuleBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSetDeliveryFeeDtoRule &&
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
    return (newBuiltValueToStringHelper(r'AdminSetDeliveryFeeDtoRule')
          ..add('kind', kind)
          ..add('flatFee', flatFee)
          ..add('currency', currency)
          ..add('minimumFee', minimumFee)
          ..add('freeDeliveryFrom', freeDeliveryFrom)
          ..add('bands', bands))
        .toString();
  }
}

class AdminSetDeliveryFeeDtoRuleBuilder
    implements
        Builder<AdminSetDeliveryFeeDtoRule, AdminSetDeliveryFeeDtoRuleBuilder> {
  _$AdminSetDeliveryFeeDtoRule? _$v;

  AdminSetDeliveryFeeDtoRuleKindEnum? _kind;
  AdminSetDeliveryFeeDtoRuleKindEnum? get kind => _$this._kind;
  set kind(AdminSetDeliveryFeeDtoRuleKindEnum? kind) => _$this._kind = kind;

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

  AdminSetDeliveryFeeDtoRuleBuilder() {
    AdminSetDeliveryFeeDtoRule._defaults(this);
  }

  AdminSetDeliveryFeeDtoRuleBuilder get _$this {
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
  void replace(AdminSetDeliveryFeeDtoRule other) {
    _$v = other as _$AdminSetDeliveryFeeDtoRule;
  }

  @override
  void update(void Function(AdminSetDeliveryFeeDtoRuleBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminSetDeliveryFeeDtoRule build() => _build();

  _$AdminSetDeliveryFeeDtoRule _build() {
    _$AdminSetDeliveryFeeDtoRule _$result;
    try {
      _$result =
          _$v ??
          _$AdminSetDeliveryFeeDtoRule._(
            kind: BuiltValueNullFieldError.checkNotNull(
              kind,
              r'AdminSetDeliveryFeeDtoRule',
              'kind',
            ),
            flatFee: flatFee,
            currency: BuiltValueNullFieldError.checkNotNull(
              currency,
              r'AdminSetDeliveryFeeDtoRule',
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
          r'AdminSetDeliveryFeeDtoRule',
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
