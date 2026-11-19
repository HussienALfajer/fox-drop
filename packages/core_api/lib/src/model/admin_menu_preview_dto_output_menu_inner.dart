//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/customer_restaurant_page_dto_output_menu_inner_window.dart';
import 'package:core_api/src/model/admin_menu_preview_dto_output_menu_inner_items_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_menu_preview_dto_output_menu_inner.g.dart';

/// AdminMenuPreviewDtoOutputMenuInner
///
/// Properties:
/// * [id]
/// * [name]
/// * [window]
/// * [items]
@BuiltValue()
abstract class AdminMenuPreviewDtoOutputMenuInner
    implements
        Built<
          AdminMenuPreviewDtoOutputMenuInner,
          AdminMenuPreviewDtoOutputMenuInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'window')
  CustomerRestaurantPageDtoOutputMenuInnerWindow? get window;

  @BuiltValueField(wireName: r'items')
  BuiltList<AdminMenuPreviewDtoOutputMenuInnerItemsInner> get items;

  AdminMenuPreviewDtoOutputMenuInner._();

  factory AdminMenuPreviewDtoOutputMenuInner([
    void updates(AdminMenuPreviewDtoOutputMenuInnerBuilder b),
  ]) = _$AdminMenuPreviewDtoOutputMenuInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminMenuPreviewDtoOutputMenuInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminMenuPreviewDtoOutputMenuInner> get serializer =>
      _$AdminMenuPreviewDtoOutputMenuInnerSerializer();
}

class _$AdminMenuPreviewDtoOutputMenuInnerSerializer
    implements PrimitiveSerializer<AdminMenuPreviewDtoOutputMenuInner> {
  @override
  final Iterable<Type> types = const [
    AdminMenuPreviewDtoOutputMenuInner,
    _$AdminMenuPreviewDtoOutputMenuInner,
  ];

  @override
  final String wireName = r'AdminMenuPreviewDtoOutputMenuInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminMenuPreviewDtoOutputMenuInner object, {
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
    yield r'window';
    yield object.window == null
        ? null
        : serializers.serialize(
            object.window,
            specifiedType: const FullType.nullable(
              CustomerRestaurantPageDtoOutputMenuInnerWindow,
            ),
          );
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminMenuPreviewDtoOutputMenuInnerItemsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminMenuPreviewDtoOutputMenuInner object, {
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
    required AdminMenuPreviewDtoOutputMenuInnerBuilder result,
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
        case r'window':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CustomerRestaurantPageDtoOutputMenuInnerWindow,
                    ),
                  )
                  as CustomerRestaurantPageDtoOutputMenuInnerWindow?;
          if (valueDes == null) continue;
          result.window.replace(valueDes);
          break;
        case r'items':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminMenuPreviewDtoOutputMenuInnerItemsInner),
                    ]),
                  )
                  as BuiltList<AdminMenuPreviewDtoOutputMenuInnerItemsInner>;
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
  AdminMenuPreviewDtoOutputMenuInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminMenuPreviewDtoOutputMenuInnerBuilder();
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
