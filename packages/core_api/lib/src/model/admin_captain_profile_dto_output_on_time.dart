//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_profile_dto_output_on_time.g.dart';

/// Of the last 50 delivered: those at or before the promised time.
///
/// Properties:
/// * [onTime]
/// * [counted]
@BuiltValue()
abstract class AdminCaptainProfileDtoOutputOnTime
    implements
        Built<
          AdminCaptainProfileDtoOutputOnTime,
          AdminCaptainProfileDtoOutputOnTimeBuilder
        > {
  @BuiltValueField(wireName: r'onTime')
  int get onTime;

  @BuiltValueField(wireName: r'counted')
  int get counted;

  AdminCaptainProfileDtoOutputOnTime._();

  factory AdminCaptainProfileDtoOutputOnTime([
    void updates(AdminCaptainProfileDtoOutputOnTimeBuilder b),
  ]) = _$AdminCaptainProfileDtoOutputOnTime;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCaptainProfileDtoOutputOnTimeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainProfileDtoOutputOnTime> get serializer =>
      _$AdminCaptainProfileDtoOutputOnTimeSerializer();
}

class _$AdminCaptainProfileDtoOutputOnTimeSerializer
    implements PrimitiveSerializer<AdminCaptainProfileDtoOutputOnTime> {
  @override
  final Iterable<Type> types = const [
    AdminCaptainProfileDtoOutputOnTime,
    _$AdminCaptainProfileDtoOutputOnTime,
  ];

  @override
  final String wireName = r'AdminCaptainProfileDtoOutputOnTime';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainProfileDtoOutputOnTime object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'onTime';
    yield serializers.serialize(
      object.onTime,
      specifiedType: const FullType(int),
    );
    yield r'counted';
    yield serializers.serialize(
      object.counted,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainProfileDtoOutputOnTime object, {
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
    required AdminCaptainProfileDtoOutputOnTimeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'onTime':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.onTime = valueDes;
          break;
        case r'counted':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.counted = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCaptainProfileDtoOutputOnTime deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainProfileDtoOutputOnTimeBuilder();
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
