// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_content_dto_output_reasons_merchant_rejection_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MerchantContentDtoOutputReasonsMerchantRejectionInnerNoteEnum
_$merchantContentDtoOutputReasonsMerchantRejectionInnerNoteEnum_none =
    const MerchantContentDtoOutputReasonsMerchantRejectionInnerNoteEnum._(
      'none',
    );
const MerchantContentDtoOutputReasonsMerchantRejectionInnerNoteEnum
_$merchantContentDtoOutputReasonsMerchantRejectionInnerNoteEnum_optional =
    const MerchantContentDtoOutputReasonsMerchantRejectionInnerNoteEnum._(
      'optional',
    );
const MerchantContentDtoOutputReasonsMerchantRejectionInnerNoteEnum
_$merchantContentDtoOutputReasonsMerchantRejectionInnerNoteEnum_required_ =
    const MerchantContentDtoOutputReasonsMerchantRejectionInnerNoteEnum._(
      'required_',
    );

MerchantContentDtoOutputReasonsMerchantRejectionInnerNoteEnum
_$merchantContentDtoOutputReasonsMerchantRejectionInnerNoteEnumValueOf(
  String name,
) {
  switch (name) {
    case 'none':
      return _$merchantContentDtoOutputReasonsMerchantRejectionInnerNoteEnum_none;
    case 'optional':
      return _$merchantContentDtoOutputReasonsMerchantRejectionInnerNoteEnum_optional;
    case 'required_':
      return _$merchantContentDtoOutputReasonsMerchantRejectionInnerNoteEnum_required_;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MerchantContentDtoOutputReasonsMerchantRejectionInnerNoteEnum>
_$merchantContentDtoOutputReasonsMerchantRejectionInnerNoteEnumValues =
    BuiltSet<
      MerchantContentDtoOutputReasonsMerchantRejectionInnerNoteEnum
    >(const <MerchantContentDtoOutputReasonsMerchantRejectionInnerNoteEnum>[
      _$merchantContentDtoOutputReasonsMerchantRejectionInnerNoteEnum_none,
      _$merchantContentDtoOutputReasonsMerchantRejectionInnerNoteEnum_optional,
      _$merchantContentDtoOutputReasonsMerchantRejectionInnerNoteEnum_required_,
    ]);

Serializer<MerchantContentDtoOutputReasonsMerchantRejectionInnerNoteEnum>
_$merchantContentDtoOutputReasonsMerchantRejectionInnerNoteEnumSerializer =
    _$MerchantContentDtoOutputReasonsMerchantRejectionInnerNoteEnumSerializer();

class _$MerchantContentDtoOutputReasonsMerchantRejectionInnerNoteEnumSerializer
    implements
        PrimitiveSerializer<
          MerchantContentDtoOutputReasonsMerchantRejectionInnerNoteEnum
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
    MerchantContentDtoOutputReasonsMerchantRejectionInnerNoteEnum,
  ];
  @override
  final String wireName =
      'MerchantContentDtoOutputReasonsMerchantRejectionInnerNoteEnum';

  @override
  Object serialize(
    Serializers serializers,
    MerchantContentDtoOutputReasonsMerchantRejectionInnerNoteEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MerchantContentDtoOutputReasonsMerchantRejectionInnerNoteEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => MerchantContentDtoOutputReasonsMerchantRejectionInnerNoteEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$MerchantContentDtoOutputReasonsMerchantRejectionInner
    extends MerchantContentDtoOutputReasonsMerchantRejectionInner {
  @override
  final String code;
  @override
  final String label;
  @override
  final MerchantContentDtoOutputReasonsMerchantRejectionInnerNoteEnum note;

  factory _$MerchantContentDtoOutputReasonsMerchantRejectionInner([
    void Function(MerchantContentDtoOutputReasonsMerchantRejectionInnerBuilder)?
    updates,
  ]) =>
      (MerchantContentDtoOutputReasonsMerchantRejectionInnerBuilder()
            ..update(updates))
          ._build();

  _$MerchantContentDtoOutputReasonsMerchantRejectionInner._({
    required this.code,
    required this.label,
    required this.note,
  }) : super._();
  @override
  MerchantContentDtoOutputReasonsMerchantRejectionInner rebuild(
    void Function(MerchantContentDtoOutputReasonsMerchantRejectionInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantContentDtoOutputReasonsMerchantRejectionInnerBuilder toBuilder() =>
      MerchantContentDtoOutputReasonsMerchantRejectionInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantContentDtoOutputReasonsMerchantRejectionInner &&
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
            r'MerchantContentDtoOutputReasonsMerchantRejectionInner',
          )
          ..add('code', code)
          ..add('label', label)
          ..add('note', note))
        .toString();
  }
}

class MerchantContentDtoOutputReasonsMerchantRejectionInnerBuilder
    implements
        Builder<
          MerchantContentDtoOutputReasonsMerchantRejectionInner,
          MerchantContentDtoOutputReasonsMerchantRejectionInnerBuilder
        > {
  _$MerchantContentDtoOutputReasonsMerchantRejectionInner? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  MerchantContentDtoOutputReasonsMerchantRejectionInnerNoteEnum? _note;
  MerchantContentDtoOutputReasonsMerchantRejectionInnerNoteEnum? get note =>
      _$this._note;
  set note(
    MerchantContentDtoOutputReasonsMerchantRejectionInnerNoteEnum? note,
  ) => _$this._note = note;

  MerchantContentDtoOutputReasonsMerchantRejectionInnerBuilder() {
    MerchantContentDtoOutputReasonsMerchantRejectionInner._defaults(this);
  }

  MerchantContentDtoOutputReasonsMerchantRejectionInnerBuilder get _$this {
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
  void replace(MerchantContentDtoOutputReasonsMerchantRejectionInner other) {
    _$v = other as _$MerchantContentDtoOutputReasonsMerchantRejectionInner;
  }

  @override
  void update(
    void Function(MerchantContentDtoOutputReasonsMerchantRejectionInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantContentDtoOutputReasonsMerchantRejectionInner build() => _build();

  _$MerchantContentDtoOutputReasonsMerchantRejectionInner _build() {
    final _$result =
        _$v ??
        _$MerchantContentDtoOutputReasonsMerchantRejectionInner._(
          code: BuiltValueNullFieldError.checkNotNull(
            code,
            r'MerchantContentDtoOutputReasonsMerchantRejectionInner',
            'code',
          ),
          label: BuiltValueNullFieldError.checkNotNull(
            label,
            r'MerchantContentDtoOutputReasonsMerchantRejectionInner',
            'label',
          ),
          note: BuiltValueNullFieldError.checkNotNull(
            note,
            r'MerchantContentDtoOutputReasonsMerchantRejectionInner',
            'note',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
