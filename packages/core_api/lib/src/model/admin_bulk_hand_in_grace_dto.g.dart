// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_bulk_hand_in_grace_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminBulkHandInGraceDto extends AdminBulkHandInGraceDto {
  @override
  final String cityId;
  @override
  final String reason;

  factory _$AdminBulkHandInGraceDto([
    void Function(AdminBulkHandInGraceDtoBuilder)? updates,
  ]) => (AdminBulkHandInGraceDtoBuilder()..update(updates))._build();

  _$AdminBulkHandInGraceDto._({required this.cityId, required this.reason})
    : super._();
  @override
  AdminBulkHandInGraceDto rebuild(
    void Function(AdminBulkHandInGraceDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminBulkHandInGraceDtoBuilder toBuilder() =>
      AdminBulkHandInGraceDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminBulkHandInGraceDto &&
        cityId == other.cityId &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminBulkHandInGraceDto')
          ..add('cityId', cityId)
          ..add('reason', reason))
        .toString();
  }
}

class AdminBulkHandInGraceDtoBuilder
    implements
        Builder<AdminBulkHandInGraceDto, AdminBulkHandInGraceDtoBuilder> {
  _$AdminBulkHandInGraceDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AdminBulkHandInGraceDtoBuilder() {
    AdminBulkHandInGraceDto._defaults(this);
  }

  AdminBulkHandInGraceDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminBulkHandInGraceDto other) {
    _$v = other as _$AdminBulkHandInGraceDto;
  }

  @override
  void update(void Function(AdminBulkHandInGraceDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminBulkHandInGraceDto build() => _build();

  _$AdminBulkHandInGraceDto _build() {
    final _$result =
        _$v ??
        _$AdminBulkHandInGraceDto._(
          cityId: BuiltValueNullFieldError.checkNotNull(
            cityId,
            r'AdminBulkHandInGraceDto',
            'cityId',
          ),
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'AdminBulkHandInGraceDto',
            'reason',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
