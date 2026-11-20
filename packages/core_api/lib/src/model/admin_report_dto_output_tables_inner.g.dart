// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_report_dto_output_tables_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminReportDtoOutputTablesInnerRowKindEnum
_$adminReportDtoOutputTablesInnerRowKindEnum_none =
    const AdminReportDtoOutputTablesInnerRowKindEnum._('none');
const AdminReportDtoOutputTablesInnerRowKindEnum
_$adminReportDtoOutputTablesInnerRowKindEnum_code =
    const AdminReportDtoOutputTablesInnerRowKindEnum._('code');
const AdminReportDtoOutputTablesInnerRowKindEnum
_$adminReportDtoOutputTablesInnerRowKindEnum_label =
    const AdminReportDtoOutputTablesInnerRowKindEnum._('label');
const AdminReportDtoOutputTablesInnerRowKindEnum
_$adminReportDtoOutputTablesInnerRowKindEnum_day =
    const AdminReportDtoOutputTablesInnerRowKindEnum._('day');
const AdminReportDtoOutputTablesInnerRowKindEnum
_$adminReportDtoOutputTablesInnerRowKindEnum_hour =
    const AdminReportDtoOutputTablesInnerRowKindEnum._('hour');

AdminReportDtoOutputTablesInnerRowKindEnum
_$adminReportDtoOutputTablesInnerRowKindEnumValueOf(String name) {
  switch (name) {
    case 'none':
      return _$adminReportDtoOutputTablesInnerRowKindEnum_none;
    case 'code':
      return _$adminReportDtoOutputTablesInnerRowKindEnum_code;
    case 'label':
      return _$adminReportDtoOutputTablesInnerRowKindEnum_label;
    case 'day':
      return _$adminReportDtoOutputTablesInnerRowKindEnum_day;
    case 'hour':
      return _$adminReportDtoOutputTablesInnerRowKindEnum_hour;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminReportDtoOutputTablesInnerRowKindEnum>
_$adminReportDtoOutputTablesInnerRowKindEnumValues =
    BuiltSet<AdminReportDtoOutputTablesInnerRowKindEnum>(
      const <AdminReportDtoOutputTablesInnerRowKindEnum>[
        _$adminReportDtoOutputTablesInnerRowKindEnum_none,
        _$adminReportDtoOutputTablesInnerRowKindEnum_code,
        _$adminReportDtoOutputTablesInnerRowKindEnum_label,
        _$adminReportDtoOutputTablesInnerRowKindEnum_day,
        _$adminReportDtoOutputTablesInnerRowKindEnum_hour,
      ],
    );

Serializer<AdminReportDtoOutputTablesInnerRowKindEnum>
_$adminReportDtoOutputTablesInnerRowKindEnumSerializer =
    _$AdminReportDtoOutputTablesInnerRowKindEnumSerializer();

class _$AdminReportDtoOutputTablesInnerRowKindEnumSerializer
    implements PrimitiveSerializer<AdminReportDtoOutputTablesInnerRowKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'none': 'none',
    'code': 'code',
    'label': 'label',
    'day': 'day',
    'hour': 'hour',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'none': 'none',
    'code': 'code',
    'label': 'label',
    'day': 'day',
    'hour': 'hour',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminReportDtoOutputTablesInnerRowKindEnum,
  ];
  @override
  final String wireName = 'AdminReportDtoOutputTablesInnerRowKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminReportDtoOutputTablesInnerRowKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminReportDtoOutputTablesInnerRowKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminReportDtoOutputTablesInnerRowKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminReportDtoOutputTablesInner
    extends AdminReportDtoOutputTablesInner {
  @override
  final String key;
  @override
  final AdminReportDtoOutputTablesInnerRowKindEnum rowKind;
  @override
  final String? rowCodes;
  @override
  final BuiltList<AdminReportDtoOutputTablesInnerColumnsInner> columns;
  @override
  final BuiltList<AdminReportDtoOutputTablesInnerRowsInner> rows;

  factory _$AdminReportDtoOutputTablesInner([
    void Function(AdminReportDtoOutputTablesInnerBuilder)? updates,
  ]) => (AdminReportDtoOutputTablesInnerBuilder()..update(updates))._build();

  _$AdminReportDtoOutputTablesInner._({
    required this.key,
    required this.rowKind,
    this.rowCodes,
    required this.columns,
    required this.rows,
  }) : super._();
  @override
  AdminReportDtoOutputTablesInner rebuild(
    void Function(AdminReportDtoOutputTablesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminReportDtoOutputTablesInnerBuilder toBuilder() =>
      AdminReportDtoOutputTablesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminReportDtoOutputTablesInner &&
        key == other.key &&
        rowKind == other.rowKind &&
        rowCodes == other.rowCodes &&
        columns == other.columns &&
        rows == other.rows;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, key.hashCode);
    _$hash = $jc(_$hash, rowKind.hashCode);
    _$hash = $jc(_$hash, rowCodes.hashCode);
    _$hash = $jc(_$hash, columns.hashCode);
    _$hash = $jc(_$hash, rows.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminReportDtoOutputTablesInner')
          ..add('key', key)
          ..add('rowKind', rowKind)
          ..add('rowCodes', rowCodes)
          ..add('columns', columns)
          ..add('rows', rows))
        .toString();
  }
}

class AdminReportDtoOutputTablesInnerBuilder
    implements
        Builder<
          AdminReportDtoOutputTablesInner,
          AdminReportDtoOutputTablesInnerBuilder
        > {
  _$AdminReportDtoOutputTablesInner? _$v;

  String? _key;
  String? get key => _$this._key;
  set key(String? key) => _$this._key = key;

  AdminReportDtoOutputTablesInnerRowKindEnum? _rowKind;
  AdminReportDtoOutputTablesInnerRowKindEnum? get rowKind => _$this._rowKind;
  set rowKind(AdminReportDtoOutputTablesInnerRowKindEnum? rowKind) =>
      _$this._rowKind = rowKind;

  String? _rowCodes;
  String? get rowCodes => _$this._rowCodes;
  set rowCodes(String? rowCodes) => _$this._rowCodes = rowCodes;

  ListBuilder<AdminReportDtoOutputTablesInnerColumnsInner>? _columns;
  ListBuilder<AdminReportDtoOutputTablesInnerColumnsInner> get columns =>
      _$this._columns ??=
          ListBuilder<AdminReportDtoOutputTablesInnerColumnsInner>();
  set columns(
    ListBuilder<AdminReportDtoOutputTablesInnerColumnsInner>? columns,
  ) => _$this._columns = columns;

  ListBuilder<AdminReportDtoOutputTablesInnerRowsInner>? _rows;
  ListBuilder<AdminReportDtoOutputTablesInnerRowsInner> get rows =>
      _$this._rows ??= ListBuilder<AdminReportDtoOutputTablesInnerRowsInner>();
  set rows(ListBuilder<AdminReportDtoOutputTablesInnerRowsInner>? rows) =>
      _$this._rows = rows;

  AdminReportDtoOutputTablesInnerBuilder() {
    AdminReportDtoOutputTablesInner._defaults(this);
  }

  AdminReportDtoOutputTablesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _key = $v.key;
      _rowKind = $v.rowKind;
      _rowCodes = $v.rowCodes;
      _columns = $v.columns.toBuilder();
      _rows = $v.rows.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminReportDtoOutputTablesInner other) {
    _$v = other as _$AdminReportDtoOutputTablesInner;
  }

  @override
  void update(void Function(AdminReportDtoOutputTablesInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminReportDtoOutputTablesInner build() => _build();

  _$AdminReportDtoOutputTablesInner _build() {
    _$AdminReportDtoOutputTablesInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminReportDtoOutputTablesInner._(
            key: BuiltValueNullFieldError.checkNotNull(
              key,
              r'AdminReportDtoOutputTablesInner',
              'key',
            ),
            rowKind: BuiltValueNullFieldError.checkNotNull(
              rowKind,
              r'AdminReportDtoOutputTablesInner',
              'rowKind',
            ),
            rowCodes: rowCodes,
            columns: columns.build(),
            rows: rows.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'columns';
        columns.build();
        _$failedField = 'rows';
        rows.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminReportDtoOutputTablesInner',
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
