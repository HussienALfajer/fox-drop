// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reorder_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ReorderDto extends ReorderDto {
  @override
  final BuiltList<String> codes;

  factory _$ReorderDto([void Function(ReorderDtoBuilder)? updates]) =>
      (ReorderDtoBuilder()..update(updates))._build();

  _$ReorderDto._({required this.codes}) : super._();
  @override
  ReorderDto rebuild(void Function(ReorderDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReorderDtoBuilder toBuilder() => ReorderDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReorderDto && codes == other.codes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, codes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'ReorderDto',
    )..add('codes', codes)).toString();
  }
}

class ReorderDtoBuilder implements Builder<ReorderDto, ReorderDtoBuilder> {
  _$ReorderDto? _$v;

  ListBuilder<String>? _codes;
  ListBuilder<String> get codes => _$this._codes ??= ListBuilder<String>();
  set codes(ListBuilder<String>? codes) => _$this._codes = codes;

  ReorderDtoBuilder() {
    ReorderDto._defaults(this);
  }

  ReorderDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _codes = $v.codes.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ReorderDto other) {
    _$v = other as _$ReorderDto;
  }

  @override
  void update(void Function(ReorderDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ReorderDto build() => _build();

  _$ReorderDto _build() {
    _$ReorderDto _$result;
    try {
      _$result = _$v ?? _$ReorderDto._(codes: codes.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'codes';
        codes.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'ReorderDto',
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
