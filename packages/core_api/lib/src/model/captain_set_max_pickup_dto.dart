//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_set_max_pickup_dto.g.dart';

/// CaptainSetMaxPickupDto
///
/// Properties:
/// * [amount] - Minor units of the city’s base currency, above zero; null for no limit.
@BuiltValue()
abstract class CaptainSetMaxPickupDto
    implements Built<CaptainSetMaxPickupDto, CaptainSetMaxPickupDtoBuilder> {
  /// Minor units of the city’s base currency, above zero; null for no limit.
  @BuiltValueField(wireName: r'amount')
  String? get amount;

  CaptainSetMaxPickupDto._();

  factory CaptainSetMaxPickupDto([
    void updates(CaptainSetMaxPickupDtoBuilder b),
  ]) = _$CaptainSetMaxPickupDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainSetMaxPickupDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainSetMaxPickupDto> get serializer =>
      _$CaptainSetMaxPickupDtoSerializer();
}

class _$CaptainSetMaxPickupDtoSerializer
    implements PrimitiveSerializer<CaptainSetMaxPickupDto> {
  @override
  final Iterable<Type> types = const [
    CaptainSetMaxPickupDto,
    _$CaptainSetMaxPickupDto,
  ];

  @override
  final String wireName = r'CaptainSetMaxPickupDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainSetMaxPickupDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'amount';
    yield object.amount == null
        ? null
        : serializers.serialize(
            object.amount,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainSetMaxPickupDto object, {
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
    required CaptainSetMaxPickupDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'amount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.amount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainSetMaxPickupDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainSetMaxPickupDtoBuilder();
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
