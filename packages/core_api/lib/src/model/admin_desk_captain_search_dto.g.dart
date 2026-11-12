// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_desk_captain_search_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDeskCaptainSearchDto extends AdminDeskCaptainSearchDto {
  @override
  final String cityId;
  @override
  final String q;

  factory _$AdminDeskCaptainSearchDto([
    void Function(AdminDeskCaptainSearchDtoBuilder)? updates,
  ]) => (AdminDeskCaptainSearchDtoBuilder()..update(updates))._build();

  _$AdminDeskCaptainSearchDto._({required this.cityId, required this.q})
    : super._();
  @override
  AdminDeskCaptainSearchDto rebuild(
    void Function(AdminDeskCaptainSearchDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDeskCaptainSearchDtoBuilder toBuilder() =>
      AdminDeskCaptainSearchDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDeskCaptainSearchDto &&
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
    return (newBuiltValueToStringHelper(r'AdminDeskCaptainSearchDto')
          ..add('cityId', cityId)
          ..add('q', q))
        .toString();
  }
}

class AdminDeskCaptainSearchDtoBuilder
    implements
        Builder<AdminDeskCaptainSearchDto, AdminDeskCaptainSearchDtoBuilder> {
  _$AdminDeskCaptainSearchDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  String? _q;
  String? get q => _$this._q;
  set q(String? q) => _$this._q = q;

  AdminDeskCaptainSearchDtoBuilder() {
    AdminDeskCaptainSearchDto._defaults(this);
  }

  AdminDeskCaptainSearchDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _q = $v.q;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDeskCaptainSearchDto other) {
    _$v = other as _$AdminDeskCaptainSearchDto;
  }

  @override
  void update(void Function(AdminDeskCaptainSearchDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDeskCaptainSearchDto build() => _build();

  _$AdminDeskCaptainSearchDto _build() {
    final _$result =
        _$v ??
        _$AdminDeskCaptainSearchDto._(
          cityId: BuiltValueNullFieldError.checkNotNull(
            cityId,
            r'AdminDeskCaptainSearchDto',
            'cityId',
          ),
          q: BuiltValueNullFieldError.checkNotNull(
            q,
            r'AdminDeskCaptainSearchDto',
            'q',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
