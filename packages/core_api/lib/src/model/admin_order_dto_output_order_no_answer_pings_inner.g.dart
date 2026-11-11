// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto_output_order_no_answer_pings_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminOrderDtoOutputOrderNoAnswerPingsInnerAnswerEnum
_$adminOrderDtoOutputOrderNoAnswerPingsInnerAnswerEnum_coming =
    const AdminOrderDtoOutputOrderNoAnswerPingsInnerAnswerEnum._('coming');
const AdminOrderDtoOutputOrderNoAnswerPingsInnerAnswerEnum
_$adminOrderDtoOutputOrderNoAnswerPingsInnerAnswerEnum_contactingRecipient =
    const AdminOrderDtoOutputOrderNoAnswerPingsInnerAnswerEnum._(
      'contactingRecipient',
    );

AdminOrderDtoOutputOrderNoAnswerPingsInnerAnswerEnum
_$adminOrderDtoOutputOrderNoAnswerPingsInnerAnswerEnumValueOf(String name) {
  switch (name) {
    case 'coming':
      return _$adminOrderDtoOutputOrderNoAnswerPingsInnerAnswerEnum_coming;
    case 'contactingRecipient':
      return _$adminOrderDtoOutputOrderNoAnswerPingsInnerAnswerEnum_contactingRecipient;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOrderDtoOutputOrderNoAnswerPingsInnerAnswerEnum>
_$adminOrderDtoOutputOrderNoAnswerPingsInnerAnswerEnumValues =
    BuiltSet<AdminOrderDtoOutputOrderNoAnswerPingsInnerAnswerEnum>(const <
      AdminOrderDtoOutputOrderNoAnswerPingsInnerAnswerEnum
    >[
      _$adminOrderDtoOutputOrderNoAnswerPingsInnerAnswerEnum_coming,
      _$adminOrderDtoOutputOrderNoAnswerPingsInnerAnswerEnum_contactingRecipient,
    ]);

Serializer<AdminOrderDtoOutputOrderNoAnswerPingsInnerAnswerEnum>
_$adminOrderDtoOutputOrderNoAnswerPingsInnerAnswerEnumSerializer =
    _$AdminOrderDtoOutputOrderNoAnswerPingsInnerAnswerEnumSerializer();

class _$AdminOrderDtoOutputOrderNoAnswerPingsInnerAnswerEnumSerializer
    implements
        PrimitiveSerializer<
          AdminOrderDtoOutputOrderNoAnswerPingsInnerAnswerEnum
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
    AdminOrderDtoOutputOrderNoAnswerPingsInnerAnswerEnum,
  ];
  @override
  final String wireName =
      'AdminOrderDtoOutputOrderNoAnswerPingsInnerAnswerEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderNoAnswerPingsInnerAnswerEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminOrderDtoOutputOrderNoAnswerPingsInnerAnswerEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminOrderDtoOutputOrderNoAnswerPingsInnerAnswerEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminOrderDtoOutputOrderNoAnswerPingsInner
    extends AdminOrderDtoOutputOrderNoAnswerPingsInner {
  @override
  final String captainId;
  @override
  final DateTime at;
  @override
  final AdminOrderDtoOutputOrderNoAnswerPingsInnerAnswerEnum? answer;
  @override
  final DateTime? answeredAt;

  factory _$AdminOrderDtoOutputOrderNoAnswerPingsInner([
    void Function(AdminOrderDtoOutputOrderNoAnswerPingsInnerBuilder)? updates,
  ]) => (AdminOrderDtoOutputOrderNoAnswerPingsInnerBuilder()..update(updates))
      ._build();

  _$AdminOrderDtoOutputOrderNoAnswerPingsInner._({
    required this.captainId,
    required this.at,
    this.answer,
    this.answeredAt,
  }) : super._();
  @override
  AdminOrderDtoOutputOrderNoAnswerPingsInner rebuild(
    void Function(AdminOrderDtoOutputOrderNoAnswerPingsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderDtoOutputOrderNoAnswerPingsInnerBuilder toBuilder() =>
      AdminOrderDtoOutputOrderNoAnswerPingsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderDtoOutputOrderNoAnswerPingsInner &&
        captainId == other.captainId &&
        at == other.at &&
        answer == other.answer &&
        answeredAt == other.answeredAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, captainId.hashCode);
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jc(_$hash, answer.hashCode);
    _$hash = $jc(_$hash, answeredAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminOrderDtoOutputOrderNoAnswerPingsInner',
          )
          ..add('captainId', captainId)
          ..add('at', at)
          ..add('answer', answer)
          ..add('answeredAt', answeredAt))
        .toString();
  }
}

class AdminOrderDtoOutputOrderNoAnswerPingsInnerBuilder
    implements
        Builder<
          AdminOrderDtoOutputOrderNoAnswerPingsInner,
          AdminOrderDtoOutputOrderNoAnswerPingsInnerBuilder
        > {
  _$AdminOrderDtoOutputOrderNoAnswerPingsInner? _$v;

  String? _captainId;
  String? get captainId => _$this._captainId;
  set captainId(String? captainId) => _$this._captainId = captainId;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  AdminOrderDtoOutputOrderNoAnswerPingsInnerAnswerEnum? _answer;
  AdminOrderDtoOutputOrderNoAnswerPingsInnerAnswerEnum? get answer =>
      _$this._answer;
  set answer(AdminOrderDtoOutputOrderNoAnswerPingsInnerAnswerEnum? answer) =>
      _$this._answer = answer;

  DateTime? _answeredAt;
  DateTime? get answeredAt => _$this._answeredAt;
  set answeredAt(DateTime? answeredAt) => _$this._answeredAt = answeredAt;

  AdminOrderDtoOutputOrderNoAnswerPingsInnerBuilder() {
    AdminOrderDtoOutputOrderNoAnswerPingsInner._defaults(this);
  }

  AdminOrderDtoOutputOrderNoAnswerPingsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _captainId = $v.captainId;
      _at = $v.at;
      _answer = $v.answer;
      _answeredAt = $v.answeredAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderDtoOutputOrderNoAnswerPingsInner other) {
    _$v = other as _$AdminOrderDtoOutputOrderNoAnswerPingsInner;
  }

  @override
  void update(
    void Function(AdminOrderDtoOutputOrderNoAnswerPingsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderDtoOutputOrderNoAnswerPingsInner build() => _build();

  _$AdminOrderDtoOutputOrderNoAnswerPingsInner _build() {
    final _$result =
        _$v ??
        _$AdminOrderDtoOutputOrderNoAnswerPingsInner._(
          captainId: BuiltValueNullFieldError.checkNotNull(
            captainId,
            r'AdminOrderDtoOutputOrderNoAnswerPingsInner',
            'captainId',
          ),
          at: BuiltValueNullFieldError.checkNotNull(
            at,
            r'AdminOrderDtoOutputOrderNoAnswerPingsInner',
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
