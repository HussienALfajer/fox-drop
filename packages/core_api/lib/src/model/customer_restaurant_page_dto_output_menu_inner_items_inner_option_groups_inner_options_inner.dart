//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_went_offline_dto_output_hand_in.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_restaurant_page_dto_output_menu_inner_items_inner_option_groups_inner_options_inner.g.dart';

/// CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInner
///
/// Properties:
/// * [id]
/// * [name]
/// * [priceDelta]
/// * [available] - Faded and not pickable when false.
@BuiltValue()
abstract class CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInner
    implements
        Built<
          CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInner,
          CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'priceDelta')
  CaptainWentOfflineDtoOutputHandIn? get priceDelta;

  /// Faded and not pickable when false.
  @BuiltValueField(wireName: r'available')
  bool get available;

  CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInner._();

  factory CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInner([
    void updates(
      CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInnerBuilder
      b,
    ),
  ]) =
      _$CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInnerBuilder
    b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<
    CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInner
  >
  get serializer =>
      _$CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInnerSerializer();
}

class _$CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInnerSerializer
    implements
        PrimitiveSerializer<
          CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInner
        > {
  @override
  final Iterable<Type> types = const [
    CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInner,
    _$CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInner,
  ];

  @override
  final String wireName =
      r'CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInner
    object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'priceDelta';
    yield object.priceDelta == null
        ? null
        : serializers.serialize(
            object.priceDelta,
            specifiedType: const FullType.nullable(
              CaptainWentOfflineDtoOutputHandIn,
            ),
          );
    yield r'available';
    yield serializers.serialize(
      object.available,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInner
    object, {
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
    required CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInnerBuilder
    result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.id = valueDes;
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
        case r'priceDelta':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CaptainWentOfflineDtoOutputHandIn,
                    ),
                  )
                  as CaptainWentOfflineDtoOutputHandIn?;
          if (valueDes == null) continue;
          result.priceDelta.replace(valueDes);
          break;
        case r'available':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.available = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInner
  deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInnerBuilder();
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
