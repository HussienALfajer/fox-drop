// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_customer_sign_out_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCustomerSignOutDto extends AdminCustomerSignOutDto {
  @override
  final String cityId;
  @override
  final String note;

  factory _$AdminCustomerSignOutDto([
    void Function(AdminCustomerSignOutDtoBuilder)? updates,
  ]) => (AdminCustomerSignOutDtoBuilder()..update(updates))._build();

  _$AdminCustomerSignOutDto._({required this.cityId, required this.note})
    : super._();
  @override
  AdminCustomerSignOutDto rebuild(
    void Function(AdminCustomerSignOutDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCustomerSignOutDtoBuilder toBuilder() =>
      AdminCustomerSignOutDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCustomerSignOutDto &&
        cityId == other.cityId &&
        note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminCustomerSignOutDto')
          ..add('cityId', cityId)
          ..add('note', note))
        .toString();
  }
}

class AdminCustomerSignOutDtoBuilder
    implements
        Builder<AdminCustomerSignOutDto, AdminCustomerSignOutDtoBuilder> {
  _$AdminCustomerSignOutDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  AdminCustomerSignOutDtoBuilder() {
    AdminCustomerSignOutDto._defaults(this);
  }

  AdminCustomerSignOutDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCustomerSignOutDto other) {
    _$v = other as _$AdminCustomerSignOutDto;
  }

  @override
  void update(void Function(AdminCustomerSignOutDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCustomerSignOutDto build() => _build();

  _$AdminCustomerSignOutDto _build() {
    final _$result =
        _$v ??
        _$AdminCustomerSignOutDto._(
          cityId: BuiltValueNullFieldError.checkNotNull(
            cityId,
            r'AdminCustomerSignOutDto',
            'cityId',
          ),
          note: BuiltValueNullFieldError.checkNotNull(
            note,
            r'AdminCustomerSignOutDto',
            'note',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
