//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_arrive_dto_location.dart';
import 'package:core_api/src/model/captain_arrive_at_customer_dto_away.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_arrive_at_customer_dto.g.dart';

/// CaptainArriveAtCustomerDto
///
/// Properties:
/// * [location] 
/// * [away] 
@BuiltValue()
abstract class CaptainArriveAtCustomerDto implements Built<CaptainArriveAtCustomerDto, CaptainArriveAtCustomerDtoBuilder> {
  @BuiltValueField(wireName: r'location')
  CaptainArriveDtoLocation get location;

  @BuiltValueField(wireName: r'away')
  CaptainArriveAtCustomerDtoAway? get away;

  CaptainArriveAtCustomerDto._();

  factory CaptainArriveAtCustomerDto([void updates(CaptainArriveAtCustomerDtoBuilder b)]) = _$CaptainArriveAtCustomerDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainArriveAtCustomerDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainArriveAtCustomerDto> get serializer => _$CaptainArriveAtCustomerDtoSerializer();
}

class _$CaptainArriveAtCustomerDtoSerializer implements PrimitiveSerializer<CaptainArriveAtCustomerDto> {
  @override
  final Iterable<Type> types = const [CaptainArriveAtCustomerDto, _$CaptainArriveAtCustomerDto];

  @override
  final String wireName = r'CaptainArriveAtCustomerDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainArriveAtCustomerDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'location';
    yield serializers.serialize(
      object.location,
      specifiedType: const FullType(CaptainArriveDtoLocation),
    );
    yield r'away';
    yield object.away == null ? null : serializers.serialize(
      object.away,
      specifiedType: const FullType.nullable(CaptainArriveAtCustomerDtoAway),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainArriveAtCustomerDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CaptainArriveAtCustomerDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'location':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CaptainArriveDtoLocation),
          ) as CaptainArriveDtoLocation;
          result.location.replace(valueDes);
          break;
        case r'away':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CaptainArriveAtCustomerDtoAway),
          ) as CaptainArriveAtCustomerDtoAway?;
          if (valueDes == null) continue;
          result.away.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainArriveAtCustomerDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainArriveAtCustomerDtoBuilder();
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


