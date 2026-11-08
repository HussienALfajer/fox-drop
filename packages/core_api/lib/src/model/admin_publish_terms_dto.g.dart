// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_publish_terms_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminPublishTermsDto extends AdminPublishTermsDto {
  @override
  final String body;

  factory _$AdminPublishTermsDto([
    void Function(AdminPublishTermsDtoBuilder)? updates,
  ]) => (AdminPublishTermsDtoBuilder()..update(updates))._build();

  _$AdminPublishTermsDto._({required this.body}) : super._();
  @override
  AdminPublishTermsDto rebuild(
    void Function(AdminPublishTermsDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminPublishTermsDtoBuilder toBuilder() =>
      AdminPublishTermsDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminPublishTermsDto && body == other.body;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, body.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminPublishTermsDto',
    )..add('body', body)).toString();
  }
}

class AdminPublishTermsDtoBuilder
    implements Builder<AdminPublishTermsDto, AdminPublishTermsDtoBuilder> {
  _$AdminPublishTermsDto? _$v;

  String? _body;
  String? get body => _$this._body;
  set body(String? body) => _$this._body = body;

  AdminPublishTermsDtoBuilder() {
    AdminPublishTermsDto._defaults(this);
  }

  AdminPublishTermsDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _body = $v.body;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminPublishTermsDto other) {
    _$v = other as _$AdminPublishTermsDto;
  }

  @override
  void update(void Function(AdminPublishTermsDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminPublishTermsDto build() => _build();

  _$AdminPublishTermsDto _build() {
    final _$result =
        _$v ??
        _$AdminPublishTermsDto._(
          body: BuiltValueNullFieldError.checkNotNull(
            body,
            r'AdminPublishTermsDto',
            'body',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
