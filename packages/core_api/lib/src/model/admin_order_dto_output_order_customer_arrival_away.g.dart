// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto_output_order_customer_arrival_away.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminOrderDtoOutputOrderCustomerArrivalAwayReasonEnum
_$adminOrderDtoOutputOrderCustomerArrivalAwayReasonEnum_customerRequestedOtherPlace =
    const AdminOrderDtoOutputOrderCustomerArrivalAwayReasonEnum._(
      'customerRequestedOtherPlace',
    );
const AdminOrderDtoOutputOrderCustomerArrivalAwayReasonEnum
_$adminOrderDtoOutputOrderCustomerArrivalAwayReasonEnum_pinInaccurate =
    const AdminOrderDtoOutputOrderCustomerArrivalAwayReasonEnum._(
      'pinInaccurate',
    );
const AdminOrderDtoOutputOrderCustomerArrivalAwayReasonEnum
_$adminOrderDtoOutputOrderCustomerArrivalAwayReasonEnum_other =
    const AdminOrderDtoOutputOrderCustomerArrivalAwayReasonEnum._('other');

AdminOrderDtoOutputOrderCustomerArrivalAwayReasonEnum
_$adminOrderDtoOutputOrderCustomerArrivalAwayReasonEnumValueOf(String name) {
  switch (name) {
    case 'customerRequestedOtherPlace':
      return _$adminOrderDtoOutputOrderCustomerArrivalAwayReasonEnum_customerRequestedOtherPlace;
    case 'pinInaccurate':
      return _$adminOrderDtoOutputOrderCustomerArrivalAwayReasonEnum_pinInaccurate;
    case 'other':
      return _$adminOrderDtoOutputOrderCustomerArrivalAwayReasonEnum_other;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOrderDtoOutputOrderCustomerArrivalAwayReasonEnum>
_$adminOrderDtoOutputOrderCustomerArrivalAwayReasonEnumValues =
    BuiltSet<AdminOrderDtoOutputOrderCustomerArrivalAwayReasonEnum>(const <
      AdminOrderDtoOutputOrderCustomerArrivalAwayReasonEnum
    >[
      _$adminOrderDtoOutputOrderCustomerArrivalAwayReasonEnum_customerRequestedOtherPlace,
      _$adminOrderDtoOutputOrderCustomerArrivalAwayReasonEnum_pinInaccurate,
      _$adminOrderDtoOutputOrderCustomerArrivalAwayReasonEnum_other,
    ]);

Serializer<AdminOrderDtoOutputOrderCustomerArrivalAwayReasonEnum>
_$adminOrderDtoOutputOrderCustomerArrivalAwayReasonEnumSerializer =
    _$AdminOrderDtoOutputOrderCustomerArrivalAwayReasonEnumSerializer();

class _$AdminOrderDtoOutputOrderCustomerArrivalAwayReasonEnumSerializer
    implements
        PrimitiveSerializer<
          AdminOrderDtoOutputOrderCustomerArrivalAwayReasonEnum
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
    AdminOrderDtoOutputOrderCustomerArrivalAwayReasonEnum,
  ];
  @override
  final String wireName =
      'AdminOrderDtoOutputOrderCustomerArrivalAwayReasonEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderCustomerArrivalAwayReasonEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminOrderDtoOutputOrderCustomerArrivalAwayReasonEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminOrderDtoOutputOrderCustomerArrivalAwayReasonEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminOrderDtoOutputOrderCustomerArrivalAway
    extends AdminOrderDtoOutputOrderCustomerArrivalAway {
  @override
  final AdminOrderDtoOutputOrderCustomerArrivalAwayReasonEnum reason;
  @override
  final String? note;

  factory _$AdminOrderDtoOutputOrderCustomerArrivalAway([
    void Function(AdminOrderDtoOutputOrderCustomerArrivalAwayBuilder)? updates,
  ]) => (AdminOrderDtoOutputOrderCustomerArrivalAwayBuilder()..update(updates))
      ._build();

  _$AdminOrderDtoOutputOrderCustomerArrivalAway._({
    required this.reason,
    this.note,
  }) : super._();
  @override
  AdminOrderDtoOutputOrderCustomerArrivalAway rebuild(
    void Function(AdminOrderDtoOutputOrderCustomerArrivalAwayBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderDtoOutputOrderCustomerArrivalAwayBuilder toBuilder() =>
      AdminOrderDtoOutputOrderCustomerArrivalAwayBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderDtoOutputOrderCustomerArrivalAway &&
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
    return (newBuiltValueToStringHelper(
            r'AdminOrderDtoOutputOrderCustomerArrivalAway',
          )
          ..add('reason', reason)
          ..add('note', note))
        .toString();
  }
}

class AdminOrderDtoOutputOrderCustomerArrivalAwayBuilder
    implements
        Builder<
          AdminOrderDtoOutputOrderCustomerArrivalAway,
          AdminOrderDtoOutputOrderCustomerArrivalAwayBuilder
        > {
  _$AdminOrderDtoOutputOrderCustomerArrivalAway? _$v;

  AdminOrderDtoOutputOrderCustomerArrivalAwayReasonEnum? _reason;
  AdminOrderDtoOutputOrderCustomerArrivalAwayReasonEnum? get reason =>
      _$this._reason;
  set reason(AdminOrderDtoOutputOrderCustomerArrivalAwayReasonEnum? reason) =>
      _$this._reason = reason;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  AdminOrderDtoOutputOrderCustomerArrivalAwayBuilder() {
    AdminOrderDtoOutputOrderCustomerArrivalAway._defaults(this);
  }

  AdminOrderDtoOutputOrderCustomerArrivalAwayBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reason = $v.reason;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderDtoOutputOrderCustomerArrivalAway other) {
    _$v = other as _$AdminOrderDtoOutputOrderCustomerArrivalAway;
  }

  @override
  void update(
    void Function(AdminOrderDtoOutputOrderCustomerArrivalAwayBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderDtoOutputOrderCustomerArrivalAway build() => _build();

  _$AdminOrderDtoOutputOrderCustomerArrivalAway _build() {
    final _$result =
        _$v ??
        _$AdminOrderDtoOutputOrderCustomerArrivalAway._(
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'AdminOrderDtoOutputOrderCustomerArrivalAway',
            'reason',
          ),
          note: note,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
