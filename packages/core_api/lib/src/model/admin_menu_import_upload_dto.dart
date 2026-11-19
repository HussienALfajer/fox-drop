//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_menu_import_upload_dto.g.dart';

/// AdminMenuImportUploadDto
///
/// Properties:
/// * [uploadId] - A menu_import upload of POST /v1/admin/uploads.
@BuiltValue()
abstract class AdminMenuImportUploadDto
    implements
        Built<AdminMenuImportUploadDto, AdminMenuImportUploadDtoBuilder> {
  /// A menu_import upload of POST /v1/admin/uploads.
  @BuiltValueField(wireName: r'uploadId')
  String get uploadId;

  AdminMenuImportUploadDto._();

  factory AdminMenuImportUploadDto([
    void updates(AdminMenuImportUploadDtoBuilder b),
  ]) = _$AdminMenuImportUploadDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminMenuImportUploadDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminMenuImportUploadDto> get serializer =>
      _$AdminMenuImportUploadDtoSerializer();
}

class _$AdminMenuImportUploadDtoSerializer
    implements PrimitiveSerializer<AdminMenuImportUploadDto> {
  @override
  final Iterable<Type> types = const [
    AdminMenuImportUploadDto,
    _$AdminMenuImportUploadDto,
  ];

  @override
  final String wireName = r'AdminMenuImportUploadDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminMenuImportUploadDto object, {
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
    AdminMenuImportUploadDto object, {
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
    required AdminMenuImportUploadDtoBuilder result,
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
  AdminMenuImportUploadDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminMenuImportUploadDtoBuilder();
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
