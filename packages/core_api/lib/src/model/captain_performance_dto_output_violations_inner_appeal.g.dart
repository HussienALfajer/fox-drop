// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_performance_dto_output_violations_inner_appeal.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CaptainPerformanceDtoOutputViolationsInnerAppealOutcomeEnum
_$captainPerformanceDtoOutputViolationsInnerAppealOutcomeEnum_accepted =
    const CaptainPerformanceDtoOutputViolationsInnerAppealOutcomeEnum._(
      'accepted',
    );
const CaptainPerformanceDtoOutputViolationsInnerAppealOutcomeEnum
_$captainPerformanceDtoOutputViolationsInnerAppealOutcomeEnum_rejected =
    const CaptainPerformanceDtoOutputViolationsInnerAppealOutcomeEnum._(
      'rejected',
    );

CaptainPerformanceDtoOutputViolationsInnerAppealOutcomeEnum
_$captainPerformanceDtoOutputViolationsInnerAppealOutcomeEnumValueOf(
  String name,
) {
  switch (name) {
    case 'accepted':
      return _$captainPerformanceDtoOutputViolationsInnerAppealOutcomeEnum_accepted;
    case 'rejected':
      return _$captainPerformanceDtoOutputViolationsInnerAppealOutcomeEnum_rejected;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CaptainPerformanceDtoOutputViolationsInnerAppealOutcomeEnum>
_$captainPerformanceDtoOutputViolationsInnerAppealOutcomeEnumValues =
    BuiltSet<CaptainPerformanceDtoOutputViolationsInnerAppealOutcomeEnum>(
      const <CaptainPerformanceDtoOutputViolationsInnerAppealOutcomeEnum>[
        _$captainPerformanceDtoOutputViolationsInnerAppealOutcomeEnum_accepted,
        _$captainPerformanceDtoOutputViolationsInnerAppealOutcomeEnum_rejected,
      ],
    );

Serializer<CaptainPerformanceDtoOutputViolationsInnerAppealOutcomeEnum>
_$captainPerformanceDtoOutputViolationsInnerAppealOutcomeEnumSerializer =
    _$CaptainPerformanceDtoOutputViolationsInnerAppealOutcomeEnumSerializer();

class _$CaptainPerformanceDtoOutputViolationsInnerAppealOutcomeEnumSerializer
    implements
        PrimitiveSerializer<
          CaptainPerformanceDtoOutputViolationsInnerAppealOutcomeEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'accepted': 'accepted',
    'rejected': 'rejected',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'accepted': 'accepted',
    'rejected': 'rejected',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CaptainPerformanceDtoOutputViolationsInnerAppealOutcomeEnum,
  ];
  @override
  final String wireName =
      'CaptainPerformanceDtoOutputViolationsInnerAppealOutcomeEnum';

  @override
  Object serialize(
    Serializers serializers,
    CaptainPerformanceDtoOutputViolationsInnerAppealOutcomeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CaptainPerformanceDtoOutputViolationsInnerAppealOutcomeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CaptainPerformanceDtoOutputViolationsInnerAppealOutcomeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CaptainPerformanceDtoOutputViolationsInnerAppeal
    extends CaptainPerformanceDtoOutputViolationsInnerAppeal {
  @override
  final String ticketId;
  @override
  final CaptainPerformanceDtoOutputViolationsInnerAppealOutcomeEnum? outcome;

  factory _$CaptainPerformanceDtoOutputViolationsInnerAppeal([
    void Function(CaptainPerformanceDtoOutputViolationsInnerAppealBuilder)?
    updates,
  ]) =>
      (CaptainPerformanceDtoOutputViolationsInnerAppealBuilder()
            ..update(updates))
          ._build();

  _$CaptainPerformanceDtoOutputViolationsInnerAppeal._({
    required this.ticketId,
    this.outcome,
  }) : super._();
  @override
  CaptainPerformanceDtoOutputViolationsInnerAppeal rebuild(
    void Function(CaptainPerformanceDtoOutputViolationsInnerAppealBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainPerformanceDtoOutputViolationsInnerAppealBuilder toBuilder() =>
      CaptainPerformanceDtoOutputViolationsInnerAppealBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainPerformanceDtoOutputViolationsInnerAppeal &&
        ticketId == other.ticketId &&
        outcome == other.outcome;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ticketId.hashCode);
    _$hash = $jc(_$hash, outcome.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CaptainPerformanceDtoOutputViolationsInnerAppeal',
          )
          ..add('ticketId', ticketId)
          ..add('outcome', outcome))
        .toString();
  }
}

class CaptainPerformanceDtoOutputViolationsInnerAppealBuilder
    implements
        Builder<
          CaptainPerformanceDtoOutputViolationsInnerAppeal,
          CaptainPerformanceDtoOutputViolationsInnerAppealBuilder
        > {
  _$CaptainPerformanceDtoOutputViolationsInnerAppeal? _$v;

  String? _ticketId;
  String? get ticketId => _$this._ticketId;
  set ticketId(String? ticketId) => _$this._ticketId = ticketId;

  CaptainPerformanceDtoOutputViolationsInnerAppealOutcomeEnum? _outcome;
  CaptainPerformanceDtoOutputViolationsInnerAppealOutcomeEnum? get outcome =>
      _$this._outcome;
  set outcome(
    CaptainPerformanceDtoOutputViolationsInnerAppealOutcomeEnum? outcome,
  ) => _$this._outcome = outcome;

  CaptainPerformanceDtoOutputViolationsInnerAppealBuilder() {
    CaptainPerformanceDtoOutputViolationsInnerAppeal._defaults(this);
  }

  CaptainPerformanceDtoOutputViolationsInnerAppealBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ticketId = $v.ticketId;
      _outcome = $v.outcome;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainPerformanceDtoOutputViolationsInnerAppeal other) {
    _$v = other as _$CaptainPerformanceDtoOutputViolationsInnerAppeal;
  }

  @override
  void update(
    void Function(CaptainPerformanceDtoOutputViolationsInnerAppealBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainPerformanceDtoOutputViolationsInnerAppeal build() => _build();

  _$CaptainPerformanceDtoOutputViolationsInnerAppeal _build() {
    final _$result =
        _$v ??
        _$CaptainPerformanceDtoOutputViolationsInnerAppeal._(
          ticketId: BuiltValueNullFieldError.checkNotNull(
            ticketId,
            r'CaptainPerformanceDtoOutputViolationsInnerAppeal',
            'ticketId',
          ),
          outcome: outcome,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
