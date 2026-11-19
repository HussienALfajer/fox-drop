//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_menu_item_order_dto.g.dart';

/// MerchantMenuItemOrderDto
///
/// Properties:
/// * [itemIds] - Every item of the category once, in order.
@BuiltValue()
abstract class MerchantMenuItemOrderDto
    implements
        Built<MerchantMenuItemOrderDto, MerchantMenuItemOrderDtoBuilder> {
  /// Every item of the category once, in order.
  @BuiltValueField(wireName: r'itemIds')
  BuiltList<String> get itemIds;

  MerchantMenuItemOrderDto._();

  factory MerchantMenuItemOrderDto([
    void updates(MerchantMenuItemOrderDtoBuilder b),
  ]) = _$MerchantMenuItemOrderDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantMenuItemOrderDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantMenuItemOrderDto> get serializer =>
      _$MerchantMenuItemOrderDtoSerializer();
}

class _$MerchantMenuItemOrderDtoSerializer
    implements PrimitiveSerializer<MerchantMenuItemOrderDto> {
  @override
  final Iterable<Type> types = const [
    MerchantMenuItemOrderDto,
    _$MerchantMenuItemOrderDto,
  ];

  @override
  final String wireName = r'MerchantMenuItemOrderDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantMenuItemOrderDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'itemIds';
    yield serializers.serialize(
      object.itemIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantMenuItemOrderDto object, {
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
    required MerchantMenuItemOrderDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'itemIds':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.itemIds.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantMenuItemOrderDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantMenuItemOrderDtoBuilder();
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
