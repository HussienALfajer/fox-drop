//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_went_offline_dto_output_hand_in.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_max_pickup_dto_output.g.dart';

/// CaptainMaxPickupDtoOutput
///
/// Properties:
/// * [limit]
/// * [answered] - Whether the captain has answered, a limit or none; the app asks until then (K2).
/// * [baseCurrency] - Null while the city has none.
@BuiltValue()
abstract class CaptainMaxPickupDtoOutput
    implements
        Built<CaptainMaxPickupDtoOutput, CaptainMaxPickupDtoOutputBuilder> {
  @BuiltValueField(wireName: r'limit')
  CaptainWentOfflineDtoOutputHandIn? get limit;

  /// Whether the captain has answered, a limit or none; the app asks until then (K2).
  @BuiltValueField(wireName: r'answered')
  bool get answered;

  /// Null while the city has none.
  @BuiltValueField(wireName: r'baseCurrency')
  String? get baseCurrency;

  CaptainMaxPickupDtoOutput._();

  factory CaptainMaxPickupDtoOutput([
    void updates(CaptainMaxPickupDtoOutputBuilder b),
  ]) = _$CaptainMaxPickupDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainMaxPickupDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainMaxPickupDtoOutput> get serializer =>
      _$CaptainMaxPickupDtoOutputSerializer();
}

class _$CaptainMaxPickupDtoOutputSerializer
    implements PrimitiveSerializer<CaptainMaxPickupDtoOutput> {
  @override
  final Iterable<Type> types = const [
    CaptainMaxPickupDtoOutput,
    _$CaptainMaxPickupDtoOutput,
  ];

  @override
  final String wireName = r'CaptainMaxPickupDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainMaxPickupDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'limit';
    yield object.limit == null
        ? null
        : serializers.serialize(
            object.limit,
            specifiedType: const FullType.nullable(
              CaptainWentOfflineDtoOutputHandIn,
            ),
          );
    yield r'answered';
    yield serializers.serialize(
      object.answered,
      specifiedType: const FullType(bool),
    );
    yield r'baseCurrency';
    yield object.baseCurrency == null
        ? null
        : serializers.serialize(
            object.baseCurrency,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainMaxPickupDtoOutput object, {
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
    required CaptainMaxPickupDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'limit':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CaptainWentOfflineDtoOutputHandIn,
                    ),
                  )
                  as CaptainWentOfflineDtoOutputHandIn?;
          if (valueDes == null) continue;
          result.limit.replace(valueDes);
          break;
        case r'answered':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.answered = valueDes;
          break;
        case r'baseCurrency':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.baseCurrency = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainMaxPickupDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainMaxPickupDtoOutputBuilder();
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
