//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dispatch_mode_dto_output.g.dart';

/// DispatchModeDtoOutput
///
/// Properties:
/// * [mode] - «يدوي», «آلي» or «مختلط».
@BuiltValue()
abstract class DispatchModeDtoOutput
    implements Built<DispatchModeDtoOutput, DispatchModeDtoOutputBuilder> {
  /// «يدوي», «آلي» or «مختلط».
  @BuiltValueField(wireName: r'mode')
  DispatchModeDtoOutputModeEnum get mode;
  // enum modeEnum {  manual,  auto,  mixed,  };

  DispatchModeDtoOutput._();

  factory DispatchModeDtoOutput([
    void updates(DispatchModeDtoOutputBuilder b),
  ]) = _$DispatchModeDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DispatchModeDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DispatchModeDtoOutput> get serializer =>
      _$DispatchModeDtoOutputSerializer();
}

class _$DispatchModeDtoOutputSerializer
    implements PrimitiveSerializer<DispatchModeDtoOutput> {
  @override
  final Iterable<Type> types = const [
    DispatchModeDtoOutput,
    _$DispatchModeDtoOutput,
  ];

  @override
  final String wireName = r'DispatchModeDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DispatchModeDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'mode';
    yield serializers.serialize(
      object.mode,
      specifiedType: const FullType(DispatchModeDtoOutputModeEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DispatchModeDtoOutput object, {
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
    required DispatchModeDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'mode':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      DispatchModeDtoOutputModeEnum,
                    ),
                  )
                  as DispatchModeDtoOutputModeEnum;
          result.mode = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DispatchModeDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DispatchModeDtoOutputBuilder();
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

/// «يدوي», «آلي» or «مختلط».
class DispatchModeDtoOutputModeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'manual')
  static const DispatchModeDtoOutputModeEnum manual =
      _$dispatchModeDtoOutputModeEnum_manual;
  @BuiltValueEnumConst(wireName: r'auto')
  static const DispatchModeDtoOutputModeEnum auto =
      _$dispatchModeDtoOutputModeEnum_auto;
  @BuiltValueEnumConst(wireName: r'mixed')
  static const DispatchModeDtoOutputModeEnum mixed =
      _$dispatchModeDtoOutputModeEnum_mixed;

  static Serializer<DispatchModeDtoOutputModeEnum> get serializer =>
      _$dispatchModeDtoOutputModeEnumSerializer;

  const DispatchModeDtoOutputModeEnum._(String name) : super(name);

  static BuiltSet<DispatchModeDtoOutputModeEnum> get values =>
      _$dispatchModeDtoOutputModeEnumValues;
  static DispatchModeDtoOutputModeEnum valueOf(String name) =>
      _$dispatchModeDtoOutputModeEnumValueOf(name);
}
