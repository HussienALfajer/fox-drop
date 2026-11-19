// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_application_kit_return_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCaptainApplicationKitReturnDto
    extends AdminCaptainApplicationKitReturnDto {
  @override
  final bool returned;

  factory _$AdminCaptainApplicationKitReturnDto([
    void Function(AdminCaptainApplicationKitReturnDtoBuilder)? updates,
  ]) =>
      (AdminCaptainApplicationKitReturnDtoBuilder()..update(updates))._build();

  _$AdminCaptainApplicationKitReturnDto._({required this.returned}) : super._();
  @override
  AdminCaptainApplicationKitReturnDto rebuild(
    void Function(AdminCaptainApplicationKitReturnDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainApplicationKitReturnDtoBuilder toBuilder() =>
      AdminCaptainApplicationKitReturnDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainApplicationKitReturnDto &&
        returned == other.returned;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, returned.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminCaptainApplicationKitReturnDto',
    )..add('returned', returned)).toString();
  }
}

class AdminCaptainApplicationKitReturnDtoBuilder
    implements
        Builder<
          AdminCaptainApplicationKitReturnDto,
          AdminCaptainApplicationKitReturnDtoBuilder
        > {
  _$AdminCaptainApplicationKitReturnDto? _$v;

  bool? _returned;
  bool? get returned => _$this._returned;
  set returned(bool? returned) => _$this._returned = returned;

  AdminCaptainApplicationKitReturnDtoBuilder() {
    AdminCaptainApplicationKitReturnDto._defaults(this);
  }

  AdminCaptainApplicationKitReturnDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _returned = $v.returned;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainApplicationKitReturnDto other) {
    _$v = other as _$AdminCaptainApplicationKitReturnDto;
  }

  @override
  void update(
    void Function(AdminCaptainApplicationKitReturnDtoBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainApplicationKitReturnDto build() => _build();

  _$AdminCaptainApplicationKitReturnDto _build() {
    final _$result =
        _$v ??
        _$AdminCaptainApplicationKitReturnDto._(
          returned: BuiltValueNullFieldError.checkNotNull(
            returned,
            r'AdminCaptainApplicationKitReturnDto',
            'returned',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
