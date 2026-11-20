// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_this_device_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantThisDeviceDtoOutput extends MerchantThisDeviceDtoOutput {
  @override
  final bool ringing;
  @override
  final MerchantDeviceCheckOutput? check;

  factory _$MerchantThisDeviceDtoOutput([
    void Function(MerchantThisDeviceDtoOutputBuilder)? updates,
  ]) => (MerchantThisDeviceDtoOutputBuilder()..update(updates))._build();

  _$MerchantThisDeviceDtoOutput._({required this.ringing, this.check})
    : super._();
  @override
  MerchantThisDeviceDtoOutput rebuild(
    void Function(MerchantThisDeviceDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantThisDeviceDtoOutputBuilder toBuilder() =>
      MerchantThisDeviceDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantThisDeviceDtoOutput &&
        ringing == other.ringing &&
        check == other.check;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ringing.hashCode);
    _$hash = $jc(_$hash, check.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantThisDeviceDtoOutput')
          ..add('ringing', ringing)
          ..add('check', check))
        .toString();
  }
}

class MerchantThisDeviceDtoOutputBuilder
    implements
        Builder<
          MerchantThisDeviceDtoOutput,
          MerchantThisDeviceDtoOutputBuilder
        > {
  _$MerchantThisDeviceDtoOutput? _$v;

  bool? _ringing;
  bool? get ringing => _$this._ringing;
  set ringing(bool? ringing) => _$this._ringing = ringing;

  MerchantDeviceCheckOutputBuilder? _check;
  MerchantDeviceCheckOutputBuilder get check =>
      _$this._check ??= MerchantDeviceCheckOutputBuilder();
  set check(MerchantDeviceCheckOutputBuilder? check) => _$this._check = check;

  MerchantThisDeviceDtoOutputBuilder() {
    MerchantThisDeviceDtoOutput._defaults(this);
  }

  MerchantThisDeviceDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ringing = $v.ringing;
      _check = $v.check?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantThisDeviceDtoOutput other) {
    _$v = other as _$MerchantThisDeviceDtoOutput;
  }

  @override
  void update(void Function(MerchantThisDeviceDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantThisDeviceDtoOutput build() => _build();

  _$MerchantThisDeviceDtoOutput _build() {
    _$MerchantThisDeviceDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$MerchantThisDeviceDtoOutput._(
            ringing: BuiltValueNullFieldError.checkNotNull(
              ringing,
              r'MerchantThisDeviceDtoOutput',
              'ringing',
            ),
            check: _check?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'check';
        _check?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantThisDeviceDtoOutput',
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
