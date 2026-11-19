// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_set_delivery_fee_dto_rule_one_of1.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminSetDeliveryFeeDtoRuleOneOf1KindEnum
_$adminSetDeliveryFeeDtoRuleOneOf1KindEnum_distanceBands =
    const AdminSetDeliveryFeeDtoRuleOneOf1KindEnum._('distanceBands');

AdminSetDeliveryFeeDtoRuleOneOf1KindEnum
_$adminSetDeliveryFeeDtoRuleOneOf1KindEnumValueOf(String name) {
  switch (name) {
    case 'distanceBands':
      return _$adminSetDeliveryFeeDtoRuleOneOf1KindEnum_distanceBands;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminSetDeliveryFeeDtoRuleOneOf1KindEnum>
_$adminSetDeliveryFeeDtoRuleOneOf1KindEnumValues =
    BuiltSet<AdminSetDeliveryFeeDtoRuleOneOf1KindEnum>(
      const <AdminSetDeliveryFeeDtoRuleOneOf1KindEnum>[
        _$adminSetDeliveryFeeDtoRuleOneOf1KindEnum_distanceBands,
      ],
    );

Serializer<AdminSetDeliveryFeeDtoRuleOneOf1KindEnum>
_$adminSetDeliveryFeeDtoRuleOneOf1KindEnumSerializer =
    _$AdminSetDeliveryFeeDtoRuleOneOf1KindEnumSerializer();

class _$AdminSetDeliveryFeeDtoRuleOneOf1KindEnumSerializer
    implements PrimitiveSerializer<AdminSetDeliveryFeeDtoRuleOneOf1KindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'distanceBands': 'distance_bands',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'distance_bands': 'distanceBands',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminSetDeliveryFeeDtoRuleOneOf1KindEnum,
  ];
  @override
  final String wireName = 'AdminSetDeliveryFeeDtoRuleOneOf1KindEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminSetDeliveryFeeDtoRuleOneOf1KindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminSetDeliveryFeeDtoRuleOneOf1KindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminSetDeliveryFeeDtoRuleOneOf1KindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminSetDeliveryFeeDtoRuleOneOf1
    extends AdminSetDeliveryFeeDtoRuleOneOf1 {
  @override
  final AdminSetDeliveryFeeDtoRuleOneOf1KindEnum kind;
  @override
  final BuiltList<AdminSetDeliveryFeeDtoRuleOneOf1BandsInner> bands;
  @override
  final String currency;
  @override
  final String? minimumFee;
  @override
  final String? freeDeliveryFrom;

  factory _$AdminSetDeliveryFeeDtoRuleOneOf1([
    void Function(AdminSetDeliveryFeeDtoRuleOneOf1Builder)? updates,
  ]) => (AdminSetDeliveryFeeDtoRuleOneOf1Builder()..update(updates))._build();

  _$AdminSetDeliveryFeeDtoRuleOneOf1._({
    required this.kind,
    required this.bands,
    required this.currency,
    this.minimumFee,
    this.freeDeliveryFrom,
  }) : super._();
  @override
  AdminSetDeliveryFeeDtoRuleOneOf1 rebuild(
    void Function(AdminSetDeliveryFeeDtoRuleOneOf1Builder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminSetDeliveryFeeDtoRuleOneOf1Builder toBuilder() =>
      AdminSetDeliveryFeeDtoRuleOneOf1Builder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSetDeliveryFeeDtoRuleOneOf1 &&
        kind == other.kind &&
        bands == other.bands &&
        currency == other.currency &&
        minimumFee == other.minimumFee &&
        freeDeliveryFrom == other.freeDeliveryFrom;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, bands.hashCode);
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, minimumFee.hashCode);
    _$hash = $jc(_$hash, freeDeliveryFrom.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminSetDeliveryFeeDtoRuleOneOf1')
          ..add('kind', kind)
          ..add('bands', bands)
          ..add('currency', currency)
          ..add('minimumFee', minimumFee)
          ..add('freeDeliveryFrom', freeDeliveryFrom))
        .toString();
  }
}

class AdminSetDeliveryFeeDtoRuleOneOf1Builder
    implements
        Builder<
          AdminSetDeliveryFeeDtoRuleOneOf1,
          AdminSetDeliveryFeeDtoRuleOneOf1Builder
        > {
  _$AdminSetDeliveryFeeDtoRuleOneOf1? _$v;

  AdminSetDeliveryFeeDtoRuleOneOf1KindEnum? _kind;
  AdminSetDeliveryFeeDtoRuleOneOf1KindEnum? get kind => _$this._kind;
  set kind(AdminSetDeliveryFeeDtoRuleOneOf1KindEnum? kind) =>
      _$this._kind = kind;

  ListBuilder<AdminSetDeliveryFeeDtoRuleOneOf1BandsInner>? _bands;
  ListBuilder<AdminSetDeliveryFeeDtoRuleOneOf1BandsInner> get bands =>
      _$this._bands ??=
          ListBuilder<AdminSetDeliveryFeeDtoRuleOneOf1BandsInner>();
  set bands(ListBuilder<AdminSetDeliveryFeeDtoRuleOneOf1BandsInner>? bands) =>
      _$this._bands = bands;

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

  AdminSetDeliveryFeeDtoRuleOneOf1Builder() {
    AdminSetDeliveryFeeDtoRuleOneOf1._defaults(this);
  }

  AdminSetDeliveryFeeDtoRuleOneOf1Builder get _$this {
    final $v = _$v;
    if ($v != null) {
      _kind = $v.kind;
      _bands = $v.bands.toBuilder();
      _currency = $v.currency;
      _minimumFee = $v.minimumFee;
      _freeDeliveryFrom = $v.freeDeliveryFrom;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSetDeliveryFeeDtoRuleOneOf1 other) {
    _$v = other as _$AdminSetDeliveryFeeDtoRuleOneOf1;
  }

  @override
  void update(void Function(AdminSetDeliveryFeeDtoRuleOneOf1Builder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminSetDeliveryFeeDtoRuleOneOf1 build() => _build();

  _$AdminSetDeliveryFeeDtoRuleOneOf1 _build() {
    _$AdminSetDeliveryFeeDtoRuleOneOf1 _$result;
    try {
      _$result =
          _$v ??
          _$AdminSetDeliveryFeeDtoRuleOneOf1._(
            kind: BuiltValueNullFieldError.checkNotNull(
              kind,
              r'AdminSetDeliveryFeeDtoRuleOneOf1',
              'kind',
            ),
            bands: bands.build(),
            currency: BuiltValueNullFieldError.checkNotNull(
              currency,
              r'AdminSetDeliveryFeeDtoRuleOneOf1',
              'currency',
            ),
            minimumFee: minimumFee,
            freeDeliveryFrom: freeDeliveryFrom,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'bands';
        bands.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminSetDeliveryFeeDtoRuleOneOf1',
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
