// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_delivery_fees_dto_output_versions_inner_rule.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminDeliveryFeesDtoOutputVersionsInnerRuleKindEnum
_$adminDeliveryFeesDtoOutputVersionsInnerRuleKindEnum_flat =
    const AdminDeliveryFeesDtoOutputVersionsInnerRuleKindEnum._('flat');
const AdminDeliveryFeesDtoOutputVersionsInnerRuleKindEnum
_$adminDeliveryFeesDtoOutputVersionsInnerRuleKindEnum_distanceBands =
    const AdminDeliveryFeesDtoOutputVersionsInnerRuleKindEnum._(
      'distanceBands',
    );

AdminDeliveryFeesDtoOutputVersionsInnerRuleKindEnum
_$adminDeliveryFeesDtoOutputVersionsInnerRuleKindEnumValueOf(String name) {
  switch (name) {
    case 'flat':
      return _$adminDeliveryFeesDtoOutputVersionsInnerRuleKindEnum_flat;
    case 'distanceBands':
      return _$adminDeliveryFeesDtoOutputVersionsInnerRuleKindEnum_distanceBands;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminDeliveryFeesDtoOutputVersionsInnerRuleKindEnum>
_$adminDeliveryFeesDtoOutputVersionsInnerRuleKindEnumValues =
    BuiltSet<AdminDeliveryFeesDtoOutputVersionsInnerRuleKindEnum>(
      const <AdminDeliveryFeesDtoOutputVersionsInnerRuleKindEnum>[
        _$adminDeliveryFeesDtoOutputVersionsInnerRuleKindEnum_flat,
        _$adminDeliveryFeesDtoOutputVersionsInnerRuleKindEnum_distanceBands,
      ],
    );

Serializer<AdminDeliveryFeesDtoOutputVersionsInnerRuleKindEnum>
_$adminDeliveryFeesDtoOutputVersionsInnerRuleKindEnumSerializer =
    _$AdminDeliveryFeesDtoOutputVersionsInnerRuleKindEnumSerializer();

class _$AdminDeliveryFeesDtoOutputVersionsInnerRuleKindEnumSerializer
    implements
        PrimitiveSerializer<
          AdminDeliveryFeesDtoOutputVersionsInnerRuleKindEnum
        > {
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
    AdminDeliveryFeesDtoOutputVersionsInnerRuleKindEnum,
  ];
  @override
  final String wireName = 'AdminDeliveryFeesDtoOutputVersionsInnerRuleKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminDeliveryFeesDtoOutputVersionsInnerRuleKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminDeliveryFeesDtoOutputVersionsInnerRuleKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminDeliveryFeesDtoOutputVersionsInnerRuleKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminDeliveryFeesDtoOutputVersionsInnerRule
    extends AdminDeliveryFeesDtoOutputVersionsInnerRule {
  @override
  final String id;
  @override
  final AdminDeliveryFeesDtoOutputVersionsInnerRuleKindEnum kind;
  @override
  final String? flatFee;
  @override
  final String currency;
  @override
  final String? minimumFee;
  @override
  final String? freeDeliveryFrom;
  @override
  final BuiltList<AdminDeliveryFeesDtoOutputVersionsInnerRuleBandsInner>? bands;

  factory _$AdminDeliveryFeesDtoOutputVersionsInnerRule([
    void Function(AdminDeliveryFeesDtoOutputVersionsInnerRuleBuilder)? updates,
  ]) => (AdminDeliveryFeesDtoOutputVersionsInnerRuleBuilder()..update(updates))
      ._build();

  _$AdminDeliveryFeesDtoOutputVersionsInnerRule._({
    required this.id,
    required this.kind,
    this.flatFee,
    required this.currency,
    this.minimumFee,
    this.freeDeliveryFrom,
    this.bands,
  }) : super._();
  @override
  AdminDeliveryFeesDtoOutputVersionsInnerRule rebuild(
    void Function(AdminDeliveryFeesDtoOutputVersionsInnerRuleBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDeliveryFeesDtoOutputVersionsInnerRuleBuilder toBuilder() =>
      AdminDeliveryFeesDtoOutputVersionsInnerRuleBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDeliveryFeesDtoOutputVersionsInnerRule &&
        id == other.id &&
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
    _$hash = $jc(_$hash, id.hashCode);
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
    return (newBuiltValueToStringHelper(
            r'AdminDeliveryFeesDtoOutputVersionsInnerRule',
          )
          ..add('id', id)
          ..add('kind', kind)
          ..add('flatFee', flatFee)
          ..add('currency', currency)
          ..add('minimumFee', minimumFee)
          ..add('freeDeliveryFrom', freeDeliveryFrom)
          ..add('bands', bands))
        .toString();
  }
}

class AdminDeliveryFeesDtoOutputVersionsInnerRuleBuilder
    implements
        Builder<
          AdminDeliveryFeesDtoOutputVersionsInnerRule,
          AdminDeliveryFeesDtoOutputVersionsInnerRuleBuilder
        > {
  _$AdminDeliveryFeesDtoOutputVersionsInnerRule? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  AdminDeliveryFeesDtoOutputVersionsInnerRuleKindEnum? _kind;
  AdminDeliveryFeesDtoOutputVersionsInnerRuleKindEnum? get kind => _$this._kind;
  set kind(AdminDeliveryFeesDtoOutputVersionsInnerRuleKindEnum? kind) =>
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

  ListBuilder<AdminDeliveryFeesDtoOutputVersionsInnerRuleBandsInner>? _bands;
  ListBuilder<AdminDeliveryFeesDtoOutputVersionsInnerRuleBandsInner>
  get bands => _$this._bands ??=
      ListBuilder<AdminDeliveryFeesDtoOutputVersionsInnerRuleBandsInner>();
  set bands(
    ListBuilder<AdminDeliveryFeesDtoOutputVersionsInnerRuleBandsInner>? bands,
  ) => _$this._bands = bands;

  AdminDeliveryFeesDtoOutputVersionsInnerRuleBuilder() {
    AdminDeliveryFeesDtoOutputVersionsInnerRule._defaults(this);
  }

  AdminDeliveryFeesDtoOutputVersionsInnerRuleBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
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
  void replace(AdminDeliveryFeesDtoOutputVersionsInnerRule other) {
    _$v = other as _$AdminDeliveryFeesDtoOutputVersionsInnerRule;
  }

  @override
  void update(
    void Function(AdminDeliveryFeesDtoOutputVersionsInnerRuleBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminDeliveryFeesDtoOutputVersionsInnerRule build() => _build();

  _$AdminDeliveryFeesDtoOutputVersionsInnerRule _build() {
    _$AdminDeliveryFeesDtoOutputVersionsInnerRule _$result;
    try {
      _$result =
          _$v ??
          _$AdminDeliveryFeesDtoOutputVersionsInnerRule._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AdminDeliveryFeesDtoOutputVersionsInnerRule',
              'id',
            ),
            kind: BuiltValueNullFieldError.checkNotNull(
              kind,
              r'AdminDeliveryFeesDtoOutputVersionsInnerRule',
              'kind',
            ),
            flatFee: flatFee,
            currency: BuiltValueNullFieldError.checkNotNull(
              currency,
              r'AdminDeliveryFeesDtoOutputVersionsInnerRule',
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
          r'AdminDeliveryFeesDtoOutputVersionsInnerRule',
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
