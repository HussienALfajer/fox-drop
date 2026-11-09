//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_went_offline_dto_output_hand_in.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_went_offline_dto_output.g.dart';

/// CaptainWentOfflineDtoOutput
///
/// Properties:
/// * [handIn]
@BuiltValue()
abstract class CaptainWentOfflineDtoOutput
    implements
        Built<CaptainWentOfflineDtoOutput, CaptainWentOfflineDtoOutputBuilder> {
  @BuiltValueField(wireName: r'handIn')
  CaptainWentOfflineDtoOutputHandIn? get handIn;

  CaptainWentOfflineDtoOutput._();

  factory CaptainWentOfflineDtoOutput([
    void updates(CaptainWentOfflineDtoOutputBuilder b),
  ]) = _$CaptainWentOfflineDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainWentOfflineDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainWentOfflineDtoOutput> get serializer =>
      _$CaptainWentOfflineDtoOutputSerializer();
}

class _$CaptainWentOfflineDtoOutputSerializer
    implements PrimitiveSerializer<CaptainWentOfflineDtoOutput> {
  @override
  final Iterable<Type> types = const [
    CaptainWentOfflineDtoOutput,
    _$CaptainWentOfflineDtoOutput,
  ];

  @override
  final String wireName = r'CaptainWentOfflineDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainWentOfflineDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'handIn';
    yield object.handIn == null
        ? null
        : serializers.serialize(
            object.handIn,
            specifiedType: const FullType.nullable(
              CaptainWentOfflineDtoOutputHandIn,
            ),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainWentOfflineDtoOutput object, {
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
    required CaptainWentOfflineDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'handIn':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CaptainWentOfflineDtoOutputHandIn,
                    ),
                  )
                  as CaptainWentOfflineDtoOutputHandIn?;
          if (valueDes == null) continue;
          result.handIn.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainWentOfflineDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainWentOfflineDtoOutputBuilder();
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
