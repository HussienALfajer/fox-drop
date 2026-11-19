// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_set_city_currency_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminSetCityCurrencyDto extends AdminSetCityCurrencyDto {
  @override
  final int displayOrder;
  @override
  final bool enabled;
  @override
  final String? reason;

  factory _$AdminSetCityCurrencyDto([
    void Function(AdminSetCityCurrencyDtoBuilder)? updates,
  ]) => (AdminSetCityCurrencyDtoBuilder()..update(updates))._build();

  _$AdminSetCityCurrencyDto._({
    required this.displayOrder,
    required this.enabled,
    this.reason,
  }) : super._();
  @override
  AdminSetCityCurrencyDto rebuild(
    void Function(AdminSetCityCurrencyDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminSetCityCurrencyDtoBuilder toBuilder() =>
      AdminSetCityCurrencyDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSetCityCurrencyDto &&
        displayOrder == other.displayOrder &&
        enabled == other.enabled &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, displayOrder.hashCode);
    _$hash = $jc(_$hash, enabled.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminSetCityCurrencyDto')
          ..add('displayOrder', displayOrder)
          ..add('enabled', enabled)
          ..add('reason', reason))
        .toString();
  }
}

class AdminSetCityCurrencyDtoBuilder
    implements
        Builder<AdminSetCityCurrencyDto, AdminSetCityCurrencyDtoBuilder> {
  _$AdminSetCityCurrencyDto? _$v;

  int? _displayOrder;
  int? get displayOrder => _$this._displayOrder;
  set displayOrder(int? displayOrder) => _$this._displayOrder = displayOrder;

  bool? _enabled;
  bool? get enabled => _$this._enabled;
  set enabled(bool? enabled) => _$this._enabled = enabled;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AdminSetCityCurrencyDtoBuilder() {
    AdminSetCityCurrencyDto._defaults(this);
  }

  AdminSetCityCurrencyDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _displayOrder = $v.displayOrder;
      _enabled = $v.enabled;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSetCityCurrencyDto other) {
    _$v = other as _$AdminSetCityCurrencyDto;
  }

  @override
  void update(void Function(AdminSetCityCurrencyDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminSetCityCurrencyDto build() => _build();

  _$AdminSetCityCurrencyDto _build() {
    final _$result =
        _$v ??
        _$AdminSetCityCurrencyDto._(
          displayOrder: BuiltValueNullFieldError.checkNotNull(
            displayOrder,
            r'AdminSetCityCurrencyDto',
            'displayOrder',
          ),
          enabled: BuiltValueNullFieldError.checkNotNull(
            enabled,
            r'AdminSetCityCurrencyDto',
            'enabled',
          ),
          reason: reason,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
