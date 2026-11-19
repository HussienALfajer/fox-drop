//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_update_city_dto.g.dart';

/// AdminUpdateCityDto
///
/// Properties:
/// * [name]
/// * [code]
/// * [timeZone]
/// * [status]
/// * [reason] - Why, for the audit log; optional.
@BuiltValue()
abstract class AdminUpdateCityDto
    implements Built<AdminUpdateCityDto, AdminUpdateCityDtoBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'timeZone')
  String get timeZone;

  @BuiltValueField(wireName: r'status')
  AdminUpdateCityDtoStatusEnum get status;
  // enum statusEnum {  active,  inactive,  };

  /// Why, for the audit log; optional.
  @BuiltValueField(wireName: r'reason')
  String? get reason;

  AdminUpdateCityDto._();

  factory AdminUpdateCityDto([void updates(AdminUpdateCityDtoBuilder b)]) =
      _$AdminUpdateCityDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminUpdateCityDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminUpdateCityDto> get serializer =>
      _$AdminUpdateCityDtoSerializer();
}

class _$AdminUpdateCityDtoSerializer
    implements PrimitiveSerializer<AdminUpdateCityDto> {
  @override
  final Iterable<Type> types = const [AdminUpdateCityDto, _$AdminUpdateCityDto];

  @override
  final String wireName = r'AdminUpdateCityDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminUpdateCityDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'timeZone';
    yield serializers.serialize(
      object.timeZone,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AdminUpdateCityDtoStatusEnum),
    );
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminUpdateCityDto object, {
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
    required AdminUpdateCityDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.name = valueDes;
          break;
        case r'code':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.code = valueDes;
          break;
        case r'timeZone':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.timeZone = valueDes;
          break;
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(AdminUpdateCityDtoStatusEnum),
                  )
                  as AdminUpdateCityDtoStatusEnum;
          result.status = valueDes;
          break;
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminUpdateCityDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminUpdateCityDtoBuilder();
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

class AdminUpdateCityDtoStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'active')
  static const AdminUpdateCityDtoStatusEnum active =
      _$adminUpdateCityDtoStatusEnum_active;
  @BuiltValueEnumConst(wireName: r'inactive')
  static const AdminUpdateCityDtoStatusEnum inactive =
      _$adminUpdateCityDtoStatusEnum_inactive;

  static Serializer<AdminUpdateCityDtoStatusEnum> get serializer =>
      _$adminUpdateCityDtoStatusEnumSerializer;

  const AdminUpdateCityDtoStatusEnum._(String name) : super(name);

  static BuiltSet<AdminUpdateCityDtoStatusEnum> get values =>
      _$adminUpdateCityDtoStatusEnumValues;
  static AdminUpdateCityDtoStatusEnum valueOf(String name) =>
      _$adminUpdateCityDtoStatusEnumValueOf(name);
}
