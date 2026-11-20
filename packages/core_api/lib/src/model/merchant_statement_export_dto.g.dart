// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_statement_export_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantStatementExportDto extends MerchantStatementExportDto {
  @override
  final String statementId;

  factory _$MerchantStatementExportDto([
    void Function(MerchantStatementExportDtoBuilder)? updates,
  ]) => (MerchantStatementExportDtoBuilder()..update(updates))._build();

  _$MerchantStatementExportDto._({required this.statementId}) : super._();
  @override
  MerchantStatementExportDto rebuild(
    void Function(MerchantStatementExportDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantStatementExportDtoBuilder toBuilder() =>
      MerchantStatementExportDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantStatementExportDto &&
        statementId == other.statementId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, statementId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'MerchantStatementExportDto',
    )..add('statementId', statementId)).toString();
  }
}

class MerchantStatementExportDtoBuilder
    implements
        Builder<MerchantStatementExportDto, MerchantStatementExportDtoBuilder> {
  _$MerchantStatementExportDto? _$v;

  String? _statementId;
  String? get statementId => _$this._statementId;
  set statementId(String? statementId) => _$this._statementId = statementId;

  MerchantStatementExportDtoBuilder() {
    MerchantStatementExportDto._defaults(this);
  }

  MerchantStatementExportDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _statementId = $v.statementId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantStatementExportDto other) {
    _$v = other as _$MerchantStatementExportDto;
  }

  @override
  void update(void Function(MerchantStatementExportDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantStatementExportDto build() => _build();

  _$MerchantStatementExportDto _build() {
    final _$result =
        _$v ??
        _$MerchantStatementExportDto._(
          statementId: BuiltValueNullFieldError.checkNotNull(
            statementId,
            r'MerchantStatementExportDto',
            'statementId',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
