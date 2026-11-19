// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_pay_table_dto_output_announced_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainPayTableDtoOutputAnnouncedInner
    extends CaptainPayTableDtoOutputAnnouncedInner {
  @override
  final DateTime effectiveFrom;
  @override
  final CaptainPayMoneyOutput basePay;
  @override
  final int includedMetres;
  @override
  final CaptainPayMoneyOutput perExtraKm;
  @override
  final CaptainPayMoneyOutput waitingPerMinute;
  @override
  final CaptainPayMoneyOutput minimumPay;

  factory _$CaptainPayTableDtoOutputAnnouncedInner([
    void Function(CaptainPayTableDtoOutputAnnouncedInnerBuilder)? updates,
  ]) => (CaptainPayTableDtoOutputAnnouncedInnerBuilder()..update(updates))
      ._build();

  _$CaptainPayTableDtoOutputAnnouncedInner._({
    required this.effectiveFrom,
    required this.basePay,
    required this.includedMetres,
    required this.perExtraKm,
    required this.waitingPerMinute,
    required this.minimumPay,
  }) : super._();
  @override
  CaptainPayTableDtoOutputAnnouncedInner rebuild(
    void Function(CaptainPayTableDtoOutputAnnouncedInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainPayTableDtoOutputAnnouncedInnerBuilder toBuilder() =>
      CaptainPayTableDtoOutputAnnouncedInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainPayTableDtoOutputAnnouncedInner &&
        effectiveFrom == other.effectiveFrom &&
        basePay == other.basePay &&
        includedMetres == other.includedMetres &&
        perExtraKm == other.perExtraKm &&
        waitingPerMinute == other.waitingPerMinute &&
        minimumPay == other.minimumPay;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, effectiveFrom.hashCode);
    _$hash = $jc(_$hash, basePay.hashCode);
    _$hash = $jc(_$hash, includedMetres.hashCode);
    _$hash = $jc(_$hash, perExtraKm.hashCode);
    _$hash = $jc(_$hash, waitingPerMinute.hashCode);
    _$hash = $jc(_$hash, minimumPay.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CaptainPayTableDtoOutputAnnouncedInner',
          )
          ..add('effectiveFrom', effectiveFrom)
          ..add('basePay', basePay)
          ..add('includedMetres', includedMetres)
          ..add('perExtraKm', perExtraKm)
          ..add('waitingPerMinute', waitingPerMinute)
          ..add('minimumPay', minimumPay))
        .toString();
  }
}

class CaptainPayTableDtoOutputAnnouncedInnerBuilder
    implements
        Builder<
          CaptainPayTableDtoOutputAnnouncedInner,
          CaptainPayTableDtoOutputAnnouncedInnerBuilder
        > {
  _$CaptainPayTableDtoOutputAnnouncedInner? _$v;

  DateTime? _effectiveFrom;
  DateTime? get effectiveFrom => _$this._effectiveFrom;
  set effectiveFrom(DateTime? effectiveFrom) =>
      _$this._effectiveFrom = effectiveFrom;

  CaptainPayMoneyOutputBuilder? _basePay;
  CaptainPayMoneyOutputBuilder get basePay =>
      _$this._basePay ??= CaptainPayMoneyOutputBuilder();
  set basePay(CaptainPayMoneyOutputBuilder? basePay) =>
      _$this._basePay = basePay;

  int? _includedMetres;
  int? get includedMetres => _$this._includedMetres;
  set includedMetres(int? includedMetres) =>
      _$this._includedMetres = includedMetres;

  CaptainPayMoneyOutputBuilder? _perExtraKm;
  CaptainPayMoneyOutputBuilder get perExtraKm =>
      _$this._perExtraKm ??= CaptainPayMoneyOutputBuilder();
  set perExtraKm(CaptainPayMoneyOutputBuilder? perExtraKm) =>
      _$this._perExtraKm = perExtraKm;

  CaptainPayMoneyOutputBuilder? _waitingPerMinute;
  CaptainPayMoneyOutputBuilder get waitingPerMinute =>
      _$this._waitingPerMinute ??= CaptainPayMoneyOutputBuilder();
  set waitingPerMinute(CaptainPayMoneyOutputBuilder? waitingPerMinute) =>
      _$this._waitingPerMinute = waitingPerMinute;

  CaptainPayMoneyOutputBuilder? _minimumPay;
  CaptainPayMoneyOutputBuilder get minimumPay =>
      _$this._minimumPay ??= CaptainPayMoneyOutputBuilder();
  set minimumPay(CaptainPayMoneyOutputBuilder? minimumPay) =>
      _$this._minimumPay = minimumPay;

  CaptainPayTableDtoOutputAnnouncedInnerBuilder() {
    CaptainPayTableDtoOutputAnnouncedInner._defaults(this);
  }

  CaptainPayTableDtoOutputAnnouncedInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _effectiveFrom = $v.effectiveFrom;
      _basePay = $v.basePay.toBuilder();
      _includedMetres = $v.includedMetres;
      _perExtraKm = $v.perExtraKm.toBuilder();
      _waitingPerMinute = $v.waitingPerMinute.toBuilder();
      _minimumPay = $v.minimumPay.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainPayTableDtoOutputAnnouncedInner other) {
    _$v = other as _$CaptainPayTableDtoOutputAnnouncedInner;
  }

  @override
  void update(
    void Function(CaptainPayTableDtoOutputAnnouncedInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainPayTableDtoOutputAnnouncedInner build() => _build();

  _$CaptainPayTableDtoOutputAnnouncedInner _build() {
    _$CaptainPayTableDtoOutputAnnouncedInner _$result;
    try {
      _$result =
          _$v ??
          _$CaptainPayTableDtoOutputAnnouncedInner._(
            effectiveFrom: BuiltValueNullFieldError.checkNotNull(
              effectiveFrom,
              r'CaptainPayTableDtoOutputAnnouncedInner',
              'effectiveFrom',
            ),
            basePay: basePay.build(),
            includedMetres: BuiltValueNullFieldError.checkNotNull(
              includedMetres,
              r'CaptainPayTableDtoOutputAnnouncedInner',
              'includedMetres',
            ),
            perExtraKm: perExtraKm.build(),
            waitingPerMinute: waitingPerMinute.build(),
            minimumPay: minimumPay.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'basePay';
        basePay.build();

        _$failedField = 'perExtraKm';
        perExtraKm.build();
        _$failedField = 'waitingPerMinute';
        waitingPerMinute.build();
        _$failedField = 'minimumPay';
        minimumPay.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainPayTableDtoOutputAnnouncedInner',
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
