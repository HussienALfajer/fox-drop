//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_update_category_dto.g.dart';

/// AdminUpdateCategoryDto
///
/// Properties:
/// * [name]
/// * [active] - False removes it.
@BuiltValue()
abstract class AdminUpdateCategoryDto
    implements Built<AdminUpdateCategoryDto, AdminUpdateCategoryDtoBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  /// False removes it.
  @BuiltValueField(wireName: r'active')
  bool get active;

  AdminUpdateCategoryDto._();

  factory AdminUpdateCategoryDto([
    void updates(AdminUpdateCategoryDtoBuilder b),
  ]) = _$AdminUpdateCategoryDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminUpdateCategoryDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminUpdateCategoryDto> get serializer =>
      _$AdminUpdateCategoryDtoSerializer();
}

class _$AdminUpdateCategoryDtoSerializer
    implements PrimitiveSerializer<AdminUpdateCategoryDto> {
  @override
  final Iterable<Type> types = const [
    AdminUpdateCategoryDto,
    _$AdminUpdateCategoryDto,
  ];

  @override
  final String wireName = r'AdminUpdateCategoryDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminUpdateCategoryDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'active';
    yield serializers.serialize(
      object.active,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminUpdateCategoryDto object, {
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
    required AdminUpdateCategoryDtoBuilder result,
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
        case r'active':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.active = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminUpdateCategoryDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminUpdateCategoryDtoBuilder();
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
