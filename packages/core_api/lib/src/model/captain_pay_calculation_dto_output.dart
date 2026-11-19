//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/captain_pay_calculation_dto_output_current.dart';
import 'package:core_api/src/model/captain_pay_calculation_dto_output_announced_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_pay_calculation_dto_output.g.dart';

/// CaptainPayCalculationDtoOutput
///
/// Properties:
/// * [current]
/// * [announced]
@BuiltValue()
abstract class CaptainPayCalculationDtoOutput
    implements
        Built<
          CaptainPayCalculationDtoOutput,
          CaptainPayCalculationDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'current')
  CaptainPayCalculationDtoOutputCurrent? get current;

  @BuiltValueField(wireName: r'announced')
  BuiltList<CaptainPayCalculationDtoOutputAnnouncedInner> get announced;

  CaptainPayCalculationDtoOutput._();

  factory CaptainPayCalculationDtoOutput([
    void updates(CaptainPayCalculationDtoOutputBuilder b),
  ]) = _$CaptainPayCalculationDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainPayCalculationDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainPayCalculationDtoOutput> get serializer =>
      _$CaptainPayCalculationDtoOutputSerializer();
}

class _$CaptainPayCalculationDtoOutputSerializer
    implements PrimitiveSerializer<CaptainPayCalculationDtoOutput> {
  @override
  final Iterable<Type> types = const [
    CaptainPayCalculationDtoOutput,
    _$CaptainPayCalculationDtoOutput,
  ];

  @override
  final String wireName = r'CaptainPayCalculationDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainPayCalculationDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'current';
    yield object.current == null
        ? null
        : serializers.serialize(
            object.current,
            specifiedType: const FullType.nullable(
              CaptainPayCalculationDtoOutputCurrent,
            ),
          );
    yield r'announced';
    yield serializers.serialize(
      object.announced,
      specifiedType: const FullType(BuiltList, [
        FullType(CaptainPayCalculationDtoOutputAnnouncedInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainPayCalculationDtoOutput object, {
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
    required CaptainPayCalculationDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'current':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CaptainPayCalculationDtoOutputCurrent,
                    ),
                  )
                  as CaptainPayCalculationDtoOutputCurrent?;
          if (valueDes == null) continue;
          result.current.replace(valueDes);
          break;
        case r'announced':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(CaptainPayCalculationDtoOutputAnnouncedInner),
                    ]),
                  )
                  as BuiltList<CaptainPayCalculationDtoOutputAnnouncedInner>;
          result.announced.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainPayCalculationDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainPayCalculationDtoOutputBuilder();
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
