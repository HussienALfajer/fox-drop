//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_menu_dto_output_option_groups_inner_options_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_menu_dto_output_option_groups_inner.g.dart';

/// AdminMenuDtoOutputOptionGroupsInner
///
/// Properties:
/// * [id]
/// * [name]
/// * [minChoices] - 0: an add-on group; 1 or more: required.
/// * [maxChoices]
/// * [options]
/// * [itemIds] - The items it is linked to, in menu order.
@BuiltValue()
abstract class AdminMenuDtoOutputOptionGroupsInner
    implements
        Built<
          AdminMenuDtoOutputOptionGroupsInner,
          AdminMenuDtoOutputOptionGroupsInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  /// 0: an add-on group; 1 or more: required.
  @BuiltValueField(wireName: r'minChoices')
  int get minChoices;

  @BuiltValueField(wireName: r'maxChoices')
  int get maxChoices;

  @BuiltValueField(wireName: r'options')
  BuiltList<AdminMenuDtoOutputOptionGroupsInnerOptionsInner> get options;

  /// The items it is linked to, in menu order.
  @BuiltValueField(wireName: r'itemIds')
  BuiltList<String> get itemIds;

  AdminMenuDtoOutputOptionGroupsInner._();

  factory AdminMenuDtoOutputOptionGroupsInner([
    void updates(AdminMenuDtoOutputOptionGroupsInnerBuilder b),
  ]) = _$AdminMenuDtoOutputOptionGroupsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminMenuDtoOutputOptionGroupsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminMenuDtoOutputOptionGroupsInner> get serializer =>
      _$AdminMenuDtoOutputOptionGroupsInnerSerializer();
}

class _$AdminMenuDtoOutputOptionGroupsInnerSerializer
    implements PrimitiveSerializer<AdminMenuDtoOutputOptionGroupsInner> {
  @override
  final Iterable<Type> types = const [
    AdminMenuDtoOutputOptionGroupsInner,
    _$AdminMenuDtoOutputOptionGroupsInner,
  ];

  @override
  final String wireName = r'AdminMenuDtoOutputOptionGroupsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminMenuDtoOutputOptionGroupsInner object, {
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
    yield r'minChoices';
    yield serializers.serialize(
      object.minChoices,
      specifiedType: const FullType(int),
    );
    yield r'maxChoices';
    yield serializers.serialize(
      object.maxChoices,
      specifiedType: const FullType(int),
    );
    yield r'options';
    yield serializers.serialize(
      object.options,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminMenuDtoOutputOptionGroupsInnerOptionsInner),
      ]),
    );
    yield r'itemIds';
    yield serializers.serialize(
      object.itemIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminMenuDtoOutputOptionGroupsInner object, {
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
    required AdminMenuDtoOutputOptionGroupsInnerBuilder result,
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
        case r'minChoices':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.minChoices = valueDes;
          break;
        case r'maxChoices':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.maxChoices = valueDes;
          break;
        case r'options':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminMenuDtoOutputOptionGroupsInnerOptionsInner),
                    ]),
                  )
                  as BuiltList<AdminMenuDtoOutputOptionGroupsInnerOptionsInner>;
          result.options.replace(valueDes);
          break;
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
  AdminMenuDtoOutputOptionGroupsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminMenuDtoOutputOptionGroupsInnerBuilder();
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
