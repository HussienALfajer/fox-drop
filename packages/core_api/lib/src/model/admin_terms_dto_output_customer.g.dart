// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_terms_dto_output_customer.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminTermsDtoOutputCustomer extends AdminTermsDtoOutputCustomer {
  @override
  final int version;
  @override
  final String body;
  @override
  final DateTime publishedAt;

  factory _$AdminTermsDtoOutputCustomer([
    void Function(AdminTermsDtoOutputCustomerBuilder)? updates,
  ]) => (AdminTermsDtoOutputCustomerBuilder()..update(updates))._build();

  _$AdminTermsDtoOutputCustomer._({
    required this.version,
    required this.body,
    required this.publishedAt,
  }) : super._();
  @override
  AdminTermsDtoOutputCustomer rebuild(
    void Function(AdminTermsDtoOutputCustomerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminTermsDtoOutputCustomerBuilder toBuilder() =>
      AdminTermsDtoOutputCustomerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminTermsDtoOutputCustomer &&
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
    return (newBuiltValueToStringHelper(r'AdminTermsDtoOutputCustomer')
          ..add('version', version)
          ..add('body', body)
          ..add('publishedAt', publishedAt))
        .toString();
  }
}

class AdminTermsDtoOutputCustomerBuilder
    implements
        Builder<
          AdminTermsDtoOutputCustomer,
          AdminTermsDtoOutputCustomerBuilder
        > {
  _$AdminTermsDtoOutputCustomer? _$v;

  int? _version;
  int? get version => _$this._version;
  set version(int? version) => _$this._version = version;

  String? _body;
  String? get body => _$this._body;
  set body(String? body) => _$this._body = body;

  DateTime? _publishedAt;
  DateTime? get publishedAt => _$this._publishedAt;
  set publishedAt(DateTime? publishedAt) => _$this._publishedAt = publishedAt;

  AdminTermsDtoOutputCustomerBuilder() {
    AdminTermsDtoOutputCustomer._defaults(this);
  }

  AdminTermsDtoOutputCustomerBuilder get _$this {
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
  void replace(AdminTermsDtoOutputCustomer other) {
    _$v = other as _$AdminTermsDtoOutputCustomer;
  }

  @override
  void update(void Function(AdminTermsDtoOutputCustomerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminTermsDtoOutputCustomer build() => _build();

  _$AdminTermsDtoOutputCustomer _build() {
    final _$result =
        _$v ??
        _$AdminTermsDtoOutputCustomer._(
          version: BuiltValueNullFieldError.checkNotNull(
            version,
            r'AdminTermsDtoOutputCustomer',
            'version',
          ),
          body: BuiltValueNullFieldError.checkNotNull(
            body,
            r'AdminTermsDtoOutputCustomer',
            'body',
          ),
          publishedAt: BuiltValueNullFieldError.checkNotNull(
            publishedAt,
            r'AdminTermsDtoOutputCustomer',
            'publishedAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
