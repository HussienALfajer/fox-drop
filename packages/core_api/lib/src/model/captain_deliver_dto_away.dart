//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_deliver_dto_away.g.dart';

/// Needed beyond captain.customer_radius_m of the pin, unless given at the arrival (K4).
///
/// Properties:
/// * [reason] - The reason's code in its Content list.
/// * [note] - The text of a reason that needs one («أخرى»), and only of it.
@BuiltValue()
abstract class CaptainDeliverDtoAway
    implements Built<CaptainDeliverDtoAway, CaptainDeliverDtoAwayBuilder> {
  /// The reason's code in its Content list.
  @BuiltValueField(wireName: r'reason')
  String get reason;

  /// The text of a reason that needs one («أخرى»), and only of it.
  @BuiltValueField(wireName: r'note')
  String? get note;

  CaptainDeliverDtoAway._();

  factory CaptainDeliverDtoAway([
    void updates(CaptainDeliverDtoAwayBuilder b),
  ]) = _$CaptainDeliverDtoAway;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainDeliverDtoAwayBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainDeliverDtoAway> get serializer =>
      _$CaptainDeliverDtoAwaySerializer();
}

class _$CaptainDeliverDtoAwaySerializer
    implements PrimitiveSerializer<CaptainDeliverDtoAway> {
  @override
  final Iterable<Type> types = const [
    CaptainDeliverDtoAway,
    _$CaptainDeliverDtoAway,
  ];

  @override
  final String wireName = r'CaptainDeliverDtoAway';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainDeliverDtoAway object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    yield r'note';
    yield object.note == null
        ? null
        : serializers.serialize(
            object.note,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainDeliverDtoAway object, {
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
    required CaptainDeliverDtoAwayBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.reason = valueDes;
          break;
        case r'note':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainDeliverDtoAway deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainDeliverDtoAwayBuilder();
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
