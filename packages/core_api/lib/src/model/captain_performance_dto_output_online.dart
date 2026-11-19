//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_performance_dto_output_online.g.dart';

/// CaptainPerformanceDtoOutputOnline
///
/// Properties:
/// * [todayMinutes]
/// * [weekMinutes] - The payout week.
@BuiltValue()
abstract class CaptainPerformanceDtoOutputOnline
    implements
        Built<
          CaptainPerformanceDtoOutputOnline,
          CaptainPerformanceDtoOutputOnlineBuilder
        > {
  @BuiltValueField(wireName: r'todayMinutes')
  int get todayMinutes;

  /// The payout week.
  @BuiltValueField(wireName: r'weekMinutes')
  int get weekMinutes;

  CaptainPerformanceDtoOutputOnline._();

  factory CaptainPerformanceDtoOutputOnline([
    void updates(CaptainPerformanceDtoOutputOnlineBuilder b),
  ]) = _$CaptainPerformanceDtoOutputOnline;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainPerformanceDtoOutputOnlineBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainPerformanceDtoOutputOnline> get serializer =>
      _$CaptainPerformanceDtoOutputOnlineSerializer();
}

class _$CaptainPerformanceDtoOutputOnlineSerializer
    implements PrimitiveSerializer<CaptainPerformanceDtoOutputOnline> {
  @override
  final Iterable<Type> types = const [
    CaptainPerformanceDtoOutputOnline,
    _$CaptainPerformanceDtoOutputOnline,
  ];

  @override
  final String wireName = r'CaptainPerformanceDtoOutputOnline';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainPerformanceDtoOutputOnline object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'todayMinutes';
    yield serializers.serialize(
      object.todayMinutes,
      specifiedType: const FullType(int),
    );
    yield r'weekMinutes';
    yield serializers.serialize(
      object.weekMinutes,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainPerformanceDtoOutputOnline object, {
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
    required CaptainPerformanceDtoOutputOnlineBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'todayMinutes':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.todayMinutes = valueDes;
          break;
        case r'weekMinutes':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.weekMinutes = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainPerformanceDtoOutputOnline deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainPerformanceDtoOutputOnlineBuilder();
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
