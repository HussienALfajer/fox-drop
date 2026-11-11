// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_active_order_dto_output_order_no_answer_answer.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CaptainActiveOrderDtoOutputOrderNoAnswerAnswerAnswerEnum
_$captainActiveOrderDtoOutputOrderNoAnswerAnswerAnswerEnum_coming =
    const CaptainActiveOrderDtoOutputOrderNoAnswerAnswerAnswerEnum._('coming');
const CaptainActiveOrderDtoOutputOrderNoAnswerAnswerAnswerEnum
_$captainActiveOrderDtoOutputOrderNoAnswerAnswerAnswerEnum_contactingRecipient =
    const CaptainActiveOrderDtoOutputOrderNoAnswerAnswerAnswerEnum._(
      'contactingRecipient',
    );

CaptainActiveOrderDtoOutputOrderNoAnswerAnswerAnswerEnum
_$captainActiveOrderDtoOutputOrderNoAnswerAnswerAnswerEnumValueOf(String name) {
  switch (name) {
    case 'coming':
      return _$captainActiveOrderDtoOutputOrderNoAnswerAnswerAnswerEnum_coming;
    case 'contactingRecipient':
      return _$captainActiveOrderDtoOutputOrderNoAnswerAnswerAnswerEnum_contactingRecipient;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CaptainActiveOrderDtoOutputOrderNoAnswerAnswerAnswerEnum>
_$captainActiveOrderDtoOutputOrderNoAnswerAnswerAnswerEnumValues =
    BuiltSet<CaptainActiveOrderDtoOutputOrderNoAnswerAnswerAnswerEnum>(const <
      CaptainActiveOrderDtoOutputOrderNoAnswerAnswerAnswerEnum
    >[
      _$captainActiveOrderDtoOutputOrderNoAnswerAnswerAnswerEnum_coming,
      _$captainActiveOrderDtoOutputOrderNoAnswerAnswerAnswerEnum_contactingRecipient,
    ]);

Serializer<CaptainActiveOrderDtoOutputOrderNoAnswerAnswerAnswerEnum>
_$captainActiveOrderDtoOutputOrderNoAnswerAnswerAnswerEnumSerializer =
    _$CaptainActiveOrderDtoOutputOrderNoAnswerAnswerAnswerEnumSerializer();

class _$CaptainActiveOrderDtoOutputOrderNoAnswerAnswerAnswerEnumSerializer
    implements
        PrimitiveSerializer<
          CaptainActiveOrderDtoOutputOrderNoAnswerAnswerAnswerEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'coming': 'coming',
    'contactingRecipient': 'contacting_recipient',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'coming': 'coming',
    'contacting_recipient': 'contactingRecipient',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CaptainActiveOrderDtoOutputOrderNoAnswerAnswerAnswerEnum,
  ];
  @override
  final String wireName =
      'CaptainActiveOrderDtoOutputOrderNoAnswerAnswerAnswerEnum';

  @override
  Object serialize(
    Serializers serializers,
    CaptainActiveOrderDtoOutputOrderNoAnswerAnswerAnswerEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CaptainActiveOrderDtoOutputOrderNoAnswerAnswerAnswerEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CaptainActiveOrderDtoOutputOrderNoAnswerAnswerAnswerEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CaptainActiveOrderDtoOutputOrderNoAnswerAnswer
    extends CaptainActiveOrderDtoOutputOrderNoAnswerAnswer {
  @override
  final CaptainActiveOrderDtoOutputOrderNoAnswerAnswerAnswerEnum answer;
  @override
  final DateTime at;

  factory _$CaptainActiveOrderDtoOutputOrderNoAnswerAnswer([
    void Function(CaptainActiveOrderDtoOutputOrderNoAnswerAnswerBuilder)?
    updates,
  ]) =>
      (CaptainActiveOrderDtoOutputOrderNoAnswerAnswerBuilder()..update(updates))
          ._build();

  _$CaptainActiveOrderDtoOutputOrderNoAnswerAnswer._({
    required this.answer,
    required this.at,
  }) : super._();
  @override
  CaptainActiveOrderDtoOutputOrderNoAnswerAnswer rebuild(
    void Function(CaptainActiveOrderDtoOutputOrderNoAnswerAnswerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainActiveOrderDtoOutputOrderNoAnswerAnswerBuilder toBuilder() =>
      CaptainActiveOrderDtoOutputOrderNoAnswerAnswerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainActiveOrderDtoOutputOrderNoAnswerAnswer &&
        answer == other.answer &&
        at == other.at;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, answer.hashCode);
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CaptainActiveOrderDtoOutputOrderNoAnswerAnswer',
          )
          ..add('answer', answer)
          ..add('at', at))
        .toString();
  }
}

class CaptainActiveOrderDtoOutputOrderNoAnswerAnswerBuilder
    implements
        Builder<
          CaptainActiveOrderDtoOutputOrderNoAnswerAnswer,
          CaptainActiveOrderDtoOutputOrderNoAnswerAnswerBuilder
        > {
  _$CaptainActiveOrderDtoOutputOrderNoAnswerAnswer? _$v;

  CaptainActiveOrderDtoOutputOrderNoAnswerAnswerAnswerEnum? _answer;
  CaptainActiveOrderDtoOutputOrderNoAnswerAnswerAnswerEnum? get answer =>
      _$this._answer;
  set answer(
    CaptainActiveOrderDtoOutputOrderNoAnswerAnswerAnswerEnum? answer,
  ) => _$this._answer = answer;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  CaptainActiveOrderDtoOutputOrderNoAnswerAnswerBuilder() {
    CaptainActiveOrderDtoOutputOrderNoAnswerAnswer._defaults(this);
  }

  CaptainActiveOrderDtoOutputOrderNoAnswerAnswerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _answer = $v.answer;
      _at = $v.at;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainActiveOrderDtoOutputOrderNoAnswerAnswer other) {
    _$v = other as _$CaptainActiveOrderDtoOutputOrderNoAnswerAnswer;
  }

  @override
  void update(
    void Function(CaptainActiveOrderDtoOutputOrderNoAnswerAnswerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainActiveOrderDtoOutputOrderNoAnswerAnswer build() => _build();

  _$CaptainActiveOrderDtoOutputOrderNoAnswerAnswer _build() {
    final _$result =
        _$v ??
        _$CaptainActiveOrderDtoOutputOrderNoAnswerAnswer._(
          answer: BuiltValueNullFieldError.checkNotNull(
            answer,
            r'CaptainActiveOrderDtoOutputOrderNoAnswerAnswer',
            'answer',
          ),
          at: BuiltValueNullFieldError.checkNotNull(
            at,
            r'CaptainActiveOrderDtoOutputOrderNoAnswerAnswer',
            'at',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
