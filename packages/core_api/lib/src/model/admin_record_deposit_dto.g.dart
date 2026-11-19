// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_record_deposit_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRecordDepositDto extends AdminRecordDepositDto {
  @override
  final String cityId;
  @override
  final String applicationId;
  @override
  final String amount;
  @override
  final String? instalment;
  @override
  final String paidNow;

  factory _$AdminRecordDepositDto([
    void Function(AdminRecordDepositDtoBuilder)? updates,
  ]) => (AdminRecordDepositDtoBuilder()..update(updates))._build();

  _$AdminRecordDepositDto._({
    required this.cityId,
    required this.applicationId,
    required this.amount,
    this.instalment,
    required this.paidNow,
  }) : super._();
  @override
  AdminRecordDepositDto rebuild(
    void Function(AdminRecordDepositDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRecordDepositDtoBuilder toBuilder() =>
      AdminRecordDepositDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRecordDepositDto &&
        cityId == other.cityId &&
        applicationId == other.applicationId &&
        amount == other.amount &&
        instalment == other.instalment &&
        paidNow == other.paidNow;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, applicationId.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, instalment.hashCode);
    _$hash = $jc(_$hash, paidNow.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminRecordDepositDto')
          ..add('cityId', cityId)
          ..add('applicationId', applicationId)
          ..add('amount', amount)
          ..add('instalment', instalment)
          ..add('paidNow', paidNow))
        .toString();
  }
}

class AdminRecordDepositDtoBuilder
    implements Builder<AdminRecordDepositDto, AdminRecordDepositDtoBuilder> {
  _$AdminRecordDepositDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  String? _applicationId;
  String? get applicationId => _$this._applicationId;
  set applicationId(String? applicationId) =>
      _$this._applicationId = applicationId;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _instalment;
  String? get instalment => _$this._instalment;
  set instalment(String? instalment) => _$this._instalment = instalment;

  String? _paidNow;
  String? get paidNow => _$this._paidNow;
  set paidNow(String? paidNow) => _$this._paidNow = paidNow;

  AdminRecordDepositDtoBuilder() {
    AdminRecordDepositDto._defaults(this);
  }

  AdminRecordDepositDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _applicationId = $v.applicationId;
      _amount = $v.amount;
      _instalment = $v.instalment;
      _paidNow = $v.paidNow;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRecordDepositDto other) {
    _$v = other as _$AdminRecordDepositDto;
  }

  @override
  void update(void Function(AdminRecordDepositDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminRecordDepositDto build() => _build();

  _$AdminRecordDepositDto _build() {
    final _$result =
        _$v ??
        _$AdminRecordDepositDto._(
          cityId: BuiltValueNullFieldError.checkNotNull(
            cityId,
            r'AdminRecordDepositDto',
            'cityId',
          ),
          applicationId: BuiltValueNullFieldError.checkNotNull(
            applicationId,
            r'AdminRecordDepositDto',
            'applicationId',
          ),
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminRecordDepositDto',
            'amount',
          ),
          instalment: instalment,
          paidNow: BuiltValueNullFieldError.checkNotNull(
            paidNow,
            r'AdminRecordDepositDto',
            'paidNow',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
