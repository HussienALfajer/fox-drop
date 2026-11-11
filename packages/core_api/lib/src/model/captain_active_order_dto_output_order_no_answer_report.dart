//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_active_order_dto_output_order_no_answer_report.g.dart';

/// The latest «الزبون لا يستجيب».
///
/// Properties:
/// * [at]
/// * [waitedAt]
/// * [waitMessage] - Operations' «انتظر» message; null while «العمليات تراجع الطلب — انتظر تعليماتهم».
@BuiltValue()
abstract class CaptainActiveOrderDtoOutputOrderNoAnswerReport
    implements
        Built<
          CaptainActiveOrderDtoOutputOrderNoAnswerReport,
          CaptainActiveOrderDtoOutputOrderNoAnswerReportBuilder
        > {
  @BuiltValueField(wireName: r'at')
  DateTime get at;

  @BuiltValueField(wireName: r'waitedAt')
  DateTime? get waitedAt;

  /// Operations' «انتظر» message; null while «العمليات تراجع الطلب — انتظر تعليماتهم».
  @BuiltValueField(wireName: r'waitMessage')
  String? get waitMessage;

  CaptainActiveOrderDtoOutputOrderNoAnswerReport._();

  factory CaptainActiveOrderDtoOutputOrderNoAnswerReport([
    void updates(CaptainActiveOrderDtoOutputOrderNoAnswerReportBuilder b),
  ]) = _$CaptainActiveOrderDtoOutputOrderNoAnswerReport;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CaptainActiveOrderDtoOutputOrderNoAnswerReportBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainActiveOrderDtoOutputOrderNoAnswerReport>
  get serializer =>
      _$CaptainActiveOrderDtoOutputOrderNoAnswerReportSerializer();
}

class _$CaptainActiveOrderDtoOutputOrderNoAnswerReportSerializer
    implements
        PrimitiveSerializer<CaptainActiveOrderDtoOutputOrderNoAnswerReport> {
  @override
  final Iterable<Type> types = const [
    CaptainActiveOrderDtoOutputOrderNoAnswerReport,
    _$CaptainActiveOrderDtoOutputOrderNoAnswerReport,
  ];

  @override
  final String wireName = r'CaptainActiveOrderDtoOutputOrderNoAnswerReport';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainActiveOrderDtoOutputOrderNoAnswerReport object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
    yield r'waitedAt';
    yield object.waitedAt == null
        ? null
        : serializers.serialize(
            object.waitedAt,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'waitMessage';
    yield object.waitMessage == null
        ? null
        : serializers.serialize(
            object.waitMessage,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainActiveOrderDtoOutputOrderNoAnswerReport object, {
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
    required CaptainActiveOrderDtoOutputOrderNoAnswerReportBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'at':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.at = valueDes;
          break;
        case r'waitedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.waitedAt = valueDes;
          break;
        case r'waitMessage':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.waitMessage = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainActiveOrderDtoOutputOrderNoAnswerReport deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainActiveOrderDtoOutputOrderNoAnswerReportBuilder();
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
