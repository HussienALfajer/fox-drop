// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_reason_lists_dto_output_lists_inner_reasons_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminReasonListsDtoOutputListsInnerReasonsInnerNoteEnum
_$adminReasonListsDtoOutputListsInnerReasonsInnerNoteEnum_none =
    const AdminReasonListsDtoOutputListsInnerReasonsInnerNoteEnum._('none');
const AdminReasonListsDtoOutputListsInnerReasonsInnerNoteEnum
_$adminReasonListsDtoOutputListsInnerReasonsInnerNoteEnum_optional =
    const AdminReasonListsDtoOutputListsInnerReasonsInnerNoteEnum._('optional');
const AdminReasonListsDtoOutputListsInnerReasonsInnerNoteEnum
_$adminReasonListsDtoOutputListsInnerReasonsInnerNoteEnum_required_ =
    const AdminReasonListsDtoOutputListsInnerReasonsInnerNoteEnum._(
      'required_',
    );

AdminReasonListsDtoOutputListsInnerReasonsInnerNoteEnum
_$adminReasonListsDtoOutputListsInnerReasonsInnerNoteEnumValueOf(String name) {
  switch (name) {
    case 'none':
      return _$adminReasonListsDtoOutputListsInnerReasonsInnerNoteEnum_none;
    case 'optional':
      return _$adminReasonListsDtoOutputListsInnerReasonsInnerNoteEnum_optional;
    case 'required_':
      return _$adminReasonListsDtoOutputListsInnerReasonsInnerNoteEnum_required_;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminReasonListsDtoOutputListsInnerReasonsInnerNoteEnum>
_$adminReasonListsDtoOutputListsInnerReasonsInnerNoteEnumValues =
    BuiltSet<AdminReasonListsDtoOutputListsInnerReasonsInnerNoteEnum>(
      const <AdminReasonListsDtoOutputListsInnerReasonsInnerNoteEnum>[
        _$adminReasonListsDtoOutputListsInnerReasonsInnerNoteEnum_none,
        _$adminReasonListsDtoOutputListsInnerReasonsInnerNoteEnum_optional,
        _$adminReasonListsDtoOutputListsInnerReasonsInnerNoteEnum_required_,
      ],
    );

Serializer<AdminReasonListsDtoOutputListsInnerReasonsInnerNoteEnum>
_$adminReasonListsDtoOutputListsInnerReasonsInnerNoteEnumSerializer =
    _$AdminReasonListsDtoOutputListsInnerReasonsInnerNoteEnumSerializer();

class _$AdminReasonListsDtoOutputListsInnerReasonsInnerNoteEnumSerializer
    implements
        PrimitiveSerializer<
          AdminReasonListsDtoOutputListsInnerReasonsInnerNoteEnum
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
    AdminReasonListsDtoOutputListsInnerReasonsInnerNoteEnum,
  ];
  @override
  final String wireName =
      'AdminReasonListsDtoOutputListsInnerReasonsInnerNoteEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminReasonListsDtoOutputListsInnerReasonsInnerNoteEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminReasonListsDtoOutputListsInnerReasonsInnerNoteEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminReasonListsDtoOutputListsInnerReasonsInnerNoteEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminReasonListsDtoOutputListsInnerReasonsInner
    extends AdminReasonListsDtoOutputListsInnerReasonsInner {
  @override
  final String code;
  @override
  final String label;
  @override
  final String? customerText;
  @override
  final AdminReasonListsDtoOutputListsInnerReasonsInnerNoteEnum note;
  @override
  final bool fixed;
  @override
  final bool active;

  factory _$AdminReasonListsDtoOutputListsInnerReasonsInner([
    void Function(AdminReasonListsDtoOutputListsInnerReasonsInnerBuilder)?
    updates,
  ]) =>
      (AdminReasonListsDtoOutputListsInnerReasonsInnerBuilder()
            ..update(updates))
          ._build();

  _$AdminReasonListsDtoOutputListsInnerReasonsInner._({
    required this.code,
    required this.label,
    this.customerText,
    required this.note,
    required this.fixed,
    required this.active,
  }) : super._();
  @override
  AdminReasonListsDtoOutputListsInnerReasonsInner rebuild(
    void Function(AdminReasonListsDtoOutputListsInnerReasonsInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminReasonListsDtoOutputListsInnerReasonsInnerBuilder toBuilder() =>
      AdminReasonListsDtoOutputListsInnerReasonsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminReasonListsDtoOutputListsInnerReasonsInner &&
        code == other.code &&
        label == other.label &&
        customerText == other.customerText &&
        note == other.note &&
        fixed == other.fixed &&
        active == other.active;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, customerText.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, fixed.hashCode);
    _$hash = $jc(_$hash, active.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminReasonListsDtoOutputListsInnerReasonsInner',
          )
          ..add('code', code)
          ..add('label', label)
          ..add('customerText', customerText)
          ..add('note', note)
          ..add('fixed', fixed)
          ..add('active', active))
        .toString();
  }
}

class AdminReasonListsDtoOutputListsInnerReasonsInnerBuilder
    implements
        Builder<
          AdminReasonListsDtoOutputListsInnerReasonsInner,
          AdminReasonListsDtoOutputListsInnerReasonsInnerBuilder
        > {
  _$AdminReasonListsDtoOutputListsInnerReasonsInner? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  String? _customerText;
  String? get customerText => _$this._customerText;
  set customerText(String? customerText) => _$this._customerText = customerText;

  AdminReasonListsDtoOutputListsInnerReasonsInnerNoteEnum? _note;
  AdminReasonListsDtoOutputListsInnerReasonsInnerNoteEnum? get note =>
      _$this._note;
  set note(AdminReasonListsDtoOutputListsInnerReasonsInnerNoteEnum? note) =>
      _$this._note = note;

  bool? _fixed;
  bool? get fixed => _$this._fixed;
  set fixed(bool? fixed) => _$this._fixed = fixed;

  bool? _active;
  bool? get active => _$this._active;
  set active(bool? active) => _$this._active = active;

  AdminReasonListsDtoOutputListsInnerReasonsInnerBuilder() {
    AdminReasonListsDtoOutputListsInnerReasonsInner._defaults(this);
  }

  AdminReasonListsDtoOutputListsInnerReasonsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _label = $v.label;
      _customerText = $v.customerText;
      _note = $v.note;
      _fixed = $v.fixed;
      _active = $v.active;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminReasonListsDtoOutputListsInnerReasonsInner other) {
    _$v = other as _$AdminReasonListsDtoOutputListsInnerReasonsInner;
  }

  @override
  void update(
    void Function(AdminReasonListsDtoOutputListsInnerReasonsInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminReasonListsDtoOutputListsInnerReasonsInner build() => _build();

  _$AdminReasonListsDtoOutputListsInnerReasonsInner _build() {
    final _$result =
        _$v ??
        _$AdminReasonListsDtoOutputListsInnerReasonsInner._(
          code: BuiltValueNullFieldError.checkNotNull(
            code,
            r'AdminReasonListsDtoOutputListsInnerReasonsInner',
            'code',
          ),
          label: BuiltValueNullFieldError.checkNotNull(
            label,
            r'AdminReasonListsDtoOutputListsInnerReasonsInner',
            'label',
          ),
          customerText: customerText,
          note: BuiltValueNullFieldError.checkNotNull(
            note,
            r'AdminReasonListsDtoOutputListsInnerReasonsInner',
            'note',
          ),
          fixed: BuiltValueNullFieldError.checkNotNull(
            fixed,
            r'AdminReasonListsDtoOutputListsInnerReasonsInner',
            'fixed',
          ),
          active: BuiltValueNullFieldError.checkNotNull(
            active,
            r'AdminReasonListsDtoOutputListsInnerReasonsInner',
            'active',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
