//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sender_number_status_dto.g.dart';

/// SenderNumberStatusDto
///
/// Properties:
/// * [status] - «نشط» or «احتياطي» (architecture §8.3.3 item 13).
@BuiltValue()
abstract class SenderNumberStatusDto implements Built<SenderNumberStatusDto, SenderNumberStatusDtoBuilder> {
  /// «نشط» or «احتياطي» (architecture §8.3.3 item 13).
  @BuiltValueField(wireName: r'status')
  SenderNumberStatusDtoStatusEnum get status;
  // enum statusEnum {  active,  standby,  };

  SenderNumberStatusDto._();

  factory SenderNumberStatusDto([void updates(SenderNumberStatusDtoBuilder b)]) = _$SenderNumberStatusDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SenderNumberStatusDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SenderNumberStatusDto> get serializer => _$SenderNumberStatusDtoSerializer();
}

class _$SenderNumberStatusDtoSerializer implements PrimitiveSerializer<SenderNumberStatusDto> {
  @override
  final Iterable<Type> types = const [SenderNumberStatusDto, _$SenderNumberStatusDto];

  @override
  final String wireName = r'SenderNumberStatusDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SenderNumberStatusDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(SenderNumberStatusDtoStatusEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SenderNumberStatusDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SenderNumberStatusDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SenderNumberStatusDtoStatusEnum),
          ) as SenderNumberStatusDtoStatusEnum;
          result.status = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SenderNumberStatusDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SenderNumberStatusDtoBuilder();
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


/// «نشط» or «احتياطي» (architecture §8.3.3 item 13).
class SenderNumberStatusDtoStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'active')
  static const SenderNumberStatusDtoStatusEnum active = _$senderNumberStatusDtoStatusEnum_active;
  @BuiltValueEnumConst(wireName: r'standby')
  static const SenderNumberStatusDtoStatusEnum standby = _$senderNumberStatusDtoStatusEnum_standby;

  static Serializer<SenderNumberStatusDtoStatusEnum> get serializer => _$senderNumberStatusDtoStatusEnumSerializer;

  const SenderNumberStatusDtoStatusEnum._(String name): super(name);

  static BuiltSet<SenderNumberStatusDtoStatusEnum> get values => _$senderNumberStatusDtoStatusEnumValues;
  static SenderNumberStatusDtoStatusEnum valueOf(String name) => _$senderNumberStatusDtoStatusEnumValueOf(name);
}

