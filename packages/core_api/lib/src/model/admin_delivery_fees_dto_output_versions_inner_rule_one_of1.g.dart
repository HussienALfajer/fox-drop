// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_delivery_fees_dto_output_versions_inner_rule_one_of1.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1KindEnum
_$adminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1KindEnum_distanceBands =
    const AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1KindEnum._(
      'distanceBands',
    );

AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1KindEnum
_$adminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1KindEnumValueOf(
  String name,
) {
  switch (name) {
    case 'distanceBands':
      return _$adminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1KindEnum_distanceBands;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1KindEnum>
_$adminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1KindEnumValues =
    BuiltSet<AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1KindEnum>(const <
      AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1KindEnum
    >[
      _$adminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1KindEnum_distanceBands,
    ]);

Serializer<AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1KindEnum>
_$adminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1KindEnumSerializer =
    _$AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1KindEnumSerializer();

class _$AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1KindEnumSerializer
    implements
        PrimitiveSerializer<
          AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1KindEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'distanceBands': 'distance_bands',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'distance_bands': 'distanceBands',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1KindEnum,
  ];
  @override
  final String wireName =
      'AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1KindEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1KindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1KindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1KindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1
    extends AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1 {
  @override
  final String id;
  @override
  final AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1KindEnum kind;
  @override
  final BuiltList<AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1BandsInner>
  bands;
  @override
  final String currency;
  @override
  final String? minimumFee;
  @override
  final String? freeDeliveryFrom;

  factory _$AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1([
    void Function(AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1Builder)?
    updates,
  ]) =>
      (AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1Builder()
            ..update(updates))
          ._build();

  _$AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1._({
    required this.id,
    required this.kind,
    required this.bands,
    required this.currency,
    this.minimumFee,
    this.freeDeliveryFrom,
  }) : super._();
  @override
  AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1 rebuild(
    void Function(AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1Builder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1Builder toBuilder() =>
      AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1Builder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1 &&
        id == other.id &&
        kind == other.kind &&
        bands == other.bands &&
        currency == other.currency &&
        minimumFee == other.minimumFee &&
        freeDeliveryFrom == other.freeDeliveryFrom;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
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
    return (newBuiltValueToStringHelper(
            r'AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1',
          )
          ..add('id', id)
          ..add('kind', kind)
          ..add('bands', bands)
          ..add('currency', currency)
          ..add('minimumFee', minimumFee)
          ..add('freeDeliveryFrom', freeDeliveryFrom))
        .toString();
  }
}

class AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1Builder
    implements
        Builder<
          AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1,
          AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1Builder
        > {
  _$AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1KindEnum? _kind;
  AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1KindEnum? get kind =>
      _$this._kind;
  set kind(AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1KindEnum? kind) =>
      _$this._kind = kind;

  ListBuilder<AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1BandsInner>?
  _bands;
  ListBuilder<AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1BandsInner>
  get bands => _$this._bands ??=
      ListBuilder<
        AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1BandsInner
      >();
  set bands(
    ListBuilder<AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1BandsInner>?
    bands,
  ) => _$this._bands = bands;

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

  AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1Builder() {
    AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1._defaults(this);
  }

  AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1Builder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
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
  void replace(AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1 other) {
    _$v = other as _$AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1;
  }

  @override
  void update(
    void Function(AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1Builder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1 build() => _build();

  _$AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1 _build() {
    _$AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1 _$result;
    try {
      _$result =
          _$v ??
          _$AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1',
              'id',
            ),
            kind: BuiltValueNullFieldError.checkNotNull(
              kind,
              r'AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1',
              'kind',
            ),
            bands: bands.build(),
            currency: BuiltValueNullFieldError.checkNotNull(
              currency,
              r'AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1',
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
          r'AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1',
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
