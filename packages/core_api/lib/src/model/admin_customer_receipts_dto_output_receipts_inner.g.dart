// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_customer_receipts_dto_output_receipts_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCustomerReceiptsDtoOutputReceiptsInner
    extends AdminCustomerReceiptsDtoOutputReceiptsInner {
  @override
  final String id;
  @override
  final String cityId;
  @override
  final String number;
  @override
  final String sessionId;
  @override
  final String cashierId;
  @override
  final String? cashierName;
  @override
  final String customerId;
  @override
  final String customerName;
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

  factory _$AdminCustomerReceiptsDtoOutputReceiptsInner([
    void Function(AdminCustomerReceiptsDtoOutputReceiptsInnerBuilder)? updates,
  ]) => (AdminCustomerReceiptsDtoOutputReceiptsInnerBuilder()..update(updates))
      ._build();

  _$AdminCustomerReceiptsDtoOutputReceiptsInner._({
    required this.id,
    required this.cityId,
    required this.number,
    required this.sessionId,
    required this.cashierId,
    this.cashierName,
    required this.customerId,
    required this.customerName,
    required this.currency,
    required this.dueBefore,
    required this.total,
    required this.dueAfter,
    required this.createdAt,
    required this.lines,
  }) : super._();
  @override
  AdminCustomerReceiptsDtoOutputReceiptsInner rebuild(
    void Function(AdminCustomerReceiptsDtoOutputReceiptsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCustomerReceiptsDtoOutputReceiptsInnerBuilder toBuilder() =>
      AdminCustomerReceiptsDtoOutputReceiptsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCustomerReceiptsDtoOutputReceiptsInner &&
        id == other.id &&
        cityId == other.cityId &&
        number == other.number &&
        sessionId == other.sessionId &&
        cashierId == other.cashierId &&
        cashierName == other.cashierName &&
        customerId == other.customerId &&
        customerName == other.customerName &&
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
    _$hash = $jc(_$hash, sessionId.hashCode);
    _$hash = $jc(_$hash, cashierId.hashCode);
    _$hash = $jc(_$hash, cashierName.hashCode);
    _$hash = $jc(_$hash, customerId.hashCode);
    _$hash = $jc(_$hash, customerName.hashCode);
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
    return (newBuiltValueToStringHelper(
            r'AdminCustomerReceiptsDtoOutputReceiptsInner',
          )
          ..add('id', id)
          ..add('cityId', cityId)
          ..add('number', number)
          ..add('sessionId', sessionId)
          ..add('cashierId', cashierId)
          ..add('cashierName', cashierName)
          ..add('customerId', customerId)
          ..add('customerName', customerName)
          ..add('currency', currency)
          ..add('dueBefore', dueBefore)
          ..add('total', total)
          ..add('dueAfter', dueAfter)
          ..add('createdAt', createdAt)
          ..add('lines', lines))
        .toString();
  }
}

class AdminCustomerReceiptsDtoOutputReceiptsInnerBuilder
    implements
        Builder<
          AdminCustomerReceiptsDtoOutputReceiptsInner,
          AdminCustomerReceiptsDtoOutputReceiptsInnerBuilder
        > {
  _$AdminCustomerReceiptsDtoOutputReceiptsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  String? _number;
  String? get number => _$this._number;
  set number(String? number) => _$this._number = number;

  String? _sessionId;
  String? get sessionId => _$this._sessionId;
  set sessionId(String? sessionId) => _$this._sessionId = sessionId;

  String? _cashierId;
  String? get cashierId => _$this._cashierId;
  set cashierId(String? cashierId) => _$this._cashierId = cashierId;

  String? _cashierName;
  String? get cashierName => _$this._cashierName;
  set cashierName(String? cashierName) => _$this._cashierName = cashierName;

  String? _customerId;
  String? get customerId => _$this._customerId;
  set customerId(String? customerId) => _$this._customerId = customerId;

  String? _customerName;
  String? get customerName => _$this._customerName;
  set customerName(String? customerName) => _$this._customerName = customerName;

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

  AdminCustomerReceiptsDtoOutputReceiptsInnerBuilder() {
    AdminCustomerReceiptsDtoOutputReceiptsInner._defaults(this);
  }

  AdminCustomerReceiptsDtoOutputReceiptsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _cityId = $v.cityId;
      _number = $v.number;
      _sessionId = $v.sessionId;
      _cashierId = $v.cashierId;
      _cashierName = $v.cashierName;
      _customerId = $v.customerId;
      _customerName = $v.customerName;
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
  void replace(AdminCustomerReceiptsDtoOutputReceiptsInner other) {
    _$v = other as _$AdminCustomerReceiptsDtoOutputReceiptsInner;
  }

  @override
  void update(
    void Function(AdminCustomerReceiptsDtoOutputReceiptsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCustomerReceiptsDtoOutputReceiptsInner build() => _build();

  _$AdminCustomerReceiptsDtoOutputReceiptsInner _build() {
    _$AdminCustomerReceiptsDtoOutputReceiptsInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminCustomerReceiptsDtoOutputReceiptsInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AdminCustomerReceiptsDtoOutputReceiptsInner',
              'id',
            ),
            cityId: BuiltValueNullFieldError.checkNotNull(
              cityId,
              r'AdminCustomerReceiptsDtoOutputReceiptsInner',
              'cityId',
            ),
            number: BuiltValueNullFieldError.checkNotNull(
              number,
              r'AdminCustomerReceiptsDtoOutputReceiptsInner',
              'number',
            ),
            sessionId: BuiltValueNullFieldError.checkNotNull(
              sessionId,
              r'AdminCustomerReceiptsDtoOutputReceiptsInner',
              'sessionId',
            ),
            cashierId: BuiltValueNullFieldError.checkNotNull(
              cashierId,
              r'AdminCustomerReceiptsDtoOutputReceiptsInner',
              'cashierId',
            ),
            cashierName: cashierName,
            customerId: BuiltValueNullFieldError.checkNotNull(
              customerId,
              r'AdminCustomerReceiptsDtoOutputReceiptsInner',
              'customerId',
            ),
            customerName: BuiltValueNullFieldError.checkNotNull(
              customerName,
              r'AdminCustomerReceiptsDtoOutputReceiptsInner',
              'customerName',
            ),
            currency: BuiltValueNullFieldError.checkNotNull(
              currency,
              r'AdminCustomerReceiptsDtoOutputReceiptsInner',
              'currency',
            ),
            dueBefore: BuiltValueNullFieldError.checkNotNull(
              dueBefore,
              r'AdminCustomerReceiptsDtoOutputReceiptsInner',
              'dueBefore',
            ),
            total: BuiltValueNullFieldError.checkNotNull(
              total,
              r'AdminCustomerReceiptsDtoOutputReceiptsInner',
              'total',
            ),
            dueAfter: BuiltValueNullFieldError.checkNotNull(
              dueAfter,
              r'AdminCustomerReceiptsDtoOutputReceiptsInner',
              'dueAfter',
            ),
            createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt,
              r'AdminCustomerReceiptsDtoOutputReceiptsInner',
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
          r'AdminCustomerReceiptsDtoOutputReceiptsInner',
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
