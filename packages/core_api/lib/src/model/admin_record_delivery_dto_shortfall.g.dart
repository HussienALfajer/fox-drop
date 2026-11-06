// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_record_delivery_dto_shortfall.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminRecordDeliveryDtoShortfallReasonEnum
_$adminRecordDeliveryDtoShortfallReasonEnum_customerShort =
    const AdminRecordDeliveryDtoShortfallReasonEnum._('customerShort');
const AdminRecordDeliveryDtoShortfallReasonEnum
_$adminRecordDeliveryDtoShortfallReasonEnum_countingError =
    const AdminRecordDeliveryDtoShortfallReasonEnum._('countingError');
const AdminRecordDeliveryDtoShortfallReasonEnum
_$adminRecordDeliveryDtoShortfallReasonEnum_other =
    const AdminRecordDeliveryDtoShortfallReasonEnum._('other');

AdminRecordDeliveryDtoShortfallReasonEnum
_$adminRecordDeliveryDtoShortfallReasonEnumValueOf(String name) {
  switch (name) {
    case 'customerShort':
      return _$adminRecordDeliveryDtoShortfallReasonEnum_customerShort;
    case 'countingError':
      return _$adminRecordDeliveryDtoShortfallReasonEnum_countingError;
    case 'other':
      return _$adminRecordDeliveryDtoShortfallReasonEnum_other;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminRecordDeliveryDtoShortfallReasonEnum>
_$adminRecordDeliveryDtoShortfallReasonEnumValues =
    BuiltSet<AdminRecordDeliveryDtoShortfallReasonEnum>(
      const <AdminRecordDeliveryDtoShortfallReasonEnum>[
        _$adminRecordDeliveryDtoShortfallReasonEnum_customerShort,
        _$adminRecordDeliveryDtoShortfallReasonEnum_countingError,
        _$adminRecordDeliveryDtoShortfallReasonEnum_other,
      ],
    );

Serializer<AdminRecordDeliveryDtoShortfallReasonEnum>
_$adminRecordDeliveryDtoShortfallReasonEnumSerializer =
    _$AdminRecordDeliveryDtoShortfallReasonEnumSerializer();

class _$AdminRecordDeliveryDtoShortfallReasonEnumSerializer
    implements PrimitiveSerializer<AdminRecordDeliveryDtoShortfallReasonEnum> {
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
    AdminRecordDeliveryDtoShortfallReasonEnum,
  ];
  @override
  final String wireName = 'AdminRecordDeliveryDtoShortfallReasonEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminRecordDeliveryDtoShortfallReasonEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminRecordDeliveryDtoShortfallReasonEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminRecordDeliveryDtoShortfallReasonEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminRecordDeliveryDtoShortfall
    extends AdminRecordDeliveryDtoShortfall {
  @override
  final AdminRecordDeliveryDtoShortfallReasonEnum reason;
  @override
  final String? note;

  factory _$AdminRecordDeliveryDtoShortfall([
    void Function(AdminRecordDeliveryDtoShortfallBuilder)? updates,
  ]) => (AdminRecordDeliveryDtoShortfallBuilder()..update(updates))._build();

  _$AdminRecordDeliveryDtoShortfall._({required this.reason, this.note})
    : super._();
  @override
  AdminRecordDeliveryDtoShortfall rebuild(
    void Function(AdminRecordDeliveryDtoShortfallBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRecordDeliveryDtoShortfallBuilder toBuilder() =>
      AdminRecordDeliveryDtoShortfallBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRecordDeliveryDtoShortfall &&
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
    return (newBuiltValueToStringHelper(r'AdminRecordDeliveryDtoShortfall')
          ..add('reason', reason)
          ..add('note', note))
        .toString();
  }
}

class AdminRecordDeliveryDtoShortfallBuilder
    implements
        Builder<
          AdminRecordDeliveryDtoShortfall,
          AdminRecordDeliveryDtoShortfallBuilder
        > {
  _$AdminRecordDeliveryDtoShortfall? _$v;

  AdminRecordDeliveryDtoShortfallReasonEnum? _reason;
  AdminRecordDeliveryDtoShortfallReasonEnum? get reason => _$this._reason;
  set reason(AdminRecordDeliveryDtoShortfallReasonEnum? reason) =>
      _$this._reason = reason;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  AdminRecordDeliveryDtoShortfallBuilder() {
    AdminRecordDeliveryDtoShortfall._defaults(this);
  }

  AdminRecordDeliveryDtoShortfallBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reason = $v.reason;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRecordDeliveryDtoShortfall other) {
    _$v = other as _$AdminRecordDeliveryDtoShortfall;
  }

  @override
  void update(void Function(AdminRecordDeliveryDtoShortfallBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminRecordDeliveryDtoShortfall build() => _build();

  _$AdminRecordDeliveryDtoShortfall _build() {
    final _$result =
        _$v ??
        _$AdminRecordDeliveryDtoShortfall._(
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'AdminRecordDeliveryDtoShortfall',
            'reason',
          ),
          note: note,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
