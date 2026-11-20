//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_windows_pairing_dto_output.g.dart';

/// MerchantWindowsPairingDtoOutput
///
/// Properties:
/// * [code] - 8 digits, typed on the PC within 10 minutes; used once.
/// * [expiresAt]
@BuiltValue()
abstract class MerchantWindowsPairingDtoOutput
    implements
        Built<
          MerchantWindowsPairingDtoOutput,
          MerchantWindowsPairingDtoOutputBuilder
        > {
  /// 8 digits, typed on the PC within 10 minutes; used once.
  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'expiresAt')
  DateTime get expiresAt;

  MerchantWindowsPairingDtoOutput._();

  factory MerchantWindowsPairingDtoOutput([
    void updates(MerchantWindowsPairingDtoOutputBuilder b),
  ]) = _$MerchantWindowsPairingDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantWindowsPairingDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantWindowsPairingDtoOutput> get serializer =>
      _$MerchantWindowsPairingDtoOutputSerializer();
}

class _$MerchantWindowsPairingDtoOutputSerializer
    implements PrimitiveSerializer<MerchantWindowsPairingDtoOutput> {
  @override
  final Iterable<Type> types = const [
    MerchantWindowsPairingDtoOutput,
    _$MerchantWindowsPairingDtoOutput,
  ];

  @override
  final String wireName = r'MerchantWindowsPairingDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantWindowsPairingDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'expiresAt';
    yield serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantWindowsPairingDtoOutput object, {
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
    required MerchantWindowsPairingDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'code':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.code = valueDes;
          break;
        case r'expiresAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.expiresAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantWindowsPairingDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantWindowsPairingDtoOutputBuilder();
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
