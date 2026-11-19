//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/merchant_menu_dto_output_categories_inner_items_inner_pending_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/merchant_menu_dto_output_categories_inner_switched_off.dart';
import 'package:core_api/src/model/merchant_menu_dto_output_categories_inner_items_inner_price.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_menu_dto_output_option_groups_inner_options_inner.g.dart';

/// MerchantMenuDtoOutputOptionGroupsInnerOptionsInner
///
/// Properties:
/// * [id]
/// * [name]
/// * [priceDelta]
/// * [switchedOff]
/// * [pending] - The pending requests on this row (RA §9.5): the badge «بانتظار المراجعة».
@BuiltValue()
abstract class MerchantMenuDtoOutputOptionGroupsInnerOptionsInner
    implements
        Built<
          MerchantMenuDtoOutputOptionGroupsInnerOptionsInner,
          MerchantMenuDtoOutputOptionGroupsInnerOptionsInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'priceDelta')
  MerchantMenuDtoOutputCategoriesInnerItemsInnerPrice get priceDelta;

  @BuiltValueField(wireName: r'switchedOff')
  MerchantMenuDtoOutputCategoriesInnerSwitchedOff? get switchedOff;

  /// The pending requests on this row (RA §9.5): the badge «بانتظار المراجعة».
  @BuiltValueField(wireName: r'pending')
  BuiltList<MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInner>
  get pending;

  MerchantMenuDtoOutputOptionGroupsInnerOptionsInner._();

  factory MerchantMenuDtoOutputOptionGroupsInnerOptionsInner([
    void updates(MerchantMenuDtoOutputOptionGroupsInnerOptionsInnerBuilder b),
  ]) = _$MerchantMenuDtoOutputOptionGroupsInnerOptionsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    MerchantMenuDtoOutputOptionGroupsInnerOptionsInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantMenuDtoOutputOptionGroupsInnerOptionsInner>
  get serializer =>
      _$MerchantMenuDtoOutputOptionGroupsInnerOptionsInnerSerializer();
}

class _$MerchantMenuDtoOutputOptionGroupsInnerOptionsInnerSerializer
    implements
        PrimitiveSerializer<
          MerchantMenuDtoOutputOptionGroupsInnerOptionsInner
        > {
  @override
  final Iterable<Type> types = const [
    MerchantMenuDtoOutputOptionGroupsInnerOptionsInner,
    _$MerchantMenuDtoOutputOptionGroupsInnerOptionsInner,
  ];

  @override
  final String wireName = r'MerchantMenuDtoOutputOptionGroupsInnerOptionsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantMenuDtoOutputOptionGroupsInnerOptionsInner object, {
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
      specifiedType: const FullType(
        MerchantMenuDtoOutputCategoriesInnerItemsInnerPrice,
      ),
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
    yield r'pending';
    yield serializers.serialize(
      object.pending,
      specifiedType: const FullType(BuiltList, [
        FullType(MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantMenuDtoOutputOptionGroupsInnerOptionsInner object, {
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
    required MerchantMenuDtoOutputOptionGroupsInnerOptionsInnerBuilder result,
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
                    specifiedType: const FullType(
                      MerchantMenuDtoOutputCategoriesInnerItemsInnerPrice,
                    ),
                  )
                  as MerchantMenuDtoOutputCategoriesInnerItemsInnerPrice;
          result.priceDelta.replace(valueDes);
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
        case r'pending':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInner
                  >;
          result.pending.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantMenuDtoOutputOptionGroupsInnerOptionsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantMenuDtoOutputOptionGroupsInnerOptionsInnerBuilder();
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
