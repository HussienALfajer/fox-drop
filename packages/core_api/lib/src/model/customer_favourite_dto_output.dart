//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_favourite_dto_output.g.dart';

/// CustomerFavouriteDtoOutput
///
/// Properties:
/// * [restaurantId]
/// * [favourite]
@BuiltValue()
abstract class CustomerFavouriteDtoOutput
    implements
        Built<CustomerFavouriteDtoOutput, CustomerFavouriteDtoOutputBuilder> {
  @BuiltValueField(wireName: r'restaurantId')
  String get restaurantId;

  @BuiltValueField(wireName: r'favourite')
  bool get favourite;

  CustomerFavouriteDtoOutput._();

  factory CustomerFavouriteDtoOutput([
    void updates(CustomerFavouriteDtoOutputBuilder b),
  ]) = _$CustomerFavouriteDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerFavouriteDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerFavouriteDtoOutput> get serializer =>
      _$CustomerFavouriteDtoOutputSerializer();
}

class _$CustomerFavouriteDtoOutputSerializer
    implements PrimitiveSerializer<CustomerFavouriteDtoOutput> {
  @override
  final Iterable<Type> types = const [
    CustomerFavouriteDtoOutput,
    _$CustomerFavouriteDtoOutput,
  ];

  @override
  final String wireName = r'CustomerFavouriteDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerFavouriteDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'restaurantId';
    yield serializers.serialize(
      object.restaurantId,
      specifiedType: const FullType(String),
    );
    yield r'favourite';
    yield serializers.serialize(
      object.favourite,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerFavouriteDtoOutput object, {
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
    required CustomerFavouriteDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'restaurantId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.restaurantId = valueDes;
          break;
        case r'favourite':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.favourite = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerFavouriteDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerFavouriteDtoOutputBuilder();
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
