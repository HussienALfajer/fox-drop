// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_arrive_at_customer_dto_away.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CaptainArriveAtCustomerDtoAwayReasonEnum
_$captainArriveAtCustomerDtoAwayReasonEnum_customerRequestedOtherPlace =
    const CaptainArriveAtCustomerDtoAwayReasonEnum._(
      'customerRequestedOtherPlace',
    );
const CaptainArriveAtCustomerDtoAwayReasonEnum
_$captainArriveAtCustomerDtoAwayReasonEnum_pinInaccurate =
    const CaptainArriveAtCustomerDtoAwayReasonEnum._('pinInaccurate');
const CaptainArriveAtCustomerDtoAwayReasonEnum
_$captainArriveAtCustomerDtoAwayReasonEnum_other =
    const CaptainArriveAtCustomerDtoAwayReasonEnum._('other');

CaptainArriveAtCustomerDtoAwayReasonEnum
_$captainArriveAtCustomerDtoAwayReasonEnumValueOf(String name) {
  switch (name) {
    case 'customerRequestedOtherPlace':
      return _$captainArriveAtCustomerDtoAwayReasonEnum_customerRequestedOtherPlace;
    case 'pinInaccurate':
      return _$captainArriveAtCustomerDtoAwayReasonEnum_pinInaccurate;
    case 'other':
      return _$captainArriveAtCustomerDtoAwayReasonEnum_other;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CaptainArriveAtCustomerDtoAwayReasonEnum>
_$captainArriveAtCustomerDtoAwayReasonEnumValues =
    BuiltSet<CaptainArriveAtCustomerDtoAwayReasonEnum>(
      const <CaptainArriveAtCustomerDtoAwayReasonEnum>[
        _$captainArriveAtCustomerDtoAwayReasonEnum_customerRequestedOtherPlace,
        _$captainArriveAtCustomerDtoAwayReasonEnum_pinInaccurate,
        _$captainArriveAtCustomerDtoAwayReasonEnum_other,
      ],
    );

Serializer<CaptainArriveAtCustomerDtoAwayReasonEnum>
_$captainArriveAtCustomerDtoAwayReasonEnumSerializer =
    _$CaptainArriveAtCustomerDtoAwayReasonEnumSerializer();

class _$CaptainArriveAtCustomerDtoAwayReasonEnumSerializer
    implements PrimitiveSerializer<CaptainArriveAtCustomerDtoAwayReasonEnum> {
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
    CaptainArriveAtCustomerDtoAwayReasonEnum,
  ];
  @override
  final String wireName = 'CaptainArriveAtCustomerDtoAwayReasonEnum';

  @override
  Object serialize(
    Serializers serializers,
    CaptainArriveAtCustomerDtoAwayReasonEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CaptainArriveAtCustomerDtoAwayReasonEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CaptainArriveAtCustomerDtoAwayReasonEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CaptainArriveAtCustomerDtoAway extends CaptainArriveAtCustomerDtoAway {
  @override
  final CaptainArriveAtCustomerDtoAwayReasonEnum reason;
  @override
  final String? note;

  factory _$CaptainArriveAtCustomerDtoAway([
    void Function(CaptainArriveAtCustomerDtoAwayBuilder)? updates,
  ]) => (CaptainArriveAtCustomerDtoAwayBuilder()..update(updates))._build();

  _$CaptainArriveAtCustomerDtoAway._({required this.reason, this.note})
    : super._();
  @override
  CaptainArriveAtCustomerDtoAway rebuild(
    void Function(CaptainArriveAtCustomerDtoAwayBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainArriveAtCustomerDtoAwayBuilder toBuilder() =>
      CaptainArriveAtCustomerDtoAwayBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainArriveAtCustomerDtoAway &&
        reason == other.reason &&
        note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainArriveAtCustomerDtoAway')
          ..add('reason', reason)
          ..add('note', note))
        .toString();
  }
}

class CaptainArriveAtCustomerDtoAwayBuilder
    implements
        Builder<
          CaptainArriveAtCustomerDtoAway,
          CaptainArriveAtCustomerDtoAwayBuilder
        > {
  _$CaptainArriveAtCustomerDtoAway? _$v;

  CaptainArriveAtCustomerDtoAwayReasonEnum? _reason;
  CaptainArriveAtCustomerDtoAwayReasonEnum? get reason => _$this._reason;
  set reason(CaptainArriveAtCustomerDtoAwayReasonEnum? reason) =>
      _$this._reason = reason;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  CaptainArriveAtCustomerDtoAwayBuilder() {
    CaptainArriveAtCustomerDtoAway._defaults(this);
  }

  CaptainArriveAtCustomerDtoAwayBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reason = $v.reason;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainArriveAtCustomerDtoAway other) {
    _$v = other as _$CaptainArriveAtCustomerDtoAway;
  }

  @override
  void update(void Function(CaptainArriveAtCustomerDtoAwayBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainArriveAtCustomerDtoAway build() => _build();

  _$CaptainArriveAtCustomerDtoAway _build() {
    final _$result =
        _$v ??
        _$CaptainArriveAtCustomerDtoAway._(
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'CaptainArriveAtCustomerDtoAway',
            'reason',
          ),
          note: note,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
