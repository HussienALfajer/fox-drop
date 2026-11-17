// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_clear_customer_strikes_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminClearCustomerStrikesDto extends AdminClearCustomerStrikesDto {
  @override
  final String cityId;
  @override
  final String note;

  factory _$AdminClearCustomerStrikesDto([
    void Function(AdminClearCustomerStrikesDtoBuilder)? updates,
  ]) => (AdminClearCustomerStrikesDtoBuilder()..update(updates))._build();

  _$AdminClearCustomerStrikesDto._({required this.cityId, required this.note})
    : super._();
  @override
  AdminClearCustomerStrikesDto rebuild(
    void Function(AdminClearCustomerStrikesDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminClearCustomerStrikesDtoBuilder toBuilder() =>
      AdminClearCustomerStrikesDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminClearCustomerStrikesDto &&
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
    return (newBuiltValueToStringHelper(r'AdminClearCustomerStrikesDto')
          ..add('cityId', cityId)
          ..add('note', note))
        .toString();
  }
}

class AdminClearCustomerStrikesDtoBuilder
    implements
        Builder<
          AdminClearCustomerStrikesDto,
          AdminClearCustomerStrikesDtoBuilder
        > {
  _$AdminClearCustomerStrikesDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  AdminClearCustomerStrikesDtoBuilder() {
    AdminClearCustomerStrikesDto._defaults(this);
  }

  AdminClearCustomerStrikesDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminClearCustomerStrikesDto other) {
    _$v = other as _$AdminClearCustomerStrikesDto;
  }

  @override
  void update(void Function(AdminClearCustomerStrikesDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminClearCustomerStrikesDto build() => _build();

  _$AdminClearCustomerStrikesDto _build() {
    final _$result =
        _$v ??
        _$AdminClearCustomerStrikesDto._(
          cityId: BuiltValueNullFieldError.checkNotNull(
            cityId,
            r'AdminClearCustomerStrikesDto',
            'cityId',
          ),
          note: BuiltValueNullFieldError.checkNotNull(
            note,
            r'AdminClearCustomerStrikesDto',
            'note',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
