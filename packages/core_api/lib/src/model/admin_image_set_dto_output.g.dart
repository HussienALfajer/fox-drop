// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_image_set_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminImageSetDtoOutput extends AdminImageSetDtoOutput {
  @override
  final String key;

  factory _$AdminImageSetDtoOutput([
    void Function(AdminImageSetDtoOutputBuilder)? updates,
  ]) => (AdminImageSetDtoOutputBuilder()..update(updates))._build();

  _$AdminImageSetDtoOutput._({required this.key}) : super._();
  @override
  AdminImageSetDtoOutput rebuild(
    void Function(AdminImageSetDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminImageSetDtoOutputBuilder toBuilder() =>
      AdminImageSetDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminImageSetDtoOutput && key == other.key;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, key.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminImageSetDtoOutput',
    )..add('key', key)).toString();
  }
}

class AdminImageSetDtoOutputBuilder
    implements Builder<AdminImageSetDtoOutput, AdminImageSetDtoOutputBuilder> {
  _$AdminImageSetDtoOutput? _$v;

  String? _key;
  String? get key => _$this._key;
  set key(String? key) => _$this._key = key;

  AdminImageSetDtoOutputBuilder() {
    AdminImageSetDtoOutput._defaults(this);
  }

  AdminImageSetDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _key = $v.key;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminImageSetDtoOutput other) {
    _$v = other as _$AdminImageSetDtoOutput;
  }

  @override
  void update(void Function(AdminImageSetDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminImageSetDtoOutput build() => _build();

  _$AdminImageSetDtoOutput _build() {
    final _$result =
        _$v ??
        _$AdminImageSetDtoOutput._(
          key: BuiltValueNullFieldError.checkNotNull(
            key,
            r'AdminImageSetDtoOutput',
            'key',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
