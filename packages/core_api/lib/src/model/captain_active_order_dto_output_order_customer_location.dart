//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_active_order_dto_output_order_customer_location.g.dart';

/// The exact pin, with the route and «ابدأ الملاحة».
///
/// Properties:
/// * [latitude]
/// * [longitude]
@BuiltValue()
abstract class CaptainActiveOrderDtoOutputOrderCustomerLocation
    implements
        Built<
          CaptainActiveOrderDtoOutputOrderCustomerLocation,
          CaptainActiveOrderDtoOutputOrderCustomerLocationBuilder
        > {
  @BuiltValueField(wireName: r'latitude')
  num get latitude;

  @BuiltValueField(wireName: r'longitude')
  num get longitude;

  CaptainActiveOrderDtoOutputOrderCustomerLocation._();

  factory CaptainActiveOrderDtoOutputOrderCustomerLocation([
    void updates(CaptainActiveOrderDtoOutputOrderCustomerLocationBuilder b),
  ]) = _$CaptainActiveOrderDtoOutputOrderCustomerLocation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CaptainActiveOrderDtoOutputOrderCustomerLocationBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainActiveOrderDtoOutputOrderCustomerLocation>
  get serializer =>
      _$CaptainActiveOrderDtoOutputOrderCustomerLocationSerializer();
}

class _$CaptainActiveOrderDtoOutputOrderCustomerLocationSerializer
    implements
        PrimitiveSerializer<CaptainActiveOrderDtoOutputOrderCustomerLocation> {
  @override
  final Iterable<Type> types = const [
    CaptainActiveOrderDtoOutputOrderCustomerLocation,
    _$CaptainActiveOrderDtoOutputOrderCustomerLocation,
  ];

  @override
  final String wireName = r'CaptainActiveOrderDtoOutputOrderCustomerLocation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainActiveOrderDtoOutputOrderCustomerLocation object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'latitude';
    yield serializers.serialize(
      object.latitude,
      specifiedType: const FullType(num),
    );
    yield r'longitude';
    yield serializers.serialize(
      object.longitude,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainActiveOrderDtoOutputOrderCustomerLocation object, {
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
    required CaptainActiveOrderDtoOutputOrderCustomerLocationBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'latitude':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(num))
                  as num;
          result.latitude = valueDes;
          break;
        case r'longitude':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(num))
                  as num;
          result.longitude = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainActiveOrderDtoOutputOrderCustomerLocation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainActiveOrderDtoOutputOrderCustomerLocationBuilder();
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
