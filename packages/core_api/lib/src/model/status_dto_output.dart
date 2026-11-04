//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'status_dto_output.g.dart';

/// StatusDtoOutput
///
/// Properties:
/// * [status]
/// * [serverTime] - The server clock in Unix milliseconds.
@BuiltValue()
abstract class StatusDtoOutput
    implements Built<StatusDtoOutput, StatusDtoOutputBuilder> {
  @BuiltValueField(wireName: r'status')
  StatusDtoOutputStatusEnum get status;
  // enum statusEnum {  ok,  };

  /// The server clock in Unix milliseconds.
  @BuiltValueField(wireName: r'serverTime')
  int get serverTime;

  StatusDtoOutput._();

  factory StatusDtoOutput([void updates(StatusDtoOutputBuilder b)]) =
      _$StatusDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StatusDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StatusDtoOutput> get serializer =>
      _$StatusDtoOutputSerializer();
}

class _$StatusDtoOutputSerializer
    implements PrimitiveSerializer<StatusDtoOutput> {
  @override
  final Iterable<Type> types = const [StatusDtoOutput, _$StatusDtoOutput];

  @override
  final String wireName = r'StatusDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StatusDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(StatusDtoOutputStatusEnum),
    );
    yield r'serverTime';
    yield serializers.serialize(
      object.serverTime,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    StatusDtoOutput object, {
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
    required StatusDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(StatusDtoOutputStatusEnum),
                  )
                  as StatusDtoOutputStatusEnum;
          result.status = valueDes;
          break;
        case r'serverTime':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.serverTime = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  StatusDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StatusDtoOutputBuilder();
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

class StatusDtoOutputStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'ok')
  static const StatusDtoOutputStatusEnum ok = _$statusDtoOutputStatusEnum_ok;

  static Serializer<StatusDtoOutputStatusEnum> get serializer =>
      _$statusDtoOutputStatusEnumSerializer;

  const StatusDtoOutputStatusEnum._(String name) : super(name);

  static BuiltSet<StatusDtoOutputStatusEnum> get values =>
      _$statusDtoOutputStatusEnumValues;
  static StatusDtoOutputStatusEnum valueOf(String name) =>
      _$statusDtoOutputStatusEnumValueOf(name);
}
