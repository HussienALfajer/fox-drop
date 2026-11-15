// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_settlements_dto_output_restaurants_inner_latest.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest
    extends AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest {
  @override
  final String id;
  @override
  final DateTime cutoff;
  @override
  final String commission;
  @override
  final String discountShare;
  @override
  final String exceptions;
  @override
  final String totalDue;

  factory _$AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest([
    void Function(
      AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatestBuilder,
    )?
    updates,
  ]) =>
      (AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatestBuilder()
            ..update(updates))
          ._build();

  _$AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest._({
    required this.id,
    required this.cutoff,
    required this.commission,
    required this.discountShare,
    required this.exceptions,
    required this.totalDue,
  }) : super._();
  @override
  AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest rebuild(
    void Function(
      AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatestBuilder,
    )
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatestBuilder
  toBuilder() =>
      AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatestBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest &&
        id == other.id &&
        cutoff == other.cutoff &&
        commission == other.commission &&
        discountShare == other.discountShare &&
        exceptions == other.exceptions &&
        totalDue == other.totalDue;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, cutoff.hashCode);
    _$hash = $jc(_$hash, commission.hashCode);
    _$hash = $jc(_$hash, discountShare.hashCode);
    _$hash = $jc(_$hash, exceptions.hashCode);
    _$hash = $jc(_$hash, totalDue.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest',
          )
          ..add('id', id)
          ..add('cutoff', cutoff)
          ..add('commission', commission)
          ..add('discountShare', discountShare)
          ..add('exceptions', exceptions)
          ..add('totalDue', totalDue))
        .toString();
  }
}

class AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatestBuilder
    implements
        Builder<
          AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest,
          AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatestBuilder
        > {
  _$AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  DateTime? _cutoff;
  DateTime? get cutoff => _$this._cutoff;
  set cutoff(DateTime? cutoff) => _$this._cutoff = cutoff;

  String? _commission;
  String? get commission => _$this._commission;
  set commission(String? commission) => _$this._commission = commission;

  String? _discountShare;
  String? get discountShare => _$this._discountShare;
  set discountShare(String? discountShare) =>
      _$this._discountShare = discountShare;

  String? _exceptions;
  String? get exceptions => _$this._exceptions;
  set exceptions(String? exceptions) => _$this._exceptions = exceptions;

  String? _totalDue;
  String? get totalDue => _$this._totalDue;
  set totalDue(String? totalDue) => _$this._totalDue = totalDue;

  AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatestBuilder() {
    AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest._defaults(this);
  }

  AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _cutoff = $v.cutoff;
      _commission = $v.commission;
      _discountShare = $v.discountShare;
      _exceptions = $v.exceptions;
      _totalDue = $v.totalDue;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(
    AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest other,
  ) {
    _$v = other as _$AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest;
  }

  @override
  void update(
    void Function(
      AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatestBuilder,
    )?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest build() => _build();

  _$AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest _build() {
    final _$result =
        _$v ??
        _$AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest',
            'id',
          ),
          cutoff: BuiltValueNullFieldError.checkNotNull(
            cutoff,
            r'AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest',
            'cutoff',
          ),
          commission: BuiltValueNullFieldError.checkNotNull(
            commission,
            r'AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest',
            'commission',
          ),
          discountShare: BuiltValueNullFieldError.checkNotNull(
            discountShare,
            r'AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest',
            'discountShare',
          ),
          exceptions: BuiltValueNullFieldError.checkNotNull(
            exceptions,
            r'AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest',
            'exceptions',
          ),
          totalDue: BuiltValueNullFieldError.checkNotNull(
            totalDue,
            r'AdminRestaurantSettlementsDtoOutputRestaurantsInnerLatest',
            'totalDue',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
