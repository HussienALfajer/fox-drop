// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_pay_tables_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminPayTablesDtoOutput extends AdminPayTablesDtoOutput {
  @override
  final String? baseCurrency;
  @override
  final int waitingThresholdMin;
  @override
  final int noticeDays;
  @override
  final DateTime earliestStart;
  @override
  final BuiltList<AdminPayTablesDtoOutputMaxDistanceKmInner> maxDistanceKm;
  @override
  final BuiltList<AdminPayTablesDtoOutputVersionsInner> versions;

  factory _$AdminPayTablesDtoOutput([
    void Function(AdminPayTablesDtoOutputBuilder)? updates,
  ]) => (AdminPayTablesDtoOutputBuilder()..update(updates))._build();

  _$AdminPayTablesDtoOutput._({
    this.baseCurrency,
    required this.waitingThresholdMin,
    required this.noticeDays,
    required this.earliestStart,
    required this.maxDistanceKm,
    required this.versions,
  }) : super._();
  @override
  AdminPayTablesDtoOutput rebuild(
    void Function(AdminPayTablesDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminPayTablesDtoOutputBuilder toBuilder() =>
      AdminPayTablesDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminPayTablesDtoOutput &&
        baseCurrency == other.baseCurrency &&
        waitingThresholdMin == other.waitingThresholdMin &&
        noticeDays == other.noticeDays &&
        earliestStart == other.earliestStart &&
        maxDistanceKm == other.maxDistanceKm &&
        versions == other.versions;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, baseCurrency.hashCode);
    _$hash = $jc(_$hash, waitingThresholdMin.hashCode);
    _$hash = $jc(_$hash, noticeDays.hashCode);
    _$hash = $jc(_$hash, earliestStart.hashCode);
    _$hash = $jc(_$hash, maxDistanceKm.hashCode);
    _$hash = $jc(_$hash, versions.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminPayTablesDtoOutput')
          ..add('baseCurrency', baseCurrency)
          ..add('waitingThresholdMin', waitingThresholdMin)
          ..add('noticeDays', noticeDays)
          ..add('earliestStart', earliestStart)
          ..add('maxDistanceKm', maxDistanceKm)
          ..add('versions', versions))
        .toString();
  }
}

class AdminPayTablesDtoOutputBuilder
    implements
        Builder<AdminPayTablesDtoOutput, AdminPayTablesDtoOutputBuilder> {
  _$AdminPayTablesDtoOutput? _$v;

  String? _baseCurrency;
  String? get baseCurrency => _$this._baseCurrency;
  set baseCurrency(String? baseCurrency) => _$this._baseCurrency = baseCurrency;

  int? _waitingThresholdMin;
  int? get waitingThresholdMin => _$this._waitingThresholdMin;
  set waitingThresholdMin(int? waitingThresholdMin) =>
      _$this._waitingThresholdMin = waitingThresholdMin;

  int? _noticeDays;
  int? get noticeDays => _$this._noticeDays;
  set noticeDays(int? noticeDays) => _$this._noticeDays = noticeDays;

  DateTime? _earliestStart;
  DateTime? get earliestStart => _$this._earliestStart;
  set earliestStart(DateTime? earliestStart) =>
      _$this._earliestStart = earliestStart;

  ListBuilder<AdminPayTablesDtoOutputMaxDistanceKmInner>? _maxDistanceKm;
  ListBuilder<AdminPayTablesDtoOutputMaxDistanceKmInner> get maxDistanceKm =>
      _$this._maxDistanceKm ??=
          ListBuilder<AdminPayTablesDtoOutputMaxDistanceKmInner>();
  set maxDistanceKm(
    ListBuilder<AdminPayTablesDtoOutputMaxDistanceKmInner>? maxDistanceKm,
  ) => _$this._maxDistanceKm = maxDistanceKm;

  ListBuilder<AdminPayTablesDtoOutputVersionsInner>? _versions;
  ListBuilder<AdminPayTablesDtoOutputVersionsInner> get versions =>
      _$this._versions ??= ListBuilder<AdminPayTablesDtoOutputVersionsInner>();
  set versions(ListBuilder<AdminPayTablesDtoOutputVersionsInner>? versions) =>
      _$this._versions = versions;

  AdminPayTablesDtoOutputBuilder() {
    AdminPayTablesDtoOutput._defaults(this);
  }

  AdminPayTablesDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _baseCurrency = $v.baseCurrency;
      _waitingThresholdMin = $v.waitingThresholdMin;
      _noticeDays = $v.noticeDays;
      _earliestStart = $v.earliestStart;
      _maxDistanceKm = $v.maxDistanceKm.toBuilder();
      _versions = $v.versions.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminPayTablesDtoOutput other) {
    _$v = other as _$AdminPayTablesDtoOutput;
  }

  @override
  void update(void Function(AdminPayTablesDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminPayTablesDtoOutput build() => _build();

  _$AdminPayTablesDtoOutput _build() {
    _$AdminPayTablesDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminPayTablesDtoOutput._(
            baseCurrency: baseCurrency,
            waitingThresholdMin: BuiltValueNullFieldError.checkNotNull(
              waitingThresholdMin,
              r'AdminPayTablesDtoOutput',
              'waitingThresholdMin',
            ),
            noticeDays: BuiltValueNullFieldError.checkNotNull(
              noticeDays,
              r'AdminPayTablesDtoOutput',
              'noticeDays',
            ),
            earliestStart: BuiltValueNullFieldError.checkNotNull(
              earliestStart,
              r'AdminPayTablesDtoOutput',
              'earliestStart',
            ),
            maxDistanceKm: maxDistanceKm.build(),
            versions: versions.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'maxDistanceKm';
        maxDistanceKm.build();
        _$failedField = 'versions';
        versions.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminPayTablesDtoOutput',
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
