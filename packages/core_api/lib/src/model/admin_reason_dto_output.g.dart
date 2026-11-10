// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_reason_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminReasonDtoOutputNoteEnum _$adminReasonDtoOutputNoteEnum_none =
    const AdminReasonDtoOutputNoteEnum._('none');
const AdminReasonDtoOutputNoteEnum _$adminReasonDtoOutputNoteEnum_optional =
    const AdminReasonDtoOutputNoteEnum._('optional');
const AdminReasonDtoOutputNoteEnum _$adminReasonDtoOutputNoteEnum_required_ =
    const AdminReasonDtoOutputNoteEnum._('required_');

AdminReasonDtoOutputNoteEnum _$adminReasonDtoOutputNoteEnumValueOf(
  String name,
) {
  switch (name) {
    case 'none':
      return _$adminReasonDtoOutputNoteEnum_none;
    case 'optional':
      return _$adminReasonDtoOutputNoteEnum_optional;
    case 'required_':
      return _$adminReasonDtoOutputNoteEnum_required_;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminReasonDtoOutputNoteEnum>
_$adminReasonDtoOutputNoteEnumValues =
    BuiltSet<AdminReasonDtoOutputNoteEnum>(const <AdminReasonDtoOutputNoteEnum>[
      _$adminReasonDtoOutputNoteEnum_none,
      _$adminReasonDtoOutputNoteEnum_optional,
      _$adminReasonDtoOutputNoteEnum_required_,
    ]);

Serializer<AdminReasonDtoOutputNoteEnum>
_$adminReasonDtoOutputNoteEnumSerializer =
    _$AdminReasonDtoOutputNoteEnumSerializer();

class _$AdminReasonDtoOutputNoteEnumSerializer
    implements PrimitiveSerializer<AdminReasonDtoOutputNoteEnum> {
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
  final Iterable<Type> types = const <Type>[AdminReasonDtoOutputNoteEnum];
  @override
  final String wireName = 'AdminReasonDtoOutputNoteEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminReasonDtoOutputNoteEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminReasonDtoOutputNoteEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminReasonDtoOutputNoteEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminReasonDtoOutput extends AdminReasonDtoOutput {
  @override
  final String code;
  @override
  final String label;
  @override
  final String? customerText;
  @override
  final AdminReasonDtoOutputNoteEnum note;
  @override
  final bool fixed;
  @override
  final bool active;
  @override
  final bool? captainFault;

  factory _$AdminReasonDtoOutput([
    void Function(AdminReasonDtoOutputBuilder)? updates,
  ]) => (AdminReasonDtoOutputBuilder()..update(updates))._build();

  _$AdminReasonDtoOutput._({
    required this.code,
    required this.label,
    this.customerText,
    required this.note,
    required this.fixed,
    required this.active,
    this.captainFault,
  }) : super._();
  @override
  AdminReasonDtoOutput rebuild(
    void Function(AdminReasonDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminReasonDtoOutputBuilder toBuilder() =>
      AdminReasonDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminReasonDtoOutput &&
        code == other.code &&
        label == other.label &&
        customerText == other.customerText &&
        note == other.note &&
        fixed == other.fixed &&
        active == other.active &&
        captainFault == other.captainFault;
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
    _$hash = $jc(_$hash, captainFault.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminReasonDtoOutput')
          ..add('code', code)
          ..add('label', label)
          ..add('customerText', customerText)
          ..add('note', note)
          ..add('fixed', fixed)
          ..add('active', active)
          ..add('captainFault', captainFault))
        .toString();
  }
}

class AdminReasonDtoOutputBuilder
    implements Builder<AdminReasonDtoOutput, AdminReasonDtoOutputBuilder> {
  _$AdminReasonDtoOutput? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  String? _customerText;
  String? get customerText => _$this._customerText;
  set customerText(String? customerText) => _$this._customerText = customerText;

  AdminReasonDtoOutputNoteEnum? _note;
  AdminReasonDtoOutputNoteEnum? get note => _$this._note;
  set note(AdminReasonDtoOutputNoteEnum? note) => _$this._note = note;

  bool? _fixed;
  bool? get fixed => _$this._fixed;
  set fixed(bool? fixed) => _$this._fixed = fixed;

  bool? _active;
  bool? get active => _$this._active;
  set active(bool? active) => _$this._active = active;

  bool? _captainFault;
  bool? get captainFault => _$this._captainFault;
  set captainFault(bool? captainFault) => _$this._captainFault = captainFault;

  AdminReasonDtoOutputBuilder() {
    AdminReasonDtoOutput._defaults(this);
  }

  AdminReasonDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _label = $v.label;
      _customerText = $v.customerText;
      _note = $v.note;
      _fixed = $v.fixed;
      _active = $v.active;
      _captainFault = $v.captainFault;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminReasonDtoOutput other) {
    _$v = other as _$AdminReasonDtoOutput;
  }

  @override
  void update(void Function(AdminReasonDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminReasonDtoOutput build() => _build();

  _$AdminReasonDtoOutput _build() {
    final _$result =
        _$v ??
        _$AdminReasonDtoOutput._(
          code: BuiltValueNullFieldError.checkNotNull(
            code,
            r'AdminReasonDtoOutput',
            'code',
          ),
          label: BuiltValueNullFieldError.checkNotNull(
            label,
            r'AdminReasonDtoOutput',
            'label',
          ),
          customerText: customerText,
          note: BuiltValueNullFieldError.checkNotNull(
            note,
            r'AdminReasonDtoOutput',
            'note',
          ),
          fixed: BuiltValueNullFieldError.checkNotNull(
            fixed,
            r'AdminReasonDtoOutput',
            'fixed',
          ),
          active: BuiltValueNullFieldError.checkNotNull(
            active,
            r'AdminReasonDtoOutput',
            'active',
          ),
          captainFault: captainFault,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
