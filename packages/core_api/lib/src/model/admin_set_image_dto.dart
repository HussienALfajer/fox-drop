//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_set_image_dto.g.dart';

/// AdminSetImageDto
///
/// Properties:
/// * [uploadId] - From POST /v1/admin/uploads, once the PUT is done.
@BuiltValue()
abstract class AdminSetImageDto implements Built<AdminSetImageDto, AdminSetImageDtoBuilder> {
  /// From POST /v1/admin/uploads, once the PUT is done.
  @BuiltValueField(wireName: r'uploadId')
  String get uploadId;

  AdminSetImageDto._();

  factory AdminSetImageDto([void updates(AdminSetImageDtoBuilder b)]) = _$AdminSetImageDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSetImageDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSetImageDto> get serializer => _$AdminSetImageDtoSerializer();
}

class _$AdminSetImageDtoSerializer implements PrimitiveSerializer<AdminSetImageDto> {
  @override
  final Iterable<Type> types = const [AdminSetImageDto, _$AdminSetImageDto];

  @override
  final String wireName = r'AdminSetImageDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSetImageDto object, {
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
    AdminSetImageDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminSetImageDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'uploadId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
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
  AdminSetImageDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSetImageDtoBuilder();
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


