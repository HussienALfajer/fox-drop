//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_status_dto_output_busy_mode.g.dart';

/// Busy mode while on (RA §7.3), until the end of the opening period.
///
/// Properties:
/// * [extraMin] 
/// * [until] 
@BuiltValue()
abstract class MerchantStatusDtoOutputBusyMode implements Built<MerchantStatusDtoOutputBusyMode, MerchantStatusDtoOutputBusyModeBuilder> {
  @BuiltValueField(wireName: r'extraMin')
  int get extraMin;

  @BuiltValueField(wireName: r'until')
  DateTime get until;

  MerchantStatusDtoOutputBusyMode._();

  factory MerchantStatusDtoOutputBusyMode([void updates(MerchantStatusDtoOutputBusyModeBuilder b)]) = _$MerchantStatusDtoOutputBusyMode;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantStatusDtoOutputBusyModeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantStatusDtoOutputBusyMode> get serializer => _$MerchantStatusDtoOutputBusyModeSerializer();
}

class _$MerchantStatusDtoOutputBusyModeSerializer implements PrimitiveSerializer<MerchantStatusDtoOutputBusyMode> {
  @override
  final Iterable<Type> types = const [MerchantStatusDtoOutputBusyMode, _$MerchantStatusDtoOutputBusyMode];

  @override
  final String wireName = r'MerchantStatusDtoOutputBusyMode';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantStatusDtoOutputBusyMode object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'extraMin';
    yield serializers.serialize(
      object.extraMin,
      specifiedType: const FullType(int),
    );
    yield r'until';
    yield serializers.serialize(
      object.until,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantStatusDtoOutputBusyMode object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MerchantStatusDtoOutputBusyModeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'extraMin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.extraMin = valueDes;
          break;
        case r'until':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.until = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantStatusDtoOutputBusyMode deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantStatusDtoOutputBusyModeBuilder();
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


