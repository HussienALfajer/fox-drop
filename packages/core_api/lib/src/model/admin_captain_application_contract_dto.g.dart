// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_application_contract_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCaptainApplicationContractDto
    extends AdminCaptainApplicationContractDto {
  @override
  final Date signedOn;
  @override
  final Date startsOn;
  @override
  final BuiltList<String> uploadIds;

  factory _$AdminCaptainApplicationContractDto([
    void Function(AdminCaptainApplicationContractDtoBuilder)? updates,
  ]) => (AdminCaptainApplicationContractDtoBuilder()..update(updates))._build();

  _$AdminCaptainApplicationContractDto._({
    required this.signedOn,
    required this.startsOn,
    required this.uploadIds,
  }) : super._();
  @override
  AdminCaptainApplicationContractDto rebuild(
    void Function(AdminCaptainApplicationContractDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainApplicationContractDtoBuilder toBuilder() =>
      AdminCaptainApplicationContractDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainApplicationContractDto &&
        signedOn == other.signedOn &&
        startsOn == other.startsOn &&
        uploadIds == other.uploadIds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, signedOn.hashCode);
    _$hash = $jc(_$hash, startsOn.hashCode);
    _$hash = $jc(_$hash, uploadIds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminCaptainApplicationContractDto')
          ..add('signedOn', signedOn)
          ..add('startsOn', startsOn)
          ..add('uploadIds', uploadIds))
        .toString();
  }
}

class AdminCaptainApplicationContractDtoBuilder
    implements
        Builder<
          AdminCaptainApplicationContractDto,
          AdminCaptainApplicationContractDtoBuilder
        > {
  _$AdminCaptainApplicationContractDto? _$v;

  Date? _signedOn;
  Date? get signedOn => _$this._signedOn;
  set signedOn(Date? signedOn) => _$this._signedOn = signedOn;

  Date? _startsOn;
  Date? get startsOn => _$this._startsOn;
  set startsOn(Date? startsOn) => _$this._startsOn = startsOn;

  ListBuilder<String>? _uploadIds;
  ListBuilder<String> get uploadIds =>
      _$this._uploadIds ??= ListBuilder<String>();
  set uploadIds(ListBuilder<String>? uploadIds) =>
      _$this._uploadIds = uploadIds;

  AdminCaptainApplicationContractDtoBuilder() {
    AdminCaptainApplicationContractDto._defaults(this);
  }

  AdminCaptainApplicationContractDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _signedOn = $v.signedOn;
      _startsOn = $v.startsOn;
      _uploadIds = $v.uploadIds.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainApplicationContractDto other) {
    _$v = other as _$AdminCaptainApplicationContractDto;
  }

  @override
  void update(
    void Function(AdminCaptainApplicationContractDtoBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainApplicationContractDto build() => _build();

  _$AdminCaptainApplicationContractDto _build() {
    _$AdminCaptainApplicationContractDto _$result;
    try {
      _$result =
          _$v ??
          _$AdminCaptainApplicationContractDto._(
            signedOn: BuiltValueNullFieldError.checkNotNull(
              signedOn,
              r'AdminCaptainApplicationContractDto',
              'signedOn',
            ),
            startsOn: BuiltValueNullFieldError.checkNotNull(
              startsOn,
              r'AdminCaptainApplicationContractDto',
              'startsOn',
            ),
            uploadIds: uploadIds.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'uploadIds';
        uploadIds.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminCaptainApplicationContractDto',
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
