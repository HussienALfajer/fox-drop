// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_search_query_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminSearchQueryDto extends AdminSearchQueryDto {
  @override
  final String cityId;
  @override
  final String q;

  factory _$AdminSearchQueryDto([
    void Function(AdminSearchQueryDtoBuilder)? updates,
  ]) => (AdminSearchQueryDtoBuilder()..update(updates))._build();

  _$AdminSearchQueryDto._({required this.cityId, required this.q}) : super._();
  @override
  AdminSearchQueryDto rebuild(
    void Function(AdminSearchQueryDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminSearchQueryDtoBuilder toBuilder() =>
      AdminSearchQueryDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSearchQueryDto &&
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
    return (newBuiltValueToStringHelper(r'AdminSearchQueryDto')
          ..add('cityId', cityId)
          ..add('q', q))
        .toString();
  }
}

class AdminSearchQueryDtoBuilder
    implements Builder<AdminSearchQueryDto, AdminSearchQueryDtoBuilder> {
  _$AdminSearchQueryDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  String? _q;
  String? get q => _$this._q;
  set q(String? q) => _$this._q = q;

  AdminSearchQueryDtoBuilder() {
    AdminSearchQueryDto._defaults(this);
  }

  AdminSearchQueryDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _q = $v.q;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSearchQueryDto other) {
    _$v = other as _$AdminSearchQueryDto;
  }

  @override
  void update(void Function(AdminSearchQueryDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminSearchQueryDto build() => _build();

  _$AdminSearchQueryDto _build() {
    final _$result =
        _$v ??
        _$AdminSearchQueryDto._(
          cityId: BuiltValueNullFieldError.checkNotNull(
            cityId,
            r'AdminSearchQueryDto',
            'cityId',
          ),
          q: BuiltValueNullFieldError.checkNotNull(
            q,
            r'AdminSearchQueryDto',
            'q',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
