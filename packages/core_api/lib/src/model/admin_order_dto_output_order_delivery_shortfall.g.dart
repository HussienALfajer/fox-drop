// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto_output_order_delivery_shortfall.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminOrderDtoOutputOrderDeliveryShortfallReasonEnum
_$adminOrderDtoOutputOrderDeliveryShortfallReasonEnum_customerShort =
    const AdminOrderDtoOutputOrderDeliveryShortfallReasonEnum._(
      'customerShort',
    );
const AdminOrderDtoOutputOrderDeliveryShortfallReasonEnum
_$adminOrderDtoOutputOrderDeliveryShortfallReasonEnum_countingError =
    const AdminOrderDtoOutputOrderDeliveryShortfallReasonEnum._(
      'countingError',
    );
const AdminOrderDtoOutputOrderDeliveryShortfallReasonEnum
_$adminOrderDtoOutputOrderDeliveryShortfallReasonEnum_other =
    const AdminOrderDtoOutputOrderDeliveryShortfallReasonEnum._('other');

AdminOrderDtoOutputOrderDeliveryShortfallReasonEnum
_$adminOrderDtoOutputOrderDeliveryShortfallReasonEnumValueOf(String name) {
  switch (name) {
    case 'customerShort':
      return _$adminOrderDtoOutputOrderDeliveryShortfallReasonEnum_customerShort;
    case 'countingError':
      return _$adminOrderDtoOutputOrderDeliveryShortfallReasonEnum_countingError;
    case 'other':
      return _$adminOrderDtoOutputOrderDeliveryShortfallReasonEnum_other;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOrderDtoOutputOrderDeliveryShortfallReasonEnum>
_$adminOrderDtoOutputOrderDeliveryShortfallReasonEnumValues =
    BuiltSet<AdminOrderDtoOutputOrderDeliveryShortfallReasonEnum>(
      const <AdminOrderDtoOutputOrderDeliveryShortfallReasonEnum>[
        _$adminOrderDtoOutputOrderDeliveryShortfallReasonEnum_customerShort,
        _$adminOrderDtoOutputOrderDeliveryShortfallReasonEnum_countingError,
        _$adminOrderDtoOutputOrderDeliveryShortfallReasonEnum_other,
      ],
    );

Serializer<AdminOrderDtoOutputOrderDeliveryShortfallReasonEnum>
_$adminOrderDtoOutputOrderDeliveryShortfallReasonEnumSerializer =
    _$AdminOrderDtoOutputOrderDeliveryShortfallReasonEnumSerializer();

class _$AdminOrderDtoOutputOrderDeliveryShortfallReasonEnumSerializer
    implements
        PrimitiveSerializer<
          AdminOrderDtoOutputOrderDeliveryShortfallReasonEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'customerShort': 'customer_short',
    'countingError': 'counting_error',
    'other': 'other',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'customer_short': 'customerShort',
    'counting_error': 'countingError',
    'other': 'other',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminOrderDtoOutputOrderDeliveryShortfallReasonEnum,
  ];
  @override
  final String wireName = 'AdminOrderDtoOutputOrderDeliveryShortfallReasonEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderDeliveryShortfallReasonEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminOrderDtoOutputOrderDeliveryShortfallReasonEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminOrderDtoOutputOrderDeliveryShortfallReasonEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminOrderDtoOutputOrderDeliveryShortfall
    extends AdminOrderDtoOutputOrderDeliveryShortfall {
  @override
  final CaptainWentOfflineDtoOutputHandIn? amount;
  @override
  final AdminOrderDtoOutputOrderDeliveryShortfallReasonEnum reason;
  @override
  final String? note;

  factory _$AdminOrderDtoOutputOrderDeliveryShortfall([
    void Function(AdminOrderDtoOutputOrderDeliveryShortfallBuilder)? updates,
  ]) => (AdminOrderDtoOutputOrderDeliveryShortfallBuilder()..update(updates))
      ._build();

  _$AdminOrderDtoOutputOrderDeliveryShortfall._({
    this.amount,
    required this.reason,
    this.note,
  }) : super._();
  @override
  AdminOrderDtoOutputOrderDeliveryShortfall rebuild(
    void Function(AdminOrderDtoOutputOrderDeliveryShortfallBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderDtoOutputOrderDeliveryShortfallBuilder toBuilder() =>
      AdminOrderDtoOutputOrderDeliveryShortfallBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderDtoOutputOrderDeliveryShortfall &&
        amount == other.amount &&
        reason == other.reason &&
        note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminOrderDtoOutputOrderDeliveryShortfall',
          )
          ..add('amount', amount)
          ..add('reason', reason)
          ..add('note', note))
        .toString();
  }
}

class AdminOrderDtoOutputOrderDeliveryShortfallBuilder
    implements
        Builder<
          AdminOrderDtoOutputOrderDeliveryShortfall,
          AdminOrderDtoOutputOrderDeliveryShortfallBuilder
        > {
  _$AdminOrderDtoOutputOrderDeliveryShortfall? _$v;

  CaptainWentOfflineDtoOutputHandInBuilder? _amount;
  CaptainWentOfflineDtoOutputHandInBuilder get amount =>
      _$this._amount ??= CaptainWentOfflineDtoOutputHandInBuilder();
  set amount(CaptainWentOfflineDtoOutputHandInBuilder? amount) =>
      _$this._amount = amount;

  AdminOrderDtoOutputOrderDeliveryShortfallReasonEnum? _reason;
  AdminOrderDtoOutputOrderDeliveryShortfallReasonEnum? get reason =>
      _$this._reason;
  set reason(AdminOrderDtoOutputOrderDeliveryShortfallReasonEnum? reason) =>
      _$this._reason = reason;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  AdminOrderDtoOutputOrderDeliveryShortfallBuilder() {
    AdminOrderDtoOutputOrderDeliveryShortfall._defaults(this);
  }

  AdminOrderDtoOutputOrderDeliveryShortfallBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount?.toBuilder();
      _reason = $v.reason;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderDtoOutputOrderDeliveryShortfall other) {
    _$v = other as _$AdminOrderDtoOutputOrderDeliveryShortfall;
  }

  @override
  void update(
    void Function(AdminOrderDtoOutputOrderDeliveryShortfallBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderDtoOutputOrderDeliveryShortfall build() => _build();

  _$AdminOrderDtoOutputOrderDeliveryShortfall _build() {
    _$AdminOrderDtoOutputOrderDeliveryShortfall _$result;
    try {
      _$result =
          _$v ??
          _$AdminOrderDtoOutputOrderDeliveryShortfall._(
            amount: _amount?.build(),
            reason: BuiltValueNullFieldError.checkNotNull(
              reason,
              r'AdminOrderDtoOutputOrderDeliveryShortfall',
              'reason',
            ),
            note: note,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'amount';
        _amount?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminOrderDtoOutputOrderDeliveryShortfall',
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
