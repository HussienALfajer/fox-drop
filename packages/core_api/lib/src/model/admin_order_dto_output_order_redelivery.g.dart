// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto_output_order_redelivery.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminOrderDtoOutputOrderRedeliveryResponsibleEnum
_$adminOrderDtoOutputOrderRedeliveryResponsibleEnum_restaurant =
    const AdminOrderDtoOutputOrderRedeliveryResponsibleEnum._('restaurant');
const AdminOrderDtoOutputOrderRedeliveryResponsibleEnum
_$adminOrderDtoOutputOrderRedeliveryResponsibleEnum_captain =
    const AdminOrderDtoOutputOrderRedeliveryResponsibleEnum._('captain');
const AdminOrderDtoOutputOrderRedeliveryResponsibleEnum
_$adminOrderDtoOutputOrderRedeliveryResponsibleEnum_platform =
    const AdminOrderDtoOutputOrderRedeliveryResponsibleEnum._('platform');

AdminOrderDtoOutputOrderRedeliveryResponsibleEnum
_$adminOrderDtoOutputOrderRedeliveryResponsibleEnumValueOf(String name) {
  switch (name) {
    case 'restaurant':
      return _$adminOrderDtoOutputOrderRedeliveryResponsibleEnum_restaurant;
    case 'captain':
      return _$adminOrderDtoOutputOrderRedeliveryResponsibleEnum_captain;
    case 'platform':
      return _$adminOrderDtoOutputOrderRedeliveryResponsibleEnum_platform;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOrderDtoOutputOrderRedeliveryResponsibleEnum>
_$adminOrderDtoOutputOrderRedeliveryResponsibleEnumValues =
    BuiltSet<AdminOrderDtoOutputOrderRedeliveryResponsibleEnum>(
      const <AdminOrderDtoOutputOrderRedeliveryResponsibleEnum>[
        _$adminOrderDtoOutputOrderRedeliveryResponsibleEnum_restaurant,
        _$adminOrderDtoOutputOrderRedeliveryResponsibleEnum_captain,
        _$adminOrderDtoOutputOrderRedeliveryResponsibleEnum_platform,
      ],
    );

Serializer<AdminOrderDtoOutputOrderRedeliveryResponsibleEnum>
_$adminOrderDtoOutputOrderRedeliveryResponsibleEnumSerializer =
    _$AdminOrderDtoOutputOrderRedeliveryResponsibleEnumSerializer();

class _$AdminOrderDtoOutputOrderRedeliveryResponsibleEnumSerializer
    implements
        PrimitiveSerializer<AdminOrderDtoOutputOrderRedeliveryResponsibleEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'restaurant': 'restaurant',
    'captain': 'captain',
    'platform': 'platform',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'restaurant': 'restaurant',
    'captain': 'captain',
    'platform': 'platform',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminOrderDtoOutputOrderRedeliveryResponsibleEnum,
  ];
  @override
  final String wireName = 'AdminOrderDtoOutputOrderRedeliveryResponsibleEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderRedeliveryResponsibleEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminOrderDtoOutputOrderRedeliveryResponsibleEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminOrderDtoOutputOrderRedeliveryResponsibleEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminOrderDtoOutputOrderRedelivery
    extends AdminOrderDtoOutputOrderRedelivery {
  @override
  final String ofOrderId;
  @override
  final String ofNumber;
  @override
  final String ticketId;
  @override
  final AdminOrderDtoOutputOrderRedeliveryResponsibleEnum responsible;
  @override
  final bool chargePay;

  factory _$AdminOrderDtoOutputOrderRedelivery([
    void Function(AdminOrderDtoOutputOrderRedeliveryBuilder)? updates,
  ]) => (AdminOrderDtoOutputOrderRedeliveryBuilder()..update(updates))._build();

  _$AdminOrderDtoOutputOrderRedelivery._({
    required this.ofOrderId,
    required this.ofNumber,
    required this.ticketId,
    required this.responsible,
    required this.chargePay,
  }) : super._();
  @override
  AdminOrderDtoOutputOrderRedelivery rebuild(
    void Function(AdminOrderDtoOutputOrderRedeliveryBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderDtoOutputOrderRedeliveryBuilder toBuilder() =>
      AdminOrderDtoOutputOrderRedeliveryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderDtoOutputOrderRedelivery &&
        ofOrderId == other.ofOrderId &&
        ofNumber == other.ofNumber &&
        ticketId == other.ticketId &&
        responsible == other.responsible &&
        chargePay == other.chargePay;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ofOrderId.hashCode);
    _$hash = $jc(_$hash, ofNumber.hashCode);
    _$hash = $jc(_$hash, ticketId.hashCode);
    _$hash = $jc(_$hash, responsible.hashCode);
    _$hash = $jc(_$hash, chargePay.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminOrderDtoOutputOrderRedelivery')
          ..add('ofOrderId', ofOrderId)
          ..add('ofNumber', ofNumber)
          ..add('ticketId', ticketId)
          ..add('responsible', responsible)
          ..add('chargePay', chargePay))
        .toString();
  }
}

class AdminOrderDtoOutputOrderRedeliveryBuilder
    implements
        Builder<
          AdminOrderDtoOutputOrderRedelivery,
          AdminOrderDtoOutputOrderRedeliveryBuilder
        > {
  _$AdminOrderDtoOutputOrderRedelivery? _$v;

  String? _ofOrderId;
  String? get ofOrderId => _$this._ofOrderId;
  set ofOrderId(String? ofOrderId) => _$this._ofOrderId = ofOrderId;

  String? _ofNumber;
  String? get ofNumber => _$this._ofNumber;
  set ofNumber(String? ofNumber) => _$this._ofNumber = ofNumber;

  String? _ticketId;
  String? get ticketId => _$this._ticketId;
  set ticketId(String? ticketId) => _$this._ticketId = ticketId;

  AdminOrderDtoOutputOrderRedeliveryResponsibleEnum? _responsible;
  AdminOrderDtoOutputOrderRedeliveryResponsibleEnum? get responsible =>
      _$this._responsible;
  set responsible(
    AdminOrderDtoOutputOrderRedeliveryResponsibleEnum? responsible,
  ) => _$this._responsible = responsible;

  bool? _chargePay;
  bool? get chargePay => _$this._chargePay;
  set chargePay(bool? chargePay) => _$this._chargePay = chargePay;

  AdminOrderDtoOutputOrderRedeliveryBuilder() {
    AdminOrderDtoOutputOrderRedelivery._defaults(this);
  }

  AdminOrderDtoOutputOrderRedeliveryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ofOrderId = $v.ofOrderId;
      _ofNumber = $v.ofNumber;
      _ticketId = $v.ticketId;
      _responsible = $v.responsible;
      _chargePay = $v.chargePay;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderDtoOutputOrderRedelivery other) {
    _$v = other as _$AdminOrderDtoOutputOrderRedelivery;
  }

  @override
  void update(
    void Function(AdminOrderDtoOutputOrderRedeliveryBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderDtoOutputOrderRedelivery build() => _build();

  _$AdminOrderDtoOutputOrderRedelivery _build() {
    final _$result =
        _$v ??
        _$AdminOrderDtoOutputOrderRedelivery._(
          ofOrderId: BuiltValueNullFieldError.checkNotNull(
            ofOrderId,
            r'AdminOrderDtoOutputOrderRedelivery',
            'ofOrderId',
          ),
          ofNumber: BuiltValueNullFieldError.checkNotNull(
            ofNumber,
            r'AdminOrderDtoOutputOrderRedelivery',
            'ofNumber',
          ),
          ticketId: BuiltValueNullFieldError.checkNotNull(
            ticketId,
            r'AdminOrderDtoOutputOrderRedelivery',
            'ticketId',
          ),
          responsible: BuiltValueNullFieldError.checkNotNull(
            responsible,
            r'AdminOrderDtoOutputOrderRedelivery',
            'responsible',
          ),
          chargePay: BuiltValueNullFieldError.checkNotNull(
            chargePay,
            r'AdminOrderDtoOutputOrderRedelivery',
            'chargePay',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
