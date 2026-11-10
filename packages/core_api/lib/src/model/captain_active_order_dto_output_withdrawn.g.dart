// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_active_order_dto_output_withdrawn.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CaptainActiveOrderDtoOutputWithdrawnCashEnum
_$captainActiveOrderDtoOutputWithdrawnCashEnum_returned =
    const CaptainActiveOrderDtoOutputWithdrawnCashEnum._('returned');
const CaptainActiveOrderDtoOutputWithdrawnCashEnum
_$captainActiveOrderDtoOutputWithdrawnCashEnum_notReturned =
    const CaptainActiveOrderDtoOutputWithdrawnCashEnum._('notReturned');
const CaptainActiveOrderDtoOutputWithdrawnCashEnum
_$captainActiveOrderDtoOutputWithdrawnCashEnum_notPaid =
    const CaptainActiveOrderDtoOutputWithdrawnCashEnum._('notPaid');

CaptainActiveOrderDtoOutputWithdrawnCashEnum
_$captainActiveOrderDtoOutputWithdrawnCashEnumValueOf(String name) {
  switch (name) {
    case 'returned':
      return _$captainActiveOrderDtoOutputWithdrawnCashEnum_returned;
    case 'notReturned':
      return _$captainActiveOrderDtoOutputWithdrawnCashEnum_notReturned;
    case 'notPaid':
      return _$captainActiveOrderDtoOutputWithdrawnCashEnum_notPaid;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CaptainActiveOrderDtoOutputWithdrawnCashEnum>
_$captainActiveOrderDtoOutputWithdrawnCashEnumValues =
    BuiltSet<CaptainActiveOrderDtoOutputWithdrawnCashEnum>(
      const <CaptainActiveOrderDtoOutputWithdrawnCashEnum>[
        _$captainActiveOrderDtoOutputWithdrawnCashEnum_returned,
        _$captainActiveOrderDtoOutputWithdrawnCashEnum_notReturned,
        _$captainActiveOrderDtoOutputWithdrawnCashEnum_notPaid,
      ],
    );

Serializer<CaptainActiveOrderDtoOutputWithdrawnCashEnum>
_$captainActiveOrderDtoOutputWithdrawnCashEnumSerializer =
    _$CaptainActiveOrderDtoOutputWithdrawnCashEnumSerializer();

class _$CaptainActiveOrderDtoOutputWithdrawnCashEnumSerializer
    implements
        PrimitiveSerializer<CaptainActiveOrderDtoOutputWithdrawnCashEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'returned': 'returned',
    'notReturned': 'not_returned',
    'notPaid': 'not_paid',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'returned': 'returned',
    'not_returned': 'notReturned',
    'not_paid': 'notPaid',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CaptainActiveOrderDtoOutputWithdrawnCashEnum,
  ];
  @override
  final String wireName = 'CaptainActiveOrderDtoOutputWithdrawnCashEnum';

  @override
  Object serialize(
    Serializers serializers,
    CaptainActiveOrderDtoOutputWithdrawnCashEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CaptainActiveOrderDtoOutputWithdrawnCashEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CaptainActiveOrderDtoOutputWithdrawnCashEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CaptainActiveOrderDtoOutputWithdrawn
    extends CaptainActiveOrderDtoOutputWithdrawn {
  @override
  final String orderId;
  @override
  final String number;
  @override
  final String reason;
  @override
  final CaptainActiveOrderDtoOutputWithdrawnCashEnum? cash;
  @override
  final DateTime at;

  factory _$CaptainActiveOrderDtoOutputWithdrawn([
    void Function(CaptainActiveOrderDtoOutputWithdrawnBuilder)? updates,
  ]) =>
      (CaptainActiveOrderDtoOutputWithdrawnBuilder()..update(updates))._build();

  _$CaptainActiveOrderDtoOutputWithdrawn._({
    required this.orderId,
    required this.number,
    required this.reason,
    this.cash,
    required this.at,
  }) : super._();
  @override
  CaptainActiveOrderDtoOutputWithdrawn rebuild(
    void Function(CaptainActiveOrderDtoOutputWithdrawnBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainActiveOrderDtoOutputWithdrawnBuilder toBuilder() =>
      CaptainActiveOrderDtoOutputWithdrawnBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainActiveOrderDtoOutputWithdrawn &&
        orderId == other.orderId &&
        number == other.number &&
        reason == other.reason &&
        cash == other.cash &&
        at == other.at;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, orderId.hashCode);
    _$hash = $jc(_$hash, number.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, cash.hashCode);
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainActiveOrderDtoOutputWithdrawn')
          ..add('orderId', orderId)
          ..add('number', number)
          ..add('reason', reason)
          ..add('cash', cash)
          ..add('at', at))
        .toString();
  }
}

class CaptainActiveOrderDtoOutputWithdrawnBuilder
    implements
        Builder<
          CaptainActiveOrderDtoOutputWithdrawn,
          CaptainActiveOrderDtoOutputWithdrawnBuilder
        > {
  _$CaptainActiveOrderDtoOutputWithdrawn? _$v;

  String? _orderId;
  String? get orderId => _$this._orderId;
  set orderId(String? orderId) => _$this._orderId = orderId;

  String? _number;
  String? get number => _$this._number;
  set number(String? number) => _$this._number = number;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  CaptainActiveOrderDtoOutputWithdrawnCashEnum? _cash;
  CaptainActiveOrderDtoOutputWithdrawnCashEnum? get cash => _$this._cash;
  set cash(CaptainActiveOrderDtoOutputWithdrawnCashEnum? cash) =>
      _$this._cash = cash;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  CaptainActiveOrderDtoOutputWithdrawnBuilder() {
    CaptainActiveOrderDtoOutputWithdrawn._defaults(this);
  }

  CaptainActiveOrderDtoOutputWithdrawnBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _orderId = $v.orderId;
      _number = $v.number;
      _reason = $v.reason;
      _cash = $v.cash;
      _at = $v.at;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainActiveOrderDtoOutputWithdrawn other) {
    _$v = other as _$CaptainActiveOrderDtoOutputWithdrawn;
  }

  @override
  void update(
    void Function(CaptainActiveOrderDtoOutputWithdrawnBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainActiveOrderDtoOutputWithdrawn build() => _build();

  _$CaptainActiveOrderDtoOutputWithdrawn _build() {
    final _$result =
        _$v ??
        _$CaptainActiveOrderDtoOutputWithdrawn._(
          orderId: BuiltValueNullFieldError.checkNotNull(
            orderId,
            r'CaptainActiveOrderDtoOutputWithdrawn',
            'orderId',
          ),
          number: BuiltValueNullFieldError.checkNotNull(
            number,
            r'CaptainActiveOrderDtoOutputWithdrawn',
            'number',
          ),
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'CaptainActiveOrderDtoOutputWithdrawn',
            'reason',
          ),
          cash: cash,
          at: BuiltValueNullFieldError.checkNotNull(
            at,
            r'CaptainActiveOrderDtoOutputWithdrawn',
            'at',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
