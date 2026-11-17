// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_change_customer_phone_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminChangeCustomerPhoneDto extends AdminChangeCustomerPhoneDto {
  @override
  final String cityId;
  @override
  final String phone;
  @override
  final String note;

  factory _$AdminChangeCustomerPhoneDto([
    void Function(AdminChangeCustomerPhoneDtoBuilder)? updates,
  ]) => (AdminChangeCustomerPhoneDtoBuilder()..update(updates))._build();

  _$AdminChangeCustomerPhoneDto._({
    required this.cityId,
    required this.phone,
    required this.note,
  }) : super._();
  @override
  AdminChangeCustomerPhoneDto rebuild(
    void Function(AdminChangeCustomerPhoneDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminChangeCustomerPhoneDtoBuilder toBuilder() =>
      AdminChangeCustomerPhoneDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminChangeCustomerPhoneDto &&
        cityId == other.cityId &&
        phone == other.phone &&
        note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminChangeCustomerPhoneDto')
          ..add('cityId', cityId)
          ..add('phone', phone)
          ..add('note', note))
        .toString();
  }
}

class AdminChangeCustomerPhoneDtoBuilder
    implements
        Builder<
          AdminChangeCustomerPhoneDto,
          AdminChangeCustomerPhoneDtoBuilder
        > {
  _$AdminChangeCustomerPhoneDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  AdminChangeCustomerPhoneDtoBuilder() {
    AdminChangeCustomerPhoneDto._defaults(this);
  }

  AdminChangeCustomerPhoneDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _phone = $v.phone;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminChangeCustomerPhoneDto other) {
    _$v = other as _$AdminChangeCustomerPhoneDto;
  }

  @override
  void update(void Function(AdminChangeCustomerPhoneDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminChangeCustomerPhoneDto build() => _build();

  _$AdminChangeCustomerPhoneDto _build() {
    final _$result =
        _$v ??
        _$AdminChangeCustomerPhoneDto._(
          cityId: BuiltValueNullFieldError.checkNotNull(
            cityId,
            r'AdminChangeCustomerPhoneDto',
            'cityId',
          ),
          phone: BuiltValueNullFieldError.checkNotNull(
            phone,
            r'AdminChangeCustomerPhoneDto',
            'phone',
          ),
          note: BuiltValueNullFieldError.checkNotNull(
            note,
            r'AdminChangeCustomerPhoneDto',
            'note',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
