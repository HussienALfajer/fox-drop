//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_order_dto_output_order_edit_choices_items_inner_option_groups_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_dto_output_order_edit_choices_items_inner.g.dart';

/// AdminOrderDtoOutputOrderEditChoicesItemsInner
///
/// Properties:
/// * [id]
/// * [name]
/// * [category]
/// * [price] - Integer minor units (AP §8.6).
/// * [optionGroups]
@BuiltValue()
abstract class AdminOrderDtoOutputOrderEditChoicesItemsInner
    implements
        Built<
          AdminOrderDtoOutputOrderEditChoicesItemsInner,
          AdminOrderDtoOutputOrderEditChoicesItemsInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'category')
  String get category;

  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'price')
  String get price;

  @BuiltValueField(wireName: r'optionGroups')
  BuiltList<AdminOrderDtoOutputOrderEditChoicesItemsInnerOptionGroupsInner>
  get optionGroups;

  AdminOrderDtoOutputOrderEditChoicesItemsInner._();

  factory AdminOrderDtoOutputOrderEditChoicesItemsInner([
    void updates(AdminOrderDtoOutputOrderEditChoicesItemsInnerBuilder b),
  ]) = _$AdminOrderDtoOutputOrderEditChoicesItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminOrderDtoOutputOrderEditChoicesItemsInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderDtoOutputOrderEditChoicesItemsInner>
  get serializer => _$AdminOrderDtoOutputOrderEditChoicesItemsInnerSerializer();
}

class _$AdminOrderDtoOutputOrderEditChoicesItemsInnerSerializer
    implements
        PrimitiveSerializer<AdminOrderDtoOutputOrderEditChoicesItemsInner> {
  @override
  final Iterable<Type> types = const [
    AdminOrderDtoOutputOrderEditChoicesItemsInner,
    _$AdminOrderDtoOutputOrderEditChoicesItemsInner,
  ];

  @override
  final String wireName = r'AdminOrderDtoOutputOrderEditChoicesItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderDtoOutputOrderEditChoicesItemsInner object, {
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
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(String),
    );
    yield r'price';
    yield serializers.serialize(
      object.price,
      specifiedType: const FullType(String),
    );
    yield r'optionGroups';
    yield serializers.serialize(
      object.optionGroups,
      specifiedType: const FullType(BuiltList, [
        FullType(
          AdminOrderDtoOutputOrderEditChoicesItemsInnerOptionGroupsInner,
        ),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderEditChoicesItemsInner object, {
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
    required AdminOrderDtoOutputOrderEditChoicesItemsInnerBuilder result,
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
        case r'category':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.category = valueDes;
          break;
        case r'price':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.price = valueDes;
          break;
        case r'optionGroups':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        AdminOrderDtoOutputOrderEditChoicesItemsInnerOptionGroupsInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    AdminOrderDtoOutputOrderEditChoicesItemsInnerOptionGroupsInner
                  >;
          result.optionGroups.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderDtoOutputOrderEditChoicesItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderDtoOutputOrderEditChoicesItemsInnerBuilder();
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
