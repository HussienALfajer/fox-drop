// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_settle_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminSettleDto extends AdminSettleDto {
  @override
  final String captainId;
  @override
  final BuiltList<AdminSettleDtoCustodyInner> custody;
  @override
  final String earnings;
  @override
  final AdminSettleDtoPayout? payout;
  @override
  final String? reason;

  factory _$AdminSettleDto([void Function(AdminSettleDtoBuilder)? updates]) =>
      (AdminSettleDtoBuilder()..update(updates))._build();

  _$AdminSettleDto._({
    required this.captainId,
    required this.custody,
    required this.earnings,
    this.payout,
    this.reason,
  }) : super._();
  @override
  AdminSettleDto rebuild(void Function(AdminSettleDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminSettleDtoBuilder toBuilder() => AdminSettleDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSettleDto &&
        captainId == other.captainId &&
        custody == other.custody &&
        earnings == other.earnings &&
        payout == other.payout &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, captainId.hashCode);
    _$hash = $jc(_$hash, custody.hashCode);
    _$hash = $jc(_$hash, earnings.hashCode);
    _$hash = $jc(_$hash, payout.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminSettleDto')
          ..add('captainId', captainId)
          ..add('custody', custody)
          ..add('earnings', earnings)
          ..add('payout', payout)
          ..add('reason', reason))
        .toString();
  }
}

class AdminSettleDtoBuilder
    implements Builder<AdminSettleDto, AdminSettleDtoBuilder> {
  _$AdminSettleDto? _$v;

  String? _captainId;
  String? get captainId => _$this._captainId;
  set captainId(String? captainId) => _$this._captainId = captainId;

  ListBuilder<AdminSettleDtoCustodyInner>? _custody;
  ListBuilder<AdminSettleDtoCustodyInner> get custody =>
      _$this._custody ??= ListBuilder<AdminSettleDtoCustodyInner>();
  set custody(ListBuilder<AdminSettleDtoCustodyInner>? custody) =>
      _$this._custody = custody;

  String? _earnings;
  String? get earnings => _$this._earnings;
  set earnings(String? earnings) => _$this._earnings = earnings;

  AdminSettleDtoPayoutBuilder? _payout;
  AdminSettleDtoPayoutBuilder get payout =>
      _$this._payout ??= AdminSettleDtoPayoutBuilder();
  set payout(AdminSettleDtoPayoutBuilder? payout) => _$this._payout = payout;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AdminSettleDtoBuilder() {
    AdminSettleDto._defaults(this);
  }

  AdminSettleDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _captainId = $v.captainId;
      _custody = $v.custody.toBuilder();
      _earnings = $v.earnings;
      _payout = $v.payout?.toBuilder();
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSettleDto other) {
    _$v = other as _$AdminSettleDto;
  }

  @override
  void update(void Function(AdminSettleDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminSettleDto build() => _build();

  _$AdminSettleDto _build() {
    _$AdminSettleDto _$result;
    try {
      _$result =
          _$v ??
          _$AdminSettleDto._(
            captainId: BuiltValueNullFieldError.checkNotNull(
              captainId,
              r'AdminSettleDto',
              'captainId',
            ),
            custody: custody.build(),
            earnings: BuiltValueNullFieldError.checkNotNull(
              earnings,
              r'AdminSettleDto',
              'earnings',
            ),
            payout: _payout?.build(),
            reason: reason,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'custody';
        custody.build();

        _$failedField = 'payout';
        _payout?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminSettleDto',
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
