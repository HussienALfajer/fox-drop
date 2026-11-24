// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform_dto_output_hours.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PlatformDtoOutputHours extends PlatformDtoOutputHours {
  @override
  final bool open;
  @override
  final DateTime? opensAt;

  factory _$PlatformDtoOutputHours([
    void Function(PlatformDtoOutputHoursBuilder)? updates,
  ]) => (PlatformDtoOutputHoursBuilder()..update(updates))._build();

  _$PlatformDtoOutputHours._({required this.open, this.opensAt}) : super._();
  @override
  PlatformDtoOutputHours rebuild(
    void Function(PlatformDtoOutputHoursBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  PlatformDtoOutputHoursBuilder toBuilder() =>
      PlatformDtoOutputHoursBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PlatformDtoOutputHours &&
        open == other.open &&
        opensAt == other.opensAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, open.hashCode);
    _$hash = $jc(_$hash, opensAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PlatformDtoOutputHours')
          ..add('open', open)
          ..add('opensAt', opensAt))
        .toString();
  }
}

class PlatformDtoOutputHoursBuilder
    implements Builder<PlatformDtoOutputHours, PlatformDtoOutputHoursBuilder> {
  _$PlatformDtoOutputHours? _$v;

  bool? _open;
  bool? get open => _$this._open;
  set open(bool? open) => _$this._open = open;

  DateTime? _opensAt;
  DateTime? get opensAt => _$this._opensAt;
  set opensAt(DateTime? opensAt) => _$this._opensAt = opensAt;

  PlatformDtoOutputHoursBuilder() {
    PlatformDtoOutputHours._defaults(this);
  }

  PlatformDtoOutputHoursBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _open = $v.open;
      _opensAt = $v.opensAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PlatformDtoOutputHours other) {
    _$v = other as _$PlatformDtoOutputHours;
  }

  @override
  void update(void Function(PlatformDtoOutputHoursBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PlatformDtoOutputHours build() => _build();

  _$PlatformDtoOutputHours _build() {
    final _$result =
        _$v ??
        _$PlatformDtoOutputHours._(
          open: BuiltValueNullFieldError.checkNotNull(
            open,
            r'PlatformDtoOutputHours',
            'open',
          ),
          opensAt: opensAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
