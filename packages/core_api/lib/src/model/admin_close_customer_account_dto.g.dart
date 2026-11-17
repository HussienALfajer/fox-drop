// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_close_customer_account_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCloseCustomerAccountDto extends AdminCloseCustomerAccountDto {
  @override
  final String cityId;
  @override
  final String note;

  factory _$AdminCloseCustomerAccountDto([
    void Function(AdminCloseCustomerAccountDtoBuilder)? updates,
  ]) => (AdminCloseCustomerAccountDtoBuilder()..update(updates))._build();

  _$AdminCloseCustomerAccountDto._({required this.cityId, required this.note})
    : super._();
  @override
  AdminCloseCustomerAccountDto rebuild(
    void Function(AdminCloseCustomerAccountDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCloseCustomerAccountDtoBuilder toBuilder() =>
      AdminCloseCustomerAccountDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCloseCustomerAccountDto &&
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
    return (newBuiltValueToStringHelper(r'AdminCloseCustomerAccountDto')
          ..add('cityId', cityId)
          ..add('note', note))
        .toString();
  }
}

class AdminCloseCustomerAccountDtoBuilder
    implements
        Builder<
          AdminCloseCustomerAccountDto,
          AdminCloseCustomerAccountDtoBuilder
        > {
  _$AdminCloseCustomerAccountDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  AdminCloseCustomerAccountDtoBuilder() {
    AdminCloseCustomerAccountDto._defaults(this);
  }

  AdminCloseCustomerAccountDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCloseCustomerAccountDto other) {
    _$v = other as _$AdminCloseCustomerAccountDto;
  }

  @override
  void update(void Function(AdminCloseCustomerAccountDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCloseCustomerAccountDto build() => _build();

  _$AdminCloseCustomerAccountDto _build() {
    final _$result =
        _$v ??
        _$AdminCloseCustomerAccountDto._(
          cityId: BuiltValueNullFieldError.checkNotNull(
            cityId,
            r'AdminCloseCustomerAccountDto',
            'cityId',
          ),
          note: BuiltValueNullFieldError.checkNotNull(
            note,
            r'AdminCloseCustomerAccountDto',
            'note',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
