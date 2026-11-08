// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_terms_version_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminTermsVersionDtoOutput extends AdminTermsVersionDtoOutput {
  @override
  final int version;
  @override
  final String body;
  @override
  final DateTime publishedAt;

  factory _$AdminTermsVersionDtoOutput([
    void Function(AdminTermsVersionDtoOutputBuilder)? updates,
  ]) => (AdminTermsVersionDtoOutputBuilder()..update(updates))._build();

  _$AdminTermsVersionDtoOutput._({
    required this.version,
    required this.body,
    required this.publishedAt,
  }) : super._();
  @override
  AdminTermsVersionDtoOutput rebuild(
    void Function(AdminTermsVersionDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminTermsVersionDtoOutputBuilder toBuilder() =>
      AdminTermsVersionDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminTermsVersionDtoOutput &&
        version == other.version &&
        body == other.body &&
        publishedAt == other.publishedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, body.hashCode);
    _$hash = $jc(_$hash, publishedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminTermsVersionDtoOutput')
          ..add('version', version)
          ..add('body', body)
          ..add('publishedAt', publishedAt))
        .toString();
  }
}

class AdminTermsVersionDtoOutputBuilder
    implements
        Builder<AdminTermsVersionDtoOutput, AdminTermsVersionDtoOutputBuilder> {
  _$AdminTermsVersionDtoOutput? _$v;

  int? _version;
  int? get version => _$this._version;
  set version(int? version) => _$this._version = version;

  String? _body;
  String? get body => _$this._body;
  set body(String? body) => _$this._body = body;

  DateTime? _publishedAt;
  DateTime? get publishedAt => _$this._publishedAt;
  set publishedAt(DateTime? publishedAt) => _$this._publishedAt = publishedAt;

  AdminTermsVersionDtoOutputBuilder() {
    AdminTermsVersionDtoOutput._defaults(this);
  }

  AdminTermsVersionDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _version = $v.version;
      _body = $v.body;
      _publishedAt = $v.publishedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminTermsVersionDtoOutput other) {
    _$v = other as _$AdminTermsVersionDtoOutput;
  }

  @override
  void update(void Function(AdminTermsVersionDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminTermsVersionDtoOutput build() => _build();

  _$AdminTermsVersionDtoOutput _build() {
    final _$result =
        _$v ??
        _$AdminTermsVersionDtoOutput._(
          version: BuiltValueNullFieldError.checkNotNull(
            version,
            r'AdminTermsVersionDtoOutput',
            'version',
          ),
          body: BuiltValueNullFieldError.checkNotNull(
            body,
            r'AdminTermsVersionDtoOutput',
            'body',
          ),
          publishedAt: BuiltValueNullFieldError.checkNotNull(
            publishedAt,
            r'AdminTermsVersionDtoOutput',
            'publishedAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
