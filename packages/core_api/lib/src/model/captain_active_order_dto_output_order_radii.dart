//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_active_order_dto_output_order_radii.g.dart';

/// The arrival radii, by the straight line from the latest fix.
///
/// Properties:
/// * [restaurantMetres] - captain.merchant_arrival_radius_m: «وصلت إلى المطعم» within it (C6).
/// * [customerMetres] - captain.customer_radius_m: «وصلت» and «تم التسليم» need no reason within it (K4, C9).
@BuiltValue()
abstract class CaptainActiveOrderDtoOutputOrderRadii implements Built<CaptainActiveOrderDtoOutputOrderRadii, CaptainActiveOrderDtoOutputOrderRadiiBuilder> {
  /// captain.merchant_arrival_radius_m: «وصلت إلى المطعم» within it (C6).
  @BuiltValueField(wireName: r'restaurantMetres')
  int get restaurantMetres;

  /// captain.customer_radius_m: «وصلت» and «تم التسليم» need no reason within it (K4, C9).
  @BuiltValueField(wireName: r'customerMetres')
  int get customerMetres;

  CaptainActiveOrderDtoOutputOrderRadii._();

  factory CaptainActiveOrderDtoOutputOrderRadii([void updates(CaptainActiveOrderDtoOutputOrderRadiiBuilder b)]) = _$CaptainActiveOrderDtoOutputOrderRadii;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainActiveOrderDtoOutputOrderRadiiBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainActiveOrderDtoOutputOrderRadii> get serializer => _$CaptainActiveOrderDtoOutputOrderRadiiSerializer();
}

class _$CaptainActiveOrderDtoOutputOrderRadiiSerializer implements PrimitiveSerializer<CaptainActiveOrderDtoOutputOrderRadii> {
  @override
  final Iterable<Type> types = const [CaptainActiveOrderDtoOutputOrderRadii, _$CaptainActiveOrderDtoOutputOrderRadii];

  @override
  final String wireName = r'CaptainActiveOrderDtoOutputOrderRadii';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainActiveOrderDtoOutputOrderRadii object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'restaurantMetres';
    yield serializers.serialize(
      object.restaurantMetres,
      specifiedType: const FullType(int),
    );
    yield r'customerMetres';
    yield serializers.serialize(
      object.customerMetres,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainActiveOrderDtoOutputOrderRadii object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CaptainActiveOrderDtoOutputOrderRadiiBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'restaurantMetres':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.restaurantMetres = valueDes;
          break;
        case r'customerMetres':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.customerMetres = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainActiveOrderDtoOutputOrderRadii deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainActiveOrderDtoOutputOrderRadiiBuilder();
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


