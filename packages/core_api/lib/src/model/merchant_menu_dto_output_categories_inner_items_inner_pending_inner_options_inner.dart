//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/merchant_pending_money_output.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_menu_dto_output_categories_inner_items_inner_pending_inner_options_inner.g.dart';

/// MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInner
///
/// Properties:
/// * [id]
/// * [name]
/// * [priceDelta]
@BuiltValue()
abstract class MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInner
    implements
        Built<
          MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInner,
          MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'priceDelta')
  MerchantPendingMoneyOutput get priceDelta;

  MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInner._();

  factory MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInner([
    void updates(
      MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInnerBuilder
      b,
    ),
  ]) = _$MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInnerBuilder
    b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<
    MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInner
  >
  get serializer =>
      _$MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInnerSerializer();
}

class _$MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInnerSerializer
    implements
        PrimitiveSerializer<
          MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInner
        > {
  @override
  final Iterable<Type> types = const [
    MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInner,
    _$MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInner,
  ];

  @override
  final String wireName =
      r'MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInner
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
    yield serializers.serialize(
      object.priceDelta,
      specifiedType: const FullType(MerchantPendingMoneyOutput),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInner
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
    required MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInnerBuilder
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
                    specifiedType: const FullType(MerchantPendingMoneyOutput),
                  )
                  as MerchantPendingMoneyOutput;
          result.priceDelta.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInner
  deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInnerBuilder();
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
