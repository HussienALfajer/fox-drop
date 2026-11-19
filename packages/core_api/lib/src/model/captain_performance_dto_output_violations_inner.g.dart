// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_performance_dto_output_violations_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CaptainPerformanceDtoOutputViolationsInnerStepEnum
_$captainPerformanceDtoOutputViolationsInnerStepEnum_warning =
    const CaptainPerformanceDtoOutputViolationsInnerStepEnum._('warning');
const CaptainPerformanceDtoOutputViolationsInnerStepEnum
_$captainPerformanceDtoOutputViolationsInnerStepEnum_suspension1d =
    const CaptainPerformanceDtoOutputViolationsInnerStepEnum._('suspension1d');
const CaptainPerformanceDtoOutputViolationsInnerStepEnum
_$captainPerformanceDtoOutputViolationsInnerStepEnum_suspension7d =
    const CaptainPerformanceDtoOutputViolationsInnerStepEnum._('suspension7d');
const CaptainPerformanceDtoOutputViolationsInnerStepEnum
_$captainPerformanceDtoOutputViolationsInnerStepEnum_termination =
    const CaptainPerformanceDtoOutputViolationsInnerStepEnum._('termination');

CaptainPerformanceDtoOutputViolationsInnerStepEnum
_$captainPerformanceDtoOutputViolationsInnerStepEnumValueOf(String name) {
  switch (name) {
    case 'warning':
      return _$captainPerformanceDtoOutputViolationsInnerStepEnum_warning;
    case 'suspension1d':
      return _$captainPerformanceDtoOutputViolationsInnerStepEnum_suspension1d;
    case 'suspension7d':
      return _$captainPerformanceDtoOutputViolationsInnerStepEnum_suspension7d;
    case 'termination':
      return _$captainPerformanceDtoOutputViolationsInnerStepEnum_termination;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CaptainPerformanceDtoOutputViolationsInnerStepEnum>
_$captainPerformanceDtoOutputViolationsInnerStepEnumValues =
    BuiltSet<CaptainPerformanceDtoOutputViolationsInnerStepEnum>(
      const <CaptainPerformanceDtoOutputViolationsInnerStepEnum>[
        _$captainPerformanceDtoOutputViolationsInnerStepEnum_warning,
        _$captainPerformanceDtoOutputViolationsInnerStepEnum_suspension1d,
        _$captainPerformanceDtoOutputViolationsInnerStepEnum_suspension7d,
        _$captainPerformanceDtoOutputViolationsInnerStepEnum_termination,
      ],
    );

Serializer<CaptainPerformanceDtoOutputViolationsInnerStepEnum>
_$captainPerformanceDtoOutputViolationsInnerStepEnumSerializer =
    _$CaptainPerformanceDtoOutputViolationsInnerStepEnumSerializer();

class _$CaptainPerformanceDtoOutputViolationsInnerStepEnumSerializer
    implements
        PrimitiveSerializer<
          CaptainPerformanceDtoOutputViolationsInnerStepEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'warning': 'warning',
    'suspension1d': 'suspension_1d',
    'suspension7d': 'suspension_7d',
    'termination': 'termination',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'warning': 'warning',
    'suspension_1d': 'suspension1d',
    'suspension_7d': 'suspension7d',
    'termination': 'termination',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CaptainPerformanceDtoOutputViolationsInnerStepEnum,
  ];
  @override
  final String wireName = 'CaptainPerformanceDtoOutputViolationsInnerStepEnum';

  @override
  Object serialize(
    Serializers serializers,
    CaptainPerformanceDtoOutputViolationsInnerStepEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CaptainPerformanceDtoOutputViolationsInnerStepEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CaptainPerformanceDtoOutputViolationsInnerStepEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CaptainPerformanceDtoOutputViolationsInner
    extends CaptainPerformanceDtoOutputViolationsInner {
  @override
  final String id;
  @override
  final DateTime recordedAt;
  @override
  final String type;
  @override
  final CaptainPerformanceDtoOutputViolationsInnerStepEnum step;
  @override
  final String? orderNumber;
  @override
  final DateTime? suspendedUntil;
  @override
  final CaptainPerformanceDtoOutputViolationsInnerAppeal? appeal;

  factory _$CaptainPerformanceDtoOutputViolationsInner([
    void Function(CaptainPerformanceDtoOutputViolationsInnerBuilder)? updates,
  ]) => (CaptainPerformanceDtoOutputViolationsInnerBuilder()..update(updates))
      ._build();

  _$CaptainPerformanceDtoOutputViolationsInner._({
    required this.id,
    required this.recordedAt,
    required this.type,
    required this.step,
    this.orderNumber,
    this.suspendedUntil,
    this.appeal,
  }) : super._();
  @override
  CaptainPerformanceDtoOutputViolationsInner rebuild(
    void Function(CaptainPerformanceDtoOutputViolationsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainPerformanceDtoOutputViolationsInnerBuilder toBuilder() =>
      CaptainPerformanceDtoOutputViolationsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainPerformanceDtoOutputViolationsInner &&
        id == other.id &&
        recordedAt == other.recordedAt &&
        type == other.type &&
        step == other.step &&
        orderNumber == other.orderNumber &&
        suspendedUntil == other.suspendedUntil &&
        appeal == other.appeal;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, recordedAt.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, step.hashCode);
    _$hash = $jc(_$hash, orderNumber.hashCode);
    _$hash = $jc(_$hash, suspendedUntil.hashCode);
    _$hash = $jc(_$hash, appeal.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CaptainPerformanceDtoOutputViolationsInner',
          )
          ..add('id', id)
          ..add('recordedAt', recordedAt)
          ..add('type', type)
          ..add('step', step)
          ..add('orderNumber', orderNumber)
          ..add('suspendedUntil', suspendedUntil)
          ..add('appeal', appeal))
        .toString();
  }
}

class CaptainPerformanceDtoOutputViolationsInnerBuilder
    implements
        Builder<
          CaptainPerformanceDtoOutputViolationsInner,
          CaptainPerformanceDtoOutputViolationsInnerBuilder
        > {
  _$CaptainPerformanceDtoOutputViolationsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  DateTime? _recordedAt;
  DateTime? get recordedAt => _$this._recordedAt;
  set recordedAt(DateTime? recordedAt) => _$this._recordedAt = recordedAt;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  CaptainPerformanceDtoOutputViolationsInnerStepEnum? _step;
  CaptainPerformanceDtoOutputViolationsInnerStepEnum? get step => _$this._step;
  set step(CaptainPerformanceDtoOutputViolationsInnerStepEnum? step) =>
      _$this._step = step;

  String? _orderNumber;
  String? get orderNumber => _$this._orderNumber;
  set orderNumber(String? orderNumber) => _$this._orderNumber = orderNumber;

  DateTime? _suspendedUntil;
  DateTime? get suspendedUntil => _$this._suspendedUntil;
  set suspendedUntil(DateTime? suspendedUntil) =>
      _$this._suspendedUntil = suspendedUntil;

  CaptainPerformanceDtoOutputViolationsInnerAppealBuilder? _appeal;
  CaptainPerformanceDtoOutputViolationsInnerAppealBuilder get appeal =>
      _$this._appeal ??=
          CaptainPerformanceDtoOutputViolationsInnerAppealBuilder();
  set appeal(CaptainPerformanceDtoOutputViolationsInnerAppealBuilder? appeal) =>
      _$this._appeal = appeal;

  CaptainPerformanceDtoOutputViolationsInnerBuilder() {
    CaptainPerformanceDtoOutputViolationsInner._defaults(this);
  }

  CaptainPerformanceDtoOutputViolationsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _recordedAt = $v.recordedAt;
      _type = $v.type;
      _step = $v.step;
      _orderNumber = $v.orderNumber;
      _suspendedUntil = $v.suspendedUntil;
      _appeal = $v.appeal?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainPerformanceDtoOutputViolationsInner other) {
    _$v = other as _$CaptainPerformanceDtoOutputViolationsInner;
  }

  @override
  void update(
    void Function(CaptainPerformanceDtoOutputViolationsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainPerformanceDtoOutputViolationsInner build() => _build();

  _$CaptainPerformanceDtoOutputViolationsInner _build() {
    _$CaptainPerformanceDtoOutputViolationsInner _$result;
    try {
      _$result =
          _$v ??
          _$CaptainPerformanceDtoOutputViolationsInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'CaptainPerformanceDtoOutputViolationsInner',
              'id',
            ),
            recordedAt: BuiltValueNullFieldError.checkNotNull(
              recordedAt,
              r'CaptainPerformanceDtoOutputViolationsInner',
              'recordedAt',
            ),
            type: BuiltValueNullFieldError.checkNotNull(
              type,
              r'CaptainPerformanceDtoOutputViolationsInner',
              'type',
            ),
            step: BuiltValueNullFieldError.checkNotNull(
              step,
              r'CaptainPerformanceDtoOutputViolationsInner',
              'step',
            ),
            orderNumber: orderNumber,
            suspendedUntil: suspendedUntil,
            appeal: _appeal?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'appeal';
        _appeal?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainPerformanceDtoOutputViolationsInner',
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
