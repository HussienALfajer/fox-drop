// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_new_cashier_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantNewCashierDto extends MerchantNewCashierDto {
  @override
  final String name;
  @override
  final String phone;

  factory _$MerchantNewCashierDto([
    void Function(MerchantNewCashierDtoBuilder)? updates,
  ]) => (MerchantNewCashierDtoBuilder()..update(updates))._build();

  _$MerchantNewCashierDto._({required this.name, required this.phone})
    : super._();
  @override
  MerchantNewCashierDto rebuild(
    void Function(MerchantNewCashierDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantNewCashierDtoBuilder toBuilder() =>
      MerchantNewCashierDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantNewCashierDto &&
        name == other.name &&
        phone == other.phone;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantNewCashierDto')
          ..add('name', name)
          ..add('phone', phone))
        .toString();
  }
}

class MerchantNewCashierDtoBuilder
    implements Builder<MerchantNewCashierDto, MerchantNewCashierDtoBuilder> {
  _$MerchantNewCashierDto? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  MerchantNewCashierDtoBuilder() {
    MerchantNewCashierDto._defaults(this);
  }

  MerchantNewCashierDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _phone = $v.phone;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantNewCashierDto other) {
    _$v = other as _$MerchantNewCashierDto;
  }

  @override
  void update(void Function(MerchantNewCashierDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantNewCashierDto build() => _build();

  _$MerchantNewCashierDto _build() {
    final _$result =
        _$v ??
        _$MerchantNewCashierDto._(
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'MerchantNewCashierDto',
            'name',
          ),
          phone: BuiltValueNullFieldError.checkNotNull(
            phone,
            r'MerchantNewCashierDto',
            'phone',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
