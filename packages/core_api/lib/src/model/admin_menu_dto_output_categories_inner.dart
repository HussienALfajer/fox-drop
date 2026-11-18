//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_menu_window_output.dart';
import 'package:core_api/src/model/admin_menu_switched_off_output.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_menu_dto_output_categories_inner_items_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_menu_dto_output_categories_inner.g.dart';

/// AdminMenuDtoOutputCategoriesInner
///
/// Properties:
/// * [id]
/// * [name]
/// * [hidden]
/// * [switchedOff] - Its own switch off (RA §9.3); null while on.
/// * [window] - null: all day.
/// * [items]
@BuiltValue()
abstract class AdminMenuDtoOutputCategoriesInner
    implements
        Built<
          AdminMenuDtoOutputCategoriesInner,
          AdminMenuDtoOutputCategoriesInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'hidden')
  bool get hidden;

  /// Its own switch off (RA §9.3); null while on.
  @BuiltValueField(wireName: r'switchedOff')
  AdminMenuSwitchedOffOutput? get switchedOff;

  /// null: all day.
  @BuiltValueField(wireName: r'window')
  AdminMenuWindowOutput? get window;

  @BuiltValueField(wireName: r'items')
  BuiltList<AdminMenuDtoOutputCategoriesInnerItemsInner> get items;

  AdminMenuDtoOutputCategoriesInner._();

  factory AdminMenuDtoOutputCategoriesInner([
    void updates(AdminMenuDtoOutputCategoriesInnerBuilder b),
  ]) = _$AdminMenuDtoOutputCategoriesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminMenuDtoOutputCategoriesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminMenuDtoOutputCategoriesInner> get serializer =>
      _$AdminMenuDtoOutputCategoriesInnerSerializer();
}

class _$AdminMenuDtoOutputCategoriesInnerSerializer
    implements PrimitiveSerializer<AdminMenuDtoOutputCategoriesInner> {
  @override
  final Iterable<Type> types = const [
    AdminMenuDtoOutputCategoriesInner,
    _$AdminMenuDtoOutputCategoriesInner,
  ];

  @override
  final String wireName = r'AdminMenuDtoOutputCategoriesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminMenuDtoOutputCategoriesInner object, {
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
    yield r'switchedOff';
    yield object.switchedOff == null
        ? null
        : serializers.serialize(
            object.switchedOff,
            specifiedType: const FullType.nullable(AdminMenuSwitchedOffOutput),
          );
    yield r'window';
    yield object.window == null
        ? null
        : serializers.serialize(
            object.window,
            specifiedType: const FullType.nullable(AdminMenuWindowOutput),
          );
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminMenuDtoOutputCategoriesInnerItemsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminMenuDtoOutputCategoriesInner object, {
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
    required AdminMenuDtoOutputCategoriesInnerBuilder result,
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
        case r'switchedOff':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminMenuSwitchedOffOutput,
                    ),
                  )
                  as AdminMenuSwitchedOffOutput?;
          if (valueDes == null) continue;
          result.switchedOff.replace(valueDes);
          break;
        case r'window':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminMenuWindowOutput,
                    ),
                  )
                  as AdminMenuWindowOutput?;
          if (valueDes == null) continue;
          result.window.replace(valueDes);
          break;
        case r'items':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminMenuDtoOutputCategoriesInnerItemsInner),
                    ]),
                  )
                  as BuiltList<AdminMenuDtoOutputCategoriesInnerItemsInner>;
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
  AdminMenuDtoOutputCategoriesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminMenuDtoOutputCategoriesInnerBuilder();
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
