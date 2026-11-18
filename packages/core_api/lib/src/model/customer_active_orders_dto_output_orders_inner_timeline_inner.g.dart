// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_active_orders_dto_output_orders_inner_timeline_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum
_$customerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum_placed =
    const CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum._(
      'placed',
    );
const CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum
_$customerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum_accepted =
    const CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum._(
      'accepted',
    );
const CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum
_$customerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum_pickedUp =
    const CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum._(
      'pickedUp',
    );
const CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum
_$customerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum_arrived =
    const CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum._(
      'arrived',
    );
const CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum
_$customerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum_delivered =
    const CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum._(
      'delivered',
    );
const CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum
_$customerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum_failed =
    const CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum._(
      'failed',
    );
const CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum
_$customerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum_rejected =
    const CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum._(
      'rejected',
    );
const CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum
_$customerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum_cancelled =
    const CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum._(
      'cancelled',
    );

CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum
_$customerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnumValueOf(
  String name,
) {
  switch (name) {
    case 'placed':
      return _$customerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum_placed;
    case 'accepted':
      return _$customerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum_accepted;
    case 'pickedUp':
      return _$customerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum_pickedUp;
    case 'arrived':
      return _$customerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum_arrived;
    case 'delivered':
      return _$customerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum_delivered;
    case 'failed':
      return _$customerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum_failed;
    case 'rejected':
      return _$customerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum_rejected;
    case 'cancelled':
      return _$customerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum_cancelled;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum>
_$customerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnumValues =
    BuiltSet<
      CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum
    >(const <CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum>[
      _$customerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum_placed,
      _$customerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum_accepted,
      _$customerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum_pickedUp,
      _$customerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum_arrived,
      _$customerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum_delivered,
      _$customerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum_failed,
      _$customerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum_rejected,
      _$customerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum_cancelled,
    ]);

Serializer<CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum>
_$customerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnumSerializer =
    _$CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnumSerializer();

class _$CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnumSerializer
    implements
        PrimitiveSerializer<
          CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum
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
    CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum,
  ];
  @override
  final String wireName =
      'CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum';

  @override
  Object serialize(
    Serializers serializers,
    CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CustomerActiveOrdersDtoOutputOrdersInnerTimelineInner
    extends CustomerActiveOrdersDtoOutputOrdersInnerTimelineInner {
  @override
  final CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum step;
  @override
  final DateTime at;

  factory _$CustomerActiveOrdersDtoOutputOrdersInnerTimelineInner([
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerBuilder)?
    updates,
  ]) =>
      (CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerBuilder()
            ..update(updates))
          ._build();

  _$CustomerActiveOrdersDtoOutputOrdersInnerTimelineInner._({
    required this.step,
    required this.at,
  }) : super._();
  @override
  CustomerActiveOrdersDtoOutputOrdersInnerTimelineInner rebuild(
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerBuilder toBuilder() =>
      CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerActiveOrdersDtoOutputOrdersInnerTimelineInner &&
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
            r'CustomerActiveOrdersDtoOutputOrdersInnerTimelineInner',
          )
          ..add('step', step)
          ..add('at', at))
        .toString();
  }
}

class CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerBuilder
    implements
        Builder<
          CustomerActiveOrdersDtoOutputOrdersInnerTimelineInner,
          CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerBuilder
        > {
  _$CustomerActiveOrdersDtoOutputOrdersInnerTimelineInner? _$v;

  CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum? _step;
  CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum? get step =>
      _$this._step;
  set step(
    CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum? step,
  ) => _$this._step = step;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerBuilder() {
    CustomerActiveOrdersDtoOutputOrdersInnerTimelineInner._defaults(this);
  }

  CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _step = $v.step;
      _at = $v.at;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerActiveOrdersDtoOutputOrdersInnerTimelineInner other) {
    _$v = other as _$CustomerActiveOrdersDtoOutputOrdersInnerTimelineInner;
  }

  @override
  void update(
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerTimelineInner build() => _build();

  _$CustomerActiveOrdersDtoOutputOrdersInnerTimelineInner _build() {
    final _$result =
        _$v ??
        _$CustomerActiveOrdersDtoOutputOrdersInnerTimelineInner._(
          step: BuiltValueNullFieldError.checkNotNull(
            step,
            r'CustomerActiveOrdersDtoOutputOrdersInnerTimelineInner',
            'step',
          ),
          at: BuiltValueNullFieldError.checkNotNull(
            at,
            r'CustomerActiveOrdersDtoOutputOrdersInnerTimelineInner',
            'at',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
