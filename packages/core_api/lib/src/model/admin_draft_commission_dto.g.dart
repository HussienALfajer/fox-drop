// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_draft_commission_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDraftCommissionDto extends AdminDraftCommissionDto {
  @override
  final int rateBp;
  @override
  final AdminDraftCommissionDtoLaunch? launch;

  factory _$AdminDraftCommissionDto([
    void Function(AdminDraftCommissionDtoBuilder)? updates,
  ]) => (AdminDraftCommissionDtoBuilder()..update(updates))._build();

  _$AdminDraftCommissionDto._({required this.rateBp, this.launch}) : super._();
  @override
  AdminDraftCommissionDto rebuild(
    void Function(AdminDraftCommissionDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDraftCommissionDtoBuilder toBuilder() =>
      AdminDraftCommissionDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDraftCommissionDto &&
        rateBp == other.rateBp &&
        launch == other.launch;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, rateBp.hashCode);
    _$hash = $jc(_$hash, launch.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminDraftCommissionDto')
          ..add('rateBp', rateBp)
          ..add('launch', launch))
        .toString();
  }
}

class AdminDraftCommissionDtoBuilder
    implements
        Builder<AdminDraftCommissionDto, AdminDraftCommissionDtoBuilder> {
  _$AdminDraftCommissionDto? _$v;

  int? _rateBp;
  int? get rateBp => _$this._rateBp;
  set rateBp(int? rateBp) => _$this._rateBp = rateBp;

  AdminDraftCommissionDtoLaunchBuilder? _launch;
  AdminDraftCommissionDtoLaunchBuilder get launch =>
      _$this._launch ??= AdminDraftCommissionDtoLaunchBuilder();
  set launch(AdminDraftCommissionDtoLaunchBuilder? launch) =>
      _$this._launch = launch;

  AdminDraftCommissionDtoBuilder() {
    AdminDraftCommissionDto._defaults(this);
  }

  AdminDraftCommissionDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _rateBp = $v.rateBp;
      _launch = $v.launch?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDraftCommissionDto other) {
    _$v = other as _$AdminDraftCommissionDto;
  }

  @override
  void update(void Function(AdminDraftCommissionDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDraftCommissionDto build() => _build();

  _$AdminDraftCommissionDto _build() {
    _$AdminDraftCommissionDto _$result;
    try {
      _$result =
          _$v ??
          _$AdminDraftCommissionDto._(
            rateBp: BuiltValueNullFieldError.checkNotNull(
              rateBp,
              r'AdminDraftCommissionDto',
              'rateBp',
            ),
            launch: _launch?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'launch';
        _launch?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminDraftCommissionDto',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
