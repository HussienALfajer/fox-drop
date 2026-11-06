//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_delivery_summary_dto_output_summary.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_delivery_summary_dto_output.g.dart';

/// CaptainDeliverySummaryDtoOutput
///
/// Properties:
/// * [summary]
@BuiltValue()
abstract class CaptainDeliverySummaryDtoOutput
    implements
        Built<
          CaptainDeliverySummaryDtoOutput,
          CaptainDeliverySummaryDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'summary')
  CaptainDeliverySummaryDtoOutputSummary get summary;

  CaptainDeliverySummaryDtoOutput._();

  factory CaptainDeliverySummaryDtoOutput([
    void updates(CaptainDeliverySummaryDtoOutputBuilder b),
  ]) = _$CaptainDeliverySummaryDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainDeliverySummaryDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainDeliverySummaryDtoOutput> get serializer =>
      _$CaptainDeliverySummaryDtoOutputSerializer();
}

class _$CaptainDeliverySummaryDtoOutputSerializer
    implements PrimitiveSerializer<CaptainDeliverySummaryDtoOutput> {
  @override
  final Iterable<Type> types = const [
    CaptainDeliverySummaryDtoOutput,
    _$CaptainDeliverySummaryDtoOutput,
  ];

  @override
  final String wireName = r'CaptainDeliverySummaryDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainDeliverySummaryDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'summary';
    yield serializers.serialize(
      object.summary,
      specifiedType: const FullType(CaptainDeliverySummaryDtoOutputSummary),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainDeliverySummaryDtoOutput object, {
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
    required CaptainDeliverySummaryDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'summary':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainDeliverySummaryDtoOutputSummary,
                    ),
                  )
                  as CaptainDeliverySummaryDtoOutputSummary;
          result.summary.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainDeliverySummaryDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainDeliverySummaryDtoOutputBuilder();
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
