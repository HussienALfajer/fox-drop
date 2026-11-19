// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_deposit_refunds_dto_output_contracts_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDepositRefundsDtoOutputContractsInner
    extends AdminDepositRefundsDtoOutputContractsInner {
  @override
  final String applicationId;
  @override
  final String captainId;
  @override
  final String fullName;
  @override
  final DateTime terminatedAt;
  @override
  final bool earlyExit;
  @override
  final bool? kitReturned;
  @override
  final AdminDepositRefundsDtoOutputContractsInnerHeld held;

  factory _$AdminDepositRefundsDtoOutputContractsInner([
    void Function(AdminDepositRefundsDtoOutputContractsInnerBuilder)? updates,
  ]) => (AdminDepositRefundsDtoOutputContractsInnerBuilder()..update(updates))
      ._build();

  _$AdminDepositRefundsDtoOutputContractsInner._({
    required this.applicationId,
    required this.captainId,
    required this.fullName,
    required this.terminatedAt,
    required this.earlyExit,
    this.kitReturned,
    required this.held,
  }) : super._();
  @override
  AdminDepositRefundsDtoOutputContractsInner rebuild(
    void Function(AdminDepositRefundsDtoOutputContractsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDepositRefundsDtoOutputContractsInnerBuilder toBuilder() =>
      AdminDepositRefundsDtoOutputContractsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDepositRefundsDtoOutputContractsInner &&
        applicationId == other.applicationId &&
        captainId == other.captainId &&
        fullName == other.fullName &&
        terminatedAt == other.terminatedAt &&
        earlyExit == other.earlyExit &&
        kitReturned == other.kitReturned &&
        held == other.held;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, applicationId.hashCode);
    _$hash = $jc(_$hash, captainId.hashCode);
    _$hash = $jc(_$hash, fullName.hashCode);
    _$hash = $jc(_$hash, terminatedAt.hashCode);
    _$hash = $jc(_$hash, earlyExit.hashCode);
    _$hash = $jc(_$hash, kitReturned.hashCode);
    _$hash = $jc(_$hash, held.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminDepositRefundsDtoOutputContractsInner',
          )
          ..add('applicationId', applicationId)
          ..add('captainId', captainId)
          ..add('fullName', fullName)
          ..add('terminatedAt', terminatedAt)
          ..add('earlyExit', earlyExit)
          ..add('kitReturned', kitReturned)
          ..add('held', held))
        .toString();
  }
}

class AdminDepositRefundsDtoOutputContractsInnerBuilder
    implements
        Builder<
          AdminDepositRefundsDtoOutputContractsInner,
          AdminDepositRefundsDtoOutputContractsInnerBuilder
        > {
  _$AdminDepositRefundsDtoOutputContractsInner? _$v;

  String? _applicationId;
  String? get applicationId => _$this._applicationId;
  set applicationId(String? applicationId) =>
      _$this._applicationId = applicationId;

  String? _captainId;
  String? get captainId => _$this._captainId;
  set captainId(String? captainId) => _$this._captainId = captainId;

  String? _fullName;
  String? get fullName => _$this._fullName;
  set fullName(String? fullName) => _$this._fullName = fullName;

  DateTime? _terminatedAt;
  DateTime? get terminatedAt => _$this._terminatedAt;
  set terminatedAt(DateTime? terminatedAt) =>
      _$this._terminatedAt = terminatedAt;

  bool? _earlyExit;
  bool? get earlyExit => _$this._earlyExit;
  set earlyExit(bool? earlyExit) => _$this._earlyExit = earlyExit;

  bool? _kitReturned;
  bool? get kitReturned => _$this._kitReturned;
  set kitReturned(bool? kitReturned) => _$this._kitReturned = kitReturned;

  AdminDepositRefundsDtoOutputContractsInnerHeldBuilder? _held;
  AdminDepositRefundsDtoOutputContractsInnerHeldBuilder get held =>
      _$this._held ??= AdminDepositRefundsDtoOutputContractsInnerHeldBuilder();
  set held(AdminDepositRefundsDtoOutputContractsInnerHeldBuilder? held) =>
      _$this._held = held;

  AdminDepositRefundsDtoOutputContractsInnerBuilder() {
    AdminDepositRefundsDtoOutputContractsInner._defaults(this);
  }

  AdminDepositRefundsDtoOutputContractsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _applicationId = $v.applicationId;
      _captainId = $v.captainId;
      _fullName = $v.fullName;
      _terminatedAt = $v.terminatedAt;
      _earlyExit = $v.earlyExit;
      _kitReturned = $v.kitReturned;
      _held = $v.held.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDepositRefundsDtoOutputContractsInner other) {
    _$v = other as _$AdminDepositRefundsDtoOutputContractsInner;
  }

  @override
  void update(
    void Function(AdminDepositRefundsDtoOutputContractsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminDepositRefundsDtoOutputContractsInner build() => _build();

  _$AdminDepositRefundsDtoOutputContractsInner _build() {
    _$AdminDepositRefundsDtoOutputContractsInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminDepositRefundsDtoOutputContractsInner._(
            applicationId: BuiltValueNullFieldError.checkNotNull(
              applicationId,
              r'AdminDepositRefundsDtoOutputContractsInner',
              'applicationId',
            ),
            captainId: BuiltValueNullFieldError.checkNotNull(
              captainId,
              r'AdminDepositRefundsDtoOutputContractsInner',
              'captainId',
            ),
            fullName: BuiltValueNullFieldError.checkNotNull(
              fullName,
              r'AdminDepositRefundsDtoOutputContractsInner',
              'fullName',
            ),
            terminatedAt: BuiltValueNullFieldError.checkNotNull(
              terminatedAt,
              r'AdminDepositRefundsDtoOutputContractsInner',
              'terminatedAt',
            ),
            earlyExit: BuiltValueNullFieldError.checkNotNull(
              earlyExit,
              r'AdminDepositRefundsDtoOutputContractsInner',
              'earlyExit',
            ),
            kitReturned: kitReturned,
            held: held.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'held';
        held.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminDepositRefundsDtoOutputContractsInner',
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
