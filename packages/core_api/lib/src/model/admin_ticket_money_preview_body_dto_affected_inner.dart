//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_ticket_money_preview_body_dto_affected_inner.g.dart';

/// AdminTicketMoneyPreviewBodyDtoAffectedInner
///
/// Properties:
/// * [position]
/// * [quantity]
@BuiltValue()
abstract class AdminTicketMoneyPreviewBodyDtoAffectedInner
    implements
        Built<
          AdminTicketMoneyPreviewBodyDtoAffectedInner,
          AdminTicketMoneyPreviewBodyDtoAffectedInnerBuilder
        > {
  @BuiltValueField(wireName: r'position')
  int get position;

  @BuiltValueField(wireName: r'quantity')
  int get quantity;

  AdminTicketMoneyPreviewBodyDtoAffectedInner._();

  factory AdminTicketMoneyPreviewBodyDtoAffectedInner([
    void updates(AdminTicketMoneyPreviewBodyDtoAffectedInnerBuilder b),
  ]) = _$AdminTicketMoneyPreviewBodyDtoAffectedInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminTicketMoneyPreviewBodyDtoAffectedInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminTicketMoneyPreviewBodyDtoAffectedInner>
  get serializer => _$AdminTicketMoneyPreviewBodyDtoAffectedInnerSerializer();
}

class _$AdminTicketMoneyPreviewBodyDtoAffectedInnerSerializer
    implements
        PrimitiveSerializer<AdminTicketMoneyPreviewBodyDtoAffectedInner> {
  @override
  final Iterable<Type> types = const [
    AdminTicketMoneyPreviewBodyDtoAffectedInner,
    _$AdminTicketMoneyPreviewBodyDtoAffectedInner,
  ];

  @override
  final String wireName = r'AdminTicketMoneyPreviewBodyDtoAffectedInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminTicketMoneyPreviewBodyDtoAffectedInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'position';
    yield serializers.serialize(
      object.position,
      specifiedType: const FullType(int),
    );
    yield r'quantity';
    yield serializers.serialize(
      object.quantity,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminTicketMoneyPreviewBodyDtoAffectedInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(
      serializers,
      object,
      specifiedType: specifiedType,
    ).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminTicketMoneyPreviewBodyDtoAffectedInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'position':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.position = valueDes;
          break;
        case r'quantity':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.quantity = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminTicketMoneyPreviewBodyDtoAffectedInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminTicketMoneyPreviewBodyDtoAffectedInnerBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}
