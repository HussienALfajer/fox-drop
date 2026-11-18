// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_mass_push_audience_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminMassPushAudienceDtoOutput extends AdminMassPushAudienceDtoOutput {
  @override
  final int size;

  factory _$AdminMassPushAudienceDtoOutput([
    void Function(AdminMassPushAudienceDtoOutputBuilder)? updates,
  ]) => (AdminMassPushAudienceDtoOutputBuilder()..update(updates))._build();

  _$AdminMassPushAudienceDtoOutput._({required this.size}) : super._();
  @override
  AdminMassPushAudienceDtoOutput rebuild(
    void Function(AdminMassPushAudienceDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminMassPushAudienceDtoOutputBuilder toBuilder() =>
      AdminMassPushAudienceDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminMassPushAudienceDtoOutput && size == other.size;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, size.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminMassPushAudienceDtoOutput',
    )..add('size', size)).toString();
  }
}

class AdminMassPushAudienceDtoOutputBuilder
    implements
        Builder<
          AdminMassPushAudienceDtoOutput,
          AdminMassPushAudienceDtoOutputBuilder
        > {
  _$AdminMassPushAudienceDtoOutput? _$v;

  int? _size;
  int? get size => _$this._size;
  set size(int? size) => _$this._size = size;

  AdminMassPushAudienceDtoOutputBuilder() {
    AdminMassPushAudienceDtoOutput._defaults(this);
  }

  AdminMassPushAudienceDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _size = $v.size;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminMassPushAudienceDtoOutput other) {
    _$v = other as _$AdminMassPushAudienceDtoOutput;
  }

  @override
  void update(void Function(AdminMassPushAudienceDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminMassPushAudienceDtoOutput build() => _build();

  _$AdminMassPushAudienceDtoOutput _build() {
    final _$result =
        _$v ??
        _$AdminMassPushAudienceDtoOutput._(
          size: BuiltValueNullFieldError.checkNotNull(
            size,
            r'AdminMassPushAudienceDtoOutput',
            'size',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
