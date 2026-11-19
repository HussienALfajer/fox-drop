// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_menu_import_template_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminMenuImportTemplateDtoOutput
    extends AdminMenuImportTemplateDtoOutput {
  @override
  final String fileName;
  @override
  final String contentBase64;

  factory _$AdminMenuImportTemplateDtoOutput([
    void Function(AdminMenuImportTemplateDtoOutputBuilder)? updates,
  ]) => (AdminMenuImportTemplateDtoOutputBuilder()..update(updates))._build();

  _$AdminMenuImportTemplateDtoOutput._({
    required this.fileName,
    required this.contentBase64,
  }) : super._();
  @override
  AdminMenuImportTemplateDtoOutput rebuild(
    void Function(AdminMenuImportTemplateDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminMenuImportTemplateDtoOutputBuilder toBuilder() =>
      AdminMenuImportTemplateDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminMenuImportTemplateDtoOutput &&
        fileName == other.fileName &&
        contentBase64 == other.contentBase64;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, fileName.hashCode);
    _$hash = $jc(_$hash, contentBase64.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminMenuImportTemplateDtoOutput')
          ..add('fileName', fileName)
          ..add('contentBase64', contentBase64))
        .toString();
  }
}

class AdminMenuImportTemplateDtoOutputBuilder
    implements
        Builder<
          AdminMenuImportTemplateDtoOutput,
          AdminMenuImportTemplateDtoOutputBuilder
        > {
  _$AdminMenuImportTemplateDtoOutput? _$v;

  String? _fileName;
  String? get fileName => _$this._fileName;
  set fileName(String? fileName) => _$this._fileName = fileName;

  String? _contentBase64;
  String? get contentBase64 => _$this._contentBase64;
  set contentBase64(String? contentBase64) =>
      _$this._contentBase64 = contentBase64;

  AdminMenuImportTemplateDtoOutputBuilder() {
    AdminMenuImportTemplateDtoOutput._defaults(this);
  }

  AdminMenuImportTemplateDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _fileName = $v.fileName;
      _contentBase64 = $v.contentBase64;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminMenuImportTemplateDtoOutput other) {
    _$v = other as _$AdminMenuImportTemplateDtoOutput;
  }

  @override
  void update(void Function(AdminMenuImportTemplateDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminMenuImportTemplateDtoOutput build() => _build();

  _$AdminMenuImportTemplateDtoOutput _build() {
    final _$result =
        _$v ??
        _$AdminMenuImportTemplateDtoOutput._(
          fileName: BuiltValueNullFieldError.checkNotNull(
            fileName,
            r'AdminMenuImportTemplateDtoOutput',
            'fileName',
          ),
          contentBase64: BuiltValueNullFieldError.checkNotNull(
            contentBase64,
            r'AdminMenuImportTemplateDtoOutput',
            'contentBase64',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
