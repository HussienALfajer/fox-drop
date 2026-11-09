//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_busy_mode_dto.g.dart';

/// MerchantBusyModeDto
///
/// Properties:
/// * [extraMin] - One of busyExtraOptionsMin to turn it on; null for «إلغاء وضع الضغط».
@BuiltValue()
abstract class MerchantBusyModeDto implements Built<MerchantBusyModeDto, MerchantBusyModeDtoBuilder> {
  /// One of busyExtraOptionsMin to turn it on; null for «إلغاء وضع الضغط».
  @BuiltValueField(wireName: r'extraMin')
  int? get extraMin;

  MerchantBusyModeDto._();

  factory MerchantBusyModeDto([void updates(MerchantBusyModeDtoBuilder b)]) = _$MerchantBusyModeDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantBusyModeDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantBusyModeDto> get serializer => _$MerchantBusyModeDtoSerializer();
}

class _$MerchantBusyModeDtoSerializer implements PrimitiveSerializer<MerchantBusyModeDto> {
  @override
  final Iterable<Type> types = const [MerchantBusyModeDto, _$MerchantBusyModeDto];

  @override
  final String wireName = r'MerchantBusyModeDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantBusyModeDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'extraMin';
    yield object.extraMin == null ? null : serializers.serialize(
      object.extraMin,
      specifiedType: const FullType.nullable(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantBusyModeDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MerchantBusyModeDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'extraMin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.extraMin = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantBusyModeDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantBusyModeDtoBuilder();
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


