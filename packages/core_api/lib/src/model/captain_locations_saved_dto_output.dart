//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_locations_saved_dto_output.g.dart';

/// CaptainLocationsSavedDtoOutput
///
/// Properties:
/// * [accepted] - The new points kept.
@BuiltValue()
abstract class CaptainLocationsSavedDtoOutput
    implements
        Built<
          CaptainLocationsSavedDtoOutput,
          CaptainLocationsSavedDtoOutputBuilder
        > {
  /// The new points kept.
  @BuiltValueField(wireName: r'accepted')
  int get accepted;

  CaptainLocationsSavedDtoOutput._();

  factory CaptainLocationsSavedDtoOutput([
    void updates(CaptainLocationsSavedDtoOutputBuilder b),
  ]) = _$CaptainLocationsSavedDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainLocationsSavedDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainLocationsSavedDtoOutput> get serializer =>
      _$CaptainLocationsSavedDtoOutputSerializer();
}

class _$CaptainLocationsSavedDtoOutputSerializer
    implements PrimitiveSerializer<CaptainLocationsSavedDtoOutput> {
  @override
  final Iterable<Type> types = const [
    CaptainLocationsSavedDtoOutput,
    _$CaptainLocationsSavedDtoOutput,
  ];

  @override
  final String wireName = r'CaptainLocationsSavedDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainLocationsSavedDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'accepted';
    yield serializers.serialize(
      object.accepted,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainLocationsSavedDtoOutput object, {
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
    required CaptainLocationsSavedDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'accepted':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.accepted = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainLocationsSavedDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainLocationsSavedDtoOutputBuilder();
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
