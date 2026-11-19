//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_performance_dto_output_online.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/captain_performance_dto_output_violations_inner.dart';
import 'package:core_api/src/model/admin_captain_profile_dto_output_on_time.dart';
import 'package:core_api/src/model/captain_performance_dto_output_acceptance.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_performance_dto_output.g.dart';

/// CaptainPerformanceDtoOutput
///
/// Properties:
/// * [acceptance]
/// * [onTime]
/// * [cancellations] - Captain cancellations within the window.
/// * [windowDays] - captain.violation_window_days
/// * [online]
/// * [violations] - Newest first.
@BuiltValue()
abstract class CaptainPerformanceDtoOutput
    implements
        Built<CaptainPerformanceDtoOutput, CaptainPerformanceDtoOutputBuilder> {
  @BuiltValueField(wireName: r'acceptance')
  CaptainPerformanceDtoOutputAcceptance get acceptance;

  @BuiltValueField(wireName: r'onTime')
  AdminCaptainProfileDtoOutputOnTime get onTime;

  /// Captain cancellations within the window.
  @BuiltValueField(wireName: r'cancellations')
  int get cancellations;

  /// captain.violation_window_days
  @BuiltValueField(wireName: r'windowDays')
  int get windowDays;

  @BuiltValueField(wireName: r'online')
  CaptainPerformanceDtoOutputOnline get online;

  /// Newest first.
  @BuiltValueField(wireName: r'violations')
  BuiltList<CaptainPerformanceDtoOutputViolationsInner> get violations;

  CaptainPerformanceDtoOutput._();

  factory CaptainPerformanceDtoOutput([
    void updates(CaptainPerformanceDtoOutputBuilder b),
  ]) = _$CaptainPerformanceDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainPerformanceDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainPerformanceDtoOutput> get serializer =>
      _$CaptainPerformanceDtoOutputSerializer();
}

class _$CaptainPerformanceDtoOutputSerializer
    implements PrimitiveSerializer<CaptainPerformanceDtoOutput> {
  @override
  final Iterable<Type> types = const [
    CaptainPerformanceDtoOutput,
    _$CaptainPerformanceDtoOutput,
  ];

  @override
  final String wireName = r'CaptainPerformanceDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainPerformanceDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'acceptance';
    yield serializers.serialize(
      object.acceptance,
      specifiedType: const FullType(CaptainPerformanceDtoOutputAcceptance),
    );
    yield r'onTime';
    yield serializers.serialize(
      object.onTime,
      specifiedType: const FullType(AdminCaptainProfileDtoOutputOnTime),
    );
    yield r'cancellations';
    yield serializers.serialize(
      object.cancellations,
      specifiedType: const FullType(int),
    );
    yield r'windowDays';
    yield serializers.serialize(
      object.windowDays,
      specifiedType: const FullType(int),
    );
    yield r'online';
    yield serializers.serialize(
      object.online,
      specifiedType: const FullType(CaptainPerformanceDtoOutputOnline),
    );
    yield r'violations';
    yield serializers.serialize(
      object.violations,
      specifiedType: const FullType(BuiltList, [
        FullType(CaptainPerformanceDtoOutputViolationsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainPerformanceDtoOutput object, {
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
    required CaptainPerformanceDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'acceptance':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainPerformanceDtoOutputAcceptance,
                    ),
                  )
                  as CaptainPerformanceDtoOutputAcceptance;
          result.acceptance.replace(valueDes);
          break;
        case r'onTime':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCaptainProfileDtoOutputOnTime,
                    ),
                  )
                  as AdminCaptainProfileDtoOutputOnTime;
          result.onTime.replace(valueDes);
          break;
        case r'cancellations':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.cancellations = valueDes;
          break;
        case r'windowDays':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.windowDays = valueDes;
          break;
        case r'online':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainPerformanceDtoOutputOnline,
                    ),
                  )
                  as CaptainPerformanceDtoOutputOnline;
          result.online.replace(valueDes);
          break;
        case r'violations':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(CaptainPerformanceDtoOutputViolationsInner),
                    ]),
                  )
                  as BuiltList<CaptainPerformanceDtoOutputViolationsInner>;
          result.violations.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainPerformanceDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainPerformanceDtoOutputBuilder();
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
