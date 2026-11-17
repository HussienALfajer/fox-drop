// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_customer_search_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCustomerSearchDto extends AdminCustomerSearchDto {
  @override
  final String cityId;
  @override
  final String q;

  factory _$AdminCustomerSearchDto([
    void Function(AdminCustomerSearchDtoBuilder)? updates,
  ]) => (AdminCustomerSearchDtoBuilder()..update(updates))._build();

  _$AdminCustomerSearchDto._({required this.cityId, required this.q})
    : super._();
  @override
  AdminCustomerSearchDto rebuild(
    void Function(AdminCustomerSearchDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCustomerSearchDtoBuilder toBuilder() =>
      AdminCustomerSearchDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCustomerSearchDto &&
        cityId == other.cityId &&
        q == other.q;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, q.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminCustomerSearchDto')
          ..add('cityId', cityId)
          ..add('q', q))
        .toString();
  }
}

class AdminCustomerSearchDtoBuilder
    implements Builder<AdminCustomerSearchDto, AdminCustomerSearchDtoBuilder> {
  _$AdminCustomerSearchDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  String? _q;
  String? get q => _$this._q;
  set q(String? q) => _$this._q = q;

  AdminCustomerSearchDtoBuilder() {
    AdminCustomerSearchDto._defaults(this);
  }

  AdminCustomerSearchDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _q = $v.q;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCustomerSearchDto other) {
    _$v = other as _$AdminCustomerSearchDto;
  }

  @override
  void update(void Function(AdminCustomerSearchDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCustomerSearchDto build() => _build();

  _$AdminCustomerSearchDto _build() {
    final _$result =
        _$v ??
        _$AdminCustomerSearchDto._(
          cityId: BuiltValueNullFieldError.checkNotNull(
            cityId,
            r'AdminCustomerSearchDto',
            'cityId',
          ),
          q: BuiltValueNullFieldError.checkNotNull(
            q,
            r'AdminCustomerSearchDto',
            'q',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
