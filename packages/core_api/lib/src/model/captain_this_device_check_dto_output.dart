//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_device_check_output.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_this_device_check_dto_output.g.dart';

/// CaptainThisDeviceCheckDtoOutput
///
/// Properties:
/// * [check] - This phone’s latest device check (CA §4.5); null before its first.
@BuiltValue()
abstract class CaptainThisDeviceCheckDtoOutput
    implements
        Built<
          CaptainThisDeviceCheckDtoOutput,
          CaptainThisDeviceCheckDtoOutputBuilder
        > {
  /// This phone’s latest device check (CA §4.5); null before its first.
  @BuiltValueField(wireName: r'check')
  CaptainDeviceCheckOutput? get check;

  CaptainThisDeviceCheckDtoOutput._();

  factory CaptainThisDeviceCheckDtoOutput([
    void updates(CaptainThisDeviceCheckDtoOutputBuilder b),
  ]) = _$CaptainThisDeviceCheckDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainThisDeviceCheckDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainThisDeviceCheckDtoOutput> get serializer =>
      _$CaptainThisDeviceCheckDtoOutputSerializer();
}

class _$CaptainThisDeviceCheckDtoOutputSerializer
    implements PrimitiveSerializer<CaptainThisDeviceCheckDtoOutput> {
  @override
  final Iterable<Type> types = const [
    CaptainThisDeviceCheckDtoOutput,
    _$CaptainThisDeviceCheckDtoOutput,
  ];

  @override
  final String wireName = r'CaptainThisDeviceCheckDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainThisDeviceCheckDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'check';
    yield object.check == null
        ? null
        : serializers.serialize(
            object.check,
            specifiedType: const FullType.nullable(CaptainDeviceCheckOutput),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainThisDeviceCheckDtoOutput object, {
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
    required CaptainThisDeviceCheckDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'check':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CaptainDeviceCheckOutput,
                    ),
                  )
                  as CaptainDeviceCheckOutput?;
          if (valueDes == null) continue;
          result.check.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainThisDeviceCheckDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainThisDeviceCheckDtoOutputBuilder();
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
