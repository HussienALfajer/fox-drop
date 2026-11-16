// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_exchange_rate_history_dto_output_versions_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminExchangeRateHistoryDtoOutputVersionsInner
    extends AdminExchangeRateHistoryDtoOutputVersionsInner {
  @override
  final String versionId;
  @override
  final String baseCurrency;
  @override
  final String numerator;
  @override
  final String denominator;
  @override
  final String editorId;
  @override
  final String? editorName;
  @override
  final String? reason;
  @override
  final DateTime setAt;

  factory _$AdminExchangeRateHistoryDtoOutputVersionsInner([
    void Function(AdminExchangeRateHistoryDtoOutputVersionsInnerBuilder)?
    updates,
  ]) =>
      (AdminExchangeRateHistoryDtoOutputVersionsInnerBuilder()..update(updates))
          ._build();

  _$AdminExchangeRateHistoryDtoOutputVersionsInner._({
    required this.versionId,
    required this.baseCurrency,
    required this.numerator,
    required this.denominator,
    required this.editorId,
    this.editorName,
    this.reason,
    required this.setAt,
  }) : super._();
  @override
  AdminExchangeRateHistoryDtoOutputVersionsInner rebuild(
    void Function(AdminExchangeRateHistoryDtoOutputVersionsInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminExchangeRateHistoryDtoOutputVersionsInnerBuilder toBuilder() =>
      AdminExchangeRateHistoryDtoOutputVersionsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminExchangeRateHistoryDtoOutputVersionsInner &&
        versionId == other.versionId &&
        baseCurrency == other.baseCurrency &&
        numerator == other.numerator &&
        denominator == other.denominator &&
        editorId == other.editorId &&
        editorName == other.editorName &&
        reason == other.reason &&
        setAt == other.setAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, versionId.hashCode);
    _$hash = $jc(_$hash, baseCurrency.hashCode);
    _$hash = $jc(_$hash, numerator.hashCode);
    _$hash = $jc(_$hash, denominator.hashCode);
    _$hash = $jc(_$hash, editorId.hashCode);
    _$hash = $jc(_$hash, editorName.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, setAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminExchangeRateHistoryDtoOutputVersionsInner',
          )
          ..add('versionId', versionId)
          ..add('baseCurrency', baseCurrency)
          ..add('numerator', numerator)
          ..add('denominator', denominator)
          ..add('editorId', editorId)
          ..add('editorName', editorName)
          ..add('reason', reason)
          ..add('setAt', setAt))
        .toString();
  }
}

class AdminExchangeRateHistoryDtoOutputVersionsInnerBuilder
    implements
        Builder<
          AdminExchangeRateHistoryDtoOutputVersionsInner,
          AdminExchangeRateHistoryDtoOutputVersionsInnerBuilder
        > {
  _$AdminExchangeRateHistoryDtoOutputVersionsInner? _$v;

  String? _versionId;
  String? get versionId => _$this._versionId;
  set versionId(String? versionId) => _$this._versionId = versionId;

  String? _baseCurrency;
  String? get baseCurrency => _$this._baseCurrency;
  set baseCurrency(String? baseCurrency) => _$this._baseCurrency = baseCurrency;

  String? _numerator;
  String? get numerator => _$this._numerator;
  set numerator(String? numerator) => _$this._numerator = numerator;

  String? _denominator;
  String? get denominator => _$this._denominator;
  set denominator(String? denominator) => _$this._denominator = denominator;

  String? _editorId;
  String? get editorId => _$this._editorId;
  set editorId(String? editorId) => _$this._editorId = editorId;

  String? _editorName;
  String? get editorName => _$this._editorName;
  set editorName(String? editorName) => _$this._editorName = editorName;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  DateTime? _setAt;
  DateTime? get setAt => _$this._setAt;
  set setAt(DateTime? setAt) => _$this._setAt = setAt;

  AdminExchangeRateHistoryDtoOutputVersionsInnerBuilder() {
    AdminExchangeRateHistoryDtoOutputVersionsInner._defaults(this);
  }

  AdminExchangeRateHistoryDtoOutputVersionsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _versionId = $v.versionId;
      _baseCurrency = $v.baseCurrency;
      _numerator = $v.numerator;
      _denominator = $v.denominator;
      _editorId = $v.editorId;
      _editorName = $v.editorName;
      _reason = $v.reason;
      _setAt = $v.setAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminExchangeRateHistoryDtoOutputVersionsInner other) {
    _$v = other as _$AdminExchangeRateHistoryDtoOutputVersionsInner;
  }

  @override
  void update(
    void Function(AdminExchangeRateHistoryDtoOutputVersionsInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminExchangeRateHistoryDtoOutputVersionsInner build() => _build();

  _$AdminExchangeRateHistoryDtoOutputVersionsInner _build() {
    final _$result =
        _$v ??
        _$AdminExchangeRateHistoryDtoOutputVersionsInner._(
          versionId: BuiltValueNullFieldError.checkNotNull(
            versionId,
            r'AdminExchangeRateHistoryDtoOutputVersionsInner',
            'versionId',
          ),
          baseCurrency: BuiltValueNullFieldError.checkNotNull(
            baseCurrency,
            r'AdminExchangeRateHistoryDtoOutputVersionsInner',
            'baseCurrency',
          ),
          numerator: BuiltValueNullFieldError.checkNotNull(
            numerator,
            r'AdminExchangeRateHistoryDtoOutputVersionsInner',
            'numerator',
          ),
          denominator: BuiltValueNullFieldError.checkNotNull(
            denominator,
            r'AdminExchangeRateHistoryDtoOutputVersionsInner',
            'denominator',
          ),
          editorId: BuiltValueNullFieldError.checkNotNull(
            editorId,
            r'AdminExchangeRateHistoryDtoOutputVersionsInner',
            'editorId',
          ),
          editorName: editorName,
          reason: reason,
          setAt: BuiltValueNullFieldError.checkNotNull(
            setAt,
            r'AdminExchangeRateHistoryDtoOutputVersionsInner',
            'setAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
