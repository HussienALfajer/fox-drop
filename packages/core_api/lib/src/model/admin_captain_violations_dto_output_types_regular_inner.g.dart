// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_violations_dto_output_types_regular_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminCaptainViolationsDtoOutputTypesRegularInnerNoteEnum
_$adminCaptainViolationsDtoOutputTypesRegularInnerNoteEnum_none =
    const AdminCaptainViolationsDtoOutputTypesRegularInnerNoteEnum._('none');
const AdminCaptainViolationsDtoOutputTypesRegularInnerNoteEnum
_$adminCaptainViolationsDtoOutputTypesRegularInnerNoteEnum_optional =
    const AdminCaptainViolationsDtoOutputTypesRegularInnerNoteEnum._(
      'optional',
    );
const AdminCaptainViolationsDtoOutputTypesRegularInnerNoteEnum
_$adminCaptainViolationsDtoOutputTypesRegularInnerNoteEnum_required_ =
    const AdminCaptainViolationsDtoOutputTypesRegularInnerNoteEnum._(
      'required_',
    );

AdminCaptainViolationsDtoOutputTypesRegularInnerNoteEnum
_$adminCaptainViolationsDtoOutputTypesRegularInnerNoteEnumValueOf(String name) {
  switch (name) {
    case 'none':
      return _$adminCaptainViolationsDtoOutputTypesRegularInnerNoteEnum_none;
    case 'optional':
      return _$adminCaptainViolationsDtoOutputTypesRegularInnerNoteEnum_optional;
    case 'required_':
      return _$adminCaptainViolationsDtoOutputTypesRegularInnerNoteEnum_required_;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminCaptainViolationsDtoOutputTypesRegularInnerNoteEnum>
_$adminCaptainViolationsDtoOutputTypesRegularInnerNoteEnumValues =
    BuiltSet<AdminCaptainViolationsDtoOutputTypesRegularInnerNoteEnum>(
      const <AdminCaptainViolationsDtoOutputTypesRegularInnerNoteEnum>[
        _$adminCaptainViolationsDtoOutputTypesRegularInnerNoteEnum_none,
        _$adminCaptainViolationsDtoOutputTypesRegularInnerNoteEnum_optional,
        _$adminCaptainViolationsDtoOutputTypesRegularInnerNoteEnum_required_,
      ],
    );

Serializer<AdminCaptainViolationsDtoOutputTypesRegularInnerNoteEnum>
_$adminCaptainViolationsDtoOutputTypesRegularInnerNoteEnumSerializer =
    _$AdminCaptainViolationsDtoOutputTypesRegularInnerNoteEnumSerializer();

class _$AdminCaptainViolationsDtoOutputTypesRegularInnerNoteEnumSerializer
    implements
        PrimitiveSerializer<
          AdminCaptainViolationsDtoOutputTypesRegularInnerNoteEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'none': 'none',
    'optional': 'optional',
    'required_': 'required',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'none': 'none',
    'optional': 'optional',
    'required': 'required_',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminCaptainViolationsDtoOutputTypesRegularInnerNoteEnum,
  ];
  @override
  final String wireName =
      'AdminCaptainViolationsDtoOutputTypesRegularInnerNoteEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainViolationsDtoOutputTypesRegularInnerNoteEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminCaptainViolationsDtoOutputTypesRegularInnerNoteEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminCaptainViolationsDtoOutputTypesRegularInnerNoteEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminCaptainViolationsDtoOutputTypesRegularInner
    extends AdminCaptainViolationsDtoOutputTypesRegularInner {
  @override
  final String code;
  @override
  final String label;
  @override
  final AdminCaptainViolationsDtoOutputTypesRegularInnerNoteEnum note;

  factory _$AdminCaptainViolationsDtoOutputTypesRegularInner([
    void Function(AdminCaptainViolationsDtoOutputTypesRegularInnerBuilder)?
    updates,
  ]) =>
      (AdminCaptainViolationsDtoOutputTypesRegularInnerBuilder()
            ..update(updates))
          ._build();

  _$AdminCaptainViolationsDtoOutputTypesRegularInner._({
    required this.code,
    required this.label,
    required this.note,
  }) : super._();
  @override
  AdminCaptainViolationsDtoOutputTypesRegularInner rebuild(
    void Function(AdminCaptainViolationsDtoOutputTypesRegularInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainViolationsDtoOutputTypesRegularInnerBuilder toBuilder() =>
      AdminCaptainViolationsDtoOutputTypesRegularInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainViolationsDtoOutputTypesRegularInner &&
        code == other.code &&
        label == other.label &&
        note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminCaptainViolationsDtoOutputTypesRegularInner',
          )
          ..add('code', code)
          ..add('label', label)
          ..add('note', note))
        .toString();
  }
}

class AdminCaptainViolationsDtoOutputTypesRegularInnerBuilder
    implements
        Builder<
          AdminCaptainViolationsDtoOutputTypesRegularInner,
          AdminCaptainViolationsDtoOutputTypesRegularInnerBuilder
        > {
  _$AdminCaptainViolationsDtoOutputTypesRegularInner? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  AdminCaptainViolationsDtoOutputTypesRegularInnerNoteEnum? _note;
  AdminCaptainViolationsDtoOutputTypesRegularInnerNoteEnum? get note =>
      _$this._note;
  set note(AdminCaptainViolationsDtoOutputTypesRegularInnerNoteEnum? note) =>
      _$this._note = note;

  AdminCaptainViolationsDtoOutputTypesRegularInnerBuilder() {
    AdminCaptainViolationsDtoOutputTypesRegularInner._defaults(this);
  }

  AdminCaptainViolationsDtoOutputTypesRegularInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _label = $v.label;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainViolationsDtoOutputTypesRegularInner other) {
    _$v = other as _$AdminCaptainViolationsDtoOutputTypesRegularInner;
  }

  @override
  void update(
    void Function(AdminCaptainViolationsDtoOutputTypesRegularInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainViolationsDtoOutputTypesRegularInner build() => _build();

  _$AdminCaptainViolationsDtoOutputTypesRegularInner _build() {
    final _$result =
        _$v ??
        _$AdminCaptainViolationsDtoOutputTypesRegularInner._(
          code: BuiltValueNullFieldError.checkNotNull(
            code,
            r'AdminCaptainViolationsDtoOutputTypesRegularInner',
            'code',
          ),
          label: BuiltValueNullFieldError.checkNotNull(
            label,
            r'AdminCaptainViolationsDtoOutputTypesRegularInner',
            'label',
          ),
          note: BuiltValueNullFieldError.checkNotNull(
            note,
            r'AdminCaptainViolationsDtoOutputTypesRegularInner',
            'note',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
