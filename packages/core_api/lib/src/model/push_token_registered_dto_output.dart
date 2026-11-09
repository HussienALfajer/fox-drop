//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'push_token_registered_dto_output.g.dart';

/// PushTokenRegisteredDtoOutput
///
/// Properties:
/// * [status] 
@BuiltValue()
abstract class PushTokenRegisteredDtoOutput implements Built<PushTokenRegisteredDtoOutput, PushTokenRegisteredDtoOutputBuilder> {
  @BuiltValueField(wireName: r'status')
  PushTokenRegisteredDtoOutputStatusEnum get status;
  // enum statusEnum {  registered,  };

  PushTokenRegisteredDtoOutput._();

  factory PushTokenRegisteredDtoOutput([void updates(PushTokenRegisteredDtoOutputBuilder b)]) = _$PushTokenRegisteredDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PushTokenRegisteredDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PushTokenRegisteredDtoOutput> get serializer => _$PushTokenRegisteredDtoOutputSerializer();
}

class _$PushTokenRegisteredDtoOutputSerializer implements PrimitiveSerializer<PushTokenRegisteredDtoOutput> {
  @override
  final Iterable<Type> types = const [PushTokenRegisteredDtoOutput, _$PushTokenRegisteredDtoOutput];

  @override
  final String wireName = r'PushTokenRegisteredDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PushTokenRegisteredDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(PushTokenRegisteredDtoOutputStatusEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PushTokenRegisteredDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PushTokenRegisteredDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PushTokenRegisteredDtoOutputStatusEnum),
          ) as PushTokenRegisteredDtoOutputStatusEnum;
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
  PushTokenRegisteredDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PushTokenRegisteredDtoOutputBuilder();
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


class PushTokenRegisteredDtoOutputStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'registered')
  static const PushTokenRegisteredDtoOutputStatusEnum registered = _$pushTokenRegisteredDtoOutputStatusEnum_registered;

  static Serializer<PushTokenRegisteredDtoOutputStatusEnum> get serializer => _$pushTokenRegisteredDtoOutputStatusEnumSerializer;

  const PushTokenRegisteredDtoOutputStatusEnum._(String name): super(name);

  static BuiltSet<PushTokenRegisteredDtoOutputStatusEnum> get values => _$pushTokenRegisteredDtoOutputStatusEnumValues;
  static PushTokenRegisteredDtoOutputStatusEnum valueOf(String name) => _$pushTokenRegisteredDtoOutputStatusEnumValueOf(name);
}

