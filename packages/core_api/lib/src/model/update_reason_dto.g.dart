// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_reason_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const UpdateReasonDtoNoteEnum _$updateReasonDtoNoteEnum_none =
    const UpdateReasonDtoNoteEnum._('none');
const UpdateReasonDtoNoteEnum _$updateReasonDtoNoteEnum_optional =
    const UpdateReasonDtoNoteEnum._('optional');
const UpdateReasonDtoNoteEnum _$updateReasonDtoNoteEnum_required_ =
    const UpdateReasonDtoNoteEnum._('required_');

UpdateReasonDtoNoteEnum _$updateReasonDtoNoteEnumValueOf(String name) {
  switch (name) {
    case 'none':
      return _$updateReasonDtoNoteEnum_none;
    case 'optional':
      return _$updateReasonDtoNoteEnum_optional;
    case 'required_':
      return _$updateReasonDtoNoteEnum_required_;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<UpdateReasonDtoNoteEnum> _$updateReasonDtoNoteEnumValues =
    BuiltSet<UpdateReasonDtoNoteEnum>(const <UpdateReasonDtoNoteEnum>[
      _$updateReasonDtoNoteEnum_none,
      _$updateReasonDtoNoteEnum_optional,
      _$updateReasonDtoNoteEnum_required_,
    ]);

Serializer<UpdateReasonDtoNoteEnum> _$updateReasonDtoNoteEnumSerializer =
    _$UpdateReasonDtoNoteEnumSerializer();

class _$UpdateReasonDtoNoteEnumSerializer
    implements PrimitiveSerializer<UpdateReasonDtoNoteEnum> {
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
  final Iterable<Type> types = const <Type>[UpdateReasonDtoNoteEnum];
  @override
  final String wireName = 'UpdateReasonDtoNoteEnum';

  @override
  Object serialize(
    Serializers serializers,
    UpdateReasonDtoNoteEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  UpdateReasonDtoNoteEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => UpdateReasonDtoNoteEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$UpdateReasonDto extends UpdateReasonDto {
  @override
  final String label;
  @override
  final String? customerText;
  @override
  final UpdateReasonDtoNoteEnum note;
  @override
  final bool? captainFault;
  @override
  final bool active;

  factory _$UpdateReasonDto([void Function(UpdateReasonDtoBuilder)? updates]) =>
      (UpdateReasonDtoBuilder()..update(updates))._build();

  _$UpdateReasonDto._({
    required this.label,
    this.customerText,
    required this.note,
    this.captainFault,
    required this.active,
  }) : super._();
  @override
  UpdateReasonDto rebuild(void Function(UpdateReasonDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateReasonDtoBuilder toBuilder() => UpdateReasonDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateReasonDto &&
        label == other.label &&
        customerText == other.customerText &&
        note == other.note &&
        captainFault == other.captainFault &&
        active == other.active;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, customerText.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, captainFault.hashCode);
    _$hash = $jc(_$hash, active.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdateReasonDto')
          ..add('label', label)
          ..add('customerText', customerText)
          ..add('note', note)
          ..add('captainFault', captainFault)
          ..add('active', active))
        .toString();
  }
}

class UpdateReasonDtoBuilder
    implements Builder<UpdateReasonDto, UpdateReasonDtoBuilder> {
  _$UpdateReasonDto? _$v;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  String? _customerText;
  String? get customerText => _$this._customerText;
  set customerText(String? customerText) => _$this._customerText = customerText;

  UpdateReasonDtoNoteEnum? _note;
  UpdateReasonDtoNoteEnum? get note => _$this._note;
  set note(UpdateReasonDtoNoteEnum? note) => _$this._note = note;

  bool? _captainFault;
  bool? get captainFault => _$this._captainFault;
  set captainFault(bool? captainFault) => _$this._captainFault = captainFault;

  bool? _active;
  bool? get active => _$this._active;
  set active(bool? active) => _$this._active = active;

  UpdateReasonDtoBuilder() {
    UpdateReasonDto._defaults(this);
  }

  UpdateReasonDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _label = $v.label;
      _customerText = $v.customerText;
      _note = $v.note;
      _captainFault = $v.captainFault;
      _active = $v.active;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateReasonDto other) {
    _$v = other as _$UpdateReasonDto;
  }

  @override
  void update(void Function(UpdateReasonDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateReasonDto build() => _build();

  _$UpdateReasonDto _build() {
    final _$result =
        _$v ??
        _$UpdateReasonDto._(
          label: BuiltValueNullFieldError.checkNotNull(
            label,
            r'UpdateReasonDto',
            'label',
          ),
          customerText: customerText,
          note: BuiltValueNullFieldError.checkNotNull(
            note,
            r'UpdateReasonDto',
            'note',
          ),
          captainFault: captainFault,
          active: BuiltValueNullFieldError.checkNotNull(
            active,
            r'UpdateReasonDto',
            'active',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
