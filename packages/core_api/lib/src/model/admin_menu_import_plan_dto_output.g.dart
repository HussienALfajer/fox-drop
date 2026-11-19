// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_menu_import_plan_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminMenuImportPlanDtoOutputFileErrorEnum
_$adminMenuImportPlanDtoOutputFileErrorEnum_missingHeaders =
    const AdminMenuImportPlanDtoOutputFileErrorEnum._('missingHeaders');
const AdminMenuImportPlanDtoOutputFileErrorEnum
_$adminMenuImportPlanDtoOutputFileErrorEnum_noRows =
    const AdminMenuImportPlanDtoOutputFileErrorEnum._('noRows');
const AdminMenuImportPlanDtoOutputFileErrorEnum
_$adminMenuImportPlanDtoOutputFileErrorEnum_tooManyRows =
    const AdminMenuImportPlanDtoOutputFileErrorEnum._('tooManyRows');

AdminMenuImportPlanDtoOutputFileErrorEnum
_$adminMenuImportPlanDtoOutputFileErrorEnumValueOf(String name) {
  switch (name) {
    case 'missingHeaders':
      return _$adminMenuImportPlanDtoOutputFileErrorEnum_missingHeaders;
    case 'noRows':
      return _$adminMenuImportPlanDtoOutputFileErrorEnum_noRows;
    case 'tooManyRows':
      return _$adminMenuImportPlanDtoOutputFileErrorEnum_tooManyRows;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminMenuImportPlanDtoOutputFileErrorEnum>
_$adminMenuImportPlanDtoOutputFileErrorEnumValues =
    BuiltSet<AdminMenuImportPlanDtoOutputFileErrorEnum>(
      const <AdminMenuImportPlanDtoOutputFileErrorEnum>[
        _$adminMenuImportPlanDtoOutputFileErrorEnum_missingHeaders,
        _$adminMenuImportPlanDtoOutputFileErrorEnum_noRows,
        _$adminMenuImportPlanDtoOutputFileErrorEnum_tooManyRows,
      ],
    );

Serializer<AdminMenuImportPlanDtoOutputFileErrorEnum>
_$adminMenuImportPlanDtoOutputFileErrorEnumSerializer =
    _$AdminMenuImportPlanDtoOutputFileErrorEnumSerializer();

class _$AdminMenuImportPlanDtoOutputFileErrorEnumSerializer
    implements PrimitiveSerializer<AdminMenuImportPlanDtoOutputFileErrorEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'missingHeaders': 'missing_headers',
    'noRows': 'no_rows',
    'tooManyRows': 'too_many_rows',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'missing_headers': 'missingHeaders',
    'no_rows': 'noRows',
    'too_many_rows': 'tooManyRows',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminMenuImportPlanDtoOutputFileErrorEnum,
  ];
  @override
  final String wireName = 'AdminMenuImportPlanDtoOutputFileErrorEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminMenuImportPlanDtoOutputFileErrorEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminMenuImportPlanDtoOutputFileErrorEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminMenuImportPlanDtoOutputFileErrorEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminMenuImportPlanDtoOutput extends AdminMenuImportPlanDtoOutput {
  @override
  final AdminMenuImportPlanDtoOutputFileErrorEnum? fileError;
  @override
  final BuiltList<AdminMenuImportPlanDtoOutputErrorsInner> errors;
  @override
  final BuiltList<String> categoriesAdded;
  @override
  final BuiltList<AdminMenuImportPlanDtoOutputAddedInner> added;
  @override
  final BuiltList<AdminMenuImportPlanDtoOutputChangedInner> changed;
  @override
  final int unchanged;

  factory _$AdminMenuImportPlanDtoOutput([
    void Function(AdminMenuImportPlanDtoOutputBuilder)? updates,
  ]) => (AdminMenuImportPlanDtoOutputBuilder()..update(updates))._build();

  _$AdminMenuImportPlanDtoOutput._({
    this.fileError,
    required this.errors,
    required this.categoriesAdded,
    required this.added,
    required this.changed,
    required this.unchanged,
  }) : super._();
  @override
  AdminMenuImportPlanDtoOutput rebuild(
    void Function(AdminMenuImportPlanDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminMenuImportPlanDtoOutputBuilder toBuilder() =>
      AdminMenuImportPlanDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminMenuImportPlanDtoOutput &&
        fileError == other.fileError &&
        errors == other.errors &&
        categoriesAdded == other.categoriesAdded &&
        added == other.added &&
        changed == other.changed &&
        unchanged == other.unchanged;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, fileError.hashCode);
    _$hash = $jc(_$hash, errors.hashCode);
    _$hash = $jc(_$hash, categoriesAdded.hashCode);
    _$hash = $jc(_$hash, added.hashCode);
    _$hash = $jc(_$hash, changed.hashCode);
    _$hash = $jc(_$hash, unchanged.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminMenuImportPlanDtoOutput')
          ..add('fileError', fileError)
          ..add('errors', errors)
          ..add('categoriesAdded', categoriesAdded)
          ..add('added', added)
          ..add('changed', changed)
          ..add('unchanged', unchanged))
        .toString();
  }
}

class AdminMenuImportPlanDtoOutputBuilder
    implements
        Builder<
          AdminMenuImportPlanDtoOutput,
          AdminMenuImportPlanDtoOutputBuilder
        > {
  _$AdminMenuImportPlanDtoOutput? _$v;

  AdminMenuImportPlanDtoOutputFileErrorEnum? _fileError;
  AdminMenuImportPlanDtoOutputFileErrorEnum? get fileError => _$this._fileError;
  set fileError(AdminMenuImportPlanDtoOutputFileErrorEnum? fileError) =>
      _$this._fileError = fileError;

  ListBuilder<AdminMenuImportPlanDtoOutputErrorsInner>? _errors;
  ListBuilder<AdminMenuImportPlanDtoOutputErrorsInner> get errors =>
      _$this._errors ??= ListBuilder<AdminMenuImportPlanDtoOutputErrorsInner>();
  set errors(ListBuilder<AdminMenuImportPlanDtoOutputErrorsInner>? errors) =>
      _$this._errors = errors;

  ListBuilder<String>? _categoriesAdded;
  ListBuilder<String> get categoriesAdded =>
      _$this._categoriesAdded ??= ListBuilder<String>();
  set categoriesAdded(ListBuilder<String>? categoriesAdded) =>
      _$this._categoriesAdded = categoriesAdded;

  ListBuilder<AdminMenuImportPlanDtoOutputAddedInner>? _added;
  ListBuilder<AdminMenuImportPlanDtoOutputAddedInner> get added =>
      _$this._added ??= ListBuilder<AdminMenuImportPlanDtoOutputAddedInner>();
  set added(ListBuilder<AdminMenuImportPlanDtoOutputAddedInner>? added) =>
      _$this._added = added;

  ListBuilder<AdminMenuImportPlanDtoOutputChangedInner>? _changed;
  ListBuilder<AdminMenuImportPlanDtoOutputChangedInner> get changed =>
      _$this._changed ??=
          ListBuilder<AdminMenuImportPlanDtoOutputChangedInner>();
  set changed(ListBuilder<AdminMenuImportPlanDtoOutputChangedInner>? changed) =>
      _$this._changed = changed;

  int? _unchanged;
  int? get unchanged => _$this._unchanged;
  set unchanged(int? unchanged) => _$this._unchanged = unchanged;

  AdminMenuImportPlanDtoOutputBuilder() {
    AdminMenuImportPlanDtoOutput._defaults(this);
  }

  AdminMenuImportPlanDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _fileError = $v.fileError;
      _errors = $v.errors.toBuilder();
      _categoriesAdded = $v.categoriesAdded.toBuilder();
      _added = $v.added.toBuilder();
      _changed = $v.changed.toBuilder();
      _unchanged = $v.unchanged;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminMenuImportPlanDtoOutput other) {
    _$v = other as _$AdminMenuImportPlanDtoOutput;
  }

  @override
  void update(void Function(AdminMenuImportPlanDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminMenuImportPlanDtoOutput build() => _build();

  _$AdminMenuImportPlanDtoOutput _build() {
    _$AdminMenuImportPlanDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminMenuImportPlanDtoOutput._(
            fileError: fileError,
            errors: errors.build(),
            categoriesAdded: categoriesAdded.build(),
            added: added.build(),
            changed: changed.build(),
            unchanged: BuiltValueNullFieldError.checkNotNull(
              unchanged,
              r'AdminMenuImportPlanDtoOutput',
              'unchanged',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'errors';
        errors.build();
        _$failedField = 'categoriesAdded';
        categoriesAdded.build();
        _$failedField = 'added';
        added.build();
        _$failedField = 'changed';
        changed.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminMenuImportPlanDtoOutput',
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
