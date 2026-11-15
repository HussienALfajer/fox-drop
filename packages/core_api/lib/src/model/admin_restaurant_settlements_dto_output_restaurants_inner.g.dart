// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_settlements_dto_output_restaurants_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRestaurantSettlementsDtoOutputRestaurantsInner
    extends AdminRestaurantSettlementsDtoOutputRestaurantsInner {
  @override
  final String restaurantId;
  @override
  final String restaurantName;
  @override
  final String currency;
  @override
  final String balance;
  @override
  final AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest? latest;
  @override
  final String unpaid;
  @override
  final DateTime? overdueSince;

  factory _$AdminRestaurantSettlementsDtoOutputRestaurantsInner([
    void Function(AdminRestaurantSettlementsDtoOutputRestaurantsInnerBuilder)?
    updates,
  ]) =>
      (AdminRestaurantSettlementsDtoOutputRestaurantsInnerBuilder()
            ..update(updates))
          ._build();

  _$AdminRestaurantSettlementsDtoOutputRestaurantsInner._({
    required this.restaurantId,
    required this.restaurantName,
    required this.currency,
    required this.balance,
    this.latest,
    required this.unpaid,
    this.overdueSince,
  }) : super._();
  @override
  AdminRestaurantSettlementsDtoOutputRestaurantsInner rebuild(
    void Function(AdminRestaurantSettlementsDtoOutputRestaurantsInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantSettlementsDtoOutputRestaurantsInnerBuilder toBuilder() =>
      AdminRestaurantSettlementsDtoOutputRestaurantsInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantSettlementsDtoOutputRestaurantsInner &&
        restaurantId == other.restaurantId &&
        restaurantName == other.restaurantName &&
        currency == other.currency &&
        balance == other.balance &&
        latest == other.latest &&
        unpaid == other.unpaid &&
        overdueSince == other.overdueSince;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, restaurantId.hashCode);
    _$hash = $jc(_$hash, restaurantName.hashCode);
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, balance.hashCode);
    _$hash = $jc(_$hash, latest.hashCode);
    _$hash = $jc(_$hash, unpaid.hashCode);
    _$hash = $jc(_$hash, overdueSince.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminRestaurantSettlementsDtoOutputRestaurantsInner',
          )
          ..add('restaurantId', restaurantId)
          ..add('restaurantName', restaurantName)
          ..add('currency', currency)
          ..add('balance', balance)
          ..add('latest', latest)
          ..add('unpaid', unpaid)
          ..add('overdueSince', overdueSince))
        .toString();
  }
}

class AdminRestaurantSettlementsDtoOutputRestaurantsInnerBuilder
    implements
        Builder<
          AdminRestaurantSettlementsDtoOutputRestaurantsInner,
          AdminRestaurantSettlementsDtoOutputRestaurantsInnerBuilder
        > {
  _$AdminRestaurantSettlementsDtoOutputRestaurantsInner? _$v;

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

  String? _balance;
  String? get balance => _$this._balance;
  set balance(String? balance) => _$this._balance = balance;

  AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatestBuilder? _latest;
  AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatestBuilder get latest =>
      _$this._latest ??=
          AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatestBuilder();
  set latest(
    AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatestBuilder? latest,
  ) => _$this._latest = latest;

  String? _unpaid;
  String? get unpaid => _$this._unpaid;
  set unpaid(String? unpaid) => _$this._unpaid = unpaid;

  DateTime? _overdueSince;
  DateTime? get overdueSince => _$this._overdueSince;
  set overdueSince(DateTime? overdueSince) =>
      _$this._overdueSince = overdueSince;

  AdminRestaurantSettlementsDtoOutputRestaurantsInnerBuilder() {
    AdminRestaurantSettlementsDtoOutputRestaurantsInner._defaults(this);
  }

  AdminRestaurantSettlementsDtoOutputRestaurantsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _restaurantId = $v.restaurantId;
      _restaurantName = $v.restaurantName;
      _currency = $v.currency;
      _balance = $v.balance;
      _latest = $v.latest?.toBuilder();
      _unpaid = $v.unpaid;
      _overdueSince = $v.overdueSince;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantSettlementsDtoOutputRestaurantsInner other) {
    _$v = other as _$AdminRestaurantSettlementsDtoOutputRestaurantsInner;
  }

  @override
  void update(
    void Function(AdminRestaurantSettlementsDtoOutputRestaurantsInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantSettlementsDtoOutputRestaurantsInner build() => _build();

  _$AdminRestaurantSettlementsDtoOutputRestaurantsInner _build() {
    _$AdminRestaurantSettlementsDtoOutputRestaurantsInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminRestaurantSettlementsDtoOutputRestaurantsInner._(
            restaurantId: BuiltValueNullFieldError.checkNotNull(
              restaurantId,
              r'AdminRestaurantSettlementsDtoOutputRestaurantsInner',
              'restaurantId',
            ),
            restaurantName: BuiltValueNullFieldError.checkNotNull(
              restaurantName,
              r'AdminRestaurantSettlementsDtoOutputRestaurantsInner',
              'restaurantName',
            ),
            currency: BuiltValueNullFieldError.checkNotNull(
              currency,
              r'AdminRestaurantSettlementsDtoOutputRestaurantsInner',
              'currency',
            ),
            balance: BuiltValueNullFieldError.checkNotNull(
              balance,
              r'AdminRestaurantSettlementsDtoOutputRestaurantsInner',
              'balance',
            ),
            latest: _latest?.build(),
            unpaid: BuiltValueNullFieldError.checkNotNull(
              unpaid,
              r'AdminRestaurantSettlementsDtoOutputRestaurantsInner',
              'unpaid',
            ),
            overdueSince: overdueSince,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'latest';
        _latest?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminRestaurantSettlementsDtoOutputRestaurantsInner',
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
