//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_new_upload_dto.g.dart';

/// AdminNewUploadDto
///
/// Properties:
/// * [purpose] - The record the file is for (architecture §5.8).
/// * [contentType]
/// * [sizeBytes]
@BuiltValue()
abstract class AdminNewUploadDto
    implements Built<AdminNewUploadDto, AdminNewUploadDtoBuilder> {
  /// The record the file is for (architecture §5.8).
  @BuiltValueField(wireName: r'purpose')
  AdminNewUploadDtoPurposeEnum get purpose;
  // enum purposeEnum {  restaurant_logo,  restaurant_cover,  item_photo,  };

  @BuiltValueField(wireName: r'contentType')
  AdminNewUploadDtoContentTypeEnum get contentType;
  // enum contentTypeEnum {  image/jpeg,  image/png,  image/webp,  };

  @BuiltValueField(wireName: r'sizeBytes')
  int get sizeBytes;

  AdminNewUploadDto._();

  factory AdminNewUploadDto([void updates(AdminNewUploadDtoBuilder b)]) =
      _$AdminNewUploadDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminNewUploadDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminNewUploadDto> get serializer =>
      _$AdminNewUploadDtoSerializer();
}

class _$AdminNewUploadDtoSerializer
    implements PrimitiveSerializer<AdminNewUploadDto> {
  @override
  final Iterable<Type> types = const [AdminNewUploadDto, _$AdminNewUploadDto];

  @override
  final String wireName = r'AdminNewUploadDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminNewUploadDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'purpose';
    yield serializers.serialize(
      object.purpose,
      specifiedType: const FullType(AdminNewUploadDtoPurposeEnum),
    );
    yield r'contentType';
    yield serializers.serialize(
      object.contentType,
      specifiedType: const FullType(AdminNewUploadDtoContentTypeEnum),
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
    AdminNewUploadDto object, {
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
    required AdminNewUploadDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'purpose':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(AdminNewUploadDtoPurposeEnum),
                  )
                  as AdminNewUploadDtoPurposeEnum;
          result.purpose = valueDes;
          break;
        case r'contentType':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminNewUploadDtoContentTypeEnum,
                    ),
                  )
                  as AdminNewUploadDtoContentTypeEnum;
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
  AdminNewUploadDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminNewUploadDtoBuilder();
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

/// The record the file is for (architecture §5.8).
class AdminNewUploadDtoPurposeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'restaurant_logo')
  static const AdminNewUploadDtoPurposeEnum restaurantLogo =
      _$adminNewUploadDtoPurposeEnum_restaurantLogo;
  @BuiltValueEnumConst(wireName: r'restaurant_cover')
  static const AdminNewUploadDtoPurposeEnum restaurantCover =
      _$adminNewUploadDtoPurposeEnum_restaurantCover;
  @BuiltValueEnumConst(wireName: r'item_photo')
  static const AdminNewUploadDtoPurposeEnum itemPhoto =
      _$adminNewUploadDtoPurposeEnum_itemPhoto;

  static Serializer<AdminNewUploadDtoPurposeEnum> get serializer =>
      _$adminNewUploadDtoPurposeEnumSerializer;

  const AdminNewUploadDtoPurposeEnum._(String name) : super(name);

  static BuiltSet<AdminNewUploadDtoPurposeEnum> get values =>
      _$adminNewUploadDtoPurposeEnumValues;
  static AdminNewUploadDtoPurposeEnum valueOf(String name) =>
      _$adminNewUploadDtoPurposeEnumValueOf(name);
}

class AdminNewUploadDtoContentTypeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'image/jpeg')
  static const AdminNewUploadDtoContentTypeEnum imageSlashJpeg =
      _$adminNewUploadDtoContentTypeEnum_imageSlashJpeg;
  @BuiltValueEnumConst(wireName: r'image/png')
  static const AdminNewUploadDtoContentTypeEnum imageSlashPng =
      _$adminNewUploadDtoContentTypeEnum_imageSlashPng;
  @BuiltValueEnumConst(wireName: r'image/webp')
  static const AdminNewUploadDtoContentTypeEnum imageSlashWebp =
      _$adminNewUploadDtoContentTypeEnum_imageSlashWebp;

  static Serializer<AdminNewUploadDtoContentTypeEnum> get serializer =>
      _$adminNewUploadDtoContentTypeEnumSerializer;

  const AdminNewUploadDtoContentTypeEnum._(String name) : super(name);

  static BuiltSet<AdminNewUploadDtoContentTypeEnum> get values =>
      _$adminNewUploadDtoContentTypeEnumValues;
  static AdminNewUploadDtoContentTypeEnum valueOf(String name) =>
      _$adminNewUploadDtoContentTypeEnumValueOf(name);
}
