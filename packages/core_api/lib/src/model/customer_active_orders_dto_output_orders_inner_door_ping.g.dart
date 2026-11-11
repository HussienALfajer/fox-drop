// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_active_orders_dto_output_orders_inner_door_ping.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CustomerActiveOrdersDtoOutputOrdersInnerDoorPingAnswerEnum
_$customerActiveOrdersDtoOutputOrdersInnerDoorPingAnswerEnum_coming =
    const CustomerActiveOrdersDtoOutputOrdersInnerDoorPingAnswerEnum._(
      'coming',
    );
const CustomerActiveOrdersDtoOutputOrdersInnerDoorPingAnswerEnum
_$customerActiveOrdersDtoOutputOrdersInnerDoorPingAnswerEnum_contactingRecipient =
    const CustomerActiveOrdersDtoOutputOrdersInnerDoorPingAnswerEnum._(
      'contactingRecipient',
    );

CustomerActiveOrdersDtoOutputOrdersInnerDoorPingAnswerEnum
_$customerActiveOrdersDtoOutputOrdersInnerDoorPingAnswerEnumValueOf(
  String name,
) {
  switch (name) {
    case 'coming':
      return _$customerActiveOrdersDtoOutputOrdersInnerDoorPingAnswerEnum_coming;
    case 'contactingRecipient':
      return _$customerActiveOrdersDtoOutputOrdersInnerDoorPingAnswerEnum_contactingRecipient;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CustomerActiveOrdersDtoOutputOrdersInnerDoorPingAnswerEnum>
_$customerActiveOrdersDtoOutputOrdersInnerDoorPingAnswerEnumValues =
    BuiltSet<CustomerActiveOrdersDtoOutputOrdersInnerDoorPingAnswerEnum>(const <
      CustomerActiveOrdersDtoOutputOrdersInnerDoorPingAnswerEnum
    >[
      _$customerActiveOrdersDtoOutputOrdersInnerDoorPingAnswerEnum_coming,
      _$customerActiveOrdersDtoOutputOrdersInnerDoorPingAnswerEnum_contactingRecipient,
    ]);

Serializer<CustomerActiveOrdersDtoOutputOrdersInnerDoorPingAnswerEnum>
_$customerActiveOrdersDtoOutputOrdersInnerDoorPingAnswerEnumSerializer =
    _$CustomerActiveOrdersDtoOutputOrdersInnerDoorPingAnswerEnumSerializer();

class _$CustomerActiveOrdersDtoOutputOrdersInnerDoorPingAnswerEnumSerializer
    implements
        PrimitiveSerializer<
          CustomerActiveOrdersDtoOutputOrdersInnerDoorPingAnswerEnum
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
    CustomerActiveOrdersDtoOutputOrdersInnerDoorPingAnswerEnum,
  ];
  @override
  final String wireName =
      'CustomerActiveOrdersDtoOutputOrdersInnerDoorPingAnswerEnum';

  @override
  Object serialize(
    Serializers serializers,
    CustomerActiveOrdersDtoOutputOrdersInnerDoorPingAnswerEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerDoorPingAnswerEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CustomerActiveOrdersDtoOutputOrdersInnerDoorPingAnswerEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CustomerActiveOrdersDtoOutputOrdersInnerDoorPing
    extends CustomerActiveOrdersDtoOutputOrdersInnerDoorPing {
  @override
  final DateTime at;
  @override
  final CustomerActiveOrdersDtoOutputOrdersInnerDoorPingAnswerEnum? answer;
  @override
  final DateTime? answeredAt;

  factory _$CustomerActiveOrdersDtoOutputOrdersInnerDoorPing([
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerDoorPingBuilder)?
    updates,
  ]) =>
      (CustomerActiveOrdersDtoOutputOrdersInnerDoorPingBuilder()
            ..update(updates))
          ._build();

  _$CustomerActiveOrdersDtoOutputOrdersInnerDoorPing._({
    required this.at,
    this.answer,
    this.answeredAt,
  }) : super._();
  @override
  CustomerActiveOrdersDtoOutputOrdersInnerDoorPing rebuild(
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerDoorPingBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerDoorPingBuilder toBuilder() =>
      CustomerActiveOrdersDtoOutputOrdersInnerDoorPingBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerActiveOrdersDtoOutputOrdersInnerDoorPing &&
        at == other.at &&
        answer == other.answer &&
        answeredAt == other.answeredAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jc(_$hash, answer.hashCode);
    _$hash = $jc(_$hash, answeredAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CustomerActiveOrdersDtoOutputOrdersInnerDoorPing',
          )
          ..add('at', at)
          ..add('answer', answer)
          ..add('answeredAt', answeredAt))
        .toString();
  }
}

class CustomerActiveOrdersDtoOutputOrdersInnerDoorPingBuilder
    implements
        Builder<
          CustomerActiveOrdersDtoOutputOrdersInnerDoorPing,
          CustomerActiveOrdersDtoOutputOrdersInnerDoorPingBuilder
        > {
  _$CustomerActiveOrdersDtoOutputOrdersInnerDoorPing? _$v;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  CustomerActiveOrdersDtoOutputOrdersInnerDoorPingAnswerEnum? _answer;
  CustomerActiveOrdersDtoOutputOrdersInnerDoorPingAnswerEnum? get answer =>
      _$this._answer;
  set answer(
    CustomerActiveOrdersDtoOutputOrdersInnerDoorPingAnswerEnum? answer,
  ) => _$this._answer = answer;

  DateTime? _answeredAt;
  DateTime? get answeredAt => _$this._answeredAt;
  set answeredAt(DateTime? answeredAt) => _$this._answeredAt = answeredAt;

  CustomerActiveOrdersDtoOutputOrdersInnerDoorPingBuilder() {
    CustomerActiveOrdersDtoOutputOrdersInnerDoorPing._defaults(this);
  }

  CustomerActiveOrdersDtoOutputOrdersInnerDoorPingBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _at = $v.at;
      _answer = $v.answer;
      _answeredAt = $v.answeredAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerActiveOrdersDtoOutputOrdersInnerDoorPing other) {
    _$v = other as _$CustomerActiveOrdersDtoOutputOrdersInnerDoorPing;
  }

  @override
  void update(
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerDoorPingBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerDoorPing build() => _build();

  _$CustomerActiveOrdersDtoOutputOrdersInnerDoorPing _build() {
    final _$result =
        _$v ??
        _$CustomerActiveOrdersDtoOutputOrdersInnerDoorPing._(
          at: BuiltValueNullFieldError.checkNotNull(
            at,
            r'CustomerActiveOrdersDtoOutputOrdersInnerDoorPing',
            'at',
          ),
          answer: answer,
          answeredAt: answeredAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
