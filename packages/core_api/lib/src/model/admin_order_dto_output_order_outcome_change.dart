//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_order_dto_output_order_outcome_change_foods_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_dto_output_order_outcome_change.g.dart';

/// AP §8.9 «تغيير النتيجة» (OWN only, orders.change_outcome): while the outcome can change; null otherwise.
///
/// Properties:
/// * [until] - order.outcome_change_days after the first outcome.
/// * [foods] - Content's food_after_failed list, in order (AP Appendix B).
@BuiltValue()
abstract class AdminOrderDtoOutputOrderOutcomeChange
    implements
        Built<
          AdminOrderDtoOutputOrderOutcomeChange,
          AdminOrderDtoOutputOrderOutcomeChangeBuilder
        > {
  /// order.outcome_change_days after the first outcome.
  @BuiltValueField(wireName: r'until')
  DateTime get until;

  /// Content's food_after_failed list, in order (AP Appendix B).
  @BuiltValueField(wireName: r'foods')
  BuiltList<AdminOrderDtoOutputOrderOutcomeChangeFoodsInner> get foods;

  AdminOrderDtoOutputOrderOutcomeChange._();

  factory AdminOrderDtoOutputOrderOutcomeChange([
    void updates(AdminOrderDtoOutputOrderOutcomeChangeBuilder b),
  ]) = _$AdminOrderDtoOutputOrderOutcomeChange;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderDtoOutputOrderOutcomeChangeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderDtoOutputOrderOutcomeChange> get serializer =>
      _$AdminOrderDtoOutputOrderOutcomeChangeSerializer();
}

class _$AdminOrderDtoOutputOrderOutcomeChangeSerializer
    implements PrimitiveSerializer<AdminOrderDtoOutputOrderOutcomeChange> {
  @override
  final Iterable<Type> types = const [
    AdminOrderDtoOutputOrderOutcomeChange,
    _$AdminOrderDtoOutputOrderOutcomeChange,
  ];

  @override
  final String wireName = r'AdminOrderDtoOutputOrderOutcomeChange';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderDtoOutputOrderOutcomeChange object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'until';
    yield serializers.serialize(
      object.until,
      specifiedType: const FullType(DateTime),
    );
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
    AdminOrderDtoOutputOrderOutcomeChange object, {
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
    required AdminOrderDtoOutputOrderOutcomeChangeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'until':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.until = valueDes;
          break;
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
  AdminOrderDtoOutputOrderOutcomeChange deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderDtoOutputOrderOutcomeChangeBuilder();
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
