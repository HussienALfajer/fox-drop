// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_profile_dto_output_app.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCaptainProfileDtoOutputApp
    extends AdminCaptainProfileDtoOutputApp {
  @override
  final AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDue? maxPickup;
  @override
  final bool maxPickupAnswered;
  @override
  final BuiltList<String> carriedCurrencies;
  @override
  final int expiredInRow;

  factory _$AdminCaptainProfileDtoOutputApp([
    void Function(AdminCaptainProfileDtoOutputAppBuilder)? updates,
  ]) => (AdminCaptainProfileDtoOutputAppBuilder()..update(updates))._build();

  _$AdminCaptainProfileDtoOutputApp._({
    this.maxPickup,
    required this.maxPickupAnswered,
    required this.carriedCurrencies,
    required this.expiredInRow,
  }) : super._();
  @override
  AdminCaptainProfileDtoOutputApp rebuild(
    void Function(AdminCaptainProfileDtoOutputAppBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainProfileDtoOutputAppBuilder toBuilder() =>
      AdminCaptainProfileDtoOutputAppBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainProfileDtoOutputApp &&
        maxPickup == other.maxPickup &&
        maxPickupAnswered == other.maxPickupAnswered &&
        carriedCurrencies == other.carriedCurrencies &&
        expiredInRow == other.expiredInRow;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, maxPickup.hashCode);
    _$hash = $jc(_$hash, maxPickupAnswered.hashCode);
    _$hash = $jc(_$hash, carriedCurrencies.hashCode);
    _$hash = $jc(_$hash, expiredInRow.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminCaptainProfileDtoOutputApp')
          ..add('maxPickup', maxPickup)
          ..add('maxPickupAnswered', maxPickupAnswered)
          ..add('carriedCurrencies', carriedCurrencies)
          ..add('expiredInRow', expiredInRow))
        .toString();
  }
}

class AdminCaptainProfileDtoOutputAppBuilder
    implements
        Builder<
          AdminCaptainProfileDtoOutputApp,
          AdminCaptainProfileDtoOutputAppBuilder
        > {
  _$AdminCaptainProfileDtoOutputApp? _$v;

  AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDueBuilder? _maxPickup;
  AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDueBuilder get maxPickup =>
      _$this._maxPickup ??=
          AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDueBuilder();
  set maxPickup(
    AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDueBuilder? maxPickup,
  ) => _$this._maxPickup = maxPickup;

  bool? _maxPickupAnswered;
  bool? get maxPickupAnswered => _$this._maxPickupAnswered;
  set maxPickupAnswered(bool? maxPickupAnswered) =>
      _$this._maxPickupAnswered = maxPickupAnswered;

  ListBuilder<String>? _carriedCurrencies;
  ListBuilder<String> get carriedCurrencies =>
      _$this._carriedCurrencies ??= ListBuilder<String>();
  set carriedCurrencies(ListBuilder<String>? carriedCurrencies) =>
      _$this._carriedCurrencies = carriedCurrencies;

  int? _expiredInRow;
  int? get expiredInRow => _$this._expiredInRow;
  set expiredInRow(int? expiredInRow) => _$this._expiredInRow = expiredInRow;

  AdminCaptainProfileDtoOutputAppBuilder() {
    AdminCaptainProfileDtoOutputApp._defaults(this);
  }

  AdminCaptainProfileDtoOutputAppBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _maxPickup = $v.maxPickup?.toBuilder();
      _maxPickupAnswered = $v.maxPickupAnswered;
      _carriedCurrencies = $v.carriedCurrencies.toBuilder();
      _expiredInRow = $v.expiredInRow;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainProfileDtoOutputApp other) {
    _$v = other as _$AdminCaptainProfileDtoOutputApp;
  }

  @override
  void update(void Function(AdminCaptainProfileDtoOutputAppBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainProfileDtoOutputApp build() => _build();

  _$AdminCaptainProfileDtoOutputApp _build() {
    _$AdminCaptainProfileDtoOutputApp _$result;
    try {
      _$result =
          _$v ??
          _$AdminCaptainProfileDtoOutputApp._(
            maxPickup: _maxPickup?.build(),
            maxPickupAnswered: BuiltValueNullFieldError.checkNotNull(
              maxPickupAnswered,
              r'AdminCaptainProfileDtoOutputApp',
              'maxPickupAnswered',
            ),
            carriedCurrencies: carriedCurrencies.build(),
            expiredInRow: BuiltValueNullFieldError.checkNotNull(
              expiredInRow,
              r'AdminCaptainProfileDtoOutputApp',
              'expiredInRow',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'maxPickup';
        _maxPickup?.build();

        _$failedField = 'carriedCurrencies';
        carriedCurrencies.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminCaptainProfileDtoOutputApp',
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
