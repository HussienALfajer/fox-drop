// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_reason_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AddReasonDtoNoteEnum _$addReasonDtoNoteEnum_none =
    const AddReasonDtoNoteEnum._('none');
const AddReasonDtoNoteEnum _$addReasonDtoNoteEnum_optional =
    const AddReasonDtoNoteEnum._('optional');
const AddReasonDtoNoteEnum _$addReasonDtoNoteEnum_required_ =
    const AddReasonDtoNoteEnum._('required_');

AddReasonDtoNoteEnum _$addReasonDtoNoteEnumValueOf(String name) {
  switch (name) {
    case 'none':
      return _$addReasonDtoNoteEnum_none;
    case 'optional':
      return _$addReasonDtoNoteEnum_optional;
    case 'required_':
      return _$addReasonDtoNoteEnum_required_;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AddReasonDtoNoteEnum> _$addReasonDtoNoteEnumValues =
    BuiltSet<AddReasonDtoNoteEnum>(const <AddReasonDtoNoteEnum>[
      _$addReasonDtoNoteEnum_none,
      _$addReasonDtoNoteEnum_optional,
      _$addReasonDtoNoteEnum_required_,
    ]);

Serializer<AddReasonDtoNoteEnum> _$addReasonDtoNoteEnumSerializer =
    _$AddReasonDtoNoteEnumSerializer();

class _$AddReasonDtoNoteEnumSerializer
    implements PrimitiveSerializer<AddReasonDtoNoteEnum> {
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
  final Iterable<Type> types = const <Type>[AddReasonDtoNoteEnum];
  @override
  final String wireName = 'AddReasonDtoNoteEnum';

  @override
  Object serialize(
    Serializers serializers,
    AddReasonDtoNoteEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AddReasonDtoNoteEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AddReasonDtoNoteEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AddReasonDto extends AddReasonDto {
  @override
  final String label;
  @override
  final String? customerText;
  @override
  final AddReasonDtoNoteEnum note;
  @override
  final bool? captainFault;

  factory _$AddReasonDto([void Function(AddReasonDtoBuilder)? updates]) =>
      (AddReasonDtoBuilder()..update(updates))._build();

  _$AddReasonDto._({
    required this.label,
    this.customerText,
    required this.note,
    this.captainFault,
  }) : super._();
  @override
  AddReasonDto rebuild(void Function(AddReasonDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AddReasonDtoBuilder toBuilder() => AddReasonDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AddReasonDto &&
        label == other.label &&
        customerText == other.customerText &&
        note == other.note &&
        captainFault == other.captainFault;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, customerText.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, captainFault.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AddReasonDto')
          ..add('label', label)
          ..add('customerText', customerText)
          ..add('note', note)
          ..add('captainFault', captainFault))
        .toString();
  }
}

class AddReasonDtoBuilder
    implements Builder<AddReasonDto, AddReasonDtoBuilder> {
  _$AddReasonDto? _$v;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  String? _customerText;
  String? get customerText => _$this._customerText;
  set customerText(String? customerText) => _$this._customerText = customerText;

  AddReasonDtoNoteEnum? _note;
  AddReasonDtoNoteEnum? get note => _$this._note;
  set note(AddReasonDtoNoteEnum? note) => _$this._note = note;

  bool? _captainFault;
  bool? get captainFault => _$this._captainFault;
  set captainFault(bool? captainFault) => _$this._captainFault = captainFault;

  AddReasonDtoBuilder() {
    AddReasonDto._defaults(this);
  }

  AddReasonDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _label = $v.label;
      _customerText = $v.customerText;
      _note = $v.note;
      _captainFault = $v.captainFault;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AddReasonDto other) {
    _$v = other as _$AddReasonDto;
  }

  @override
  void update(void Function(AddReasonDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AddReasonDto build() => _build();

  _$AddReasonDto _build() {
    final _$result =
        _$v ??
        _$AddReasonDto._(
          label: BuiltValueNullFieldError.checkNotNull(
            label,
            r'AddReasonDto',
            'label',
          ),
          customerText: customerText,
          note: BuiltValueNullFieldError.checkNotNull(
            note,
            r'AddReasonDto',
            'note',
          ),
          captainFault: captainFault,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
