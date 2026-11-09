// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'terms_accept_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TermsAcceptDto extends TermsAcceptDto {
  @override
  final int version;

  factory _$TermsAcceptDto([void Function(TermsAcceptDtoBuilder)? updates]) =>
      (TermsAcceptDtoBuilder()..update(updates))._build();

  _$TermsAcceptDto._({required this.version}) : super._();
  @override
  TermsAcceptDto rebuild(void Function(TermsAcceptDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TermsAcceptDtoBuilder toBuilder() => TermsAcceptDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TermsAcceptDto && version == other.version;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'TermsAcceptDto',
    )..add('version', version)).toString();
  }
}

class TermsAcceptDtoBuilder
    implements Builder<TermsAcceptDto, TermsAcceptDtoBuilder> {
  _$TermsAcceptDto? _$v;

  int? _version;
  int? get version => _$this._version;
  set version(int? version) => _$this._version = version;

  TermsAcceptDtoBuilder() {
    TermsAcceptDto._defaults(this);
  }

  TermsAcceptDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _version = $v.version;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TermsAcceptDto other) {
    _$v = other as _$TermsAcceptDto;
  }

  @override
  void update(void Function(TermsAcceptDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TermsAcceptDto build() => _build();

  _$TermsAcceptDto _build() {
    final _$result =
        _$v ??
        _$TermsAcceptDto._(
          version: BuiltValueNullFieldError.checkNotNull(
            version,
            r'TermsAcceptDto',
            'version',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
