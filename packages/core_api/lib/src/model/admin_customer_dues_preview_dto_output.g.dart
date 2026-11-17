// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_customer_dues_preview_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCustomerDuesPreviewDtoOutput
    extends AdminCustomerDuesPreviewDtoOutput {
  @override
  final String customerId;
  @override
  final String customerName;
  @override
  final String cityId;
  @override
  final String currency;
  @override
  final String due;
  @override
  final BuiltList<AdminRestaurantSettlementPreviewDtoOutputLinesInner> lines;
  @override
  final String total;
  @override
  final String remaining;

  factory _$AdminCustomerDuesPreviewDtoOutput([
    void Function(AdminCustomerDuesPreviewDtoOutputBuilder)? updates,
  ]) => (AdminCustomerDuesPreviewDtoOutputBuilder()..update(updates))._build();

  _$AdminCustomerDuesPreviewDtoOutput._({
    required this.customerId,
    required this.customerName,
    required this.cityId,
    required this.currency,
    required this.due,
    required this.lines,
    required this.total,
    required this.remaining,
  }) : super._();
  @override
  AdminCustomerDuesPreviewDtoOutput rebuild(
    void Function(AdminCustomerDuesPreviewDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCustomerDuesPreviewDtoOutputBuilder toBuilder() =>
      AdminCustomerDuesPreviewDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCustomerDuesPreviewDtoOutput &&
        customerId == other.customerId &&
        customerName == other.customerName &&
        cityId == other.cityId &&
        currency == other.currency &&
        due == other.due &&
        lines == other.lines &&
        total == other.total &&
        remaining == other.remaining;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, customerId.hashCode);
    _$hash = $jc(_$hash, customerName.hashCode);
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, due.hashCode);
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, remaining.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminCustomerDuesPreviewDtoOutput')
          ..add('customerId', customerId)
          ..add('customerName', customerName)
          ..add('cityId', cityId)
          ..add('currency', currency)
          ..add('due', due)
          ..add('lines', lines)
          ..add('total', total)
          ..add('remaining', remaining))
        .toString();
  }
}

class AdminCustomerDuesPreviewDtoOutputBuilder
    implements
        Builder<
          AdminCustomerDuesPreviewDtoOutput,
          AdminCustomerDuesPreviewDtoOutputBuilder
        > {
  _$AdminCustomerDuesPreviewDtoOutput? _$v;

  String? _customerId;
  String? get customerId => _$this._customerId;
  set customerId(String? customerId) => _$this._customerId = customerId;

  String? _customerName;
  String? get customerName => _$this._customerName;
  set customerName(String? customerName) => _$this._customerName = customerName;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  String? _due;
  String? get due => _$this._due;
  set due(String? due) => _$this._due = due;

  ListBuilder<AdminRestaurantSettlementPreviewDtoOutputLinesInner>? _lines;
  ListBuilder<AdminRestaurantSettlementPreviewDtoOutputLinesInner> get lines =>
      _$this._lines ??=
          ListBuilder<AdminRestaurantSettlementPreviewDtoOutputLinesInner>();
  set lines(
    ListBuilder<AdminRestaurantSettlementPreviewDtoOutputLinesInner>? lines,
  ) => _$this._lines = lines;

  String? _total;
  String? get total => _$this._total;
  set total(String? total) => _$this._total = total;

  String? _remaining;
  String? get remaining => _$this._remaining;
  set remaining(String? remaining) => _$this._remaining = remaining;

  AdminCustomerDuesPreviewDtoOutputBuilder() {
    AdminCustomerDuesPreviewDtoOutput._defaults(this);
  }

  AdminCustomerDuesPreviewDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _customerId = $v.customerId;
      _customerName = $v.customerName;
      _cityId = $v.cityId;
      _currency = $v.currency;
      _due = $v.due;
      _lines = $v.lines.toBuilder();
      _total = $v.total;
      _remaining = $v.remaining;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCustomerDuesPreviewDtoOutput other) {
    _$v = other as _$AdminCustomerDuesPreviewDtoOutput;
  }

  @override
  void update(
    void Function(AdminCustomerDuesPreviewDtoOutputBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCustomerDuesPreviewDtoOutput build() => _build();

  _$AdminCustomerDuesPreviewDtoOutput _build() {
    _$AdminCustomerDuesPreviewDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminCustomerDuesPreviewDtoOutput._(
            customerId: BuiltValueNullFieldError.checkNotNull(
              customerId,
              r'AdminCustomerDuesPreviewDtoOutput',
              'customerId',
            ),
            customerName: BuiltValueNullFieldError.checkNotNull(
              customerName,
              r'AdminCustomerDuesPreviewDtoOutput',
              'customerName',
            ),
            cityId: BuiltValueNullFieldError.checkNotNull(
              cityId,
              r'AdminCustomerDuesPreviewDtoOutput',
              'cityId',
            ),
            currency: BuiltValueNullFieldError.checkNotNull(
              currency,
              r'AdminCustomerDuesPreviewDtoOutput',
              'currency',
            ),
            due: BuiltValueNullFieldError.checkNotNull(
              due,
              r'AdminCustomerDuesPreviewDtoOutput',
              'due',
            ),
            lines: lines.build(),
            total: BuiltValueNullFieldError.checkNotNull(
              total,
              r'AdminCustomerDuesPreviewDtoOutput',
              'total',
            ),
            remaining: BuiltValueNullFieldError.checkNotNull(
              remaining,
              r'AdminCustomerDuesPreviewDtoOutput',
              'remaining',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lines';
        lines.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminCustomerDuesPreviewDtoOutput',
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
