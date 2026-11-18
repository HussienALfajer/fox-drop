//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_new_category_dto.g.dart';

/// AdminNewCategoryDto
///
/// Properties:
/// * [name]
@BuiltValue()
abstract class AdminNewCategoryDto
    implements Built<AdminNewCategoryDto, AdminNewCategoryDtoBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  AdminNewCategoryDto._();

  factory AdminNewCategoryDto([void updates(AdminNewCategoryDtoBuilder b)]) =
      _$AdminNewCategoryDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminNewCategoryDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminNewCategoryDto> get serializer =>
      _$AdminNewCategoryDtoSerializer();
}

class _$AdminNewCategoryDtoSerializer
    implements PrimitiveSerializer<AdminNewCategoryDto> {
  @override
  final Iterable<Type> types = const [
    AdminNewCategoryDto,
    _$AdminNewCategoryDto,
  ];

  @override
  final String wireName = r'AdminNewCategoryDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminNewCategoryDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminNewCategoryDto object, {
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
    required AdminNewCategoryDtoBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminNewCategoryDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminNewCategoryDtoBuilder();
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
