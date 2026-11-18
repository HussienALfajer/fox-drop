//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_new_mass_push_dto.g.dart';

/// AdminNewMassPushDto
///
/// Properties:
/// * [cityId]
/// * [title] - Trimmed, 1 to 50 characters.
/// * [body] - Trimmed, 1 to 200 characters.
/// * [audience] - `all` every registered customer; `zone` those with a saved address in zoneId; `inactive` those whose latest delivered order in the city is older than inactiveDays; `never_ordered` registered with no delivered order in the city.
/// * [zoneId]
/// * [inactiveDays] - 1 to 365.
/// * [target] - `home` the home screen; `restaurant` its page (restaurantId); `code` «أكوادي» on that code (codeId).
/// * [restaurantId]
/// * [codeId]
/// * [sendAt] - Null: now; else ahead, at most 30 days.
/// * [audienceSize] - The size the panel showed and the admin confirmed (GET …/audience).
@BuiltValue()
abstract class AdminNewMassPushDto
    implements Built<AdminNewMassPushDto, AdminNewMassPushDtoBuilder> {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  /// Trimmed, 1 to 50 characters.
  @BuiltValueField(wireName: r'title')
  String get title;

  /// Trimmed, 1 to 200 characters.
  @BuiltValueField(wireName: r'body')
  String get body;

  /// `all` every registered customer; `zone` those with a saved address in zoneId; `inactive` those whose latest delivered order in the city is older than inactiveDays; `never_ordered` registered with no delivered order in the city.
  @BuiltValueField(wireName: r'audience')
  AdminNewMassPushDtoAudienceEnum get audience;
  // enum audienceEnum {  all,  zone,  inactive,  never_ordered,  };

  @BuiltValueField(wireName: r'zoneId')
  String? get zoneId;

  /// 1 to 365.
  @BuiltValueField(wireName: r'inactiveDays')
  int? get inactiveDays;

  /// `home` the home screen; `restaurant` its page (restaurantId); `code` «أكوادي» on that code (codeId).
  @BuiltValueField(wireName: r'target')
  AdminNewMassPushDtoTargetEnum get target;
  // enum targetEnum {  home,  restaurant,  code,  };

  @BuiltValueField(wireName: r'restaurantId')
  String? get restaurantId;

  @BuiltValueField(wireName: r'codeId')
  String? get codeId;

  /// Null: now; else ahead, at most 30 days.
  @BuiltValueField(wireName: r'sendAt')
  DateTime? get sendAt;

  /// The size the panel showed and the admin confirmed (GET …/audience).
  @BuiltValueField(wireName: r'audienceSize')
  int get audienceSize;

  AdminNewMassPushDto._();

  factory AdminNewMassPushDto([void updates(AdminNewMassPushDtoBuilder b)]) =
      _$AdminNewMassPushDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminNewMassPushDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminNewMassPushDto> get serializer =>
      _$AdminNewMassPushDtoSerializer();
}

class _$AdminNewMassPushDtoSerializer
    implements PrimitiveSerializer<AdminNewMassPushDto> {
  @override
  final Iterable<Type> types = const [
    AdminNewMassPushDto,
    _$AdminNewMassPushDto,
  ];

  @override
  final String wireName = r'AdminNewMassPushDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminNewMassPushDto object, {
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
    yield r'body';
    yield serializers.serialize(
      object.body,
      specifiedType: const FullType(String),
    );
    yield r'audience';
    yield serializers.serialize(
      object.audience,
      specifiedType: const FullType(AdminNewMassPushDtoAudienceEnum),
    );
    yield r'zoneId';
    yield object.zoneId == null
        ? null
        : serializers.serialize(
            object.zoneId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'inactiveDays';
    yield object.inactiveDays == null
        ? null
        : serializers.serialize(
            object.inactiveDays,
            specifiedType: const FullType.nullable(int),
          );
    yield r'target';
    yield serializers.serialize(
      object.target,
      specifiedType: const FullType(AdminNewMassPushDtoTargetEnum),
    );
    yield r'restaurantId';
    yield object.restaurantId == null
        ? null
        : serializers.serialize(
            object.restaurantId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'codeId';
    yield object.codeId == null
        ? null
        : serializers.serialize(
            object.codeId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'sendAt';
    yield object.sendAt == null
        ? null
        : serializers.serialize(
            object.sendAt,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'audienceSize';
    yield serializers.serialize(
      object.audienceSize,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminNewMassPushDto object, {
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
    required AdminNewMassPushDtoBuilder result,
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
        case r'body':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.body = valueDes;
          break;
        case r'audience':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminNewMassPushDtoAudienceEnum,
                    ),
                  )
                  as AdminNewMassPushDtoAudienceEnum;
          result.audience = valueDes;
          break;
        case r'zoneId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.zoneId = valueDes;
          break;
        case r'inactiveDays':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.inactiveDays = valueDes;
          break;
        case r'target':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminNewMassPushDtoTargetEnum,
                    ),
                  )
                  as AdminNewMassPushDtoTargetEnum;
          result.target = valueDes;
          break;
        case r'restaurantId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.restaurantId = valueDes;
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
        case r'sendAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.sendAt = valueDes;
          break;
        case r'audienceSize':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.audienceSize = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminNewMassPushDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminNewMassPushDtoBuilder();
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

/// `all` every registered customer; `zone` those with a saved address in zoneId; `inactive` those whose latest delivered order in the city is older than inactiveDays; `never_ordered` registered with no delivered order in the city.
class AdminNewMassPushDtoAudienceEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'all')
  static const AdminNewMassPushDtoAudienceEnum all =
      _$adminNewMassPushDtoAudienceEnum_all;
  @BuiltValueEnumConst(wireName: r'zone')
  static const AdminNewMassPushDtoAudienceEnum zone =
      _$adminNewMassPushDtoAudienceEnum_zone;
  @BuiltValueEnumConst(wireName: r'inactive')
  static const AdminNewMassPushDtoAudienceEnum inactive =
      _$adminNewMassPushDtoAudienceEnum_inactive;
  @BuiltValueEnumConst(wireName: r'never_ordered')
  static const AdminNewMassPushDtoAudienceEnum neverOrdered =
      _$adminNewMassPushDtoAudienceEnum_neverOrdered;

  static Serializer<AdminNewMassPushDtoAudienceEnum> get serializer =>
      _$adminNewMassPushDtoAudienceEnumSerializer;

  const AdminNewMassPushDtoAudienceEnum._(String name) : super(name);

  static BuiltSet<AdminNewMassPushDtoAudienceEnum> get values =>
      _$adminNewMassPushDtoAudienceEnumValues;
  static AdminNewMassPushDtoAudienceEnum valueOf(String name) =>
      _$adminNewMassPushDtoAudienceEnumValueOf(name);
}

/// `home` the home screen; `restaurant` its page (restaurantId); `code` «أكوادي» on that code (codeId).
class AdminNewMassPushDtoTargetEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'home')
  static const AdminNewMassPushDtoTargetEnum home =
      _$adminNewMassPushDtoTargetEnum_home;
  @BuiltValueEnumConst(wireName: r'restaurant')
  static const AdminNewMassPushDtoTargetEnum restaurant =
      _$adminNewMassPushDtoTargetEnum_restaurant;
  @BuiltValueEnumConst(wireName: r'code')
  static const AdminNewMassPushDtoTargetEnum code =
      _$adminNewMassPushDtoTargetEnum_code;

  static Serializer<AdminNewMassPushDtoTargetEnum> get serializer =>
      _$adminNewMassPushDtoTargetEnumSerializer;

  const AdminNewMassPushDtoTargetEnum._(String name) : super(name);

  static BuiltSet<AdminNewMassPushDtoTargetEnum> get values =>
      _$adminNewMassPushDtoTargetEnumValues;
  static AdminNewMassPushDtoTargetEnum valueOf(String name) =>
      _$adminNewMassPushDtoTargetEnumValueOf(name);
}
