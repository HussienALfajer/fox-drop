// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_receipt_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminRestaurantReceiptDtoOutputTypeEnum
_$adminRestaurantReceiptDtoOutputTypeEnum_merchantSettlement =
    const AdminRestaurantReceiptDtoOutputTypeEnum._('merchantSettlement');
const AdminRestaurantReceiptDtoOutputTypeEnum
_$adminRestaurantReceiptDtoOutputTypeEnum_merchantPayout =
    const AdminRestaurantReceiptDtoOutputTypeEnum._('merchantPayout');

AdminRestaurantReceiptDtoOutputTypeEnum
_$adminRestaurantReceiptDtoOutputTypeEnumValueOf(String name) {
  switch (name) {
    case 'merchantSettlement':
      return _$adminRestaurantReceiptDtoOutputTypeEnum_merchantSettlement;
    case 'merchantPayout':
      return _$adminRestaurantReceiptDtoOutputTypeEnum_merchantPayout;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminRestaurantReceiptDtoOutputTypeEnum>
_$adminRestaurantReceiptDtoOutputTypeEnumValues =
    BuiltSet<AdminRestaurantReceiptDtoOutputTypeEnum>(
      const <AdminRestaurantReceiptDtoOutputTypeEnum>[
        _$adminRestaurantReceiptDtoOutputTypeEnum_merchantSettlement,
        _$adminRestaurantReceiptDtoOutputTypeEnum_merchantPayout,
      ],
    );

const AdminRestaurantReceiptDtoOutputMethodEnum
_$adminRestaurantReceiptDtoOutputMethodEnum_office =
    const AdminRestaurantReceiptDtoOutputMethodEnum._('office');

AdminRestaurantReceiptDtoOutputMethodEnum
_$adminRestaurantReceiptDtoOutputMethodEnumValueOf(String name) {
  switch (name) {
    case 'office':
      return _$adminRestaurantReceiptDtoOutputMethodEnum_office;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminRestaurantReceiptDtoOutputMethodEnum>
_$adminRestaurantReceiptDtoOutputMethodEnumValues =
    BuiltSet<AdminRestaurantReceiptDtoOutputMethodEnum>(
      const <AdminRestaurantReceiptDtoOutputMethodEnum>[
        _$adminRestaurantReceiptDtoOutputMethodEnum_office,
      ],
    );

Serializer<AdminRestaurantReceiptDtoOutputTypeEnum>
_$adminRestaurantReceiptDtoOutputTypeEnumSerializer =
    _$AdminRestaurantReceiptDtoOutputTypeEnumSerializer();
Serializer<AdminRestaurantReceiptDtoOutputMethodEnum>
_$adminRestaurantReceiptDtoOutputMethodEnumSerializer =
    _$AdminRestaurantReceiptDtoOutputMethodEnumSerializer();

class _$AdminRestaurantReceiptDtoOutputTypeEnumSerializer
    implements PrimitiveSerializer<AdminRestaurantReceiptDtoOutputTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'merchantSettlement': 'merchant_settlement',
    'merchantPayout': 'merchant_payout',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'merchant_settlement': 'merchantSettlement',
    'merchant_payout': 'merchantPayout',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminRestaurantReceiptDtoOutputTypeEnum,
  ];
  @override
  final String wireName = 'AdminRestaurantReceiptDtoOutputTypeEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantReceiptDtoOutputTypeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminRestaurantReceiptDtoOutputTypeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminRestaurantReceiptDtoOutputTypeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminRestaurantReceiptDtoOutputMethodEnumSerializer
    implements PrimitiveSerializer<AdminRestaurantReceiptDtoOutputMethodEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'office': 'office',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'office': 'office',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminRestaurantReceiptDtoOutputMethodEnum,
  ];
  @override
  final String wireName = 'AdminRestaurantReceiptDtoOutputMethodEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantReceiptDtoOutputMethodEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminRestaurantReceiptDtoOutputMethodEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminRestaurantReceiptDtoOutputMethodEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminRestaurantReceiptDtoOutput
    extends AdminRestaurantReceiptDtoOutput {
  @override
  final String id;
  @override
  final String cityId;
  @override
  final String number;
  @override
  final AdminRestaurantReceiptDtoOutputTypeEnum type;
  @override
  final String sessionId;
  @override
  final AdminRestaurantReceiptDtoOutputMethodEnum method;
  @override
  final String cashierId;
  @override
  final String? cashierName;
  @override
  final String restaurantId;
  @override
  final String restaurantName;
  @override
  final String currency;
  @override
  final String dueBefore;
  @override
  final String total;
  @override
  final String dueAfter;
  @override
  final DateTime createdAt;
  @override
  final BuiltList<AdminRestaurantReceiptDtoOutputLinesInner> lines;

  factory _$AdminRestaurantReceiptDtoOutput([
    void Function(AdminRestaurantReceiptDtoOutputBuilder)? updates,
  ]) => (AdminRestaurantReceiptDtoOutputBuilder()..update(updates))._build();

  _$AdminRestaurantReceiptDtoOutput._({
    required this.id,
    required this.cityId,
    required this.number,
    required this.type,
    required this.sessionId,
    required this.method,
    required this.cashierId,
    this.cashierName,
    required this.restaurantId,
    required this.restaurantName,
    required this.currency,
    required this.dueBefore,
    required this.total,
    required this.dueAfter,
    required this.createdAt,
    required this.lines,
  }) : super._();
  @override
  AdminRestaurantReceiptDtoOutput rebuild(
    void Function(AdminRestaurantReceiptDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantReceiptDtoOutputBuilder toBuilder() =>
      AdminRestaurantReceiptDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantReceiptDtoOutput &&
        id == other.id &&
        cityId == other.cityId &&
        number == other.number &&
        type == other.type &&
        sessionId == other.sessionId &&
        method == other.method &&
        cashierId == other.cashierId &&
        cashierName == other.cashierName &&
        restaurantId == other.restaurantId &&
        restaurantName == other.restaurantName &&
        currency == other.currency &&
        dueBefore == other.dueBefore &&
        total == other.total &&
        dueAfter == other.dueAfter &&
        createdAt == other.createdAt &&
        lines == other.lines;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, number.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, sessionId.hashCode);
    _$hash = $jc(_$hash, method.hashCode);
    _$hash = $jc(_$hash, cashierId.hashCode);
    _$hash = $jc(_$hash, cashierName.hashCode);
    _$hash = $jc(_$hash, restaurantId.hashCode);
    _$hash = $jc(_$hash, restaurantName.hashCode);
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, dueBefore.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, dueAfter.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminRestaurantReceiptDtoOutput')
          ..add('id', id)
          ..add('cityId', cityId)
          ..add('number', number)
          ..add('type', type)
          ..add('sessionId', sessionId)
          ..add('method', method)
          ..add('cashierId', cashierId)
          ..add('cashierName', cashierName)
          ..add('restaurantId', restaurantId)
          ..add('restaurantName', restaurantName)
          ..add('currency', currency)
          ..add('dueBefore', dueBefore)
          ..add('total', total)
          ..add('dueAfter', dueAfter)
          ..add('createdAt', createdAt)
          ..add('lines', lines))
        .toString();
  }
}

class AdminRestaurantReceiptDtoOutputBuilder
    implements
        Builder<
          AdminRestaurantReceiptDtoOutput,
          AdminRestaurantReceiptDtoOutputBuilder
        > {
  _$AdminRestaurantReceiptDtoOutput? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  String? _number;
  String? get number => _$this._number;
  set number(String? number) => _$this._number = number;

  AdminRestaurantReceiptDtoOutputTypeEnum? _type;
  AdminRestaurantReceiptDtoOutputTypeEnum? get type => _$this._type;
  set type(AdminRestaurantReceiptDtoOutputTypeEnum? type) =>
      _$this._type = type;

  String? _sessionId;
  String? get sessionId => _$this._sessionId;
  set sessionId(String? sessionId) => _$this._sessionId = sessionId;

  AdminRestaurantReceiptDtoOutputMethodEnum? _method;
  AdminRestaurantReceiptDtoOutputMethodEnum? get method => _$this._method;
  set method(AdminRestaurantReceiptDtoOutputMethodEnum? method) =>
      _$this._method = method;

  String? _cashierId;
  String? get cashierId => _$this._cashierId;
  set cashierId(String? cashierId) => _$this._cashierId = cashierId;

  String? _cashierName;
  String? get cashierName => _$this._cashierName;
  set cashierName(String? cashierName) => _$this._cashierName = cashierName;

  String? _restaurantId;
  String? get restaurantId => _$this._restaurantId;
  set restaurantId(String? restaurantId) => _$this._restaurantId = restaurantId;

  String? _restaurantName;
  String? get restaurantName => _$this._restaurantName;
  set restaurantName(String? restaurantName) =>
      _$this._restaurantName = restaurantName;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  String? _dueBefore;
  String? get dueBefore => _$this._dueBefore;
  set dueBefore(String? dueBefore) => _$this._dueBefore = dueBefore;

  String? _total;
  String? get total => _$this._total;
  set total(String? total) => _$this._total = total;

  String? _dueAfter;
  String? get dueAfter => _$this._dueAfter;
  set dueAfter(String? dueAfter) => _$this._dueAfter = dueAfter;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  ListBuilder<AdminRestaurantReceiptDtoOutputLinesInner>? _lines;
  ListBuilder<AdminRestaurantReceiptDtoOutputLinesInner> get lines =>
      _$this._lines ??=
          ListBuilder<AdminRestaurantReceiptDtoOutputLinesInner>();
  set lines(ListBuilder<AdminRestaurantReceiptDtoOutputLinesInner>? lines) =>
      _$this._lines = lines;

  AdminRestaurantReceiptDtoOutputBuilder() {
    AdminRestaurantReceiptDtoOutput._defaults(this);
  }

  AdminRestaurantReceiptDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _cityId = $v.cityId;
      _number = $v.number;
      _type = $v.type;
      _sessionId = $v.sessionId;
      _method = $v.method;
      _cashierId = $v.cashierId;
      _cashierName = $v.cashierName;
      _restaurantId = $v.restaurantId;
      _restaurantName = $v.restaurantName;
      _currency = $v.currency;
      _dueBefore = $v.dueBefore;
      _total = $v.total;
      _dueAfter = $v.dueAfter;
      _createdAt = $v.createdAt;
      _lines = $v.lines.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantReceiptDtoOutput other) {
    _$v = other as _$AdminRestaurantReceiptDtoOutput;
  }

  @override
  void update(void Function(AdminRestaurantReceiptDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantReceiptDtoOutput build() => _build();

  _$AdminRestaurantReceiptDtoOutput _build() {
    _$AdminRestaurantReceiptDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminRestaurantReceiptDtoOutput._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AdminRestaurantReceiptDtoOutput',
              'id',
            ),
            cityId: BuiltValueNullFieldError.checkNotNull(
              cityId,
              r'AdminRestaurantReceiptDtoOutput',
              'cityId',
            ),
            number: BuiltValueNullFieldError.checkNotNull(
              number,
              r'AdminRestaurantReceiptDtoOutput',
              'number',
            ),
            type: BuiltValueNullFieldError.checkNotNull(
              type,
              r'AdminRestaurantReceiptDtoOutput',
              'type',
            ),
            sessionId: BuiltValueNullFieldError.checkNotNull(
              sessionId,
              r'AdminRestaurantReceiptDtoOutput',
              'sessionId',
            ),
            method: BuiltValueNullFieldError.checkNotNull(
              method,
              r'AdminRestaurantReceiptDtoOutput',
              'method',
            ),
            cashierId: BuiltValueNullFieldError.checkNotNull(
              cashierId,
              r'AdminRestaurantReceiptDtoOutput',
              'cashierId',
            ),
            cashierName: cashierName,
            restaurantId: BuiltValueNullFieldError.checkNotNull(
              restaurantId,
              r'AdminRestaurantReceiptDtoOutput',
              'restaurantId',
            ),
            restaurantName: BuiltValueNullFieldError.checkNotNull(
              restaurantName,
              r'AdminRestaurantReceiptDtoOutput',
              'restaurantName',
            ),
            currency: BuiltValueNullFieldError.checkNotNull(
              currency,
              r'AdminRestaurantReceiptDtoOutput',
              'currency',
            ),
            dueBefore: BuiltValueNullFieldError.checkNotNull(
              dueBefore,
              r'AdminRestaurantReceiptDtoOutput',
              'dueBefore',
            ),
            total: BuiltValueNullFieldError.checkNotNull(
              total,
              r'AdminRestaurantReceiptDtoOutput',
              'total',
            ),
            dueAfter: BuiltValueNullFieldError.checkNotNull(
              dueAfter,
              r'AdminRestaurantReceiptDtoOutput',
              'dueAfter',
            ),
            createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt,
              r'AdminRestaurantReceiptDtoOutput',
              'createdAt',
            ),
            lines: lines.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lines';
        lines.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminRestaurantReceiptDtoOutput',
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
