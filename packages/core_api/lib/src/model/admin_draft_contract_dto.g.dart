// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_draft_contract_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDraftContractDto extends AdminDraftContractDto {
  @override
  final Date signedOn;
  @override
  final int durationMonths;
  @override
  final String? contractUploadId;
  @override
  final String? licenceUploadId;

  factory _$AdminDraftContractDto([
    void Function(AdminDraftContractDtoBuilder)? updates,
  ]) => (AdminDraftContractDtoBuilder()..update(updates))._build();

  _$AdminDraftContractDto._({
    required this.signedOn,
    required this.durationMonths,
    this.contractUploadId,
    this.licenceUploadId,
  }) : super._();
  @override
  AdminDraftContractDto rebuild(
    void Function(AdminDraftContractDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDraftContractDtoBuilder toBuilder() =>
      AdminDraftContractDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDraftContractDto &&
        signedOn == other.signedOn &&
        durationMonths == other.durationMonths &&
        contractUploadId == other.contractUploadId &&
        licenceUploadId == other.licenceUploadId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, signedOn.hashCode);
    _$hash = $jc(_$hash, durationMonths.hashCode);
    _$hash = $jc(_$hash, contractUploadId.hashCode);
    _$hash = $jc(_$hash, licenceUploadId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminDraftContractDto')
          ..add('signedOn', signedOn)
          ..add('durationMonths', durationMonths)
          ..add('contractUploadId', contractUploadId)
          ..add('licenceUploadId', licenceUploadId))
        .toString();
  }
}

class AdminDraftContractDtoBuilder
    implements Builder<AdminDraftContractDto, AdminDraftContractDtoBuilder> {
  _$AdminDraftContractDto? _$v;

  Date? _signedOn;
  Date? get signedOn => _$this._signedOn;
  set signedOn(Date? signedOn) => _$this._signedOn = signedOn;

  int? _durationMonths;
  int? get durationMonths => _$this._durationMonths;
  set durationMonths(int? durationMonths) =>
      _$this._durationMonths = durationMonths;

  String? _contractUploadId;
  String? get contractUploadId => _$this._contractUploadId;
  set contractUploadId(String? contractUploadId) =>
      _$this._contractUploadId = contractUploadId;

  String? _licenceUploadId;
  String? get licenceUploadId => _$this._licenceUploadId;
  set licenceUploadId(String? licenceUploadId) =>
      _$this._licenceUploadId = licenceUploadId;

  AdminDraftContractDtoBuilder() {
    AdminDraftContractDto._defaults(this);
  }

  AdminDraftContractDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _signedOn = $v.signedOn;
      _durationMonths = $v.durationMonths;
      _contractUploadId = $v.contractUploadId;
      _licenceUploadId = $v.licenceUploadId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDraftContractDto other) {
    _$v = other as _$AdminDraftContractDto;
  }

  @override
  void update(void Function(AdminDraftContractDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDraftContractDto build() => _build();

  _$AdminDraftContractDto _build() {
    final _$result =
        _$v ??
        _$AdminDraftContractDto._(
          signedOn: BuiltValueNullFieldError.checkNotNull(
            signedOn,
            r'AdminDraftContractDto',
            'signedOn',
          ),
          durationMonths: BuiltValueNullFieldError.checkNotNull(
            durationMonths,
            r'AdminDraftContractDto',
            'durationMonths',
          ),
          contractUploadId: contractUploadId,
          licenceUploadId: licenceUploadId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
