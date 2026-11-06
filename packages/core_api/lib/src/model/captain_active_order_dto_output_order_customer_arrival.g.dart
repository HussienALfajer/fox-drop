// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_active_order_dto_output_order_customer_arrival.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CaptainActiveOrderDtoOutputOrderCustomerArrivalAwayReasonEnum
_$captainActiveOrderDtoOutputOrderCustomerArrivalAwayReasonEnum_customerRequestedOtherPlace =
    const CaptainActiveOrderDtoOutputOrderCustomerArrivalAwayReasonEnum._(
      'customerRequestedOtherPlace',
    );
const CaptainActiveOrderDtoOutputOrderCustomerArrivalAwayReasonEnum
_$captainActiveOrderDtoOutputOrderCustomerArrivalAwayReasonEnum_pinInaccurate =
    const CaptainActiveOrderDtoOutputOrderCustomerArrivalAwayReasonEnum._(
      'pinInaccurate',
    );
const CaptainActiveOrderDtoOutputOrderCustomerArrivalAwayReasonEnum
_$captainActiveOrderDtoOutputOrderCustomerArrivalAwayReasonEnum_other =
    const CaptainActiveOrderDtoOutputOrderCustomerArrivalAwayReasonEnum._(
      'other',
    );

CaptainActiveOrderDtoOutputOrderCustomerArrivalAwayReasonEnum
_$captainActiveOrderDtoOutputOrderCustomerArrivalAwayReasonEnumValueOf(
  String name,
) {
  switch (name) {
    case 'customerRequestedOtherPlace':
      return _$captainActiveOrderDtoOutputOrderCustomerArrivalAwayReasonEnum_customerRequestedOtherPlace;
    case 'pinInaccurate':
      return _$captainActiveOrderDtoOutputOrderCustomerArrivalAwayReasonEnum_pinInaccurate;
    case 'other':
      return _$captainActiveOrderDtoOutputOrderCustomerArrivalAwayReasonEnum_other;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CaptainActiveOrderDtoOutputOrderCustomerArrivalAwayReasonEnum>
_$captainActiveOrderDtoOutputOrderCustomerArrivalAwayReasonEnumValues =
    BuiltSet<
      CaptainActiveOrderDtoOutputOrderCustomerArrivalAwayReasonEnum
    >(const <CaptainActiveOrderDtoOutputOrderCustomerArrivalAwayReasonEnum>[
      _$captainActiveOrderDtoOutputOrderCustomerArrivalAwayReasonEnum_customerRequestedOtherPlace,
      _$captainActiveOrderDtoOutputOrderCustomerArrivalAwayReasonEnum_pinInaccurate,
      _$captainActiveOrderDtoOutputOrderCustomerArrivalAwayReasonEnum_other,
    ]);

Serializer<CaptainActiveOrderDtoOutputOrderCustomerArrivalAwayReasonEnum>
_$captainActiveOrderDtoOutputOrderCustomerArrivalAwayReasonEnumSerializer =
    _$CaptainActiveOrderDtoOutputOrderCustomerArrivalAwayReasonEnumSerializer();

class _$CaptainActiveOrderDtoOutputOrderCustomerArrivalAwayReasonEnumSerializer
    implements
        PrimitiveSerializer<
          CaptainActiveOrderDtoOutputOrderCustomerArrivalAwayReasonEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'customerRequestedOtherPlace': 'customer_requested_other_place',
    'pinInaccurate': 'pin_inaccurate',
    'other': 'other',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'customer_requested_other_place': 'customerRequestedOtherPlace',
    'pin_inaccurate': 'pinInaccurate',
    'other': 'other',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CaptainActiveOrderDtoOutputOrderCustomerArrivalAwayReasonEnum,
  ];
  @override
  final String wireName =
      'CaptainActiveOrderDtoOutputOrderCustomerArrivalAwayReasonEnum';

  @override
  Object serialize(
    Serializers serializers,
    CaptainActiveOrderDtoOutputOrderCustomerArrivalAwayReasonEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CaptainActiveOrderDtoOutputOrderCustomerArrivalAwayReasonEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CaptainActiveOrderDtoOutputOrderCustomerArrivalAwayReasonEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CaptainActiveOrderDtoOutputOrderCustomerArrival
    extends CaptainActiveOrderDtoOutputOrderCustomerArrival {
  @override
  final DateTime at;
  @override
  final CaptainActiveOrderDtoOutputOrderCustomerArrivalAwayReasonEnum?
  awayReason;

  factory _$CaptainActiveOrderDtoOutputOrderCustomerArrival([
    void Function(CaptainActiveOrderDtoOutputOrderCustomerArrivalBuilder)?
    updates,
  ]) =>
      (CaptainActiveOrderDtoOutputOrderCustomerArrivalBuilder()
            ..update(updates))
          ._build();

  _$CaptainActiveOrderDtoOutputOrderCustomerArrival._({
    required this.at,
    this.awayReason,
  }) : super._();
  @override
  CaptainActiveOrderDtoOutputOrderCustomerArrival rebuild(
    void Function(CaptainActiveOrderDtoOutputOrderCustomerArrivalBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainActiveOrderDtoOutputOrderCustomerArrivalBuilder toBuilder() =>
      CaptainActiveOrderDtoOutputOrderCustomerArrivalBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainActiveOrderDtoOutputOrderCustomerArrival &&
        at == other.at &&
        awayReason == other.awayReason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jc(_$hash, awayReason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CaptainActiveOrderDtoOutputOrderCustomerArrival',
          )
          ..add('at', at)
          ..add('awayReason', awayReason))
        .toString();
  }
}

class CaptainActiveOrderDtoOutputOrderCustomerArrivalBuilder
    implements
        Builder<
          CaptainActiveOrderDtoOutputOrderCustomerArrival,
          CaptainActiveOrderDtoOutputOrderCustomerArrivalBuilder
        > {
  _$CaptainActiveOrderDtoOutputOrderCustomerArrival? _$v;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  CaptainActiveOrderDtoOutputOrderCustomerArrivalAwayReasonEnum? _awayReason;
  CaptainActiveOrderDtoOutputOrderCustomerArrivalAwayReasonEnum?
  get awayReason => _$this._awayReason;
  set awayReason(
    CaptainActiveOrderDtoOutputOrderCustomerArrivalAwayReasonEnum? awayReason,
  ) => _$this._awayReason = awayReason;

  CaptainActiveOrderDtoOutputOrderCustomerArrivalBuilder() {
    CaptainActiveOrderDtoOutputOrderCustomerArrival._defaults(this);
  }

  CaptainActiveOrderDtoOutputOrderCustomerArrivalBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _at = $v.at;
      _awayReason = $v.awayReason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainActiveOrderDtoOutputOrderCustomerArrival other) {
    _$v = other as _$CaptainActiveOrderDtoOutputOrderCustomerArrival;
  }

  @override
  void update(
    void Function(CaptainActiveOrderDtoOutputOrderCustomerArrivalBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainActiveOrderDtoOutputOrderCustomerArrival build() => _build();

  _$CaptainActiveOrderDtoOutputOrderCustomerArrival _build() {
    final _$result =
        _$v ??
        _$CaptainActiveOrderDtoOutputOrderCustomerArrival._(
          at: BuiltValueNullFieldError.checkNotNull(
            at,
            r'CaptainActiveOrderDtoOutputOrderCustomerArrival',
            'at',
          ),
          awayReason: awayReason,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
