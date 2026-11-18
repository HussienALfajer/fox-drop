//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_update_banner_dto.g.dart';

/// AdminUpdateBannerDto
///
/// Properties:
/// * [cityId]
/// * [title] - Trimmed, 1 to 60 characters.
/// * [target] - `restaurant` opens its page (restaurantIds holds it), `category` its category page, `restaurants` the banner’s own list under its title (restaurantIds in order), `code` «أكوادي» on that code.
/// * [restaurantIds] - One for `restaurant`, 1 to 30 for `restaurants`.
/// * [categoryId]
/// * [codeId]
/// * [zoneIds] - The city's zones; none for all.
/// * [startsAt]
/// * [endsAt] - After the start and after now.
/// * [uploadId] - A new image (banner_image); null keeps the image.
@BuiltValue()
abstract class AdminUpdateBannerDto
    implements Built<AdminUpdateBannerDto, AdminUpdateBannerDtoBuilder> {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  /// Trimmed, 1 to 60 characters.
  @BuiltValueField(wireName: r'title')
  String get title;

  /// `restaurant` opens its page (restaurantIds holds it), `category` its category page, `restaurants` the banner’s own list under its title (restaurantIds in order), `code` «أكوادي» on that code.
  @BuiltValueField(wireName: r'target')
  AdminUpdateBannerDtoTargetEnum get target;
  // enum targetEnum {  restaurant,  category,  restaurants,  code,  };

  /// One for `restaurant`, 1 to 30 for `restaurants`.
  @BuiltValueField(wireName: r'restaurantIds')
  BuiltList<String> get restaurantIds;

  @BuiltValueField(wireName: r'categoryId')
  String? get categoryId;

  @BuiltValueField(wireName: r'codeId')
  String? get codeId;

  /// The city's zones; none for all.
  @BuiltValueField(wireName: r'zoneIds')
  BuiltList<String> get zoneIds;

  @BuiltValueField(wireName: r'startsAt')
  DateTime get startsAt;

  /// After the start and after now.
  @BuiltValueField(wireName: r'endsAt')
  DateTime get endsAt;

  /// A new image (banner_image); null keeps the image.
  @BuiltValueField(wireName: r'uploadId')
  String? get uploadId;

  AdminUpdateBannerDto._();

  factory AdminUpdateBannerDto([void updates(AdminUpdateBannerDtoBuilder b)]) =
      _$AdminUpdateBannerDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminUpdateBannerDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminUpdateBannerDto> get serializer =>
      _$AdminUpdateBannerDtoSerializer();
}

class _$AdminUpdateBannerDtoSerializer
    implements PrimitiveSerializer<AdminUpdateBannerDto> {
  @override
  final Iterable<Type> types = const [
    AdminUpdateBannerDto,
    _$AdminUpdateBannerDto,
  ];

  @override
  final String wireName = r'AdminUpdateBannerDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminUpdateBannerDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
    yield r'title';
    yield serializers.serialize(
      object.title,
      specifiedType: const FullType(String),
    );
    yield r'target';
    yield serializers.serialize(
      object.target,
      specifiedType: const FullType(AdminUpdateBannerDtoTargetEnum),
    );
    yield r'restaurantIds';
    yield serializers.serialize(
      object.restaurantIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'categoryId';
    yield object.categoryId == null
        ? null
        : serializers.serialize(
            object.categoryId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'codeId';
    yield object.codeId == null
        ? null
        : serializers.serialize(
            object.codeId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'zoneIds';
    yield serializers.serialize(
      object.zoneIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'startsAt';
    yield serializers.serialize(
      object.startsAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'endsAt';
    yield serializers.serialize(
      object.endsAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'uploadId';
    yield object.uploadId == null
        ? null
        : serializers.serialize(
            object.uploadId,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminUpdateBannerDto object, {
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
    required AdminUpdateBannerDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'cityId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.cityId = valueDes;
          break;
        case r'title':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.title = valueDes;
          break;
        case r'target':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminUpdateBannerDtoTargetEnum,
                    ),
                  )
                  as AdminUpdateBannerDtoTargetEnum;
          result.target = valueDes;
          break;
        case r'restaurantIds':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.restaurantIds.replace(valueDes);
          break;
        case r'categoryId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.categoryId = valueDes;
          break;
        case r'codeId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.codeId = valueDes;
          break;
        case r'zoneIds':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.zoneIds.replace(valueDes);
          break;
        case r'startsAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.startsAt = valueDes;
          break;
        case r'endsAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.endsAt = valueDes;
          break;
        case r'uploadId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
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
  AdminUpdateBannerDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminUpdateBannerDtoBuilder();
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

/// `restaurant` opens its page (restaurantIds holds it), `category` its category page, `restaurants` the banner’s own list under its title (restaurantIds in order), `code` «أكوادي» on that code.
class AdminUpdateBannerDtoTargetEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'restaurant')
  static const AdminUpdateBannerDtoTargetEnum restaurant =
      _$adminUpdateBannerDtoTargetEnum_restaurant;
  @BuiltValueEnumConst(wireName: r'category')
  static const AdminUpdateBannerDtoTargetEnum category =
      _$adminUpdateBannerDtoTargetEnum_category;
  @BuiltValueEnumConst(wireName: r'restaurants')
  static const AdminUpdateBannerDtoTargetEnum restaurants =
      _$adminUpdateBannerDtoTargetEnum_restaurants;
  @BuiltValueEnumConst(wireName: r'code')
  static const AdminUpdateBannerDtoTargetEnum code =
      _$adminUpdateBannerDtoTargetEnum_code;

  static Serializer<AdminUpdateBannerDtoTargetEnum> get serializer =>
      _$adminUpdateBannerDtoTargetEnumSerializer;

  const AdminUpdateBannerDtoTargetEnum._(String name) : super(name);

  static BuiltSet<AdminUpdateBannerDtoTargetEnum> get values =>
      _$adminUpdateBannerDtoTargetEnumValues;
  static AdminUpdateBannerDtoTargetEnum valueOf(String name) =>
      _$adminUpdateBannerDtoTargetEnumValueOf(name);
}
