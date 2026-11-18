// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_draft_dto_output_contract.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRestaurantDraftDtoOutputContract
    extends AdminRestaurantDraftDtoOutputContract {
  @override
  final String? signedOn;
  @override
  final int? durationMonths;
  @override
  final String? contractUrl;
  @override
  final String? licenceUrl;
  @override
  final DateTime? confirmedAt;

  factory _$AdminRestaurantDraftDtoOutputContract([
    void Function(AdminRestaurantDraftDtoOutputContractBuilder)? updates,
  ]) => (AdminRestaurantDraftDtoOutputContractBuilder()..update(updates))
      ._build();

  _$AdminRestaurantDraftDtoOutputContract._({
    this.signedOn,
    this.durationMonths,
    this.contractUrl,
    this.licenceUrl,
    this.confirmedAt,
  }) : super._();
  @override
  AdminRestaurantDraftDtoOutputContract rebuild(
    void Function(AdminRestaurantDraftDtoOutputContractBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantDraftDtoOutputContractBuilder toBuilder() =>
      AdminRestaurantDraftDtoOutputContractBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantDraftDtoOutputContract &&
        signedOn == other.signedOn &&
        durationMonths == other.durationMonths &&
        contractUrl == other.contractUrl &&
        licenceUrl == other.licenceUrl &&
        confirmedAt == other.confirmedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, signedOn.hashCode);
    _$hash = $jc(_$hash, durationMonths.hashCode);
    _$hash = $jc(_$hash, contractUrl.hashCode);
    _$hash = $jc(_$hash, licenceUrl.hashCode);
    _$hash = $jc(_$hash, confirmedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminRestaurantDraftDtoOutputContract',
          )
          ..add('signedOn', signedOn)
          ..add('durationMonths', durationMonths)
          ..add('contractUrl', contractUrl)
          ..add('licenceUrl', licenceUrl)
          ..add('confirmedAt', confirmedAt))
        .toString();
  }
}

class AdminRestaurantDraftDtoOutputContractBuilder
    implements
        Builder<
          AdminRestaurantDraftDtoOutputContract,
          AdminRestaurantDraftDtoOutputContractBuilder
        > {
  _$AdminRestaurantDraftDtoOutputContract? _$v;

  String? _signedOn;
  String? get signedOn => _$this._signedOn;
  set signedOn(String? signedOn) => _$this._signedOn = signedOn;

  int? _durationMonths;
  int? get durationMonths => _$this._durationMonths;
  set durationMonths(int? durationMonths) =>
      _$this._durationMonths = durationMonths;

  String? _contractUrl;
  String? get contractUrl => _$this._contractUrl;
  set contractUrl(String? contractUrl) => _$this._contractUrl = contractUrl;

  String? _licenceUrl;
  String? get licenceUrl => _$this._licenceUrl;
  set licenceUrl(String? licenceUrl) => _$this._licenceUrl = licenceUrl;

  DateTime? _confirmedAt;
  DateTime? get confirmedAt => _$this._confirmedAt;
  set confirmedAt(DateTime? confirmedAt) => _$this._confirmedAt = confirmedAt;

  AdminRestaurantDraftDtoOutputContractBuilder() {
    AdminRestaurantDraftDtoOutputContract._defaults(this);
  }

  AdminRestaurantDraftDtoOutputContractBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _signedOn = $v.signedOn;
      _durationMonths = $v.durationMonths;
      _contractUrl = $v.contractUrl;
      _licenceUrl = $v.licenceUrl;
      _confirmedAt = $v.confirmedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantDraftDtoOutputContract other) {
    _$v = other as _$AdminRestaurantDraftDtoOutputContract;
  }

  @override
  void update(
    void Function(AdminRestaurantDraftDtoOutputContractBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantDraftDtoOutputContract build() => _build();

  _$AdminRestaurantDraftDtoOutputContract _build() {
    final _$result =
        _$v ??
        _$AdminRestaurantDraftDtoOutputContract._(
          signedOn: signedOn,
          durationMonths: durationMonths,
          contractUrl: contractUrl,
          licenceUrl: licenceUrl,
          confirmedAt: confirmedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
