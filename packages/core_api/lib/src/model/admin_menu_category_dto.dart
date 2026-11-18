//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_menu_window.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_menu_category_dto.g.dart';

/// AdminMenuCategoryDto
///
/// Properties:
/// * [name]
/// * [hidden]
/// * [window] - «متوفر من … إلى …»; null all day.
@BuiltValue()
abstract class AdminMenuCategoryDto
    implements Built<AdminMenuCategoryDto, AdminMenuCategoryDtoBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'hidden')
  bool get hidden;

  /// «متوفر من … إلى …»; null all day.
  @BuiltValueField(wireName: r'window')
  AdminMenuWindow? get window;

  AdminMenuCategoryDto._();

  factory AdminMenuCategoryDto([void updates(AdminMenuCategoryDtoBuilder b)]) =
      _$AdminMenuCategoryDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminMenuCategoryDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminMenuCategoryDto> get serializer =>
      _$AdminMenuCategoryDtoSerializer();
}

class _$AdminMenuCategoryDtoSerializer
    implements PrimitiveSerializer<AdminMenuCategoryDto> {
  @override
  final Iterable<Type> types = const [
    AdminMenuCategoryDto,
    _$AdminMenuCategoryDto,
  ];

  @override
  final String wireName = r'AdminMenuCategoryDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminMenuCategoryDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    yield r'window';
    yield object.window == null
        ? null
        : serializers.serialize(
            object.window,
            specifiedType: const FullType.nullable(AdminMenuWindow),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminMenuCategoryDto object, {
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
    required AdminMenuCategoryDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        case r'window':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(AdminMenuWindow),
                  )
                  as AdminMenuWindow?;
          if (valueDes == null) continue;
          result.window.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminMenuCategoryDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminMenuCategoryDtoBuilder();
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
