// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_card_dto_output_order_dispatch_manual.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminOrderCardDtoOutputOrderDispatchManualReasonEnum
_$adminOrderCardDtoOutputOrderDispatchManualReasonEnum_maxOffers =
    const AdminOrderCardDtoOutputOrderDispatchManualReasonEnum._('maxOffers');
const AdminOrderCardDtoOutputOrderDispatchManualReasonEnum
_$adminOrderCardDtoOutputOrderDispatchManualReasonEnum_noCaptainAlert =
    const AdminOrderCardDtoOutputOrderDispatchManualReasonEnum._(
      'noCaptainAlert',
    );
const AdminOrderCardDtoOutputOrderDispatchManualReasonEnum
_$adminOrderCardDtoOutputOrderDispatchManualReasonEnum_operations =
    const AdminOrderCardDtoOutputOrderDispatchManualReasonEnum._('operations');

AdminOrderCardDtoOutputOrderDispatchManualReasonEnum
_$adminOrderCardDtoOutputOrderDispatchManualReasonEnumValueOf(String name) {
  switch (name) {
    case 'maxOffers':
      return _$adminOrderCardDtoOutputOrderDispatchManualReasonEnum_maxOffers;
    case 'noCaptainAlert':
      return _$adminOrderCardDtoOutputOrderDispatchManualReasonEnum_noCaptainAlert;
    case 'operations':
      return _$adminOrderCardDtoOutputOrderDispatchManualReasonEnum_operations;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOrderCardDtoOutputOrderDispatchManualReasonEnum>
_$adminOrderCardDtoOutputOrderDispatchManualReasonEnumValues =
    BuiltSet<AdminOrderCardDtoOutputOrderDispatchManualReasonEnum>(
      const <AdminOrderCardDtoOutputOrderDispatchManualReasonEnum>[
        _$adminOrderCardDtoOutputOrderDispatchManualReasonEnum_maxOffers,
        _$adminOrderCardDtoOutputOrderDispatchManualReasonEnum_noCaptainAlert,
        _$adminOrderCardDtoOutputOrderDispatchManualReasonEnum_operations,
      ],
    );

Serializer<AdminOrderCardDtoOutputOrderDispatchManualReasonEnum>
_$adminOrderCardDtoOutputOrderDispatchManualReasonEnumSerializer =
    _$AdminOrderCardDtoOutputOrderDispatchManualReasonEnumSerializer();

class _$AdminOrderCardDtoOutputOrderDispatchManualReasonEnumSerializer
    implements
        PrimitiveSerializer<
          AdminOrderCardDtoOutputOrderDispatchManualReasonEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'maxOffers': 'max_offers',
    'noCaptainAlert': 'no_captain_alert',
    'operations': 'operations',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'max_offers': 'maxOffers',
    'no_captain_alert': 'noCaptainAlert',
    'operations': 'operations',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminOrderCardDtoOutputOrderDispatchManualReasonEnum,
  ];
  @override
  final String wireName =
      'AdminOrderCardDtoOutputOrderDispatchManualReasonEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderCardDtoOutputOrderDispatchManualReasonEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminOrderCardDtoOutputOrderDispatchManualReasonEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminOrderCardDtoOutputOrderDispatchManualReasonEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminOrderCardDtoOutputOrderDispatchManual
    extends AdminOrderCardDtoOutputOrderDispatchManual {
  @override
  final AdminOrderCardDtoOutputOrderDispatchManualReasonEnum reason;
  @override
  final DateTime at;

  factory _$AdminOrderCardDtoOutputOrderDispatchManual([
    void Function(AdminOrderCardDtoOutputOrderDispatchManualBuilder)? updates,
  ]) => (AdminOrderCardDtoOutputOrderDispatchManualBuilder()..update(updates))
      ._build();

  _$AdminOrderCardDtoOutputOrderDispatchManual._({
    required this.reason,
    required this.at,
  }) : super._();
  @override
  AdminOrderCardDtoOutputOrderDispatchManual rebuild(
    void Function(AdminOrderCardDtoOutputOrderDispatchManualBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderCardDtoOutputOrderDispatchManualBuilder toBuilder() =>
      AdminOrderCardDtoOutputOrderDispatchManualBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderCardDtoOutputOrderDispatchManual &&
        reason == other.reason &&
        at == other.at;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminOrderCardDtoOutputOrderDispatchManual',
          )
          ..add('reason', reason)
          ..add('at', at))
        .toString();
  }
}

class AdminOrderCardDtoOutputOrderDispatchManualBuilder
    implements
        Builder<
          AdminOrderCardDtoOutputOrderDispatchManual,
          AdminOrderCardDtoOutputOrderDispatchManualBuilder
        > {
  _$AdminOrderCardDtoOutputOrderDispatchManual? _$v;

  AdminOrderCardDtoOutputOrderDispatchManualReasonEnum? _reason;
  AdminOrderCardDtoOutputOrderDispatchManualReasonEnum? get reason =>
      _$this._reason;
  set reason(AdminOrderCardDtoOutputOrderDispatchManualReasonEnum? reason) =>
      _$this._reason = reason;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  AdminOrderCardDtoOutputOrderDispatchManualBuilder() {
    AdminOrderCardDtoOutputOrderDispatchManual._defaults(this);
  }

  AdminOrderCardDtoOutputOrderDispatchManualBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reason = $v.reason;
      _at = $v.at;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderCardDtoOutputOrderDispatchManual other) {
    _$v = other as _$AdminOrderCardDtoOutputOrderDispatchManual;
  }

  @override
  void update(
    void Function(AdminOrderCardDtoOutputOrderDispatchManualBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderCardDtoOutputOrderDispatchManual build() => _build();

  _$AdminOrderCardDtoOutputOrderDispatchManual _build() {
    final _$result =
        _$v ??
        _$AdminOrderCardDtoOutputOrderDispatchManual._(
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'AdminOrderCardDtoOutputOrderDispatchManual',
            'reason',
          ),
          at: BuiltValueNullFieldError.checkNotNull(
            at,
            r'AdminOrderCardDtoOutputOrderDispatchManual',
            'at',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
