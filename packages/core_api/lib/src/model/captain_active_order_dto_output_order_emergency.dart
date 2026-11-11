//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_active_order_dto_output_order_emergency.g.dart';

/// «طوارئ» (CA §9.11, slice 2.13c): the captain's open emergency; it cannot be withdrawn and every step stays open. Null without one.
///
/// Properties:
/// * [at]
/// * [located] - Whether the press sent a fix.
@BuiltValue()
abstract class CaptainActiveOrderDtoOutputOrderEmergency
    implements
        Built<
          CaptainActiveOrderDtoOutputOrderEmergency,
          CaptainActiveOrderDtoOutputOrderEmergencyBuilder
        > {
  @BuiltValueField(wireName: r'at')
  DateTime get at;

  /// Whether the press sent a fix.
  @BuiltValueField(wireName: r'located')
  bool get located;

  CaptainActiveOrderDtoOutputOrderEmergency._();

  factory CaptainActiveOrderDtoOutputOrderEmergency([
    void updates(CaptainActiveOrderDtoOutputOrderEmergencyBuilder b),
  ]) = _$CaptainActiveOrderDtoOutputOrderEmergency;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainActiveOrderDtoOutputOrderEmergencyBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainActiveOrderDtoOutputOrderEmergency> get serializer =>
      _$CaptainActiveOrderDtoOutputOrderEmergencySerializer();
}

class _$CaptainActiveOrderDtoOutputOrderEmergencySerializer
    implements PrimitiveSerializer<CaptainActiveOrderDtoOutputOrderEmergency> {
  @override
  final Iterable<Type> types = const [
    CaptainActiveOrderDtoOutputOrderEmergency,
    _$CaptainActiveOrderDtoOutputOrderEmergency,
  ];

  @override
  final String wireName = r'CaptainActiveOrderDtoOutputOrderEmergency';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainActiveOrderDtoOutputOrderEmergency object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
    yield r'located';
    yield serializers.serialize(
      object.located,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainActiveOrderDtoOutputOrderEmergency object, {
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
    required CaptainActiveOrderDtoOutputOrderEmergencyBuilder result,
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
        case r'located':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.located = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainActiveOrderDtoOutputOrderEmergency deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainActiveOrderDtoOutputOrderEmergencyBuilder();
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
