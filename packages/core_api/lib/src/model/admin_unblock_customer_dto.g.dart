// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_unblock_customer_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminUnblockCustomerDto extends AdminUnblockCustomerDto {
  @override
  final String cityId;
  @override
  final String note;

  factory _$AdminUnblockCustomerDto([
    void Function(AdminUnblockCustomerDtoBuilder)? updates,
  ]) => (AdminUnblockCustomerDtoBuilder()..update(updates))._build();

  _$AdminUnblockCustomerDto._({required this.cityId, required this.note})
    : super._();
  @override
  AdminUnblockCustomerDto rebuild(
    void Function(AdminUnblockCustomerDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminUnblockCustomerDtoBuilder toBuilder() =>
      AdminUnblockCustomerDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminUnblockCustomerDto &&
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
    return (newBuiltValueToStringHelper(r'AdminUnblockCustomerDto')
          ..add('cityId', cityId)
          ..add('note', note))
        .toString();
  }
}

class AdminUnblockCustomerDtoBuilder
    implements
        Builder<AdminUnblockCustomerDto, AdminUnblockCustomerDtoBuilder> {
  _$AdminUnblockCustomerDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  AdminUnblockCustomerDtoBuilder() {
    AdminUnblockCustomerDto._defaults(this);
  }

  AdminUnblockCustomerDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminUnblockCustomerDto other) {
    _$v = other as _$AdminUnblockCustomerDto;
  }

  @override
  void update(void Function(AdminUnblockCustomerDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminUnblockCustomerDto build() => _build();

  _$AdminUnblockCustomerDto _build() {
    final _$result =
        _$v ??
        _$AdminUnblockCustomerDto._(
          cityId: BuiltValueNullFieldError.checkNotNull(
            cityId,
            r'AdminUnblockCustomerDto',
            'cityId',
          ),
          note: BuiltValueNullFieldError.checkNotNull(
            note,
            r'AdminUnblockCustomerDto',
            'note',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
