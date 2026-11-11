//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_active_orders_dto_output_orders_inner_door_ping.g.dart';

/// CU §11.7 (slice 2.13d): the captain's latest «تنبيه الزبون» while at the door. Unanswered and under 30 seconds old, the open app rings full screen «الكابتن عند الباب ويحاول الوصول إليك» (or «… إلى {المستلم}») with «أنا قادم» (or «سأتصل بالمستلم») and «اتصال بالكابتن». Null without one.
///
/// Properties:
/// * [at]
/// * [answer] - «أنا قادم», or «سأتصل بالمستلم» for an order with a recipient; null unanswered.
/// * [answeredAt]
@BuiltValue()
abstract class CustomerActiveOrdersDtoOutputOrdersInnerDoorPing
    implements
        Built<
          CustomerActiveOrdersDtoOutputOrdersInnerDoorPing,
          CustomerActiveOrdersDtoOutputOrdersInnerDoorPingBuilder
        > {
  @BuiltValueField(wireName: r'at')
  DateTime get at;

  /// «أنا قادم», or «سأتصل بالمستلم» for an order with a recipient; null unanswered.
  @BuiltValueField(wireName: r'answer')
  CustomerActiveOrdersDtoOutputOrdersInnerDoorPingAnswerEnum? get answer;
  // enum answerEnum {  coming,  contacting_recipient,  };

  @BuiltValueField(wireName: r'answeredAt')
  DateTime? get answeredAt;

  CustomerActiveOrdersDtoOutputOrdersInnerDoorPing._();

  factory CustomerActiveOrdersDtoOutputOrdersInnerDoorPing([
    void updates(CustomerActiveOrdersDtoOutputOrdersInnerDoorPingBuilder b),
  ]) = _$CustomerActiveOrdersDtoOutputOrdersInnerDoorPing;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CustomerActiveOrdersDtoOutputOrdersInnerDoorPingBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerActiveOrdersDtoOutputOrdersInnerDoorPing>
  get serializer =>
      _$CustomerActiveOrdersDtoOutputOrdersInnerDoorPingSerializer();
}

class _$CustomerActiveOrdersDtoOutputOrdersInnerDoorPingSerializer
    implements
        PrimitiveSerializer<CustomerActiveOrdersDtoOutputOrdersInnerDoorPing> {
  @override
  final Iterable<Type> types = const [
    CustomerActiveOrdersDtoOutputOrdersInnerDoorPing,
    _$CustomerActiveOrdersDtoOutputOrdersInnerDoorPing,
  ];

  @override
  final String wireName = r'CustomerActiveOrdersDtoOutputOrdersInnerDoorPing';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerActiveOrdersDtoOutputOrdersInnerDoorPing object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
    yield r'answer';
    yield object.answer == null
        ? null
        : serializers.serialize(
            object.answer,
            specifiedType: const FullType.nullable(
              CustomerActiveOrdersDtoOutputOrdersInnerDoorPingAnswerEnum,
            ),
          );
    yield r'answeredAt';
    yield object.answeredAt == null
        ? null
        : serializers.serialize(
            object.answeredAt,
            specifiedType: const FullType.nullable(DateTime),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerActiveOrdersDtoOutputOrdersInnerDoorPing object, {
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
    required CustomerActiveOrdersDtoOutputOrdersInnerDoorPingBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'at':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.at = valueDes;
          break;
        case r'answer':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CustomerActiveOrdersDtoOutputOrdersInnerDoorPingAnswerEnum,
                    ),
                  )
                  as CustomerActiveOrdersDtoOutputOrdersInnerDoorPingAnswerEnum?;
          if (valueDes == null) continue;
          result.answer = valueDes;
          break;
        case r'answeredAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.answeredAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerDoorPing deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerActiveOrdersDtoOutputOrdersInnerDoorPingBuilder();
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

/// «أنا قادم», or «سأتصل بالمستلم» for an order with a recipient; null unanswered.
class CustomerActiveOrdersDtoOutputOrdersInnerDoorPingAnswerEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'coming')
  static const CustomerActiveOrdersDtoOutputOrdersInnerDoorPingAnswerEnum
  coming = _$customerActiveOrdersDtoOutputOrdersInnerDoorPingAnswerEnum_coming;
  @BuiltValueEnumConst(wireName: r'contacting_recipient')
  static const CustomerActiveOrdersDtoOutputOrdersInnerDoorPingAnswerEnum
  contactingRecipient =
      _$customerActiveOrdersDtoOutputOrdersInnerDoorPingAnswerEnum_contactingRecipient;

  static Serializer<CustomerActiveOrdersDtoOutputOrdersInnerDoorPingAnswerEnum>
  get serializer =>
      _$customerActiveOrdersDtoOutputOrdersInnerDoorPingAnswerEnumSerializer;

  const CustomerActiveOrdersDtoOutputOrdersInnerDoorPingAnswerEnum._(
    String name,
  ) : super(name);

  static BuiltSet<CustomerActiveOrdersDtoOutputOrdersInnerDoorPingAnswerEnum>
  get values =>
      _$customerActiveOrdersDtoOutputOrdersInnerDoorPingAnswerEnumValues;
  static CustomerActiveOrdersDtoOutputOrdersInnerDoorPingAnswerEnum valueOf(
    String name,
  ) =>
      _$customerActiveOrdersDtoOutputOrdersInnerDoorPingAnswerEnumValueOf(name);
}
