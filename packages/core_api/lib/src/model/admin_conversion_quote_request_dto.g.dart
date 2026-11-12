// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_conversion_quote_request_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminConversionQuoteRequestDto extends AdminConversionQuoteRequestDto {
  @override
  final String cityId;
  @override
  final String from;
  @override
  final String to;
  @override
  final String amount;

  factory _$AdminConversionQuoteRequestDto([
    void Function(AdminConversionQuoteRequestDtoBuilder)? updates,
  ]) => (AdminConversionQuoteRequestDtoBuilder()..update(updates))._build();

  _$AdminConversionQuoteRequestDto._({
    required this.cityId,
    required this.from,
    required this.to,
    required this.amount,
  }) : super._();
  @override
  AdminConversionQuoteRequestDto rebuild(
    void Function(AdminConversionQuoteRequestDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminConversionQuoteRequestDtoBuilder toBuilder() =>
      AdminConversionQuoteRequestDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminConversionQuoteRequestDto &&
        cityId == other.cityId &&
        from == other.from &&
        to == other.to &&
        amount == other.amount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, from.hashCode);
    _$hash = $jc(_$hash, to.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminConversionQuoteRequestDto')
          ..add('cityId', cityId)
          ..add('from', from)
          ..add('to', to)
          ..add('amount', amount))
        .toString();
  }
}

class AdminConversionQuoteRequestDtoBuilder
    implements
        Builder<
          AdminConversionQuoteRequestDto,
          AdminConversionQuoteRequestDtoBuilder
        > {
  _$AdminConversionQuoteRequestDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  String? _from;
  String? get from => _$this._from;
  set from(String? from) => _$this._from = from;

  String? _to;
  String? get to => _$this._to;
  set to(String? to) => _$this._to = to;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  AdminConversionQuoteRequestDtoBuilder() {
    AdminConversionQuoteRequestDto._defaults(this);
  }

  AdminConversionQuoteRequestDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _from = $v.from;
      _to = $v.to;
      _amount = $v.amount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminConversionQuoteRequestDto other) {
    _$v = other as _$AdminConversionQuoteRequestDto;
  }

  @override
  void update(void Function(AdminConversionQuoteRequestDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminConversionQuoteRequestDto build() => _build();

  _$AdminConversionQuoteRequestDto _build() {
    final _$result =
        _$v ??
        _$AdminConversionQuoteRequestDto._(
          cityId: BuiltValueNullFieldError.checkNotNull(
            cityId,
            r'AdminConversionQuoteRequestDto',
            'cityId',
          ),
          from: BuiltValueNullFieldError.checkNotNull(
            from,
            r'AdminConversionQuoteRequestDto',
            'from',
          ),
          to: BuiltValueNullFieldError.checkNotNull(
            to,
            r'AdminConversionQuoteRequestDto',
            'to',
          ),
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminConversionQuoteRequestDto',
            'amount',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
