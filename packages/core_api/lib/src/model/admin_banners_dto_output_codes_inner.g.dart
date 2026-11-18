// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_banners_dto_output_codes_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminBannersDtoOutputCodesInner
    extends AdminBannersDtoOutputCodesInner {
  @override
  final String id;
  @override
  final String code;

  factory _$AdminBannersDtoOutputCodesInner([
    void Function(AdminBannersDtoOutputCodesInnerBuilder)? updates,
  ]) => (AdminBannersDtoOutputCodesInnerBuilder()..update(updates))._build();

  _$AdminBannersDtoOutputCodesInner._({required this.id, required this.code})
    : super._();
  @override
  AdminBannersDtoOutputCodesInner rebuild(
    void Function(AdminBannersDtoOutputCodesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminBannersDtoOutputCodesInnerBuilder toBuilder() =>
      AdminBannersDtoOutputCodesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminBannersDtoOutputCodesInner &&
        id == other.id &&
        code == other.code;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminBannersDtoOutputCodesInner')
          ..add('id', id)
          ..add('code', code))
        .toString();
  }
}

class AdminBannersDtoOutputCodesInnerBuilder
    implements
        Builder<
          AdminBannersDtoOutputCodesInner,
          AdminBannersDtoOutputCodesInnerBuilder
        > {
  _$AdminBannersDtoOutputCodesInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  AdminBannersDtoOutputCodesInnerBuilder() {
    AdminBannersDtoOutputCodesInner._defaults(this);
  }

  AdminBannersDtoOutputCodesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _code = $v.code;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminBannersDtoOutputCodesInner other) {
    _$v = other as _$AdminBannersDtoOutputCodesInner;
  }

  @override
  void update(void Function(AdminBannersDtoOutputCodesInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminBannersDtoOutputCodesInner build() => _build();

  _$AdminBannersDtoOutputCodesInner _build() {
    final _$result =
        _$v ??
        _$AdminBannersDtoOutputCodesInner._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'AdminBannersDtoOutputCodesInner',
            'id',
          ),
          code: BuiltValueNullFieldError.checkNotNull(
            code,
            r'AdminBannersDtoOutputCodesInner',
            'code',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
