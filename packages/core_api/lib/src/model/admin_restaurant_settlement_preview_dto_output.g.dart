// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_settlement_preview_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRestaurantSettlementPreviewDtoOutput
    extends AdminRestaurantSettlementPreviewDtoOutput {
  @override
  final String restaurantId;
  @override
  final String restaurantName;
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

  factory _$AdminRestaurantSettlementPreviewDtoOutput([
    void Function(AdminRestaurantSettlementPreviewDtoOutputBuilder)? updates,
  ]) => (AdminRestaurantSettlementPreviewDtoOutputBuilder()..update(updates))
      ._build();

  _$AdminRestaurantSettlementPreviewDtoOutput._({
    required this.restaurantId,
    required this.restaurantName,
    required this.cityId,
    required this.currency,
    required this.due,
    required this.lines,
    required this.total,
    required this.remaining,
  }) : super._();
  @override
  AdminRestaurantSettlementPreviewDtoOutput rebuild(
    void Function(AdminRestaurantSettlementPreviewDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantSettlementPreviewDtoOutputBuilder toBuilder() =>
      AdminRestaurantSettlementPreviewDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantSettlementPreviewDtoOutput &&
        restaurantId == other.restaurantId &&
        restaurantName == other.restaurantName &&
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
    _$hash = $jc(_$hash, restaurantId.hashCode);
    _$hash = $jc(_$hash, restaurantName.hashCode);
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
    return (newBuiltValueToStringHelper(
            r'AdminRestaurantSettlementPreviewDtoOutput',
          )
          ..add('restaurantId', restaurantId)
          ..add('restaurantName', restaurantName)
          ..add('cityId', cityId)
          ..add('currency', currency)
          ..add('due', due)
          ..add('lines', lines)
          ..add('total', total)
          ..add('remaining', remaining))
        .toString();
  }
}

class AdminRestaurantSettlementPreviewDtoOutputBuilder
    implements
        Builder<
          AdminRestaurantSettlementPreviewDtoOutput,
          AdminRestaurantSettlementPreviewDtoOutputBuilder
        > {
  _$AdminRestaurantSettlementPreviewDtoOutput? _$v;

  String? _restaurantId;
  String? get restaurantId => _$this._restaurantId;
  set restaurantId(String? restaurantId) => _$this._restaurantId = restaurantId;

  String? _restaurantName;
  String? get restaurantName => _$this._restaurantName;
  set restaurantName(String? restaurantName) =>
      _$this._restaurantName = restaurantName;

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

  AdminRestaurantSettlementPreviewDtoOutputBuilder() {
    AdminRestaurantSettlementPreviewDtoOutput._defaults(this);
  }

  AdminRestaurantSettlementPreviewDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _restaurantId = $v.restaurantId;
      _restaurantName = $v.restaurantName;
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
  void replace(AdminRestaurantSettlementPreviewDtoOutput other) {
    _$v = other as _$AdminRestaurantSettlementPreviewDtoOutput;
  }

  @override
  void update(
    void Function(AdminRestaurantSettlementPreviewDtoOutputBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantSettlementPreviewDtoOutput build() => _build();

  _$AdminRestaurantSettlementPreviewDtoOutput _build() {
    _$AdminRestaurantSettlementPreviewDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminRestaurantSettlementPreviewDtoOutput._(
            restaurantId: BuiltValueNullFieldError.checkNotNull(
              restaurantId,
              r'AdminRestaurantSettlementPreviewDtoOutput',
              'restaurantId',
            ),
            restaurantName: BuiltValueNullFieldError.checkNotNull(
              restaurantName,
              r'AdminRestaurantSettlementPreviewDtoOutput',
              'restaurantName',
            ),
            cityId: BuiltValueNullFieldError.checkNotNull(
              cityId,
              r'AdminRestaurantSettlementPreviewDtoOutput',
              'cityId',
            ),
            currency: BuiltValueNullFieldError.checkNotNull(
              currency,
              r'AdminRestaurantSettlementPreviewDtoOutput',
              'currency',
            ),
            due: BuiltValueNullFieldError.checkNotNull(
              due,
              r'AdminRestaurantSettlementPreviewDtoOutput',
              'due',
            ),
            lines: lines.build(),
            total: BuiltValueNullFieldError.checkNotNull(
              total,
              r'AdminRestaurantSettlementPreviewDtoOutput',
              'total',
            ),
            remaining: BuiltValueNullFieldError.checkNotNull(
              remaining,
              r'AdminRestaurantSettlementPreviewDtoOutput',
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
          r'AdminRestaurantSettlementPreviewDtoOutput',
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
