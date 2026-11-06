//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_availability_dto_output_custody_usage.g.dart';

/// The cash held, in the base currency (AP §8.5.3).
///
/// Properties:
/// * [amount] - Integer minor units (AP §8.6).
/// * [currency] 
@BuiltValue()
abstract class CaptainAvailabilityDtoOutputCustodyUsage implements Built<CaptainAvailabilityDtoOutputCustodyUsage, CaptainAvailabilityDtoOutputCustodyUsageBuilder> {
  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  CaptainAvailabilityDtoOutputCustodyUsage._();

  factory CaptainAvailabilityDtoOutputCustodyUsage([void updates(CaptainAvailabilityDtoOutputCustodyUsageBuilder b)]) = _$CaptainAvailabilityDtoOutputCustodyUsage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainAvailabilityDtoOutputCustodyUsageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainAvailabilityDtoOutputCustodyUsage> get serializer => _$CaptainAvailabilityDtoOutputCustodyUsageSerializer();
}

class _$CaptainAvailabilityDtoOutputCustodyUsageSerializer implements PrimitiveSerializer<CaptainAvailabilityDtoOutputCustodyUsage> {
  @override
  final Iterable<Type> types = const [CaptainAvailabilityDtoOutputCustodyUsage, _$CaptainAvailabilityDtoOutputCustodyUsage];

  @override
  final String wireName = r'CaptainAvailabilityDtoOutputCustodyUsage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainAvailabilityDtoOutputCustodyUsage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(String),
    );
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainAvailabilityDtoOutputCustodyUsage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CaptainAvailabilityDtoOutputCustodyUsageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.amount = valueDes;
          break;
        case r'currency':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.currency = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainAvailabilityDtoOutputCustodyUsage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainAvailabilityDtoOutputCustodyUsageBuilder();
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


