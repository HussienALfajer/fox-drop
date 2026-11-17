//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_new_upload_dto.g.dart';

/// CustomerNewUploadDto
///
/// Properties:
/// * [contentType]
/// * [sizeBytes]
@BuiltValue()
abstract class CustomerNewUploadDto
    implements Built<CustomerNewUploadDto, CustomerNewUploadDtoBuilder> {
  @BuiltValueField(wireName: r'contentType')
  CustomerNewUploadDtoContentTypeEnum get contentType;
  // enum contentTypeEnum {  image/jpeg,  image/png,  image/webp,  };

  @BuiltValueField(wireName: r'sizeBytes')
  int get sizeBytes;

  CustomerNewUploadDto._();

  factory CustomerNewUploadDto([void updates(CustomerNewUploadDtoBuilder b)]) =
      _$CustomerNewUploadDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerNewUploadDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerNewUploadDto> get serializer =>
      _$CustomerNewUploadDtoSerializer();
}

class _$CustomerNewUploadDtoSerializer
    implements PrimitiveSerializer<CustomerNewUploadDto> {
  @override
  final Iterable<Type> types = const [
    CustomerNewUploadDto,
    _$CustomerNewUploadDto,
  ];

  @override
  final String wireName = r'CustomerNewUploadDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerNewUploadDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'contentType';
    yield serializers.serialize(
      object.contentType,
      specifiedType: const FullType(CustomerNewUploadDtoContentTypeEnum),
    );
    yield r'sizeBytes';
    yield serializers.serialize(
      object.sizeBytes,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerNewUploadDto object, {
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
    required CustomerNewUploadDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'contentType':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CustomerNewUploadDtoContentTypeEnum,
                    ),
                  )
                  as CustomerNewUploadDtoContentTypeEnum;
          result.contentType = valueDes;
          break;
        case r'sizeBytes':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.sizeBytes = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerNewUploadDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerNewUploadDtoBuilder();
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

class CustomerNewUploadDtoContentTypeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'image/jpeg')
  static const CustomerNewUploadDtoContentTypeEnum imageSlashJpeg =
      _$customerNewUploadDtoContentTypeEnum_imageSlashJpeg;
  @BuiltValueEnumConst(wireName: r'image/png')
  static const CustomerNewUploadDtoContentTypeEnum imageSlashPng =
      _$customerNewUploadDtoContentTypeEnum_imageSlashPng;
  @BuiltValueEnumConst(wireName: r'image/webp')
  static const CustomerNewUploadDtoContentTypeEnum imageSlashWebp =
      _$customerNewUploadDtoContentTypeEnum_imageSlashWebp;

  static Serializer<CustomerNewUploadDtoContentTypeEnum> get serializer =>
      _$customerNewUploadDtoContentTypeEnumSerializer;

  const CustomerNewUploadDtoContentTypeEnum._(String name) : super(name);

  static BuiltSet<CustomerNewUploadDtoContentTypeEnum> get values =>
      _$customerNewUploadDtoContentTypeEnumValues;
  static CustomerNewUploadDtoContentTypeEnum valueOf(String name) =>
      _$customerNewUploadDtoContentTypeEnumValueOf(name);
}
