// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_orders_dto_output_orders_inner_acceptance.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantOrdersDtoOutputOrdersInnerAcceptance
    extends MerchantOrdersDtoOutputOrdersInnerAcceptance {
  @override
  final DateTime at;
  @override
  final int prepMin;
  @override
  final DateTime prepDueAt;
  @override
  final String? deviceName;

  factory _$MerchantOrdersDtoOutputOrdersInnerAcceptance([
    void Function(MerchantOrdersDtoOutputOrdersInnerAcceptanceBuilder)? updates,
  ]) => (MerchantOrdersDtoOutputOrdersInnerAcceptanceBuilder()..update(updates))
      ._build();

  _$MerchantOrdersDtoOutputOrdersInnerAcceptance._({
    required this.at,
    required this.prepMin,
    required this.prepDueAt,
    this.deviceName,
  }) : super._();
  @override
  MerchantOrdersDtoOutputOrdersInnerAcceptance rebuild(
    void Function(MerchantOrdersDtoOutputOrdersInnerAcceptanceBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantOrdersDtoOutputOrdersInnerAcceptanceBuilder toBuilder() =>
      MerchantOrdersDtoOutputOrdersInnerAcceptanceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantOrdersDtoOutputOrdersInnerAcceptance &&
        at == other.at &&
        prepMin == other.prepMin &&
        prepDueAt == other.prepDueAt &&
        deviceName == other.deviceName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jc(_$hash, prepMin.hashCode);
    _$hash = $jc(_$hash, prepDueAt.hashCode);
    _$hash = $jc(_$hash, deviceName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'MerchantOrdersDtoOutputOrdersInnerAcceptance',
          )
          ..add('at', at)
          ..add('prepMin', prepMin)
          ..add('prepDueAt', prepDueAt)
          ..add('deviceName', deviceName))
        .toString();
  }
}

class MerchantOrdersDtoOutputOrdersInnerAcceptanceBuilder
    implements
        Builder<
          MerchantOrdersDtoOutputOrdersInnerAcceptance,
          MerchantOrdersDtoOutputOrdersInnerAcceptanceBuilder
        > {
  _$MerchantOrdersDtoOutputOrdersInnerAcceptance? _$v;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  int? _prepMin;
  int? get prepMin => _$this._prepMin;
  set prepMin(int? prepMin) => _$this._prepMin = prepMin;

  DateTime? _prepDueAt;
  DateTime? get prepDueAt => _$this._prepDueAt;
  set prepDueAt(DateTime? prepDueAt) => _$this._prepDueAt = prepDueAt;

  String? _deviceName;
  String? get deviceName => _$this._deviceName;
  set deviceName(String? deviceName) => _$this._deviceName = deviceName;

  MerchantOrdersDtoOutputOrdersInnerAcceptanceBuilder() {
    MerchantOrdersDtoOutputOrdersInnerAcceptance._defaults(this);
  }

  MerchantOrdersDtoOutputOrdersInnerAcceptanceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _at = $v.at;
      _prepMin = $v.prepMin;
      _prepDueAt = $v.prepDueAt;
      _deviceName = $v.deviceName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantOrdersDtoOutputOrdersInnerAcceptance other) {
    _$v = other as _$MerchantOrdersDtoOutputOrdersInnerAcceptance;
  }

  @override
  void update(
    void Function(MerchantOrdersDtoOutputOrdersInnerAcceptanceBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantOrdersDtoOutputOrdersInnerAcceptance build() => _build();

  _$MerchantOrdersDtoOutputOrdersInnerAcceptance _build() {
    final _$result =
        _$v ??
        _$MerchantOrdersDtoOutputOrdersInnerAcceptance._(
          at: BuiltValueNullFieldError.checkNotNull(
            at,
            r'MerchantOrdersDtoOutputOrdersInnerAcceptance',
            'at',
          ),
          prepMin: BuiltValueNullFieldError.checkNotNull(
            prepMin,
            r'MerchantOrdersDtoOutputOrdersInnerAcceptance',
            'prepMin',
          ),
          prepDueAt: BuiltValueNullFieldError.checkNotNull(
            prepDueAt,
            r'MerchantOrdersDtoOutputOrdersInnerAcceptance',
            'prepDueAt',
          ),
          deviceName: deviceName,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
