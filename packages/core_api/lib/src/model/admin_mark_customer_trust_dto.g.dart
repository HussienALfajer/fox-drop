// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_mark_customer_trust_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminMarkCustomerTrustDto extends AdminMarkCustomerTrustDto {
  @override
  final String cityId;
  @override
  final bool trusted;
  @override
  final String note;

  factory _$AdminMarkCustomerTrustDto([
    void Function(AdminMarkCustomerTrustDtoBuilder)? updates,
  ]) => (AdminMarkCustomerTrustDtoBuilder()..update(updates))._build();

  _$AdminMarkCustomerTrustDto._({
    required this.cityId,
    required this.trusted,
    required this.note,
  }) : super._();
  @override
  AdminMarkCustomerTrustDto rebuild(
    void Function(AdminMarkCustomerTrustDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminMarkCustomerTrustDtoBuilder toBuilder() =>
      AdminMarkCustomerTrustDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminMarkCustomerTrustDto &&
        cityId == other.cityId &&
        trusted == other.trusted &&
        note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, trusted.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminMarkCustomerTrustDto')
          ..add('cityId', cityId)
          ..add('trusted', trusted)
          ..add('note', note))
        .toString();
  }
}

class AdminMarkCustomerTrustDtoBuilder
    implements
        Builder<AdminMarkCustomerTrustDto, AdminMarkCustomerTrustDtoBuilder> {
  _$AdminMarkCustomerTrustDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  bool? _trusted;
  bool? get trusted => _$this._trusted;
  set trusted(bool? trusted) => _$this._trusted = trusted;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  AdminMarkCustomerTrustDtoBuilder() {
    AdminMarkCustomerTrustDto._defaults(this);
  }

  AdminMarkCustomerTrustDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _trusted = $v.trusted;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminMarkCustomerTrustDto other) {
    _$v = other as _$AdminMarkCustomerTrustDto;
  }

  @override
  void update(void Function(AdminMarkCustomerTrustDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminMarkCustomerTrustDto build() => _build();

  _$AdminMarkCustomerTrustDto _build() {
    final _$result =
        _$v ??
        _$AdminMarkCustomerTrustDto._(
          cityId: BuiltValueNullFieldError.checkNotNull(
            cityId,
            r'AdminMarkCustomerTrustDto',
            'cityId',
          ),
          trusted: BuiltValueNullFieldError.checkNotNull(
            trusted,
            r'AdminMarkCustomerTrustDto',
            'trusted',
          ),
          note: BuiltValueNullFieldError.checkNotNull(
            note,
            r'AdminMarkCustomerTrustDto',
            'note',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
