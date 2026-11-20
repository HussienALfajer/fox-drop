// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_order_with_timeline_dto_output_timeline_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MerchantOrderWithTimelineDtoOutputTimelineInnerStepEnum
_$merchantOrderWithTimelineDtoOutputTimelineInnerStepEnum_placed =
    const MerchantOrderWithTimelineDtoOutputTimelineInnerStepEnum._('placed');
const MerchantOrderWithTimelineDtoOutputTimelineInnerStepEnum
_$merchantOrderWithTimelineDtoOutputTimelineInnerStepEnum_accepted =
    const MerchantOrderWithTimelineDtoOutputTimelineInnerStepEnum._('accepted');
const MerchantOrderWithTimelineDtoOutputTimelineInnerStepEnum
_$merchantOrderWithTimelineDtoOutputTimelineInnerStepEnum_pickedUp =
    const MerchantOrderWithTimelineDtoOutputTimelineInnerStepEnum._('pickedUp');
const MerchantOrderWithTimelineDtoOutputTimelineInnerStepEnum
_$merchantOrderWithTimelineDtoOutputTimelineInnerStepEnum_arrived =
    const MerchantOrderWithTimelineDtoOutputTimelineInnerStepEnum._('arrived');
const MerchantOrderWithTimelineDtoOutputTimelineInnerStepEnum
_$merchantOrderWithTimelineDtoOutputTimelineInnerStepEnum_delivered =
    const MerchantOrderWithTimelineDtoOutputTimelineInnerStepEnum._(
      'delivered',
    );
const MerchantOrderWithTimelineDtoOutputTimelineInnerStepEnum
_$merchantOrderWithTimelineDtoOutputTimelineInnerStepEnum_failed =
    const MerchantOrderWithTimelineDtoOutputTimelineInnerStepEnum._('failed');
const MerchantOrderWithTimelineDtoOutputTimelineInnerStepEnum
_$merchantOrderWithTimelineDtoOutputTimelineInnerStepEnum_rejected =
    const MerchantOrderWithTimelineDtoOutputTimelineInnerStepEnum._('rejected');
const MerchantOrderWithTimelineDtoOutputTimelineInnerStepEnum
_$merchantOrderWithTimelineDtoOutputTimelineInnerStepEnum_cancelled =
    const MerchantOrderWithTimelineDtoOutputTimelineInnerStepEnum._(
      'cancelled',
    );

MerchantOrderWithTimelineDtoOutputTimelineInnerStepEnum
_$merchantOrderWithTimelineDtoOutputTimelineInnerStepEnumValueOf(String name) {
  switch (name) {
    case 'placed':
      return _$merchantOrderWithTimelineDtoOutputTimelineInnerStepEnum_placed;
    case 'accepted':
      return _$merchantOrderWithTimelineDtoOutputTimelineInnerStepEnum_accepted;
    case 'pickedUp':
      return _$merchantOrderWithTimelineDtoOutputTimelineInnerStepEnum_pickedUp;
    case 'arrived':
      return _$merchantOrderWithTimelineDtoOutputTimelineInnerStepEnum_arrived;
    case 'delivered':
      return _$merchantOrderWithTimelineDtoOutputTimelineInnerStepEnum_delivered;
    case 'failed':
      return _$merchantOrderWithTimelineDtoOutputTimelineInnerStepEnum_failed;
    case 'rejected':
      return _$merchantOrderWithTimelineDtoOutputTimelineInnerStepEnum_rejected;
    case 'cancelled':
      return _$merchantOrderWithTimelineDtoOutputTimelineInnerStepEnum_cancelled;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MerchantOrderWithTimelineDtoOutputTimelineInnerStepEnum>
_$merchantOrderWithTimelineDtoOutputTimelineInnerStepEnumValues =
    BuiltSet<MerchantOrderWithTimelineDtoOutputTimelineInnerStepEnum>(
      const <MerchantOrderWithTimelineDtoOutputTimelineInnerStepEnum>[
        _$merchantOrderWithTimelineDtoOutputTimelineInnerStepEnum_placed,
        _$merchantOrderWithTimelineDtoOutputTimelineInnerStepEnum_accepted,
        _$merchantOrderWithTimelineDtoOutputTimelineInnerStepEnum_pickedUp,
        _$merchantOrderWithTimelineDtoOutputTimelineInnerStepEnum_arrived,
        _$merchantOrderWithTimelineDtoOutputTimelineInnerStepEnum_delivered,
        _$merchantOrderWithTimelineDtoOutputTimelineInnerStepEnum_failed,
        _$merchantOrderWithTimelineDtoOutputTimelineInnerStepEnum_rejected,
        _$merchantOrderWithTimelineDtoOutputTimelineInnerStepEnum_cancelled,
      ],
    );

Serializer<MerchantOrderWithTimelineDtoOutputTimelineInnerStepEnum>
_$merchantOrderWithTimelineDtoOutputTimelineInnerStepEnumSerializer =
    _$MerchantOrderWithTimelineDtoOutputTimelineInnerStepEnumSerializer();

class _$MerchantOrderWithTimelineDtoOutputTimelineInnerStepEnumSerializer
    implements
        PrimitiveSerializer<
          MerchantOrderWithTimelineDtoOutputTimelineInnerStepEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'placed': 'placed',
    'accepted': 'accepted',
    'pickedUp': 'picked_up',
    'arrived': 'arrived',
    'delivered': 'delivered',
    'failed': 'failed',
    'rejected': 'rejected',
    'cancelled': 'cancelled',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'placed': 'placed',
    'accepted': 'accepted',
    'picked_up': 'pickedUp',
    'arrived': 'arrived',
    'delivered': 'delivered',
    'failed': 'failed',
    'rejected': 'rejected',
    'cancelled': 'cancelled',
  };

  @override
  final Iterable<Type> types = const <Type>[
    MerchantOrderWithTimelineDtoOutputTimelineInnerStepEnum,
  ];
  @override
  final String wireName =
      'MerchantOrderWithTimelineDtoOutputTimelineInnerStepEnum';

  @override
  Object serialize(
    Serializers serializers,
    MerchantOrderWithTimelineDtoOutputTimelineInnerStepEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MerchantOrderWithTimelineDtoOutputTimelineInnerStepEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => MerchantOrderWithTimelineDtoOutputTimelineInnerStepEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$MerchantOrderWithTimelineDtoOutputTimelineInner
    extends MerchantOrderWithTimelineDtoOutputTimelineInner {
  @override
  final MerchantOrderWithTimelineDtoOutputTimelineInnerStepEnum step;
  @override
  final DateTime at;

  factory _$MerchantOrderWithTimelineDtoOutputTimelineInner([
    void Function(MerchantOrderWithTimelineDtoOutputTimelineInnerBuilder)?
    updates,
  ]) =>
      (MerchantOrderWithTimelineDtoOutputTimelineInnerBuilder()
            ..update(updates))
          ._build();

  _$MerchantOrderWithTimelineDtoOutputTimelineInner._({
    required this.step,
    required this.at,
  }) : super._();
  @override
  MerchantOrderWithTimelineDtoOutputTimelineInner rebuild(
    void Function(MerchantOrderWithTimelineDtoOutputTimelineInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantOrderWithTimelineDtoOutputTimelineInnerBuilder toBuilder() =>
      MerchantOrderWithTimelineDtoOutputTimelineInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantOrderWithTimelineDtoOutputTimelineInner &&
        step == other.step &&
        at == other.at;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, step.hashCode);
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'MerchantOrderWithTimelineDtoOutputTimelineInner',
          )
          ..add('step', step)
          ..add('at', at))
        .toString();
  }
}

class MerchantOrderWithTimelineDtoOutputTimelineInnerBuilder
    implements
        Builder<
          MerchantOrderWithTimelineDtoOutputTimelineInner,
          MerchantOrderWithTimelineDtoOutputTimelineInnerBuilder
        > {
  _$MerchantOrderWithTimelineDtoOutputTimelineInner? _$v;

  MerchantOrderWithTimelineDtoOutputTimelineInnerStepEnum? _step;
  MerchantOrderWithTimelineDtoOutputTimelineInnerStepEnum? get step =>
      _$this._step;
  set step(MerchantOrderWithTimelineDtoOutputTimelineInnerStepEnum? step) =>
      _$this._step = step;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  MerchantOrderWithTimelineDtoOutputTimelineInnerBuilder() {
    MerchantOrderWithTimelineDtoOutputTimelineInner._defaults(this);
  }

  MerchantOrderWithTimelineDtoOutputTimelineInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _step = $v.step;
      _at = $v.at;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantOrderWithTimelineDtoOutputTimelineInner other) {
    _$v = other as _$MerchantOrderWithTimelineDtoOutputTimelineInner;
  }

  @override
  void update(
    void Function(MerchantOrderWithTimelineDtoOutputTimelineInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantOrderWithTimelineDtoOutputTimelineInner build() => _build();

  _$MerchantOrderWithTimelineDtoOutputTimelineInner _build() {
    final _$result =
        _$v ??
        _$MerchantOrderWithTimelineDtoOutputTimelineInner._(
          step: BuiltValueNullFieldError.checkNotNull(
            step,
            r'MerchantOrderWithTimelineDtoOutputTimelineInner',
            'step',
          ),
          at: BuiltValueNullFieldError.checkNotNull(
            at,
            r'MerchantOrderWithTimelineDtoOutputTimelineInner',
            'at',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
