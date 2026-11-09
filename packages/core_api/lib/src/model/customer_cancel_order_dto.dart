//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_cancel_order_dto.g.dart';

/// CustomerCancelOrderDto
///
/// Properties:
/// * [reason] - A code of Content's customer_cancel list (AP Appendix B).
/// * [note] - The optional text of «سبب آخر»; null for the other reasons.
@BuiltValue()
abstract class CustomerCancelOrderDto
    implements Built<CustomerCancelOrderDto, CustomerCancelOrderDtoBuilder> {
  /// A code of Content's customer_cancel list (AP Appendix B).
  @BuiltValueField(wireName: r'reason')
  String get reason;

  /// The optional text of «سبب آخر»; null for the other reasons.
  @BuiltValueField(wireName: r'note')
  String? get note;

  CustomerCancelOrderDto._();

  factory CustomerCancelOrderDto([
    void updates(CustomerCancelOrderDtoBuilder b),
  ]) = _$CustomerCancelOrderDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerCancelOrderDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerCancelOrderDto> get serializer =>
      _$CustomerCancelOrderDtoSerializer();
}

class _$CustomerCancelOrderDtoSerializer
    implements PrimitiveSerializer<CustomerCancelOrderDto> {
  @override
  final Iterable<Type> types = const [
    CustomerCancelOrderDto,
    _$CustomerCancelOrderDto,
  ];

  @override
  final String wireName = r'CustomerCancelOrderDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerCancelOrderDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    yield r'note';
    yield object.note == null
        ? null
        : serializers.serialize(
            object.note,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerCancelOrderDto object, {
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
    required CustomerCancelOrderDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.reason = valueDes;
          break;
        case r'note':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerCancelOrderDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerCancelOrderDtoBuilder();
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
