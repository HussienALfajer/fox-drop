// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_customer_dues_pay_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCustomerDuesPayDto extends AdminCustomerDuesPayDto {
  @override
  final String cityId;
  @override
  final String customerId;
  @override
  final String due;
  @override
  final BuiltList<AdminRestaurantSettleDtoLinesInner> lines;

  factory _$AdminCustomerDuesPayDto([
    void Function(AdminCustomerDuesPayDtoBuilder)? updates,
  ]) => (AdminCustomerDuesPayDtoBuilder()..update(updates))._build();

  _$AdminCustomerDuesPayDto._({
    required this.cityId,
    required this.customerId,
    required this.due,
    required this.lines,
  }) : super._();
  @override
  AdminCustomerDuesPayDto rebuild(
    void Function(AdminCustomerDuesPayDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCustomerDuesPayDtoBuilder toBuilder() =>
      AdminCustomerDuesPayDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCustomerDuesPayDto &&
        cityId == other.cityId &&
        customerId == other.customerId &&
        due == other.due &&
        lines == other.lines;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, customerId.hashCode);
    _$hash = $jc(_$hash, due.hashCode);
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminCustomerDuesPayDto')
          ..add('cityId', cityId)
          ..add('customerId', customerId)
          ..add('due', due)
          ..add('lines', lines))
        .toString();
  }
}

class AdminCustomerDuesPayDtoBuilder
    implements
        Builder<AdminCustomerDuesPayDto, AdminCustomerDuesPayDtoBuilder> {
  _$AdminCustomerDuesPayDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  String? _customerId;
  String? get customerId => _$this._customerId;
  set customerId(String? customerId) => _$this._customerId = customerId;

  String? _due;
  String? get due => _$this._due;
  set due(String? due) => _$this._due = due;

  ListBuilder<AdminRestaurantSettleDtoLinesInner>? _lines;
  ListBuilder<AdminRestaurantSettleDtoLinesInner> get lines =>
      _$this._lines ??= ListBuilder<AdminRestaurantSettleDtoLinesInner>();
  set lines(ListBuilder<AdminRestaurantSettleDtoLinesInner>? lines) =>
      _$this._lines = lines;

  AdminCustomerDuesPayDtoBuilder() {
    AdminCustomerDuesPayDto._defaults(this);
  }

  AdminCustomerDuesPayDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _customerId = $v.customerId;
      _due = $v.due;
      _lines = $v.lines.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCustomerDuesPayDto other) {
    _$v = other as _$AdminCustomerDuesPayDto;
  }

  @override
  void update(void Function(AdminCustomerDuesPayDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCustomerDuesPayDto build() => _build();

  _$AdminCustomerDuesPayDto _build() {
    _$AdminCustomerDuesPayDto _$result;
    try {
      _$result =
          _$v ??
          _$AdminCustomerDuesPayDto._(
            cityId: BuiltValueNullFieldError.checkNotNull(
              cityId,
              r'AdminCustomerDuesPayDto',
              'cityId',
            ),
            customerId: BuiltValueNullFieldError.checkNotNull(
              customerId,
              r'AdminCustomerDuesPayDto',
              'customerId',
            ),
            due: BuiltValueNullFieldError.checkNotNull(
              due,
              r'AdminCustomerDuesPayDto',
              'due',
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
          r'AdminCustomerDuesPayDto',
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
