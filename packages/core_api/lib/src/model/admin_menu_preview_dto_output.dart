//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_menu_preview_dto_output_menu_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_menu_preview_dto_output.g.dart';

/// AdminMenuPreviewDtoOutput
///
/// Properties:
/// * [menu] - The restaurant page's menu (CU §9.3): hidden rows left out.
@BuiltValue()
abstract class AdminMenuPreviewDtoOutput
    implements
        Built<AdminMenuPreviewDtoOutput, AdminMenuPreviewDtoOutputBuilder> {
  /// The restaurant page's menu (CU §9.3): hidden rows left out.
  @BuiltValueField(wireName: r'menu')
  BuiltList<AdminMenuPreviewDtoOutputMenuInner> get menu;

  AdminMenuPreviewDtoOutput._();

  factory AdminMenuPreviewDtoOutput([
    void updates(AdminMenuPreviewDtoOutputBuilder b),
  ]) = _$AdminMenuPreviewDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminMenuPreviewDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminMenuPreviewDtoOutput> get serializer =>
      _$AdminMenuPreviewDtoOutputSerializer();
}

class _$AdminMenuPreviewDtoOutputSerializer
    implements PrimitiveSerializer<AdminMenuPreviewDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminMenuPreviewDtoOutput,
    _$AdminMenuPreviewDtoOutput,
  ];

  @override
  final String wireName = r'AdminMenuPreviewDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminMenuPreviewDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'menu';
    yield serializers.serialize(
      object.menu,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminMenuPreviewDtoOutputMenuInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminMenuPreviewDtoOutput object, {
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
    required AdminMenuPreviewDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'menu':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminMenuPreviewDtoOutputMenuInner),
                    ]),
                  )
                  as BuiltList<AdminMenuPreviewDtoOutputMenuInner>;
          result.menu.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminMenuPreviewDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminMenuPreviewDtoOutputBuilder();
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
