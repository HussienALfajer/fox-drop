//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_banners_dto_output_banners_inner.g.dart';

/// AdminBannersDtoOutputBannersInner
///
/// Properties:
/// * [id]
/// * [title]
/// * [imageKey] - In public-media, 1200×500 (architecture §5.8).
/// * [target] - `restaurant` opens its page (restaurantIds holds it), `category` its category page, `restaurants` the banner’s own list under its title (restaurantIds in order), `code` «أكوادي» on that code.
/// * [restaurantIds]
/// * [categoryId]
/// * [codeId]
/// * [code] - The code target's code; null otherwise.
/// * [zoneIds] - None: every zone of the city.
/// * [startsAt]
/// * [endsAt]
@BuiltValue()
abstract class AdminBannersDtoOutputBannersInner
    implements
        Built<
          AdminBannersDtoOutputBannersInner,
          AdminBannersDtoOutputBannersInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'title')
  String get title;

  /// In public-media, 1200×500 (architecture §5.8).
  @BuiltValueField(wireName: r'imageKey')
  String get imageKey;

  /// `restaurant` opens its page (restaurantIds holds it), `category` its category page, `restaurants` the banner’s own list under its title (restaurantIds in order), `code` «أكوادي» on that code.
  @BuiltValueField(wireName: r'target')
  AdminBannersDtoOutputBannersInnerTargetEnum get target;
  // enum targetEnum {  restaurant,  category,  restaurants,  code,  };

  @BuiltValueField(wireName: r'restaurantIds')
  BuiltList<String> get restaurantIds;

  @BuiltValueField(wireName: r'categoryId')
  String? get categoryId;

  @BuiltValueField(wireName: r'codeId')
  String? get codeId;

  /// The code target's code; null otherwise.
  @BuiltValueField(wireName: r'code')
  String? get code;

  /// None: every zone of the city.
  @BuiltValueField(wireName: r'zoneIds')
  BuiltList<String> get zoneIds;

  @BuiltValueField(wireName: r'startsAt')
  DateTime get startsAt;

  @BuiltValueField(wireName: r'endsAt')
  DateTime get endsAt;

  AdminBannersDtoOutputBannersInner._();

  factory AdminBannersDtoOutputBannersInner([
    void updates(AdminBannersDtoOutputBannersInnerBuilder b),
  ]) = _$AdminBannersDtoOutputBannersInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminBannersDtoOutputBannersInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminBannersDtoOutputBannersInner> get serializer =>
      _$AdminBannersDtoOutputBannersInnerSerializer();
}

class _$AdminBannersDtoOutputBannersInnerSerializer
    implements PrimitiveSerializer<AdminBannersDtoOutputBannersInner> {
  @override
  final Iterable<Type> types = const [
    AdminBannersDtoOutputBannersInner,
    _$AdminBannersDtoOutputBannersInner,
  ];

  @override
  final String wireName = r'AdminBannersDtoOutputBannersInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminBannersDtoOutputBannersInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'title';
    yield serializers.serialize(
      object.title,
      specifiedType: const FullType(String),
    );
    yield r'imageKey';
    yield serializers.serialize(
      object.imageKey,
      specifiedType: const FullType(String),
    );
    yield r'target';
    yield serializers.serialize(
      object.target,
      specifiedType: const FullType(
        AdminBannersDtoOutputBannersInnerTargetEnum,
      ),
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
    yield r'code';
    yield object.code == null
        ? null
        : serializers.serialize(
            object.code,
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
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminBannersDtoOutputBannersInner object, {
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
    required AdminBannersDtoOutputBannersInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.id = valueDes;
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
        case r'imageKey':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.imageKey = valueDes;
          break;
        case r'target':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminBannersDtoOutputBannersInnerTargetEnum,
                    ),
                  )
                  as AdminBannersDtoOutputBannersInnerTargetEnum;
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
        case r'code':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.code = valueDes;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminBannersDtoOutputBannersInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminBannersDtoOutputBannersInnerBuilder();
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
class AdminBannersDtoOutputBannersInnerTargetEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'restaurant')
  static const AdminBannersDtoOutputBannersInnerTargetEnum restaurant =
      _$adminBannersDtoOutputBannersInnerTargetEnum_restaurant;
  @BuiltValueEnumConst(wireName: r'category')
  static const AdminBannersDtoOutputBannersInnerTargetEnum category =
      _$adminBannersDtoOutputBannersInnerTargetEnum_category;
  @BuiltValueEnumConst(wireName: r'restaurants')
  static const AdminBannersDtoOutputBannersInnerTargetEnum restaurants =
      _$adminBannersDtoOutputBannersInnerTargetEnum_restaurants;
  @BuiltValueEnumConst(wireName: r'code')
  static const AdminBannersDtoOutputBannersInnerTargetEnum code =
      _$adminBannersDtoOutputBannersInnerTargetEnum_code;

  static Serializer<AdminBannersDtoOutputBannersInnerTargetEnum>
  get serializer => _$adminBannersDtoOutputBannersInnerTargetEnumSerializer;

  const AdminBannersDtoOutputBannersInnerTargetEnum._(String name)
    : super(name);

  static BuiltSet<AdminBannersDtoOutputBannersInnerTargetEnum> get values =>
      _$adminBannersDtoOutputBannersInnerTargetEnumValues;
  static AdminBannersDtoOutputBannersInnerTargetEnum valueOf(String name) =>
      _$adminBannersDtoOutputBannersInnerTargetEnumValueOf(name);
}
