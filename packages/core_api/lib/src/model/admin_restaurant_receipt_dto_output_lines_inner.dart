//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_receipt_dto_output_lines_inner.g.dart';

/// AdminRestaurantReceiptDtoOutputLinesInner
///
/// Properties:
/// * [currency]
/// * [amount]
/// * [base_]
@BuiltValue()
abstract class AdminRestaurantReceiptDtoOutputLinesInner
    implements
        Built<
          AdminRestaurantReceiptDtoOutputLinesInner,
          AdminRestaurantReceiptDtoOutputLinesInnerBuilder
        > {
  @BuiltValueField(wireName: r'currency')
  String get currency;

  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'base')
  String get base_;

  AdminRestaurantReceiptDtoOutputLinesInner._();

  factory AdminRestaurantReceiptDtoOutputLinesInner([
    void updates(AdminRestaurantReceiptDtoOutputLinesInnerBuilder b),
  ]) = _$AdminRestaurantReceiptDtoOutputLinesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRestaurantReceiptDtoOutputLinesInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantReceiptDtoOutputLinesInner> get serializer =>
      _$AdminRestaurantReceiptDtoOutputLinesInnerSerializer();
}

class _$AdminRestaurantReceiptDtoOutputLinesInnerSerializer
    implements PrimitiveSerializer<AdminRestaurantReceiptDtoOutputLinesInner> {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantReceiptDtoOutputLinesInner,
    _$AdminRestaurantReceiptDtoOutputLinesInner,
  ];

  @override
  final String wireName = r'AdminRestaurantReceiptDtoOutputLinesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantReceiptDtoOutputLinesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(String),
    );
    yield r'base';
    yield serializers.serialize(
      object.base_,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantReceiptDtoOutputLinesInner object, {
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
    required AdminRestaurantReceiptDtoOutputLinesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'currency':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.currency = valueDes;
          break;
        case r'amount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.amount = valueDes;
          break;
        case r'base':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.base_ = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRestaurantReceiptDtoOutputLinesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantReceiptDtoOutputLinesInnerBuilder();
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
