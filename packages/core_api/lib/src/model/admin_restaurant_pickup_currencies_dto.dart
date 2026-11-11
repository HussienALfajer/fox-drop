//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_pickup_currencies_dto.g.dart';

/// AdminRestaurantPickupCurrenciesDto
///
/// Properties:
/// * [currencies] - The other currencies to accept at pickup; the base is always accepted.
@BuiltValue()
abstract class AdminRestaurantPickupCurrenciesDto
    implements
        Built<
          AdminRestaurantPickupCurrenciesDto,
          AdminRestaurantPickupCurrenciesDtoBuilder
        > {
  /// The other currencies to accept at pickup; the base is always accepted.
  @BuiltValueField(wireName: r'currencies')
  BuiltList<String> get currencies;

  AdminRestaurantPickupCurrenciesDto._();

  factory AdminRestaurantPickupCurrenciesDto([
    void updates(AdminRestaurantPickupCurrenciesDtoBuilder b),
  ]) = _$AdminRestaurantPickupCurrenciesDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRestaurantPickupCurrenciesDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantPickupCurrenciesDto> get serializer =>
      _$AdminRestaurantPickupCurrenciesDtoSerializer();
}

class _$AdminRestaurantPickupCurrenciesDtoSerializer
    implements PrimitiveSerializer<AdminRestaurantPickupCurrenciesDto> {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantPickupCurrenciesDto,
    _$AdminRestaurantPickupCurrenciesDto,
  ];

  @override
  final String wireName = r'AdminRestaurantPickupCurrenciesDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantPickupCurrenciesDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'currencies';
    yield serializers.serialize(
      object.currencies,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantPickupCurrenciesDto object, {
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
    required AdminRestaurantPickupCurrenciesDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'currencies':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.currencies.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRestaurantPickupCurrenciesDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantPickupCurrenciesDtoBuilder();
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
