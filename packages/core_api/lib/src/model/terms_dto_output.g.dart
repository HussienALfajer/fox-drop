// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'terms_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TermsDtoOutput extends TermsDtoOutput {
  @override
  final int version;
  @override
  final String body;
  @override
  final DateTime publishedAt;
  @override
  final bool pending;

  factory _$TermsDtoOutput([void Function(TermsDtoOutputBuilder)? updates]) =>
      (TermsDtoOutputBuilder()..update(updates))._build();

  _$TermsDtoOutput._({
    required this.version,
    required this.body,
    required this.publishedAt,
    required this.pending,
  }) : super._();
  @override
  TermsDtoOutput rebuild(void Function(TermsDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TermsDtoOutputBuilder toBuilder() => TermsDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TermsDtoOutput &&
        version == other.version &&
        body == other.body &&
        publishedAt == other.publishedAt &&
        pending == other.pending;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, body.hashCode);
    _$hash = $jc(_$hash, publishedAt.hashCode);
    _$hash = $jc(_$hash, pending.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TermsDtoOutput')
          ..add('version', version)
          ..add('body', body)
          ..add('publishedAt', publishedAt)
          ..add('pending', pending))
        .toString();
  }
}

class TermsDtoOutputBuilder
    implements Builder<TermsDtoOutput, TermsDtoOutputBuilder> {
  _$TermsDtoOutput? _$v;

  int? _version;
  int? get version => _$this._version;
  set version(int? version) => _$this._version = version;

  String? _body;
  String? get body => _$this._body;
  set body(String? body) => _$this._body = body;

  DateTime? _publishedAt;
  DateTime? get publishedAt => _$this._publishedAt;
  set publishedAt(DateTime? publishedAt) => _$this._publishedAt = publishedAt;

  bool? _pending;
  bool? get pending => _$this._pending;
  set pending(bool? pending) => _$this._pending = pending;

  TermsDtoOutputBuilder() {
    TermsDtoOutput._defaults(this);
  }

  TermsDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _version = $v.version;
      _body = $v.body;
      _publishedAt = $v.publishedAt;
      _pending = $v.pending;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TermsDtoOutput other) {
    _$v = other as _$TermsDtoOutput;
  }

  @override
  void update(void Function(TermsDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TermsDtoOutput build() => _build();

  _$TermsDtoOutput _build() {
    final _$result =
        _$v ??
        _$TermsDtoOutput._(
          version: BuiltValueNullFieldError.checkNotNull(
            version,
            r'TermsDtoOutput',
            'version',
          ),
          body: BuiltValueNullFieldError.checkNotNull(
            body,
            r'TermsDtoOutput',
            'body',
          ),
          publishedAt: BuiltValueNullFieldError.checkNotNull(
            publishedAt,
            r'TermsDtoOutput',
            'publishedAt',
          ),
          pending: BuiltValueNullFieldError.checkNotNull(
            pending,
            r'TermsDtoOutput',
            'pending',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
