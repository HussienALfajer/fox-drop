//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_application_dto_output_application.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_application_dto_output.g.dart';

/// CaptainApplicationDtoOutput
///
/// Properties:
/// * [application]
@BuiltValue()
abstract class CaptainApplicationDtoOutput
    implements
        Built<CaptainApplicationDtoOutput, CaptainApplicationDtoOutputBuilder> {
  @BuiltValueField(wireName: r'application')
  CaptainApplicationDtoOutputApplication? get application;

  CaptainApplicationDtoOutput._();

  factory CaptainApplicationDtoOutput([
    void updates(CaptainApplicationDtoOutputBuilder b),
  ]) = _$CaptainApplicationDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainApplicationDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainApplicationDtoOutput> get serializer =>
      _$CaptainApplicationDtoOutputSerializer();
}

class _$CaptainApplicationDtoOutputSerializer
    implements PrimitiveSerializer<CaptainApplicationDtoOutput> {
  @override
  final Iterable<Type> types = const [
    CaptainApplicationDtoOutput,
    _$CaptainApplicationDtoOutput,
  ];

  @override
  final String wireName = r'CaptainApplicationDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainApplicationDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'application';
    yield object.application == null
        ? null
        : serializers.serialize(
            object.application,
            specifiedType: const FullType.nullable(
              CaptainApplicationDtoOutputApplication,
            ),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainApplicationDtoOutput object, {
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
    required CaptainApplicationDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'application':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CaptainApplicationDtoOutputApplication,
                    ),
                  )
                  as CaptainApplicationDtoOutputApplication?;
          if (valueDes == null) continue;
          result.application.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainApplicationDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainApplicationDtoOutputBuilder();
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
