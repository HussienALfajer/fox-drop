//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_menu_item_groups_dto.g.dart';

/// AdminMenuItemGroupsDto
///
/// Properties:
/// * [groupIds] - The item's groups, in order.
@BuiltValue()
abstract class AdminMenuItemGroupsDto
    implements Built<AdminMenuItemGroupsDto, AdminMenuItemGroupsDtoBuilder> {
  /// The item's groups, in order.
  @BuiltValueField(wireName: r'groupIds')
  BuiltList<String> get groupIds;

  AdminMenuItemGroupsDto._();

  factory AdminMenuItemGroupsDto([
    void updates(AdminMenuItemGroupsDtoBuilder b),
  ]) = _$AdminMenuItemGroupsDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminMenuItemGroupsDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminMenuItemGroupsDto> get serializer =>
      _$AdminMenuItemGroupsDtoSerializer();
}

class _$AdminMenuItemGroupsDtoSerializer
    implements PrimitiveSerializer<AdminMenuItemGroupsDto> {
  @override
  final Iterable<Type> types = const [
    AdminMenuItemGroupsDto,
    _$AdminMenuItemGroupsDto,
  ];

  @override
  final String wireName = r'AdminMenuItemGroupsDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminMenuItemGroupsDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'groupIds';
    yield serializers.serialize(
      object.groupIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminMenuItemGroupsDto object, {
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
    required AdminMenuItemGroupsDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'groupIds':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.groupIds.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminMenuItemGroupsDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminMenuItemGroupsDtoBuilder();
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
