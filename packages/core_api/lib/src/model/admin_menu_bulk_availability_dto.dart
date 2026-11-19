//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_menu_bulk_availability_dto.g.dart';

/// AdminMenuBulkAvailabilityDto
///
/// Properties:
/// * [itemIds]
/// * [available]
/// * [until] - When switching off: «حتى الغد» or «حتى أعيده» (the default).
@BuiltValue()
abstract class AdminMenuBulkAvailabilityDto
    implements
        Built<
          AdminMenuBulkAvailabilityDto,
          AdminMenuBulkAvailabilityDtoBuilder
        > {
  @BuiltValueField(wireName: r'itemIds')
  BuiltList<String> get itemIds;

  @BuiltValueField(wireName: r'available')
  bool get available;

  /// When switching off: «حتى الغد» or «حتى أعيده» (the default).
  @BuiltValueField(wireName: r'until')
  AdminMenuBulkAvailabilityDtoUntilEnum? get until;
  // enum untilEnum {  tomorrow,  turned_back_on,  };

  AdminMenuBulkAvailabilityDto._();

  factory AdminMenuBulkAvailabilityDto([
    void updates(AdminMenuBulkAvailabilityDtoBuilder b),
  ]) = _$AdminMenuBulkAvailabilityDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminMenuBulkAvailabilityDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminMenuBulkAvailabilityDto> get serializer =>
      _$AdminMenuBulkAvailabilityDtoSerializer();
}

class _$AdminMenuBulkAvailabilityDtoSerializer
    implements PrimitiveSerializer<AdminMenuBulkAvailabilityDto> {
  @override
  final Iterable<Type> types = const [
    AdminMenuBulkAvailabilityDto,
    _$AdminMenuBulkAvailabilityDto,
  ];

  @override
  final String wireName = r'AdminMenuBulkAvailabilityDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminMenuBulkAvailabilityDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'itemIds';
    yield serializers.serialize(
      object.itemIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
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
        specifiedType: const FullType(AdminMenuBulkAvailabilityDtoUntilEnum),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminMenuBulkAvailabilityDto object, {
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
    required AdminMenuBulkAvailabilityDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'itemIds':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.itemIds.replace(valueDes);
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
                      AdminMenuBulkAvailabilityDtoUntilEnum,
                    ),
                  )
                  as AdminMenuBulkAvailabilityDtoUntilEnum?;
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
  AdminMenuBulkAvailabilityDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminMenuBulkAvailabilityDtoBuilder();
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

/// When switching off: «حتى الغد» or «حتى أعيده» (the default).
class AdminMenuBulkAvailabilityDtoUntilEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'tomorrow')
  static const AdminMenuBulkAvailabilityDtoUntilEnum tomorrow =
      _$adminMenuBulkAvailabilityDtoUntilEnum_tomorrow;
  @BuiltValueEnumConst(wireName: r'turned_back_on')
  static const AdminMenuBulkAvailabilityDtoUntilEnum turnedBackOn =
      _$adminMenuBulkAvailabilityDtoUntilEnum_turnedBackOn;

  static Serializer<AdminMenuBulkAvailabilityDtoUntilEnum> get serializer =>
      _$adminMenuBulkAvailabilityDtoUntilEnumSerializer;

  const AdminMenuBulkAvailabilityDtoUntilEnum._(String name) : super(name);

  static BuiltSet<AdminMenuBulkAvailabilityDtoUntilEnum> get values =>
      _$adminMenuBulkAvailabilityDtoUntilEnumValues;
  static AdminMenuBulkAvailabilityDtoUntilEnum valueOf(String name) =>
      _$adminMenuBulkAvailabilityDtoUntilEnumValueOf(name);
}
