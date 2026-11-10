// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_order_dto_output_order_outcome_to_collect.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CaptainOrderDtoOutputOrderOutcomeToCollectOutcomeEnum
_$captainOrderDtoOutputOrderOutcomeToCollectOutcomeEnum_free =
    const CaptainOrderDtoOutputOrderOutcomeToCollectOutcomeEnum._('free');
const CaptainOrderDtoOutputOrderOutcomeToCollectOutcomeEnum
_$captainOrderDtoOutputOrderOutcomeToCollectOutcomeEnum_damaged =
    const CaptainOrderDtoOutputOrderOutcomeToCollectOutcomeEnum._('damaged');

CaptainOrderDtoOutputOrderOutcomeToCollectOutcomeEnum
_$captainOrderDtoOutputOrderOutcomeToCollectOutcomeEnumValueOf(String name) {
  switch (name) {
    case 'free':
      return _$captainOrderDtoOutputOrderOutcomeToCollectOutcomeEnum_free;
    case 'damaged':
      return _$captainOrderDtoOutputOrderOutcomeToCollectOutcomeEnum_damaged;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CaptainOrderDtoOutputOrderOutcomeToCollectOutcomeEnum>
_$captainOrderDtoOutputOrderOutcomeToCollectOutcomeEnumValues =
    BuiltSet<CaptainOrderDtoOutputOrderOutcomeToCollectOutcomeEnum>(
      const <CaptainOrderDtoOutputOrderOutcomeToCollectOutcomeEnum>[
        _$captainOrderDtoOutputOrderOutcomeToCollectOutcomeEnum_free,
        _$captainOrderDtoOutputOrderOutcomeToCollectOutcomeEnum_damaged,
      ],
    );

Serializer<CaptainOrderDtoOutputOrderOutcomeToCollectOutcomeEnum>
_$captainOrderDtoOutputOrderOutcomeToCollectOutcomeEnumSerializer =
    _$CaptainOrderDtoOutputOrderOutcomeToCollectOutcomeEnumSerializer();

class _$CaptainOrderDtoOutputOrderOutcomeToCollectOutcomeEnumSerializer
    implements
        PrimitiveSerializer<
          CaptainOrderDtoOutputOrderOutcomeToCollectOutcomeEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'free': 'free',
    'damaged': 'damaged',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'free': 'free',
    'damaged': 'damaged',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CaptainOrderDtoOutputOrderOutcomeToCollectOutcomeEnum,
  ];
  @override
  final String wireName =
      'CaptainOrderDtoOutputOrderOutcomeToCollectOutcomeEnum';

  @override
  Object serialize(
    Serializers serializers,
    CaptainOrderDtoOutputOrderOutcomeToCollectOutcomeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CaptainOrderDtoOutputOrderOutcomeToCollectOutcomeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CaptainOrderDtoOutputOrderOutcomeToCollectOutcomeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CaptainOrderDtoOutputOrderOutcomeToCollect
    extends CaptainOrderDtoOutputOrderOutcomeToCollect {
  @override
  final CaptainOrderDtoOutputOrderOutcomeToCollectOutcomeEnum outcome;
  @override
  final CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmount amount;
  @override
  final BuiltList<CaptainAvailabilityDtoOutputCustodyLimit> equivalents;

  factory _$CaptainOrderDtoOutputOrderOutcomeToCollect([
    void Function(CaptainOrderDtoOutputOrderOutcomeToCollectBuilder)? updates,
  ]) => (CaptainOrderDtoOutputOrderOutcomeToCollectBuilder()..update(updates))
      ._build();

  _$CaptainOrderDtoOutputOrderOutcomeToCollect._({
    required this.outcome,
    required this.amount,
    required this.equivalents,
  }) : super._();
  @override
  CaptainOrderDtoOutputOrderOutcomeToCollect rebuild(
    void Function(CaptainOrderDtoOutputOrderOutcomeToCollectBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainOrderDtoOutputOrderOutcomeToCollectBuilder toBuilder() =>
      CaptainOrderDtoOutputOrderOutcomeToCollectBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainOrderDtoOutputOrderOutcomeToCollect &&
        outcome == other.outcome &&
        amount == other.amount &&
        equivalents == other.equivalents;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, outcome.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, equivalents.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CaptainOrderDtoOutputOrderOutcomeToCollect',
          )
          ..add('outcome', outcome)
          ..add('amount', amount)
          ..add('equivalents', equivalents))
        .toString();
  }
}

class CaptainOrderDtoOutputOrderOutcomeToCollectBuilder
    implements
        Builder<
          CaptainOrderDtoOutputOrderOutcomeToCollect,
          CaptainOrderDtoOutputOrderOutcomeToCollectBuilder
        > {
  _$CaptainOrderDtoOutputOrderOutcomeToCollect? _$v;

  CaptainOrderDtoOutputOrderOutcomeToCollectOutcomeEnum? _outcome;
  CaptainOrderDtoOutputOrderOutcomeToCollectOutcomeEnum? get outcome =>
      _$this._outcome;
  set outcome(CaptainOrderDtoOutputOrderOutcomeToCollectOutcomeEnum? outcome) =>
      _$this._outcome = outcome;

  CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmountBuilder? _amount;
  CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmountBuilder get amount =>
      _$this._amount ??=
          CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmountBuilder();
  set amount(
    CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmountBuilder? amount,
  ) => _$this._amount = amount;

  ListBuilder<CaptainAvailabilityDtoOutputCustodyLimit>? _equivalents;
  ListBuilder<CaptainAvailabilityDtoOutputCustodyLimit> get equivalents =>
      _$this._equivalents ??=
          ListBuilder<CaptainAvailabilityDtoOutputCustodyLimit>();
  set equivalents(
    ListBuilder<CaptainAvailabilityDtoOutputCustodyLimit>? equivalents,
  ) => _$this._equivalents = equivalents;

  CaptainOrderDtoOutputOrderOutcomeToCollectBuilder() {
    CaptainOrderDtoOutputOrderOutcomeToCollect._defaults(this);
  }

  CaptainOrderDtoOutputOrderOutcomeToCollectBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _outcome = $v.outcome;
      _amount = $v.amount.toBuilder();
      _equivalents = $v.equivalents.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainOrderDtoOutputOrderOutcomeToCollect other) {
    _$v = other as _$CaptainOrderDtoOutputOrderOutcomeToCollect;
  }

  @override
  void update(
    void Function(CaptainOrderDtoOutputOrderOutcomeToCollectBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainOrderDtoOutputOrderOutcomeToCollect build() => _build();

  _$CaptainOrderDtoOutputOrderOutcomeToCollect _build() {
    _$CaptainOrderDtoOutputOrderOutcomeToCollect _$result;
    try {
      _$result =
          _$v ??
          _$CaptainOrderDtoOutputOrderOutcomeToCollect._(
            outcome: BuiltValueNullFieldError.checkNotNull(
              outcome,
              r'CaptainOrderDtoOutputOrderOutcomeToCollect',
              'outcome',
            ),
            amount: amount.build(),
            equivalents: equivalents.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'amount';
        amount.build();
        _$failedField = 'equivalents';
        equivalents.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainOrderDtoOutputOrderOutcomeToCollect',
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
