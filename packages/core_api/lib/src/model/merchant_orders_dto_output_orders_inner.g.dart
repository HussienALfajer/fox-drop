// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_orders_dto_output_orders_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MerchantOrdersDtoOutputOrdersInnerStatusEnum
_$merchantOrdersDtoOutputOrdersInnerStatusEnum_placed =
    const MerchantOrdersDtoOutputOrdersInnerStatusEnum._('placed');
const MerchantOrdersDtoOutputOrdersInnerStatusEnum
_$merchantOrdersDtoOutputOrdersInnerStatusEnum_accepted =
    const MerchantOrdersDtoOutputOrdersInnerStatusEnum._('accepted');
const MerchantOrdersDtoOutputOrdersInnerStatusEnum
_$merchantOrdersDtoOutputOrdersInnerStatusEnum_ready =
    const MerchantOrdersDtoOutputOrdersInnerStatusEnum._('ready');
const MerchantOrdersDtoOutputOrdersInnerStatusEnum
_$merchantOrdersDtoOutputOrdersInnerStatusEnum_pickedUp =
    const MerchantOrdersDtoOutputOrdersInnerStatusEnum._('pickedUp');
const MerchantOrdersDtoOutputOrdersInnerStatusEnum
_$merchantOrdersDtoOutputOrdersInnerStatusEnum_arrived =
    const MerchantOrdersDtoOutputOrdersInnerStatusEnum._('arrived');
const MerchantOrdersDtoOutputOrdersInnerStatusEnum
_$merchantOrdersDtoOutputOrdersInnerStatusEnum_delivered =
    const MerchantOrdersDtoOutputOrdersInnerStatusEnum._('delivered');
const MerchantOrdersDtoOutputOrdersInnerStatusEnum
_$merchantOrdersDtoOutputOrdersInnerStatusEnum_rejected =
    const MerchantOrdersDtoOutputOrdersInnerStatusEnum._('rejected');
const MerchantOrdersDtoOutputOrdersInnerStatusEnum
_$merchantOrdersDtoOutputOrdersInnerStatusEnum_cancelled =
    const MerchantOrdersDtoOutputOrdersInnerStatusEnum._('cancelled');
const MerchantOrdersDtoOutputOrdersInnerStatusEnum
_$merchantOrdersDtoOutputOrdersInnerStatusEnum_failed =
    const MerchantOrdersDtoOutputOrdersInnerStatusEnum._('failed');

MerchantOrdersDtoOutputOrdersInnerStatusEnum
_$merchantOrdersDtoOutputOrdersInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'placed':
      return _$merchantOrdersDtoOutputOrdersInnerStatusEnum_placed;
    case 'accepted':
      return _$merchantOrdersDtoOutputOrdersInnerStatusEnum_accepted;
    case 'ready':
      return _$merchantOrdersDtoOutputOrdersInnerStatusEnum_ready;
    case 'pickedUp':
      return _$merchantOrdersDtoOutputOrdersInnerStatusEnum_pickedUp;
    case 'arrived':
      return _$merchantOrdersDtoOutputOrdersInnerStatusEnum_arrived;
    case 'delivered':
      return _$merchantOrdersDtoOutputOrdersInnerStatusEnum_delivered;
    case 'rejected':
      return _$merchantOrdersDtoOutputOrdersInnerStatusEnum_rejected;
    case 'cancelled':
      return _$merchantOrdersDtoOutputOrdersInnerStatusEnum_cancelled;
    case 'failed':
      return _$merchantOrdersDtoOutputOrdersInnerStatusEnum_failed;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MerchantOrdersDtoOutputOrdersInnerStatusEnum>
_$merchantOrdersDtoOutputOrdersInnerStatusEnumValues =
    BuiltSet<MerchantOrdersDtoOutputOrdersInnerStatusEnum>(
      const <MerchantOrdersDtoOutputOrdersInnerStatusEnum>[
        _$merchantOrdersDtoOutputOrdersInnerStatusEnum_placed,
        _$merchantOrdersDtoOutputOrdersInnerStatusEnum_accepted,
        _$merchantOrdersDtoOutputOrdersInnerStatusEnum_ready,
        _$merchantOrdersDtoOutputOrdersInnerStatusEnum_pickedUp,
        _$merchantOrdersDtoOutputOrdersInnerStatusEnum_arrived,
        _$merchantOrdersDtoOutputOrdersInnerStatusEnum_delivered,
        _$merchantOrdersDtoOutputOrdersInnerStatusEnum_rejected,
        _$merchantOrdersDtoOutputOrdersInnerStatusEnum_cancelled,
        _$merchantOrdersDtoOutputOrdersInnerStatusEnum_failed,
      ],
    );

Serializer<MerchantOrdersDtoOutputOrdersInnerStatusEnum>
_$merchantOrdersDtoOutputOrdersInnerStatusEnumSerializer =
    _$MerchantOrdersDtoOutputOrdersInnerStatusEnumSerializer();

class _$MerchantOrdersDtoOutputOrdersInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<MerchantOrdersDtoOutputOrdersInnerStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'placed': 'placed',
    'accepted': 'accepted',
    'ready': 'ready',
    'pickedUp': 'picked_up',
    'arrived': 'arrived',
    'delivered': 'delivered',
    'rejected': 'rejected',
    'cancelled': 'cancelled',
    'failed': 'failed',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'placed': 'placed',
    'accepted': 'accepted',
    'ready': 'ready',
    'picked_up': 'pickedUp',
    'arrived': 'arrived',
    'delivered': 'delivered',
    'rejected': 'rejected',
    'cancelled': 'cancelled',
    'failed': 'failed',
  };

  @override
  final Iterable<Type> types = const <Type>[
    MerchantOrdersDtoOutputOrdersInnerStatusEnum,
  ];
  @override
  final String wireName = 'MerchantOrdersDtoOutputOrdersInnerStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    MerchantOrdersDtoOutputOrdersInnerStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MerchantOrdersDtoOutputOrdersInnerStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => MerchantOrdersDtoOutputOrdersInnerStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$MerchantOrdersDtoOutputOrdersInner
    extends MerchantOrdersDtoOutputOrdersInner {
  @override
  final String id;
  @override
  final String number;
  @override
  final MerchantOrdersDtoOutputOrdersInnerStatusEnum status;
  @override
  final int version;
  @override
  final DateTime placedAt;
  @override
  final DateTime? acceptAlertAt;
  @override
  final DateTime? autoCancelAt;
  @override
  final MerchantOrdersDtoOutputOrdersInnerCustomer customer;
  @override
  final String? note;
  @override
  final BuiltList<MerchantOrdersDtoOutputOrdersInnerLinesInner> lines;
  @override
  final String currency;
  @override
  final String itemsValue;

  factory _$MerchantOrdersDtoOutputOrdersInner([
    void Function(MerchantOrdersDtoOutputOrdersInnerBuilder)? updates,
  ]) => (MerchantOrdersDtoOutputOrdersInnerBuilder()..update(updates))._build();

  _$MerchantOrdersDtoOutputOrdersInner._({
    required this.id,
    required this.number,
    required this.status,
    required this.version,
    required this.placedAt,
    this.acceptAlertAt,
    this.autoCancelAt,
    required this.customer,
    this.note,
    required this.lines,
    required this.currency,
    required this.itemsValue,
  }) : super._();
  @override
  MerchantOrdersDtoOutputOrdersInner rebuild(
    void Function(MerchantOrdersDtoOutputOrdersInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantOrdersDtoOutputOrdersInnerBuilder toBuilder() =>
      MerchantOrdersDtoOutputOrdersInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantOrdersDtoOutputOrdersInner &&
        id == other.id &&
        number == other.number &&
        status == other.status &&
        version == other.version &&
        placedAt == other.placedAt &&
        acceptAlertAt == other.acceptAlertAt &&
        autoCancelAt == other.autoCancelAt &&
        customer == other.customer &&
        note == other.note &&
        lines == other.lines &&
        currency == other.currency &&
        itemsValue == other.itemsValue;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, number.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, placedAt.hashCode);
    _$hash = $jc(_$hash, acceptAlertAt.hashCode);
    _$hash = $jc(_$hash, autoCancelAt.hashCode);
    _$hash = $jc(_$hash, customer.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, itemsValue.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantOrdersDtoOutputOrdersInner')
          ..add('id', id)
          ..add('number', number)
          ..add('status', status)
          ..add('version', version)
          ..add('placedAt', placedAt)
          ..add('acceptAlertAt', acceptAlertAt)
          ..add('autoCancelAt', autoCancelAt)
          ..add('customer', customer)
          ..add('note', note)
          ..add('lines', lines)
          ..add('currency', currency)
          ..add('itemsValue', itemsValue))
        .toString();
  }
}

class MerchantOrdersDtoOutputOrdersInnerBuilder
    implements
        Builder<
          MerchantOrdersDtoOutputOrdersInner,
          MerchantOrdersDtoOutputOrdersInnerBuilder
        > {
  _$MerchantOrdersDtoOutputOrdersInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _number;
  String? get number => _$this._number;
  set number(String? number) => _$this._number = number;

  MerchantOrdersDtoOutputOrdersInnerStatusEnum? _status;
  MerchantOrdersDtoOutputOrdersInnerStatusEnum? get status => _$this._status;
  set status(MerchantOrdersDtoOutputOrdersInnerStatusEnum? status) =>
      _$this._status = status;

  int? _version;
  int? get version => _$this._version;
  set version(int? version) => _$this._version = version;

  DateTime? _placedAt;
  DateTime? get placedAt => _$this._placedAt;
  set placedAt(DateTime? placedAt) => _$this._placedAt = placedAt;

  DateTime? _acceptAlertAt;
  DateTime? get acceptAlertAt => _$this._acceptAlertAt;
  set acceptAlertAt(DateTime? acceptAlertAt) =>
      _$this._acceptAlertAt = acceptAlertAt;

  DateTime? _autoCancelAt;
  DateTime? get autoCancelAt => _$this._autoCancelAt;
  set autoCancelAt(DateTime? autoCancelAt) =>
      _$this._autoCancelAt = autoCancelAt;

  MerchantOrdersDtoOutputOrdersInnerCustomerBuilder? _customer;
  MerchantOrdersDtoOutputOrdersInnerCustomerBuilder get customer =>
      _$this._customer ??= MerchantOrdersDtoOutputOrdersInnerCustomerBuilder();
  set customer(MerchantOrdersDtoOutputOrdersInnerCustomerBuilder? customer) =>
      _$this._customer = customer;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  ListBuilder<MerchantOrdersDtoOutputOrdersInnerLinesInner>? _lines;
  ListBuilder<MerchantOrdersDtoOutputOrdersInnerLinesInner> get lines =>
      _$this._lines ??=
          ListBuilder<MerchantOrdersDtoOutputOrdersInnerLinesInner>();
  set lines(ListBuilder<MerchantOrdersDtoOutputOrdersInnerLinesInner>? lines) =>
      _$this._lines = lines;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  String? _itemsValue;
  String? get itemsValue => _$this._itemsValue;
  set itemsValue(String? itemsValue) => _$this._itemsValue = itemsValue;

  MerchantOrdersDtoOutputOrdersInnerBuilder() {
    MerchantOrdersDtoOutputOrdersInner._defaults(this);
  }

  MerchantOrdersDtoOutputOrdersInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _number = $v.number;
      _status = $v.status;
      _version = $v.version;
      _placedAt = $v.placedAt;
      _acceptAlertAt = $v.acceptAlertAt;
      _autoCancelAt = $v.autoCancelAt;
      _customer = $v.customer.toBuilder();
      _note = $v.note;
      _lines = $v.lines.toBuilder();
      _currency = $v.currency;
      _itemsValue = $v.itemsValue;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantOrdersDtoOutputOrdersInner other) {
    _$v = other as _$MerchantOrdersDtoOutputOrdersInner;
  }

  @override
  void update(
    void Function(MerchantOrdersDtoOutputOrdersInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantOrdersDtoOutputOrdersInner build() => _build();

  _$MerchantOrdersDtoOutputOrdersInner _build() {
    _$MerchantOrdersDtoOutputOrdersInner _$result;
    try {
      _$result =
          _$v ??
          _$MerchantOrdersDtoOutputOrdersInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'MerchantOrdersDtoOutputOrdersInner',
              'id',
            ),
            number: BuiltValueNullFieldError.checkNotNull(
              number,
              r'MerchantOrdersDtoOutputOrdersInner',
              'number',
            ),
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'MerchantOrdersDtoOutputOrdersInner',
              'status',
            ),
            version: BuiltValueNullFieldError.checkNotNull(
              version,
              r'MerchantOrdersDtoOutputOrdersInner',
              'version',
            ),
            placedAt: BuiltValueNullFieldError.checkNotNull(
              placedAt,
              r'MerchantOrdersDtoOutputOrdersInner',
              'placedAt',
            ),
            acceptAlertAt: acceptAlertAt,
            autoCancelAt: autoCancelAt,
            customer: customer.build(),
            note: note,
            lines: lines.build(),
            currency: BuiltValueNullFieldError.checkNotNull(
              currency,
              r'MerchantOrdersDtoOutputOrdersInner',
              'currency',
            ),
            itemsValue: BuiltValueNullFieldError.checkNotNull(
              itemsValue,
              r'MerchantOrdersDtoOutputOrdersInner',
              'itemsValue',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'customer';
        customer.build();

        _$failedField = 'lines';
        lines.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantOrdersDtoOutputOrdersInner',
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
