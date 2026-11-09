// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_status_dto_output_busy_mode.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantStatusDtoOutputBusyMode
    extends MerchantStatusDtoOutputBusyMode {
  @override
  final int extraMin;
  @override
  final DateTime until;

  factory _$MerchantStatusDtoOutputBusyMode([
    void Function(MerchantStatusDtoOutputBusyModeBuilder)? updates,
  ]) => (MerchantStatusDtoOutputBusyModeBuilder()..update(updates))._build();

  _$MerchantStatusDtoOutputBusyMode._({
    required this.extraMin,
    required this.until,
  }) : super._();
  @override
  MerchantStatusDtoOutputBusyMode rebuild(
    void Function(MerchantStatusDtoOutputBusyModeBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantStatusDtoOutputBusyModeBuilder toBuilder() =>
      MerchantStatusDtoOutputBusyModeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantStatusDtoOutputBusyMode &&
        extraMin == other.extraMin &&
        until == other.until;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, extraMin.hashCode);
    _$hash = $jc(_$hash, until.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantStatusDtoOutputBusyMode')
          ..add('extraMin', extraMin)
          ..add('until', until))
        .toString();
  }
}

class MerchantStatusDtoOutputBusyModeBuilder
    implements
        Builder<
          MerchantStatusDtoOutputBusyMode,
          MerchantStatusDtoOutputBusyModeBuilder
        > {
  _$MerchantStatusDtoOutputBusyMode? _$v;

  int? _extraMin;
  int? get extraMin => _$this._extraMin;
  set extraMin(int? extraMin) => _$this._extraMin = extraMin;

  DateTime? _until;
  DateTime? get until => _$this._until;
  set until(DateTime? until) => _$this._until = until;

  MerchantStatusDtoOutputBusyModeBuilder() {
    MerchantStatusDtoOutputBusyMode._defaults(this);
  }

  MerchantStatusDtoOutputBusyModeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _extraMin = $v.extraMin;
      _until = $v.until;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantStatusDtoOutputBusyMode other) {
    _$v = other as _$MerchantStatusDtoOutputBusyMode;
  }

  @override
  void update(void Function(MerchantStatusDtoOutputBusyModeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantStatusDtoOutputBusyMode build() => _build();

  _$MerchantStatusDtoOutputBusyMode _build() {
    final _$result =
        _$v ??
        _$MerchantStatusDtoOutputBusyMode._(
          extraMin: BuiltValueNullFieldError.checkNotNull(
            extraMin,
            r'MerchantStatusDtoOutputBusyMode',
            'extraMin',
          ),
          until: BuiltValueNullFieldError.checkNotNull(
            until,
            r'MerchantStatusDtoOutputBusyMode',
            'until',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
