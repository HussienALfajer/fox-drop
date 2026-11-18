//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_list_query_dto.g.dart';

/// AdminRestaurantListQueryDto
///
/// Properties:
/// * [cityId]
/// * [status] - Only this account status; null for every one.
/// * [categoryId] - Only the restaurants of this category.
/// * [zoneId] - Only the restaurants whose pin is in this zone.
/// * [q] - A part of the name, or a number (E.164, 00…, 09…, 05…): the restaurant’s own or a user’s.
@BuiltValue()
abstract class AdminRestaurantListQueryDto
    implements
        Built<AdminRestaurantListQueryDto, AdminRestaurantListQueryDtoBuilder> {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  /// Only this account status; null for every one.
  @BuiltValueField(wireName: r'status')
  AdminRestaurantListQueryDtoStatusEnum? get status;
  // enum statusEnum {  draft,  test,  active,  suspended,  terminated,  };

  /// Only the restaurants of this category.
  @BuiltValueField(wireName: r'categoryId')
  String? get categoryId;

  /// Only the restaurants whose pin is in this zone.
  @BuiltValueField(wireName: r'zoneId')
  String? get zoneId;

  /// A part of the name, or a number (E.164, 00…, 09…, 05…): the restaurant’s own or a user’s.
  @BuiltValueField(wireName: r'q')
  String? get q;

  AdminRestaurantListQueryDto._();

  factory AdminRestaurantListQueryDto([
    void updates(AdminRestaurantListQueryDtoBuilder b),
  ]) = _$AdminRestaurantListQueryDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRestaurantListQueryDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantListQueryDto> get serializer =>
      _$AdminRestaurantListQueryDtoSerializer();
}

class _$AdminRestaurantListQueryDtoSerializer
    implements PrimitiveSerializer<AdminRestaurantListQueryDto> {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantListQueryDto,
    _$AdminRestaurantListQueryDto,
  ];

  @override
  final String wireName = r'AdminRestaurantListQueryDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantListQueryDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield object.status == null
        ? null
        : serializers.serialize(
            object.status,
            specifiedType: const FullType.nullable(
              AdminRestaurantListQueryDtoStatusEnum,
            ),
          );
    yield r'categoryId';
    yield object.categoryId == null
        ? null
        : serializers.serialize(
            object.categoryId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'zoneId';
    yield object.zoneId == null
        ? null
        : serializers.serialize(
            object.zoneId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'q';
    yield object.q == null
        ? null
        : serializers.serialize(
            object.q,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantListQueryDto object, {
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
    required AdminRestaurantListQueryDtoBuilder result,
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
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminRestaurantListQueryDtoStatusEnum,
                    ),
                  )
                  as AdminRestaurantListQueryDtoStatusEnum?;
          if (valueDes == null) continue;
          result.status = valueDes;
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
        case r'q':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.q = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRestaurantListQueryDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantListQueryDtoBuilder();
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

/// Only this account status; null for every one.
class AdminRestaurantListQueryDtoStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'draft')
  static const AdminRestaurantListQueryDtoStatusEnum draft =
      _$adminRestaurantListQueryDtoStatusEnum_draft;
  @BuiltValueEnumConst(wireName: r'test')
  static const AdminRestaurantListQueryDtoStatusEnum test =
      _$adminRestaurantListQueryDtoStatusEnum_test;
  @BuiltValueEnumConst(wireName: r'active')
  static const AdminRestaurantListQueryDtoStatusEnum active =
      _$adminRestaurantListQueryDtoStatusEnum_active;
  @BuiltValueEnumConst(wireName: r'suspended')
  static const AdminRestaurantListQueryDtoStatusEnum suspended =
      _$adminRestaurantListQueryDtoStatusEnum_suspended;
  @BuiltValueEnumConst(wireName: r'terminated')
  static const AdminRestaurantListQueryDtoStatusEnum terminated =
      _$adminRestaurantListQueryDtoStatusEnum_terminated;

  static Serializer<AdminRestaurantListQueryDtoStatusEnum> get serializer =>
      _$adminRestaurantListQueryDtoStatusEnumSerializer;

  const AdminRestaurantListQueryDtoStatusEnum._(String name) : super(name);

  static BuiltSet<AdminRestaurantListQueryDtoStatusEnum> get values =>
      _$adminRestaurantListQueryDtoStatusEnumValues;
  static AdminRestaurantListQueryDtoStatusEnum valueOf(String name) =>
      _$adminRestaurantListQueryDtoStatusEnumValueOf(name);
}
