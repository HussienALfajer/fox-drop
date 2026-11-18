//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_menu_availability_dto.g.dart';

/// AdminMenuAvailabilityDto
///
/// Properties:
/// * [type]
/// * [id]
/// * [available]
/// * [until] - When switching off: «حتى الغد» or «حتى أعيده» (the default).
@BuiltValue()
abstract class AdminMenuAvailabilityDto
    implements
        Built<AdminMenuAvailabilityDto, AdminMenuAvailabilityDtoBuilder> {
  @BuiltValueField(wireName: r'type')
  AdminMenuAvailabilityDtoTypeEnum get type;
  // enum typeEnum {  category,  item,  };

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'available')
  bool get available;

  /// When switching off: «حتى الغد» or «حتى أعيده» (the default).
  @BuiltValueField(wireName: r'until')
  AdminMenuAvailabilityDtoUntilEnum? get until;
  // enum untilEnum {  tomorrow,  turned_back_on,  };

  AdminMenuAvailabilityDto._();

  factory AdminMenuAvailabilityDto([
    void updates(AdminMenuAvailabilityDtoBuilder b),
  ]) = _$AdminMenuAvailabilityDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminMenuAvailabilityDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminMenuAvailabilityDto> get serializer =>
      _$AdminMenuAvailabilityDtoSerializer();
}

class _$AdminMenuAvailabilityDtoSerializer
    implements PrimitiveSerializer<AdminMenuAvailabilityDto> {
  @override
  final Iterable<Type> types = const [
    AdminMenuAvailabilityDto,
    _$AdminMenuAvailabilityDto,
  ];

  @override
  final String wireName = r'AdminMenuAvailabilityDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminMenuAvailabilityDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(AdminMenuAvailabilityDtoTypeEnum),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'available';
    yield serializers.serialize(
      object.available,
      specifiedType: const FullType(bool),
    );
    if (object.until != null) {
      yield r'until';
      yield serializers.serialize(
        object.until,
        specifiedType: const FullType(AdminMenuAvailabilityDtoUntilEnum),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminMenuAvailabilityDto object, {
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
    required AdminMenuAvailabilityDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'type':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminMenuAvailabilityDtoTypeEnum,
                    ),
                  )
                  as AdminMenuAvailabilityDtoTypeEnum;
          result.type = valueDes;
          break;
        case r'id':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.id = valueDes;
          break;
        case r'available':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.available = valueDes;
          break;
        case r'until':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminMenuAvailabilityDtoUntilEnum,
                    ),
                  )
                  as AdminMenuAvailabilityDtoUntilEnum?;
          if (valueDes == null) continue;
          result.until = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminMenuAvailabilityDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminMenuAvailabilityDtoBuilder();
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

class AdminMenuAvailabilityDtoTypeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'category')
  static const AdminMenuAvailabilityDtoTypeEnum category =
      _$adminMenuAvailabilityDtoTypeEnum_category;
  @BuiltValueEnumConst(wireName: r'item')
  static const AdminMenuAvailabilityDtoTypeEnum item =
      _$adminMenuAvailabilityDtoTypeEnum_item;

  static Serializer<AdminMenuAvailabilityDtoTypeEnum> get serializer =>
      _$adminMenuAvailabilityDtoTypeEnumSerializer;

  const AdminMenuAvailabilityDtoTypeEnum._(String name) : super(name);

  static BuiltSet<AdminMenuAvailabilityDtoTypeEnum> get values =>
      _$adminMenuAvailabilityDtoTypeEnumValues;
  static AdminMenuAvailabilityDtoTypeEnum valueOf(String name) =>
      _$adminMenuAvailabilityDtoTypeEnumValueOf(name);
}

/// When switching off: «حتى الغد» or «حتى أعيده» (the default).
class AdminMenuAvailabilityDtoUntilEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'tomorrow')
  static const AdminMenuAvailabilityDtoUntilEnum tomorrow =
      _$adminMenuAvailabilityDtoUntilEnum_tomorrow;
  @BuiltValueEnumConst(wireName: r'turned_back_on')
  static const AdminMenuAvailabilityDtoUntilEnum turnedBackOn =
      _$adminMenuAvailabilityDtoUntilEnum_turnedBackOn;

  static Serializer<AdminMenuAvailabilityDtoUntilEnum> get serializer =>
      _$adminMenuAvailabilityDtoUntilEnumSerializer;

  const AdminMenuAvailabilityDtoUntilEnum._(String name) : super(name);

  static BuiltSet<AdminMenuAvailabilityDtoUntilEnum> get values =>
      _$adminMenuAvailabilityDtoUntilEnumValues;
  static AdminMenuAvailabilityDtoUntilEnum valueOf(String name) =>
      _$adminMenuAvailabilityDtoUntilEnumValueOf(name);
}
