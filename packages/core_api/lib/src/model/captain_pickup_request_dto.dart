//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/captain_arrive_dto_location.dart';
import 'package:core_api/src/model/merchant_pickup_dispute_dto_received_lines_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_pickup_request_dto.g.dart';

/// CaptainPickupRequestDto
///
/// Properties:
/// * [lines] - The currency lines paid, the proposed ones or the own split.
/// * [location] 
@BuiltValue()
abstract class CaptainPickupRequestDto implements Built<CaptainPickupRequestDto, CaptainPickupRequestDtoBuilder> {
  /// The currency lines paid, the proposed ones or the own split.
  @BuiltValueField(wireName: r'lines')
  BuiltList<MerchantPickupDisputeDtoReceivedLinesInner> get lines;

  @BuiltValueField(wireName: r'location')
  CaptainArriveDtoLocation get location;

  CaptainPickupRequestDto._();

  factory CaptainPickupRequestDto([void updates(CaptainPickupRequestDtoBuilder b)]) = _$CaptainPickupRequestDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainPickupRequestDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainPickupRequestDto> get serializer => _$CaptainPickupRequestDtoSerializer();
}

class _$CaptainPickupRequestDtoSerializer implements PrimitiveSerializer<CaptainPickupRequestDto> {
  @override
  final Iterable<Type> types = const [CaptainPickupRequestDto, _$CaptainPickupRequestDto];

  @override
  final String wireName = r'CaptainPickupRequestDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainPickupRequestDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [FullType(MerchantPickupDisputeDtoReceivedLinesInner)]),
    );
    yield r'location';
    yield serializers.serialize(
      object.location,
      specifiedType: const FullType(CaptainArriveDtoLocation),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainPickupRequestDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CaptainPickupRequestDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'lines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(MerchantPickupDisputeDtoReceivedLinesInner)]),
          ) as BuiltList<MerchantPickupDisputeDtoReceivedLinesInner>;
          result.lines.replace(valueDes);
          break;
        case r'location':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CaptainArriveDtoLocation),
          ) as CaptainArriveDtoLocation;
          result.location.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainPickupRequestDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainPickupRequestDtoBuilder();
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


