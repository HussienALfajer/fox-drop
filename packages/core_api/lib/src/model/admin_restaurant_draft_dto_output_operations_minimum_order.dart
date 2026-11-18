//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_draft_dto_output_operations_minimum_order.g.dart';

/// AdminRestaurantDraftDtoOutputOperationsMinimumOrder
///
/// Properties:
/// * [amount] - Integer minor units of the currency, as a string.
/// * [currency]
@BuiltValue()
abstract class AdminRestaurantDraftDtoOutputOperationsMinimumOrder
    implements
        Built<
          AdminRestaurantDraftDtoOutputOperationsMinimumOrder,
          AdminRestaurantDraftDtoOutputOperationsMinimumOrderBuilder
        > {
  /// Integer minor units of the currency, as a string.
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  AdminRestaurantDraftDtoOutputOperationsMinimumOrder._();

  factory AdminRestaurantDraftDtoOutputOperationsMinimumOrder([
    void updates(AdminRestaurantDraftDtoOutputOperationsMinimumOrderBuilder b),
  ]) = _$AdminRestaurantDraftDtoOutputOperationsMinimumOrder;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminRestaurantDraftDtoOutputOperationsMinimumOrderBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantDraftDtoOutputOperationsMinimumOrder>
  get serializer =>
      _$AdminRestaurantDraftDtoOutputOperationsMinimumOrderSerializer();
}

class _$AdminRestaurantDraftDtoOutputOperationsMinimumOrderSerializer
    implements
        PrimitiveSerializer<
          AdminRestaurantDraftDtoOutputOperationsMinimumOrder
        > {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantDraftDtoOutputOperationsMinimumOrder,
    _$AdminRestaurantDraftDtoOutputOperationsMinimumOrder,
  ];

  @override
  final String wireName =
      r'AdminRestaurantDraftDtoOutputOperationsMinimumOrder';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantDraftDtoOutputOperationsMinimumOrder object, {
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
    AdminRestaurantDraftDtoOutputOperationsMinimumOrder object, {
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
    required AdminRestaurantDraftDtoOutputOperationsMinimumOrderBuilder result,
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
  AdminRestaurantDraftDtoOutputOperationsMinimumOrder deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantDraftDtoOutputOperationsMinimumOrderBuilder();
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
