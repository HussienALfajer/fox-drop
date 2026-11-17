//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_customer_dto_output_review_stop.g.dart';

/// AdminCustomerDtoOutputReviewStop
///
/// Properties:
/// * [id]
/// * [startedAt]
@BuiltValue()
abstract class AdminCustomerDtoOutputReviewStop
    implements
        Built<
          AdminCustomerDtoOutputReviewStop,
          AdminCustomerDtoOutputReviewStopBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'startedAt')
  DateTime get startedAt;

  AdminCustomerDtoOutputReviewStop._();

  factory AdminCustomerDtoOutputReviewStop([
    void updates(AdminCustomerDtoOutputReviewStopBuilder b),
  ]) = _$AdminCustomerDtoOutputReviewStop;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCustomerDtoOutputReviewStopBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCustomerDtoOutputReviewStop> get serializer =>
      _$AdminCustomerDtoOutputReviewStopSerializer();
}

class _$AdminCustomerDtoOutputReviewStopSerializer
    implements PrimitiveSerializer<AdminCustomerDtoOutputReviewStop> {
  @override
  final Iterable<Type> types = const [
    AdminCustomerDtoOutputReviewStop,
    _$AdminCustomerDtoOutputReviewStop,
  ];

  @override
  final String wireName = r'AdminCustomerDtoOutputReviewStop';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCustomerDtoOutputReviewStop object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'startedAt';
    yield serializers.serialize(
      object.startedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCustomerDtoOutputReviewStop object, {
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
    required AdminCustomerDtoOutputReviewStopBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.id = valueDes;
          break;
        case r'startedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.startedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCustomerDtoOutputReviewStop deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCustomerDtoOutputReviewStopBuilder();
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
