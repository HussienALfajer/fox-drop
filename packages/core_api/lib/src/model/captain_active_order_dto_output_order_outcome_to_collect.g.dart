// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_active_order_dto_output_order_outcome_to_collect.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CaptainActiveOrderDtoOutputOrderOutcomeToCollectOutcomeEnum
_$captainActiveOrderDtoOutputOrderOutcomeToCollectOutcomeEnum_free =
    const CaptainActiveOrderDtoOutputOrderOutcomeToCollectOutcomeEnum._('free');
const CaptainActiveOrderDtoOutputOrderOutcomeToCollectOutcomeEnum
_$captainActiveOrderDtoOutputOrderOutcomeToCollectOutcomeEnum_damaged =
    const CaptainActiveOrderDtoOutputOrderOutcomeToCollectOutcomeEnum._(
      'damaged',
    );

CaptainActiveOrderDtoOutputOrderOutcomeToCollectOutcomeEnum
_$captainActiveOrderDtoOutputOrderOutcomeToCollectOutcomeEnumValueOf(
  String name,
) {
  switch (name) {
    case 'free':
      return _$captainActiveOrderDtoOutputOrderOutcomeToCollectOutcomeEnum_free;
    case 'damaged':
      return _$captainActiveOrderDtoOutputOrderOutcomeToCollectOutcomeEnum_damaged;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CaptainActiveOrderDtoOutputOrderOutcomeToCollectOutcomeEnum>
_$captainActiveOrderDtoOutputOrderOutcomeToCollectOutcomeEnumValues =
    BuiltSet<CaptainActiveOrderDtoOutputOrderOutcomeToCollectOutcomeEnum>(
      const <CaptainActiveOrderDtoOutputOrderOutcomeToCollectOutcomeEnum>[
        _$captainActiveOrderDtoOutputOrderOutcomeToCollectOutcomeEnum_free,
        _$captainActiveOrderDtoOutputOrderOutcomeToCollectOutcomeEnum_damaged,
      ],
    );

Serializer<CaptainActiveOrderDtoOutputOrderOutcomeToCollectOutcomeEnum>
_$captainActiveOrderDtoOutputOrderOutcomeToCollectOutcomeEnumSerializer =
    _$CaptainActiveOrderDtoOutputOrderOutcomeToCollectOutcomeEnumSerializer();

class _$CaptainActiveOrderDtoOutputOrderOutcomeToCollectOutcomeEnumSerializer
    implements
        PrimitiveSerializer<
          CaptainActiveOrderDtoOutputOrderOutcomeToCollectOutcomeEnum
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
    CaptainActiveOrderDtoOutputOrderOutcomeToCollectOutcomeEnum,
  ];
  @override
  final String wireName =
      'CaptainActiveOrderDtoOutputOrderOutcomeToCollectOutcomeEnum';

  @override
  Object serialize(
    Serializers serializers,
    CaptainActiveOrderDtoOutputOrderOutcomeToCollectOutcomeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CaptainActiveOrderDtoOutputOrderOutcomeToCollectOutcomeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CaptainActiveOrderDtoOutputOrderOutcomeToCollectOutcomeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CaptainActiveOrderDtoOutputOrderOutcomeToCollect
    extends CaptainActiveOrderDtoOutputOrderOutcomeToCollect {
  @override
  final CaptainActiveOrderDtoOutputOrderOutcomeToCollectOutcomeEnum outcome;
  @override
  final CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmount amount;
  @override
  final BuiltList<CaptainWentOfflineDtoOutputHandIn?> equivalents;

  factory _$CaptainActiveOrderDtoOutputOrderOutcomeToCollect([
    void Function(CaptainActiveOrderDtoOutputOrderOutcomeToCollectBuilder)?
    updates,
  ]) =>
      (CaptainActiveOrderDtoOutputOrderOutcomeToCollectBuilder()
            ..update(updates))
          ._build();

  _$CaptainActiveOrderDtoOutputOrderOutcomeToCollect._({
    required this.outcome,
    required this.amount,
    required this.equivalents,
  }) : super._();
  @override
  CaptainActiveOrderDtoOutputOrderOutcomeToCollect rebuild(
    void Function(CaptainActiveOrderDtoOutputOrderOutcomeToCollectBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainActiveOrderDtoOutputOrderOutcomeToCollectBuilder toBuilder() =>
      CaptainActiveOrderDtoOutputOrderOutcomeToCollectBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainActiveOrderDtoOutputOrderOutcomeToCollect &&
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
            r'CaptainActiveOrderDtoOutputOrderOutcomeToCollect',
          )
          ..add('outcome', outcome)
          ..add('amount', amount)
          ..add('equivalents', equivalents))
        .toString();
  }
}

class CaptainActiveOrderDtoOutputOrderOutcomeToCollectBuilder
    implements
        Builder<
          CaptainActiveOrderDtoOutputOrderOutcomeToCollect,
          CaptainActiveOrderDtoOutputOrderOutcomeToCollectBuilder
        > {
  _$CaptainActiveOrderDtoOutputOrderOutcomeToCollect? _$v;

  CaptainActiveOrderDtoOutputOrderOutcomeToCollectOutcomeEnum? _outcome;
  CaptainActiveOrderDtoOutputOrderOutcomeToCollectOutcomeEnum? get outcome =>
      _$this._outcome;
  set outcome(
    CaptainActiveOrderDtoOutputOrderOutcomeToCollectOutcomeEnum? outcome,
  ) => _$this._outcome = outcome;

  CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmountBuilder? _amount;
  CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmountBuilder get amount =>
      _$this._amount ??=
          CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmountBuilder();
  set amount(
    CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmountBuilder? amount,
  ) => _$this._amount = amount;

  ListBuilder<CaptainWentOfflineDtoOutputHandIn?>? _equivalents;
  ListBuilder<CaptainWentOfflineDtoOutputHandIn?> get equivalents =>
      _$this._equivalents ??= ListBuilder<CaptainWentOfflineDtoOutputHandIn?>();
  set equivalents(
    ListBuilder<CaptainWentOfflineDtoOutputHandIn?>? equivalents,
  ) => _$this._equivalents = equivalents;

  CaptainActiveOrderDtoOutputOrderOutcomeToCollectBuilder() {
    CaptainActiveOrderDtoOutputOrderOutcomeToCollect._defaults(this);
  }

  CaptainActiveOrderDtoOutputOrderOutcomeToCollectBuilder get _$this {
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
  void replace(CaptainActiveOrderDtoOutputOrderOutcomeToCollect other) {
    _$v = other as _$CaptainActiveOrderDtoOutputOrderOutcomeToCollect;
  }

  @override
  void update(
    void Function(CaptainActiveOrderDtoOutputOrderOutcomeToCollectBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainActiveOrderDtoOutputOrderOutcomeToCollect build() => _build();

  _$CaptainActiveOrderDtoOutputOrderOutcomeToCollect _build() {
    _$CaptainActiveOrderDtoOutputOrderOutcomeToCollect _$result;
    try {
      _$result =
          _$v ??
          _$CaptainActiveOrderDtoOutputOrderOutcomeToCollect._(
            outcome: BuiltValueNullFieldError.checkNotNull(
              outcome,
              r'CaptainActiveOrderDtoOutputOrderOutcomeToCollect',
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
          r'CaptainActiveOrderDtoOutputOrderOutcomeToCollect',
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
