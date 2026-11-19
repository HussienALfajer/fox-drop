//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_new_upload_dto.g.dart';

/// MerchantNewUploadDto
///
/// Properties:
/// * [contentType]
/// * [sizeBytes]
@BuiltValue()
abstract class MerchantNewUploadDto
    implements Built<MerchantNewUploadDto, MerchantNewUploadDtoBuilder> {
  @BuiltValueField(wireName: r'contentType')
  MerchantNewUploadDtoContentTypeEnum get contentType;
  // enum contentTypeEnum {  image/jpeg,  image/png,  image/webp,  };

  @BuiltValueField(wireName: r'sizeBytes')
  int get sizeBytes;

  MerchantNewUploadDto._();

  factory MerchantNewUploadDto([void updates(MerchantNewUploadDtoBuilder b)]) =
      _$MerchantNewUploadDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantNewUploadDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantNewUploadDto> get serializer =>
      _$MerchantNewUploadDtoSerializer();
}

class _$MerchantNewUploadDtoSerializer
    implements PrimitiveSerializer<MerchantNewUploadDto> {
  @override
  final Iterable<Type> types = const [
    MerchantNewUploadDto,
    _$MerchantNewUploadDto,
  ];

  @override
  final String wireName = r'MerchantNewUploadDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantNewUploadDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'contentType';
    yield serializers.serialize(
      object.contentType,
      specifiedType: const FullType(MerchantNewUploadDtoContentTypeEnum),
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
    MerchantNewUploadDto object, {
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
    required MerchantNewUploadDtoBuilder result,
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
                      MerchantNewUploadDtoContentTypeEnum,
                    ),
                  )
                  as MerchantNewUploadDtoContentTypeEnum;
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
  MerchantNewUploadDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantNewUploadDtoBuilder();
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

class MerchantNewUploadDtoContentTypeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'image/jpeg')
  static const MerchantNewUploadDtoContentTypeEnum imageSlashJpeg =
      _$merchantNewUploadDtoContentTypeEnum_imageSlashJpeg;
  @BuiltValueEnumConst(wireName: r'image/png')
  static const MerchantNewUploadDtoContentTypeEnum imageSlashPng =
      _$merchantNewUploadDtoContentTypeEnum_imageSlashPng;
  @BuiltValueEnumConst(wireName: r'image/webp')
  static const MerchantNewUploadDtoContentTypeEnum imageSlashWebp =
      _$merchantNewUploadDtoContentTypeEnum_imageSlashWebp;

  static Serializer<MerchantNewUploadDtoContentTypeEnum> get serializer =>
      _$merchantNewUploadDtoContentTypeEnumSerializer;

  const MerchantNewUploadDtoContentTypeEnum._(String name) : super(name);

  static BuiltSet<MerchantNewUploadDtoContentTypeEnum> get values =>
      _$merchantNewUploadDtoContentTypeEnumValues;
  static MerchantNewUploadDtoContentTypeEnum valueOf(String name) =>
      _$merchantNewUploadDtoContentTypeEnumValueOf(name);
}
