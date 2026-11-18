//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_push_receipt_dto.g.dart';

/// CustomerPushReceiptDto
///
/// Properties:
/// * [messageId] - The push's `messageId`, from its data.
@BuiltValue()
abstract class CustomerPushReceiptDto
    implements Built<CustomerPushReceiptDto, CustomerPushReceiptDtoBuilder> {
  /// The push's `messageId`, from its data.
  @BuiltValueField(wireName: r'messageId')
  String get messageId;

  CustomerPushReceiptDto._();

  factory CustomerPushReceiptDto([
    void updates(CustomerPushReceiptDtoBuilder b),
  ]) = _$CustomerPushReceiptDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerPushReceiptDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerPushReceiptDto> get serializer =>
      _$CustomerPushReceiptDtoSerializer();
}

class _$CustomerPushReceiptDtoSerializer
    implements PrimitiveSerializer<CustomerPushReceiptDto> {
  @override
  final Iterable<Type> types = const [
    CustomerPushReceiptDto,
    _$CustomerPushReceiptDto,
  ];

  @override
  final String wireName = r'CustomerPushReceiptDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerPushReceiptDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'messageId';
    yield serializers.serialize(
      object.messageId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerPushReceiptDto object, {
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
    required CustomerPushReceiptDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'messageId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.messageId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerPushReceiptDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerPushReceiptDtoBuilder();
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
