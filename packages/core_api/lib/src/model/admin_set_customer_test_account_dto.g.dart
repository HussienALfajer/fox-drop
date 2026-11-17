// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_set_customer_test_account_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminSetCustomerTestAccountDto extends AdminSetCustomerTestAccountDto {
  @override
  final String cityId;
  @override
  final bool flagged;

  factory _$AdminSetCustomerTestAccountDto([
    void Function(AdminSetCustomerTestAccountDtoBuilder)? updates,
  ]) => (AdminSetCustomerTestAccountDtoBuilder()..update(updates))._build();

  _$AdminSetCustomerTestAccountDto._({
    required this.cityId,
    required this.flagged,
  }) : super._();
  @override
  AdminSetCustomerTestAccountDto rebuild(
    void Function(AdminSetCustomerTestAccountDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminSetCustomerTestAccountDtoBuilder toBuilder() =>
      AdminSetCustomerTestAccountDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSetCustomerTestAccountDto &&
        cityId == other.cityId &&
        flagged == other.flagged;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, flagged.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminSetCustomerTestAccountDto')
          ..add('cityId', cityId)
          ..add('flagged', flagged))
        .toString();
  }
}

class AdminSetCustomerTestAccountDtoBuilder
    implements
        Builder<
          AdminSetCustomerTestAccountDto,
          AdminSetCustomerTestAccountDtoBuilder
        > {
  _$AdminSetCustomerTestAccountDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  bool? _flagged;
  bool? get flagged => _$this._flagged;
  set flagged(bool? flagged) => _$this._flagged = flagged;

  AdminSetCustomerTestAccountDtoBuilder() {
    AdminSetCustomerTestAccountDto._defaults(this);
  }

  AdminSetCustomerTestAccountDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _flagged = $v.flagged;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSetCustomerTestAccountDto other) {
    _$v = other as _$AdminSetCustomerTestAccountDto;
  }

  @override
  void update(void Function(AdminSetCustomerTestAccountDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminSetCustomerTestAccountDto build() => _build();

  _$AdminSetCustomerTestAccountDto _build() {
    final _$result =
        _$v ??
        _$AdminSetCustomerTestAccountDto._(
          cityId: BuiltValueNullFieldError.checkNotNull(
            cityId,
            r'AdminSetCustomerTestAccountDto',
            'cityId',
          ),
          flagged: BuiltValueNullFieldError.checkNotNull(
            flagged,
            r'AdminSetCustomerTestAccountDto',
            'flagged',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
