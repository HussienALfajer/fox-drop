// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_performance_dto_output_acceptance.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainPerformanceDtoOutputAcceptance
    extends CaptainPerformanceDtoOutputAcceptance {
  @override
  final int? rate;
  @override
  final int accepted;
  @override
  final int answered;
  @override
  final int windowOffers;
  @override
  final bool warn;
  @override
  final int alertPct;
  @override
  final BuiltList<CaptainPerformanceDtoOutputAcceptanceOffersInner> offers;

  factory _$CaptainPerformanceDtoOutputAcceptance([
    void Function(CaptainPerformanceDtoOutputAcceptanceBuilder)? updates,
  ]) => (CaptainPerformanceDtoOutputAcceptanceBuilder()..update(updates))
      ._build();

  _$CaptainPerformanceDtoOutputAcceptance._({
    this.rate,
    required this.accepted,
    required this.answered,
    required this.windowOffers,
    required this.warn,
    required this.alertPct,
    required this.offers,
  }) : super._();
  @override
  CaptainPerformanceDtoOutputAcceptance rebuild(
    void Function(CaptainPerformanceDtoOutputAcceptanceBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainPerformanceDtoOutputAcceptanceBuilder toBuilder() =>
      CaptainPerformanceDtoOutputAcceptanceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainPerformanceDtoOutputAcceptance &&
        rate == other.rate &&
        accepted == other.accepted &&
        answered == other.answered &&
        windowOffers == other.windowOffers &&
        warn == other.warn &&
        alertPct == other.alertPct &&
        offers == other.offers;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, rate.hashCode);
    _$hash = $jc(_$hash, accepted.hashCode);
    _$hash = $jc(_$hash, answered.hashCode);
    _$hash = $jc(_$hash, windowOffers.hashCode);
    _$hash = $jc(_$hash, warn.hashCode);
    _$hash = $jc(_$hash, alertPct.hashCode);
    _$hash = $jc(_$hash, offers.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CaptainPerformanceDtoOutputAcceptance',
          )
          ..add('rate', rate)
          ..add('accepted', accepted)
          ..add('answered', answered)
          ..add('windowOffers', windowOffers)
          ..add('warn', warn)
          ..add('alertPct', alertPct)
          ..add('offers', offers))
        .toString();
  }
}

class CaptainPerformanceDtoOutputAcceptanceBuilder
    implements
        Builder<
          CaptainPerformanceDtoOutputAcceptance,
          CaptainPerformanceDtoOutputAcceptanceBuilder
        > {
  _$CaptainPerformanceDtoOutputAcceptance? _$v;

  int? _rate;
  int? get rate => _$this._rate;
  set rate(int? rate) => _$this._rate = rate;

  int? _accepted;
  int? get accepted => _$this._accepted;
  set accepted(int? accepted) => _$this._accepted = accepted;

  int? _answered;
  int? get answered => _$this._answered;
  set answered(int? answered) => _$this._answered = answered;

  int? _windowOffers;
  int? get windowOffers => _$this._windowOffers;
  set windowOffers(int? windowOffers) => _$this._windowOffers = windowOffers;

  bool? _warn;
  bool? get warn => _$this._warn;
  set warn(bool? warn) => _$this._warn = warn;

  int? _alertPct;
  int? get alertPct => _$this._alertPct;
  set alertPct(int? alertPct) => _$this._alertPct = alertPct;

  ListBuilder<CaptainPerformanceDtoOutputAcceptanceOffersInner>? _offers;
  ListBuilder<CaptainPerformanceDtoOutputAcceptanceOffersInner> get offers =>
      _$this._offers ??=
          ListBuilder<CaptainPerformanceDtoOutputAcceptanceOffersInner>();
  set offers(
    ListBuilder<CaptainPerformanceDtoOutputAcceptanceOffersInner>? offers,
  ) => _$this._offers = offers;

  CaptainPerformanceDtoOutputAcceptanceBuilder() {
    CaptainPerformanceDtoOutputAcceptance._defaults(this);
  }

  CaptainPerformanceDtoOutputAcceptanceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _rate = $v.rate;
      _accepted = $v.accepted;
      _answered = $v.answered;
      _windowOffers = $v.windowOffers;
      _warn = $v.warn;
      _alertPct = $v.alertPct;
      _offers = $v.offers.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainPerformanceDtoOutputAcceptance other) {
    _$v = other as _$CaptainPerformanceDtoOutputAcceptance;
  }

  @override
  void update(
    void Function(CaptainPerformanceDtoOutputAcceptanceBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainPerformanceDtoOutputAcceptance build() => _build();

  _$CaptainPerformanceDtoOutputAcceptance _build() {
    _$CaptainPerformanceDtoOutputAcceptance _$result;
    try {
      _$result =
          _$v ??
          _$CaptainPerformanceDtoOutputAcceptance._(
            rate: rate,
            accepted: BuiltValueNullFieldError.checkNotNull(
              accepted,
              r'CaptainPerformanceDtoOutputAcceptance',
              'accepted',
            ),
            answered: BuiltValueNullFieldError.checkNotNull(
              answered,
              r'CaptainPerformanceDtoOutputAcceptance',
              'answered',
            ),
            windowOffers: BuiltValueNullFieldError.checkNotNull(
              windowOffers,
              r'CaptainPerformanceDtoOutputAcceptance',
              'windowOffers',
            ),
            warn: BuiltValueNullFieldError.checkNotNull(
              warn,
              r'CaptainPerformanceDtoOutputAcceptance',
              'warn',
            ),
            alertPct: BuiltValueNullFieldError.checkNotNull(
              alertPct,
              r'CaptainPerformanceDtoOutputAcceptance',
              'alertPct',
            ),
            offers: offers.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'offers';
        offers.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainPerformanceDtoOutputAcceptance',
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
