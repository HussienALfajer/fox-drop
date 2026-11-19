//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_menu_group_items_dto.g.dart';

/// AdminMenuGroupItemsDto
///
/// Properties:
/// * [itemIds] - Every item the group is linked to.
@BuiltValue()
abstract class AdminMenuGroupItemsDto
    implements Built<AdminMenuGroupItemsDto, AdminMenuGroupItemsDtoBuilder> {
  /// Every item the group is linked to.
  @BuiltValueField(wireName: r'itemIds')
  BuiltList<String> get itemIds;

  AdminMenuGroupItemsDto._();

  factory AdminMenuGroupItemsDto([
    void updates(AdminMenuGroupItemsDtoBuilder b),
  ]) = _$AdminMenuGroupItemsDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminMenuGroupItemsDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminMenuGroupItemsDto> get serializer =>
      _$AdminMenuGroupItemsDtoSerializer();
}

class _$AdminMenuGroupItemsDtoSerializer
    implements PrimitiveSerializer<AdminMenuGroupItemsDto> {
  @override
  final Iterable<Type> types = const [
    AdminMenuGroupItemsDto,
    _$AdminMenuGroupItemsDto,
  ];

  @override
  final String wireName = r'AdminMenuGroupItemsDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminMenuGroupItemsDto object, {
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
    AdminMenuGroupItemsDto object, {
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
    required AdminMenuGroupItemsDtoBuilder result,
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
  AdminMenuGroupItemsDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminMenuGroupItemsDtoBuilder();
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
