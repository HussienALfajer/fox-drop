//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_draft_choices_dto_output_default_minimum_order.g.dart';

/// merchant.default_min_order; null when unset.
///
/// Properties:
/// * [amount] - Integer minor units of the currency, as a string.
/// * [currency]
@BuiltValue()
abstract class AdminRestaurantDraftChoicesDtoOutputDefaultMinimumOrder
    implements
        Built<
          AdminRestaurantDraftChoicesDtoOutputDefaultMinimumOrder,
          AdminRestaurantDraftChoicesDtoOutputDefaultMinimumOrderBuilder
        > {
  /// Integer minor units of the currency, as a string.
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  AdminRestaurantDraftChoicesDtoOutputDefaultMinimumOrder._();

  factory AdminRestaurantDraftChoicesDtoOutputDefaultMinimumOrder([
    void updates(
      AdminRestaurantDraftChoicesDtoOutputDefaultMinimumOrderBuilder b,
    ),
  ]) = _$AdminRestaurantDraftChoicesDtoOutputDefaultMinimumOrder;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminRestaurantDraftChoicesDtoOutputDefaultMinimumOrderBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantDraftChoicesDtoOutputDefaultMinimumOrder>
  get serializer =>
      _$AdminRestaurantDraftChoicesDtoOutputDefaultMinimumOrderSerializer();
}

class _$AdminRestaurantDraftChoicesDtoOutputDefaultMinimumOrderSerializer
    implements
        PrimitiveSerializer<
          AdminRestaurantDraftChoicesDtoOutputDefaultMinimumOrder
        > {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantDraftChoicesDtoOutputDefaultMinimumOrder,
    _$AdminRestaurantDraftChoicesDtoOutputDefaultMinimumOrder,
  ];

  @override
  final String wireName =
      r'AdminRestaurantDraftChoicesDtoOutputDefaultMinimumOrder';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantDraftChoicesDtoOutputDefaultMinimumOrder object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(String),
    );
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantDraftChoicesDtoOutputDefaultMinimumOrder object, {
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
    required AdminRestaurantDraftChoicesDtoOutputDefaultMinimumOrderBuilder
    result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'amount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.amount = valueDes;
          break;
        case r'currency':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.currency = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRestaurantDraftChoicesDtoOutputDefaultMinimumOrder deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        AdminRestaurantDraftChoicesDtoOutputDefaultMinimumOrderBuilder();
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
