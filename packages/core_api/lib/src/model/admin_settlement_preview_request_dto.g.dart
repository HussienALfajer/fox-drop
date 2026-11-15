// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_settlement_preview_request_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminSettlementPreviewRequestDto
    extends AdminSettlementPreviewRequestDto {
  @override
  final String captainId;
  @override
  final String? payoutCurrency;

  factory _$AdminSettlementPreviewRequestDto([
    void Function(AdminSettlementPreviewRequestDtoBuilder)? updates,
  ]) => (AdminSettlementPreviewRequestDtoBuilder()..update(updates))._build();

  _$AdminSettlementPreviewRequestDto._({
    required this.captainId,
    this.payoutCurrency,
  }) : super._();
  @override
  AdminSettlementPreviewRequestDto rebuild(
    void Function(AdminSettlementPreviewRequestDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminSettlementPreviewRequestDtoBuilder toBuilder() =>
      AdminSettlementPreviewRequestDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSettlementPreviewRequestDto &&
        captainId == other.captainId &&
        payoutCurrency == other.payoutCurrency;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, captainId.hashCode);
    _$hash = $jc(_$hash, payoutCurrency.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminSettlementPreviewRequestDto')
          ..add('captainId', captainId)
          ..add('payoutCurrency', payoutCurrency))
        .toString();
  }
}

class AdminSettlementPreviewRequestDtoBuilder
    implements
        Builder<
          AdminSettlementPreviewRequestDto,
          AdminSettlementPreviewRequestDtoBuilder
        > {
  _$AdminSettlementPreviewRequestDto? _$v;

  String? _captainId;
  String? get captainId => _$this._captainId;
  set captainId(String? captainId) => _$this._captainId = captainId;

  String? _payoutCurrency;
  String? get payoutCurrency => _$this._payoutCurrency;
  set payoutCurrency(String? payoutCurrency) =>
      _$this._payoutCurrency = payoutCurrency;

  AdminSettlementPreviewRequestDtoBuilder() {
    AdminSettlementPreviewRequestDto._defaults(this);
  }

  AdminSettlementPreviewRequestDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _captainId = $v.captainId;
      _payoutCurrency = $v.payoutCurrency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSettlementPreviewRequestDto other) {
    _$v = other as _$AdminSettlementPreviewRequestDto;
  }

  @override
  void update(void Function(AdminSettlementPreviewRequestDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminSettlementPreviewRequestDto build() => _build();

  _$AdminSettlementPreviewRequestDto _build() {
    final _$result =
        _$v ??
        _$AdminSettlementPreviewRequestDto._(
          captainId: BuiltValueNullFieldError.checkNotNull(
            captainId,
            r'AdminSettlementPreviewRequestDto',
            'captainId',
          ),
          payoutCurrency: payoutCurrency,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
