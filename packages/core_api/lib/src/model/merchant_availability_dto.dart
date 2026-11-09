//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_availability_dto.g.dart';

/// MerchantAvailabilityDto
///
/// Properties:
/// * [type] 
/// * [id] 
/// * [available] 
/// * [until] - Needed to switch off: «حتى الغد» (the default in the app) or «حتى أعيده» (RA §9.3).
@BuiltValue()
abstract class MerchantAvailabilityDto implements Built<MerchantAvailabilityDto, MerchantAvailabilityDtoBuilder> {
  @BuiltValueField(wireName: r'type')
  MerchantAvailabilityDtoTypeEnum get type;
  // enum typeEnum {  category,  item,  option,  };

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'available')
  bool get available;

  /// Needed to switch off: «حتى الغد» (the default in the app) or «حتى أعيده» (RA §9.3).
  @BuiltValueField(wireName: r'until')
  MerchantAvailabilityDtoUntilEnum? get until;
  // enum untilEnum {  tomorrow,  turned_back_on,  };

  MerchantAvailabilityDto._();

  factory MerchantAvailabilityDto([void updates(MerchantAvailabilityDtoBuilder b)]) = _$MerchantAvailabilityDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantAvailabilityDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantAvailabilityDto> get serializer => _$MerchantAvailabilityDtoSerializer();
}

class _$MerchantAvailabilityDtoSerializer implements PrimitiveSerializer<MerchantAvailabilityDto> {
  @override
  final Iterable<Type> types = const [MerchantAvailabilityDto, _$MerchantAvailabilityDto];

  @override
  final String wireName = r'MerchantAvailabilityDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantAvailabilityDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(MerchantAvailabilityDtoTypeEnum),
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
        specifiedType: const FullType(MerchantAvailabilityDtoUntilEnum),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantAvailabilityDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MerchantAvailabilityDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MerchantAvailabilityDtoTypeEnum),
          ) as MerchantAvailabilityDtoTypeEnum;
          result.type = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'available':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.available = valueDes;
          break;
        case r'until':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(MerchantAvailabilityDtoUntilEnum),
          ) as MerchantAvailabilityDtoUntilEnum?;
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
  MerchantAvailabilityDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantAvailabilityDtoBuilder();
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


class MerchantAvailabilityDtoTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'category')
  static const MerchantAvailabilityDtoTypeEnum category = _$merchantAvailabilityDtoTypeEnum_category;
  @BuiltValueEnumConst(wireName: r'item')
  static const MerchantAvailabilityDtoTypeEnum item = _$merchantAvailabilityDtoTypeEnum_item;
  @BuiltValueEnumConst(wireName: r'option')
  static const MerchantAvailabilityDtoTypeEnum option = _$merchantAvailabilityDtoTypeEnum_option;

  static Serializer<MerchantAvailabilityDtoTypeEnum> get serializer => _$merchantAvailabilityDtoTypeEnumSerializer;

  const MerchantAvailabilityDtoTypeEnum._(String name): super(name);

  static BuiltSet<MerchantAvailabilityDtoTypeEnum> get values => _$merchantAvailabilityDtoTypeEnumValues;
  static MerchantAvailabilityDtoTypeEnum valueOf(String name) => _$merchantAvailabilityDtoTypeEnumValueOf(name);
}

/// Needed to switch off: «حتى الغد» (the default in the app) or «حتى أعيده» (RA §9.3).
class MerchantAvailabilityDtoUntilEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'tomorrow')
  static const MerchantAvailabilityDtoUntilEnum tomorrow = _$merchantAvailabilityDtoUntilEnum_tomorrow;
  @BuiltValueEnumConst(wireName: r'turned_back_on')
  static const MerchantAvailabilityDtoUntilEnum turnedBackOn = _$merchantAvailabilityDtoUntilEnum_turnedBackOn;

  static Serializer<MerchantAvailabilityDtoUntilEnum> get serializer => _$merchantAvailabilityDtoUntilEnumSerializer;

  const MerchantAvailabilityDtoUntilEnum._(String name): super(name);

  static BuiltSet<MerchantAvailabilityDtoUntilEnum> get values => _$merchantAvailabilityDtoUntilEnumValues;
  static MerchantAvailabilityDtoUntilEnum valueOf(String name) => _$merchantAvailabilityDtoUntilEnumValueOf(name);
}

