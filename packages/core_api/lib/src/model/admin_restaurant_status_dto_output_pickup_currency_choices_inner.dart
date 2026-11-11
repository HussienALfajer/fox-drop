//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_status_dto_output_pickup_currency_choices_inner.g.dart';

/// AdminRestaurantStatusDtoOutputPickupCurrencyChoicesInner
///
/// Properties:
/// * [currency]
/// * [name] - Its Arabic name.
@BuiltValue()
abstract class AdminRestaurantStatusDtoOutputPickupCurrencyChoicesInner
    implements
        Built<
          AdminRestaurantStatusDtoOutputPickupCurrencyChoicesInner,
          AdminRestaurantStatusDtoOutputPickupCurrencyChoicesInnerBuilder
        > {
  @BuiltValueField(wireName: r'currency')
  String get currency;

  /// Its Arabic name.
  @BuiltValueField(wireName: r'name')
  String get name;

  AdminRestaurantStatusDtoOutputPickupCurrencyChoicesInner._();

  factory AdminRestaurantStatusDtoOutputPickupCurrencyChoicesInner([
    void updates(
      AdminRestaurantStatusDtoOutputPickupCurrencyChoicesInnerBuilder b,
    ),
  ]) = _$AdminRestaurantStatusDtoOutputPickupCurrencyChoicesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminRestaurantStatusDtoOutputPickupCurrencyChoicesInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantStatusDtoOutputPickupCurrencyChoicesInner>
  get serializer =>
      _$AdminRestaurantStatusDtoOutputPickupCurrencyChoicesInnerSerializer();
}

class _$AdminRestaurantStatusDtoOutputPickupCurrencyChoicesInnerSerializer
    implements
        PrimitiveSerializer<
          AdminRestaurantStatusDtoOutputPickupCurrencyChoicesInner
        > {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantStatusDtoOutputPickupCurrencyChoicesInner,
    _$AdminRestaurantStatusDtoOutputPickupCurrencyChoicesInner,
  ];

  @override
  final String wireName =
      r'AdminRestaurantStatusDtoOutputPickupCurrencyChoicesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantStatusDtoOutputPickupCurrencyChoicesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantStatusDtoOutputPickupCurrencyChoicesInner object, {
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
    required AdminRestaurantStatusDtoOutputPickupCurrencyChoicesInnerBuilder
    result,
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
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.name = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRestaurantStatusDtoOutputPickupCurrencyChoicesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        AdminRestaurantStatusDtoOutputPickupCurrencyChoicesInnerBuilder();
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
