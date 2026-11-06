// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto_output_order_customer_arrival.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOrderDtoOutputOrderCustomerArrival
    extends AdminOrderDtoOutputOrderCustomerArrival {
  @override
  final DateTime at;
  @override
  final AdminOrderDtoOutputOrderCustomerArrivalAway? away;

  factory _$AdminOrderDtoOutputOrderCustomerArrival([
    void Function(AdminOrderDtoOutputOrderCustomerArrivalBuilder)? updates,
  ]) => (AdminOrderDtoOutputOrderCustomerArrivalBuilder()..update(updates))
      ._build();

  _$AdminOrderDtoOutputOrderCustomerArrival._({required this.at, this.away})
    : super._();
  @override
  AdminOrderDtoOutputOrderCustomerArrival rebuild(
    void Function(AdminOrderDtoOutputOrderCustomerArrivalBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderDtoOutputOrderCustomerArrivalBuilder toBuilder() =>
      AdminOrderDtoOutputOrderCustomerArrivalBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderDtoOutputOrderCustomerArrival &&
        at == other.at &&
        away == other.away;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jc(_$hash, away.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminOrderDtoOutputOrderCustomerArrival',
          )
          ..add('at', at)
          ..add('away', away))
        .toString();
  }
}

class AdminOrderDtoOutputOrderCustomerArrivalBuilder
    implements
        Builder<
          AdminOrderDtoOutputOrderCustomerArrival,
          AdminOrderDtoOutputOrderCustomerArrivalBuilder
        > {
  _$AdminOrderDtoOutputOrderCustomerArrival? _$v;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  AdminOrderDtoOutputOrderCustomerArrivalAwayBuilder? _away;
  AdminOrderDtoOutputOrderCustomerArrivalAwayBuilder get away =>
      _$this._away ??= AdminOrderDtoOutputOrderCustomerArrivalAwayBuilder();
  set away(AdminOrderDtoOutputOrderCustomerArrivalAwayBuilder? away) =>
      _$this._away = away;

  AdminOrderDtoOutputOrderCustomerArrivalBuilder() {
    AdminOrderDtoOutputOrderCustomerArrival._defaults(this);
  }

  AdminOrderDtoOutputOrderCustomerArrivalBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _at = $v.at;
      _away = $v.away?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderDtoOutputOrderCustomerArrival other) {
    _$v = other as _$AdminOrderDtoOutputOrderCustomerArrival;
  }

  @override
  void update(
    void Function(AdminOrderDtoOutputOrderCustomerArrivalBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderDtoOutputOrderCustomerArrival build() => _build();

  _$AdminOrderDtoOutputOrderCustomerArrival _build() {
    _$AdminOrderDtoOutputOrderCustomerArrival _$result;
    try {
      _$result =
          _$v ??
          _$AdminOrderDtoOutputOrderCustomerArrival._(
            at: BuiltValueNullFieldError.checkNotNull(
              at,
              r'AdminOrderDtoOutputOrderCustomerArrival',
              'at',
            ),
            away: _away?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'away';
        _away?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminOrderDtoOutputOrderCustomerArrival',
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
