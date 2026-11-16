// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_manual_reversal_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminManualReversalDto extends AdminManualReversalDto {
  @override
  final String cityId;
  @override
  final String journalId;
  @override
  final String reason;

  factory _$AdminManualReversalDto([
    void Function(AdminManualReversalDtoBuilder)? updates,
  ]) => (AdminManualReversalDtoBuilder()..update(updates))._build();

  _$AdminManualReversalDto._({
    required this.cityId,
    required this.journalId,
    required this.reason,
  }) : super._();
  @override
  AdminManualReversalDto rebuild(
    void Function(AdminManualReversalDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminManualReversalDtoBuilder toBuilder() =>
      AdminManualReversalDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminManualReversalDto &&
        cityId == other.cityId &&
        journalId == other.journalId &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, journalId.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminManualReversalDto')
          ..add('cityId', cityId)
          ..add('journalId', journalId)
          ..add('reason', reason))
        .toString();
  }
}

class AdminManualReversalDtoBuilder
    implements Builder<AdminManualReversalDto, AdminManualReversalDtoBuilder> {
  _$AdminManualReversalDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  String? _journalId;
  String? get journalId => _$this._journalId;
  set journalId(String? journalId) => _$this._journalId = journalId;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AdminManualReversalDtoBuilder() {
    AdminManualReversalDto._defaults(this);
  }

  AdminManualReversalDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _journalId = $v.journalId;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminManualReversalDto other) {
    _$v = other as _$AdminManualReversalDto;
  }

  @override
  void update(void Function(AdminManualReversalDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminManualReversalDto build() => _build();

  _$AdminManualReversalDto _build() {
    final _$result =
        _$v ??
        _$AdminManualReversalDto._(
          cityId: BuiltValueNullFieldError.checkNotNull(
            cityId,
            r'AdminManualReversalDto',
            'cityId',
          ),
          journalId: BuiltValueNullFieldError.checkNotNull(
            journalId,
            r'AdminManualReversalDto',
            'journalId',
          ),
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'AdminManualReversalDto',
            'reason',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
