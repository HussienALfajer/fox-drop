//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_order_dto_output_order_outcome_change_foods_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_dto_output_order_outcome_choices.g.dart';

/// While picked up or arrived: the choices of «تحديد النتيجة» (AP §9.3.2).
///
/// Properties:
/// * [foods] - Content's food_after_failed list, in order (AP Appendix B).
@BuiltValue()
abstract class AdminOrderDtoOutputOrderOutcomeChoices
    implements
        Built<
          AdminOrderDtoOutputOrderOutcomeChoices,
          AdminOrderDtoOutputOrderOutcomeChoicesBuilder
        > {
  /// Content's food_after_failed list, in order (AP Appendix B).
  @BuiltValueField(wireName: r'foods')
  BuiltList<AdminOrderDtoOutputOrderOutcomeChangeFoodsInner> get foods;

  AdminOrderDtoOutputOrderOutcomeChoices._();

  factory AdminOrderDtoOutputOrderOutcomeChoices([
    void updates(AdminOrderDtoOutputOrderOutcomeChoicesBuilder b),
  ]) = _$AdminOrderDtoOutputOrderOutcomeChoices;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderDtoOutputOrderOutcomeChoicesBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderDtoOutputOrderOutcomeChoices> get serializer =>
      _$AdminOrderDtoOutputOrderOutcomeChoicesSerializer();
}

class _$AdminOrderDtoOutputOrderOutcomeChoicesSerializer
    implements PrimitiveSerializer<AdminOrderDtoOutputOrderOutcomeChoices> {
  @override
  final Iterable<Type> types = const [
    AdminOrderDtoOutputOrderOutcomeChoices,
    _$AdminOrderDtoOutputOrderOutcomeChoices,
  ];

  @override
  final String wireName = r'AdminOrderDtoOutputOrderOutcomeChoices';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderDtoOutputOrderOutcomeChoices object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'foods';
    yield serializers.serialize(
      object.foods,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminOrderDtoOutputOrderOutcomeChangeFoodsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderOutcomeChoices object, {
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
    required AdminOrderDtoOutputOrderOutcomeChoicesBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'foods':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminOrderDtoOutputOrderOutcomeChangeFoodsInner),
                    ]),
                  )
                  as BuiltList<AdminOrderDtoOutputOrderOutcomeChangeFoodsInner>;
          result.foods.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderDtoOutputOrderOutcomeChoices deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderDtoOutputOrderOutcomeChoicesBuilder();
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
