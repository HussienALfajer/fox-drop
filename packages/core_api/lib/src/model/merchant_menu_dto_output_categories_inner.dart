//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/merchant_menu_dto_output_categories_inner_items_inner.dart';
import 'package:core_api/src/model/merchant_menu_dto_output_categories_inner_switched_off.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_menu_dto_output_categories_inner.g.dart';

/// MerchantMenuDtoOutputCategoriesInner
///
/// Properties:
/// * [id]
/// * [name]
/// * [hidden]
/// * [available]
/// * [switchedOff]
/// * [items]
@BuiltValue()
abstract class MerchantMenuDtoOutputCategoriesInner
    implements
        Built<
          MerchantMenuDtoOutputCategoriesInner,
          MerchantMenuDtoOutputCategoriesInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'hidden')
  bool get hidden;

  @BuiltValueField(wireName: r'available')
  bool get available;

  @BuiltValueField(wireName: r'switchedOff')
  MerchantMenuDtoOutputCategoriesInnerSwitchedOff? get switchedOff;

  @BuiltValueField(wireName: r'items')
  BuiltList<MerchantMenuDtoOutputCategoriesInnerItemsInner> get items;

  MerchantMenuDtoOutputCategoriesInner._();

  factory MerchantMenuDtoOutputCategoriesInner([
    void updates(MerchantMenuDtoOutputCategoriesInnerBuilder b),
  ]) = _$MerchantMenuDtoOutputCategoriesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantMenuDtoOutputCategoriesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantMenuDtoOutputCategoriesInner> get serializer =>
      _$MerchantMenuDtoOutputCategoriesInnerSerializer();
}

class _$MerchantMenuDtoOutputCategoriesInnerSerializer
    implements PrimitiveSerializer<MerchantMenuDtoOutputCategoriesInner> {
  @override
  final Iterable<Type> types = const [
    MerchantMenuDtoOutputCategoriesInner,
    _$MerchantMenuDtoOutputCategoriesInner,
  ];

  @override
  final String wireName = r'MerchantMenuDtoOutputCategoriesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantMenuDtoOutputCategoriesInner object, {
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
    yield r'hidden';
    yield serializers.serialize(
      object.hidden,
      specifiedType: const FullType(bool),
    );
    yield r'available';
    yield serializers.serialize(
      object.available,
      specifiedType: const FullType(bool),
    );
    yield r'switchedOff';
    yield object.switchedOff == null
        ? null
        : serializers.serialize(
            object.switchedOff,
            specifiedType: const FullType.nullable(
              MerchantMenuDtoOutputCategoriesInnerSwitchedOff,
            ),
          );
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [
        FullType(MerchantMenuDtoOutputCategoriesInnerItemsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantMenuDtoOutputCategoriesInner object, {
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
    required MerchantMenuDtoOutputCategoriesInnerBuilder result,
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
        case r'hidden':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.hidden = valueDes;
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
        case r'switchedOff':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      MerchantMenuDtoOutputCategoriesInnerSwitchedOff,
                    ),
                  )
                  as MerchantMenuDtoOutputCategoriesInnerSwitchedOff?;
          if (valueDes == null) continue;
          result.switchedOff.replace(valueDes);
          break;
        case r'items':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(MerchantMenuDtoOutputCategoriesInnerItemsInner),
                    ]),
                  )
                  as BuiltList<MerchantMenuDtoOutputCategoriesInnerItemsInner>;
          result.items.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantMenuDtoOutputCategoriesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantMenuDtoOutputCategoriesInnerBuilder();
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
