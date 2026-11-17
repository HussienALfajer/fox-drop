//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_upload_dto_output.g.dart';

/// CustomerUploadDtoOutput
///
/// Properties:
/// * [uploadId] - Sent with the report once the file is uploaded.
/// * [url] - A PUT of the exact bytes, with the same Content-Type.
/// * [expiresAt]
@BuiltValue()
abstract class CustomerUploadDtoOutput
    implements Built<CustomerUploadDtoOutput, CustomerUploadDtoOutputBuilder> {
  /// Sent with the report once the file is uploaded.
  @BuiltValueField(wireName: r'uploadId')
  String get uploadId;

  /// A PUT of the exact bytes, with the same Content-Type.
  @BuiltValueField(wireName: r'url')
  String get url;

  @BuiltValueField(wireName: r'expiresAt')
  DateTime get expiresAt;

  CustomerUploadDtoOutput._();

  factory CustomerUploadDtoOutput([
    void updates(CustomerUploadDtoOutputBuilder b),
  ]) = _$CustomerUploadDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerUploadDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerUploadDtoOutput> get serializer =>
      _$CustomerUploadDtoOutputSerializer();
}

class _$CustomerUploadDtoOutputSerializer
    implements PrimitiveSerializer<CustomerUploadDtoOutput> {
  @override
  final Iterable<Type> types = const [
    CustomerUploadDtoOutput,
    _$CustomerUploadDtoOutput,
  ];

  @override
  final String wireName = r'CustomerUploadDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerUploadDtoOutput object, {
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
    CustomerUploadDtoOutput object, {
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
    required CustomerUploadDtoOutputBuilder result,
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
        case r'url':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.url = valueDes;
          break;
        case r'expiresAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
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
  CustomerUploadDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerUploadDtoOutputBuilder();
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
