//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_active_orders_dto_output_orders_inner_cancellation.g.dart';

/// While cancelled (CU §11.9).
///
/// Properties:
/// * [at]
/// * [reason] - The code, such as merchant_auto_cancel (CU §11.9).
/// * [text] - What the customer sees (CU Appendix C), from Content as it was at the cancellation.
/// * [byCustomer] - The customer cancelled it themselves while placed: «ألغيت طلبك» instead of the text (CU §11.4, §11.9).
@BuiltValue()
abstract class CustomerActiveOrdersDtoOutputOrdersInnerCancellation
    implements
        Built<
          CustomerActiveOrdersDtoOutputOrdersInnerCancellation,
          CustomerActiveOrdersDtoOutputOrdersInnerCancellationBuilder
        > {
  @BuiltValueField(wireName: r'at')
  DateTime get at;

  /// The code, such as merchant_auto_cancel (CU §11.9).
  @BuiltValueField(wireName: r'reason')
  String get reason;

  /// What the customer sees (CU Appendix C), from Content as it was at the cancellation.
  @BuiltValueField(wireName: r'text')
  String get text;

  /// The customer cancelled it themselves while placed: «ألغيت طلبك» instead of the text (CU §11.4, §11.9).
  @BuiltValueField(wireName: r'byCustomer')
  bool get byCustomer;

  CustomerActiveOrdersDtoOutputOrdersInnerCancellation._();

  factory CustomerActiveOrdersDtoOutputOrdersInnerCancellation([
    void updates(CustomerActiveOrdersDtoOutputOrdersInnerCancellationBuilder b),
  ]) = _$CustomerActiveOrdersDtoOutputOrdersInnerCancellation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CustomerActiveOrdersDtoOutputOrdersInnerCancellationBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerActiveOrdersDtoOutputOrdersInnerCancellation>
  get serializer =>
      _$CustomerActiveOrdersDtoOutputOrdersInnerCancellationSerializer();
}

class _$CustomerActiveOrdersDtoOutputOrdersInnerCancellationSerializer
    implements
        PrimitiveSerializer<
          CustomerActiveOrdersDtoOutputOrdersInnerCancellation
        > {
  @override
  final Iterable<Type> types = const [
    CustomerActiveOrdersDtoOutputOrdersInnerCancellation,
    _$CustomerActiveOrdersDtoOutputOrdersInnerCancellation,
  ];

  @override
  final String wireName =
      r'CustomerActiveOrdersDtoOutputOrdersInnerCancellation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerActiveOrdersDtoOutputOrdersInnerCancellation object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    yield r'text';
    yield serializers.serialize(
      object.text,
      specifiedType: const FullType(String),
    );
    yield r'byCustomer';
    yield serializers.serialize(
      object.byCustomer,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerActiveOrdersDtoOutputOrdersInnerCancellation object, {
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
    required CustomerActiveOrdersDtoOutputOrdersInnerCancellationBuilder result,
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
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.reason = valueDes;
          break;
        case r'text':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.text = valueDes;
          break;
        case r'byCustomer':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.byCustomer = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerCancellation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        CustomerActiveOrdersDtoOutputOrdersInnerCancellationBuilder();
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
