// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_order_settings_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantOrderSettingsDto extends MerchantOrderSettingsDto {
  @override
  final int defaultPrepMin;
  @override
  final int? maxActiveOrders;

  factory _$MerchantOrderSettingsDto([
    void Function(MerchantOrderSettingsDtoBuilder)? updates,
  ]) => (MerchantOrderSettingsDtoBuilder()..update(updates))._build();

  _$MerchantOrderSettingsDto._({
    required this.defaultPrepMin,
    this.maxActiveOrders,
  }) : super._();
  @override
  MerchantOrderSettingsDto rebuild(
    void Function(MerchantOrderSettingsDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantOrderSettingsDtoBuilder toBuilder() =>
      MerchantOrderSettingsDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantOrderSettingsDto &&
        defaultPrepMin == other.defaultPrepMin &&
        maxActiveOrders == other.maxActiveOrders;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, defaultPrepMin.hashCode);
    _$hash = $jc(_$hash, maxActiveOrders.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantOrderSettingsDto')
          ..add('defaultPrepMin', defaultPrepMin)
          ..add('maxActiveOrders', maxActiveOrders))
        .toString();
  }
}

class MerchantOrderSettingsDtoBuilder
    implements
        Builder<MerchantOrderSettingsDto, MerchantOrderSettingsDtoBuilder> {
  _$MerchantOrderSettingsDto? _$v;

  int? _defaultPrepMin;
  int? get defaultPrepMin => _$this._defaultPrepMin;
  set defaultPrepMin(int? defaultPrepMin) =>
      _$this._defaultPrepMin = defaultPrepMin;

  int? _maxActiveOrders;
  int? get maxActiveOrders => _$this._maxActiveOrders;
  set maxActiveOrders(int? maxActiveOrders) =>
      _$this._maxActiveOrders = maxActiveOrders;

  MerchantOrderSettingsDtoBuilder() {
    MerchantOrderSettingsDto._defaults(this);
  }

  MerchantOrderSettingsDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _defaultPrepMin = $v.defaultPrepMin;
      _maxActiveOrders = $v.maxActiveOrders;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantOrderSettingsDto other) {
    _$v = other as _$MerchantOrderSettingsDto;
  }

  @override
  void update(void Function(MerchantOrderSettingsDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantOrderSettingsDto build() => _build();

  _$MerchantOrderSettingsDto _build() {
    final _$result =
        _$v ??
        _$MerchantOrderSettingsDto._(
          defaultPrepMin: BuiltValueNullFieldError.checkNotNull(
            defaultPrepMin,
            r'MerchantOrderSettingsDto',
            'defaultPrepMin',
          ),
          maxActiveOrders: maxActiveOrders,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
