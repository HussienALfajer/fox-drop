// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_deliver_dto_away.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CaptainDeliverDtoAwayReasonEnum
_$captainDeliverDtoAwayReasonEnum_customerRequestedOtherPlace =
    const CaptainDeliverDtoAwayReasonEnum._('customerRequestedOtherPlace');
const CaptainDeliverDtoAwayReasonEnum
_$captainDeliverDtoAwayReasonEnum_pinInaccurate =
    const CaptainDeliverDtoAwayReasonEnum._('pinInaccurate');
const CaptainDeliverDtoAwayReasonEnum _$captainDeliverDtoAwayReasonEnum_other =
    const CaptainDeliverDtoAwayReasonEnum._('other');

CaptainDeliverDtoAwayReasonEnum _$captainDeliverDtoAwayReasonEnumValueOf(
  String name,
) {
  switch (name) {
    case 'customerRequestedOtherPlace':
      return _$captainDeliverDtoAwayReasonEnum_customerRequestedOtherPlace;
    case 'pinInaccurate':
      return _$captainDeliverDtoAwayReasonEnum_pinInaccurate;
    case 'other':
      return _$captainDeliverDtoAwayReasonEnum_other;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CaptainDeliverDtoAwayReasonEnum>
_$captainDeliverDtoAwayReasonEnumValues =
    BuiltSet<CaptainDeliverDtoAwayReasonEnum>(
      const <CaptainDeliverDtoAwayReasonEnum>[
        _$captainDeliverDtoAwayReasonEnum_customerRequestedOtherPlace,
        _$captainDeliverDtoAwayReasonEnum_pinInaccurate,
        _$captainDeliverDtoAwayReasonEnum_other,
      ],
    );

Serializer<CaptainDeliverDtoAwayReasonEnum>
_$captainDeliverDtoAwayReasonEnumSerializer =
    _$CaptainDeliverDtoAwayReasonEnumSerializer();

class _$CaptainDeliverDtoAwayReasonEnumSerializer
    implements PrimitiveSerializer<CaptainDeliverDtoAwayReasonEnum> {
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
  final Iterable<Type> types = const <Type>[CaptainDeliverDtoAwayReasonEnum];
  @override
  final String wireName = 'CaptainDeliverDtoAwayReasonEnum';

  @override
  Object serialize(
    Serializers serializers,
    CaptainDeliverDtoAwayReasonEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CaptainDeliverDtoAwayReasonEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CaptainDeliverDtoAwayReasonEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CaptainDeliverDtoAway extends CaptainDeliverDtoAway {
  @override
  final CaptainDeliverDtoAwayReasonEnum reason;
  @override
  final String? note;

  factory _$CaptainDeliverDtoAway([
    void Function(CaptainDeliverDtoAwayBuilder)? updates,
  ]) => (CaptainDeliverDtoAwayBuilder()..update(updates))._build();

  _$CaptainDeliverDtoAway._({required this.reason, this.note}) : super._();
  @override
  CaptainDeliverDtoAway rebuild(
    void Function(CaptainDeliverDtoAwayBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainDeliverDtoAwayBuilder toBuilder() =>
      CaptainDeliverDtoAwayBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainDeliverDtoAway &&
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
    return (newBuiltValueToStringHelper(r'CaptainDeliverDtoAway')
          ..add('reason', reason)
          ..add('note', note))
        .toString();
  }
}

class CaptainDeliverDtoAwayBuilder
    implements Builder<CaptainDeliverDtoAway, CaptainDeliverDtoAwayBuilder> {
  _$CaptainDeliverDtoAway? _$v;

  CaptainDeliverDtoAwayReasonEnum? _reason;
  CaptainDeliverDtoAwayReasonEnum? get reason => _$this._reason;
  set reason(CaptainDeliverDtoAwayReasonEnum? reason) =>
      _$this._reason = reason;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  CaptainDeliverDtoAwayBuilder() {
    CaptainDeliverDtoAway._defaults(this);
  }

  CaptainDeliverDtoAwayBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reason = $v.reason;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainDeliverDtoAway other) {
    _$v = other as _$CaptainDeliverDtoAway;
  }

  @override
  void update(void Function(CaptainDeliverDtoAwayBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainDeliverDtoAway build() => _build();

  _$CaptainDeliverDtoAway _build() {
    final _$result =
        _$v ??
        _$CaptainDeliverDtoAway._(
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'CaptainDeliverDtoAway',
            'reason',
          ),
          note: note,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
