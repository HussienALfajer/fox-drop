//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_new_banner_dto.g.dart';

/// AdminNewBannerDto
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
/// * [uploadId] - From POST /v1/admin/uploads (banner_image), cut to exactly 1200×500.
@BuiltValue()
abstract class AdminNewBannerDto
    implements Built<AdminNewBannerDto, AdminNewBannerDtoBuilder> {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  /// Trimmed, 1 to 60 characters.
  @BuiltValueField(wireName: r'title')
  String get title;

  /// `restaurant` opens its page (restaurantIds holds it), `category` its category page, `restaurants` the banner’s own list under its title (restaurantIds in order), `code` «أكوادي» on that code.
  @BuiltValueField(wireName: r'target')
  AdminNewBannerDtoTargetEnum get target;
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

  /// From POST /v1/admin/uploads (banner_image), cut to exactly 1200×500.
  @BuiltValueField(wireName: r'uploadId')
  String get uploadId;

  AdminNewBannerDto._();

  factory AdminNewBannerDto([void updates(AdminNewBannerDtoBuilder b)]) =
      _$AdminNewBannerDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminNewBannerDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminNewBannerDto> get serializer =>
      _$AdminNewBannerDtoSerializer();
}

class _$AdminNewBannerDtoSerializer
    implements PrimitiveSerializer<AdminNewBannerDto> {
  @override
  final Iterable<Type> types = const [AdminNewBannerDto, _$AdminNewBannerDto];

  @override
  final String wireName = r'AdminNewBannerDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminNewBannerDto object, {
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
      specifiedType: const FullType(AdminNewBannerDtoTargetEnum),
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
    yield serializers.serialize(
      object.uploadId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminNewBannerDto object, {
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
    required AdminNewBannerDtoBuilder result,
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
                    specifiedType: const FullType(AdminNewBannerDtoTargetEnum),
                  )
                  as AdminNewBannerDtoTargetEnum;
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
  AdminNewBannerDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminNewBannerDtoBuilder();
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
class AdminNewBannerDtoTargetEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'restaurant')
  static const AdminNewBannerDtoTargetEnum restaurant =
      _$adminNewBannerDtoTargetEnum_restaurant;
  @BuiltValueEnumConst(wireName: r'category')
  static const AdminNewBannerDtoTargetEnum category =
      _$adminNewBannerDtoTargetEnum_category;
  @BuiltValueEnumConst(wireName: r'restaurants')
  static const AdminNewBannerDtoTargetEnum restaurants =
      _$adminNewBannerDtoTargetEnum_restaurants;
  @BuiltValueEnumConst(wireName: r'code')
  static const AdminNewBannerDtoTargetEnum code =
      _$adminNewBannerDtoTargetEnum_code;

  static Serializer<AdminNewBannerDtoTargetEnum> get serializer =>
      _$adminNewBannerDtoTargetEnumSerializer;

  const AdminNewBannerDtoTargetEnum._(String name) : super(name);

  static BuiltSet<AdminNewBannerDtoTargetEnum> get values =>
      _$adminNewBannerDtoTargetEnumValues;
  static AdminNewBannerDtoTargetEnum valueOf(String name) =>
      _$adminNewBannerDtoTargetEnumValueOf(name);
}
