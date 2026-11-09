// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_place_order_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerPlaceOrderDto extends CustomerPlaceOrderDto {
  @override
  final String restaurantId;
  @override
  final BuiltList<CustomerQuoteRequestDtoLinesInner> lines;
  @override
  final String? payIn;
  @override
  final String appVersion;
  @override
  final String quoteVersion;
  @override
  final String? addressId;
  @override
  final CustomerPlaceOrderDtoUnsavedAddress? unsavedAddress;
  @override
  final String? note;

  factory _$CustomerPlaceOrderDto([
    void Function(CustomerPlaceOrderDtoBuilder)? updates,
  ]) => (CustomerPlaceOrderDtoBuilder()..update(updates))._build();

  _$CustomerPlaceOrderDto._({
    required this.restaurantId,
    required this.lines,
    this.payIn,
    required this.appVersion,
    required this.quoteVersion,
    this.addressId,
    this.unsavedAddress,
    this.note,
  }) : super._();
  @override
  CustomerPlaceOrderDto rebuild(
    void Function(CustomerPlaceOrderDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerPlaceOrderDtoBuilder toBuilder() =>
      CustomerPlaceOrderDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerPlaceOrderDto &&
        restaurantId == other.restaurantId &&
        lines == other.lines &&
        payIn == other.payIn &&
        appVersion == other.appVersion &&
        quoteVersion == other.quoteVersion &&
        addressId == other.addressId &&
        unsavedAddress == other.unsavedAddress &&
        note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, restaurantId.hashCode);
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jc(_$hash, payIn.hashCode);
    _$hash = $jc(_$hash, appVersion.hashCode);
    _$hash = $jc(_$hash, quoteVersion.hashCode);
    _$hash = $jc(_$hash, addressId.hashCode);
    _$hash = $jc(_$hash, unsavedAddress.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CustomerPlaceOrderDto')
          ..add('restaurantId', restaurantId)
          ..add('lines', lines)
          ..add('payIn', payIn)
          ..add('appVersion', appVersion)
          ..add('quoteVersion', quoteVersion)
          ..add('addressId', addressId)
          ..add('unsavedAddress', unsavedAddress)
          ..add('note', note))
        .toString();
  }
}

class CustomerPlaceOrderDtoBuilder
    implements Builder<CustomerPlaceOrderDto, CustomerPlaceOrderDtoBuilder> {
  _$CustomerPlaceOrderDto? _$v;

  String? _restaurantId;
  String? get restaurantId => _$this._restaurantId;
  set restaurantId(String? restaurantId) => _$this._restaurantId = restaurantId;

  ListBuilder<CustomerQuoteRequestDtoLinesInner>? _lines;
  ListBuilder<CustomerQuoteRequestDtoLinesInner> get lines =>
      _$this._lines ??= ListBuilder<CustomerQuoteRequestDtoLinesInner>();
  set lines(ListBuilder<CustomerQuoteRequestDtoLinesInner>? lines) =>
      _$this._lines = lines;

  String? _payIn;
  String? get payIn => _$this._payIn;
  set payIn(String? payIn) => _$this._payIn = payIn;

  String? _appVersion;
  String? get appVersion => _$this._appVersion;
  set appVersion(String? appVersion) => _$this._appVersion = appVersion;

  String? _quoteVersion;
  String? get quoteVersion => _$this._quoteVersion;
  set quoteVersion(String? quoteVersion) => _$this._quoteVersion = quoteVersion;

  String? _addressId;
  String? get addressId => _$this._addressId;
  set addressId(String? addressId) => _$this._addressId = addressId;

  CustomerPlaceOrderDtoUnsavedAddressBuilder? _unsavedAddress;
  CustomerPlaceOrderDtoUnsavedAddressBuilder get unsavedAddress =>
      _$this._unsavedAddress ??= CustomerPlaceOrderDtoUnsavedAddressBuilder();
  set unsavedAddress(
    CustomerPlaceOrderDtoUnsavedAddressBuilder? unsavedAddress,
  ) => _$this._unsavedAddress = unsavedAddress;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  CustomerPlaceOrderDtoBuilder() {
    CustomerPlaceOrderDto._defaults(this);
  }

  CustomerPlaceOrderDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _restaurantId = $v.restaurantId;
      _lines = $v.lines.toBuilder();
      _payIn = $v.payIn;
      _appVersion = $v.appVersion;
      _quoteVersion = $v.quoteVersion;
      _addressId = $v.addressId;
      _unsavedAddress = $v.unsavedAddress?.toBuilder();
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerPlaceOrderDto other) {
    _$v = other as _$CustomerPlaceOrderDto;
  }

  @override
  void update(void Function(CustomerPlaceOrderDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerPlaceOrderDto build() => _build();

  _$CustomerPlaceOrderDto _build() {
    _$CustomerPlaceOrderDto _$result;
    try {
      _$result =
          _$v ??
          _$CustomerPlaceOrderDto._(
            restaurantId: BuiltValueNullFieldError.checkNotNull(
              restaurantId,
              r'CustomerPlaceOrderDto',
              'restaurantId',
            ),
            lines: lines.build(),
            payIn: payIn,
            appVersion: BuiltValueNullFieldError.checkNotNull(
              appVersion,
              r'CustomerPlaceOrderDto',
              'appVersion',
            ),
            quoteVersion: BuiltValueNullFieldError.checkNotNull(
              quoteVersion,
              r'CustomerPlaceOrderDto',
              'quoteVersion',
            ),
            addressId: addressId,
            unsavedAddress: _unsavedAddress?.build(),
            note: note,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lines';
        lines.build();

        _$failedField = 'unsavedAddress';
        _unsavedAddress?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CustomerPlaceOrderDto',
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
