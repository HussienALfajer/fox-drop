//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_category_image_dto.g.dart';

/// AdminCategoryImageDto
///
/// Properties:
/// * [uploadId] - From POST /v1/admin/uploads (category_image).
@BuiltValue()
abstract class AdminCategoryImageDto
    implements Built<AdminCategoryImageDto, AdminCategoryImageDtoBuilder> {
  /// From POST /v1/admin/uploads (category_image).
  @BuiltValueField(wireName: r'uploadId')
  String get uploadId;

  AdminCategoryImageDto._();

  factory AdminCategoryImageDto([
    void updates(AdminCategoryImageDtoBuilder b),
  ]) = _$AdminCategoryImageDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCategoryImageDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCategoryImageDto> get serializer =>
      _$AdminCategoryImageDtoSerializer();
}

class _$AdminCategoryImageDtoSerializer
    implements PrimitiveSerializer<AdminCategoryImageDto> {
  @override
  final Iterable<Type> types = const [
    AdminCategoryImageDto,
    _$AdminCategoryImageDto,
  ];

  @override
  final String wireName = r'AdminCategoryImageDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCategoryImageDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'uploadId';
    yield serializers.serialize(
      object.uploadId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCategoryImageDto object, {
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
    required AdminCategoryImageDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'uploadId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.uploadId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCategoryImageDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCategoryImageDtoBuilder();
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
