//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_active_orders_dto_output_orders_inner_outcome_amount_to_collect.g.dart';

/// CU §11.6: «المبلغ المطلوب الآن: {المبلغ}», or «لن تدفع شيئاً لهذا الطلب» at 0.
///
/// Properties:
/// * [amount] - Integer minor units (AP §8.6).
/// * [currency]
@BuiltValue()
abstract class CustomerActiveOrdersDtoOutputOrdersInnerOutcomeAmountToCollect
    implements
        Built<
          CustomerActiveOrdersDtoOutputOrdersInnerOutcomeAmountToCollect,
          CustomerActiveOrdersDtoOutputOrdersInnerOutcomeAmountToCollectBuilder
        > {
  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  CustomerActiveOrdersDtoOutputOrdersInnerOutcomeAmountToCollect._();

  factory CustomerActiveOrdersDtoOutputOrdersInnerOutcomeAmountToCollect([
    void updates(
      CustomerActiveOrdersDtoOutputOrdersInnerOutcomeAmountToCollectBuilder b,
    ),
  ]) = _$CustomerActiveOrdersDtoOutputOrdersInnerOutcomeAmountToCollect;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CustomerActiveOrdersDtoOutputOrdersInnerOutcomeAmountToCollectBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<
    CustomerActiveOrdersDtoOutputOrdersInnerOutcomeAmountToCollect
  >
  get serializer =>
      _$CustomerActiveOrdersDtoOutputOrdersInnerOutcomeAmountToCollectSerializer();
}

class _$CustomerActiveOrdersDtoOutputOrdersInnerOutcomeAmountToCollectSerializer
    implements
        PrimitiveSerializer<
          CustomerActiveOrdersDtoOutputOrdersInnerOutcomeAmountToCollect
        > {
  @override
  final Iterable<Type> types = const [
    CustomerActiveOrdersDtoOutputOrdersInnerOutcomeAmountToCollect,
    _$CustomerActiveOrdersDtoOutputOrdersInnerOutcomeAmountToCollect,
  ];

  @override
  final String wireName =
      r'CustomerActiveOrdersDtoOutputOrdersInnerOutcomeAmountToCollect';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerActiveOrdersDtoOutputOrdersInnerOutcomeAmountToCollect object, {
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
    CustomerActiveOrdersDtoOutputOrdersInnerOutcomeAmountToCollect object, {
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
    required CustomerActiveOrdersDtoOutputOrdersInnerOutcomeAmountToCollectBuilder
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
  CustomerActiveOrdersDtoOutputOrdersInnerOutcomeAmountToCollect deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        CustomerActiveOrdersDtoOutputOrdersInnerOutcomeAmountToCollectBuilder();
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
