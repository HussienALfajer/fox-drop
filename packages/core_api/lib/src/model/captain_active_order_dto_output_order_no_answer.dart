//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_active_order_dto_output_order_no_answer_report.dart';
import 'package:core_api/src/model/captain_active_order_dto_output_order_no_answer_answer.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_active_order_dto_output_order_no_answer.g.dart';

/// CA §9.9 (slice 2.13d): the door, while the order is arrived with this captain at the customer; null otherwise.
///
/// Properties:
/// * [pingsLeft] - «تنبيه الزبون» presses left.
/// * [nextPingAt] - When «تنبيه الزبون» is allowed next (the screen shows it); null with none left.
/// * [answer]
/// * [reportableAt] - When «الزبون لا يستجيب» appears: after every ping and pings × interval since the arrival or the latest «انتظر»; null while pings are left or a report waits.
/// * [report]
@BuiltValue()
abstract class CaptainActiveOrderDtoOutputOrderNoAnswer
    implements
        Built<
          CaptainActiveOrderDtoOutputOrderNoAnswer,
          CaptainActiveOrderDtoOutputOrderNoAnswerBuilder
        > {
  /// «تنبيه الزبون» presses left.
  @BuiltValueField(wireName: r'pingsLeft')
  int get pingsLeft;

  /// When «تنبيه الزبون» is allowed next (the screen shows it); null with none left.
  @BuiltValueField(wireName: r'nextPingAt')
  DateTime? get nextPingAt;

  @BuiltValueField(wireName: r'answer')
  CaptainActiveOrderDtoOutputOrderNoAnswerAnswer? get answer;

  /// When «الزبون لا يستجيب» appears: after every ping and pings × interval since the arrival or the latest «انتظر»; null while pings are left or a report waits.
  @BuiltValueField(wireName: r'reportableAt')
  DateTime? get reportableAt;

  @BuiltValueField(wireName: r'report')
  CaptainActiveOrderDtoOutputOrderNoAnswerReport? get report;

  CaptainActiveOrderDtoOutputOrderNoAnswer._();

  factory CaptainActiveOrderDtoOutputOrderNoAnswer([
    void updates(CaptainActiveOrderDtoOutputOrderNoAnswerBuilder b),
  ]) = _$CaptainActiveOrderDtoOutputOrderNoAnswer;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainActiveOrderDtoOutputOrderNoAnswerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainActiveOrderDtoOutputOrderNoAnswer> get serializer =>
      _$CaptainActiveOrderDtoOutputOrderNoAnswerSerializer();
}

class _$CaptainActiveOrderDtoOutputOrderNoAnswerSerializer
    implements PrimitiveSerializer<CaptainActiveOrderDtoOutputOrderNoAnswer> {
  @override
  final Iterable<Type> types = const [
    CaptainActiveOrderDtoOutputOrderNoAnswer,
    _$CaptainActiveOrderDtoOutputOrderNoAnswer,
  ];

  @override
  final String wireName = r'CaptainActiveOrderDtoOutputOrderNoAnswer';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainActiveOrderDtoOutputOrderNoAnswer object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'pingsLeft';
    yield serializers.serialize(
      object.pingsLeft,
      specifiedType: const FullType(int),
    );
    yield r'nextPingAt';
    yield object.nextPingAt == null
        ? null
        : serializers.serialize(
            object.nextPingAt,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'answer';
    yield object.answer == null
        ? null
        : serializers.serialize(
            object.answer,
            specifiedType: const FullType.nullable(
              CaptainActiveOrderDtoOutputOrderNoAnswerAnswer,
            ),
          );
    yield r'reportableAt';
    yield object.reportableAt == null
        ? null
        : serializers.serialize(
            object.reportableAt,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'report';
    yield object.report == null
        ? null
        : serializers.serialize(
            object.report,
            specifiedType: const FullType.nullable(
              CaptainActiveOrderDtoOutputOrderNoAnswerReport,
            ),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainActiveOrderDtoOutputOrderNoAnswer object, {
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
    required CaptainActiveOrderDtoOutputOrderNoAnswerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'pingsLeft':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.pingsLeft = valueDes;
          break;
        case r'nextPingAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.nextPingAt = valueDes;
          break;
        case r'answer':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CaptainActiveOrderDtoOutputOrderNoAnswerAnswer,
                    ),
                  )
                  as CaptainActiveOrderDtoOutputOrderNoAnswerAnswer?;
          if (valueDes == null) continue;
          result.answer.replace(valueDes);
          break;
        case r'reportableAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.reportableAt = valueDes;
          break;
        case r'report':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CaptainActiveOrderDtoOutputOrderNoAnswerReport,
                    ),
                  )
                  as CaptainActiveOrderDtoOutputOrderNoAnswerReport?;
          if (valueDes == null) continue;
          result.report.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainActiveOrderDtoOutputOrderNoAnswer deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainActiveOrderDtoOutputOrderNoAnswerBuilder();
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
