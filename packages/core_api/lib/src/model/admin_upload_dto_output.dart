//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_upload_dto_output.g.dart';

/// AdminUploadDtoOutput
///
/// Properties:
/// * [uploadId] - Links the file once uploaded (the record’s own route).
/// * [url] - A PUT of the exact bytes, with the same Content-Type, on the panel’s own origin.
/// * [expiresAt] 
@BuiltValue()
abstract class AdminUploadDtoOutput implements Built<AdminUploadDtoOutput, AdminUploadDtoOutputBuilder> {
  /// Links the file once uploaded (the record’s own route).
  @BuiltValueField(wireName: r'uploadId')
  String get uploadId;

  /// A PUT of the exact bytes, with the same Content-Type, on the panel’s own origin.
  @BuiltValueField(wireName: r'url')
  String get url;

  @BuiltValueField(wireName: r'expiresAt')
  DateTime get expiresAt;

  AdminUploadDtoOutput._();

  factory AdminUploadDtoOutput([void updates(AdminUploadDtoOutputBuilder b)]) = _$AdminUploadDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminUploadDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminUploadDtoOutput> get serializer => _$AdminUploadDtoOutputSerializer();
}

class _$AdminUploadDtoOutputSerializer implements PrimitiveSerializer<AdminUploadDtoOutput> {
  @override
  final Iterable<Type> types = const [AdminUploadDtoOutput, _$AdminUploadDtoOutput];

  @override
  final String wireName = r'AdminUploadDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminUploadDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'uploadId';
    yield serializers.serialize(
      object.uploadId,
      specifiedType: const FullType(String),
    );
    yield r'url';
    yield serializers.serialize(
      object.url,
      specifiedType: const FullType(String),
    );
    yield r'expiresAt';
    yield serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminUploadDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminUploadDtoOutputBuilder result,
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
        case r'url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.url = valueDes;
          break;
        case r'expiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.expiresAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminUploadDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminUploadDtoOutputBuilder();
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


