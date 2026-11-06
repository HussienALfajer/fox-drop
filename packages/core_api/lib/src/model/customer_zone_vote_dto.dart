//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/customer_zone_vote_dto_location.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_zone_vote_dto.g.dart';

/// CustomerZoneVoteDto
///
/// Properties:
/// * [deviceId] - The app installation, generated once by the app and kept until it is removed.
/// * [location]
@BuiltValue()
abstract class CustomerZoneVoteDto
    implements Built<CustomerZoneVoteDto, CustomerZoneVoteDtoBuilder> {
  /// The app installation, generated once by the app and kept until it is removed.
  @BuiltValueField(wireName: r'deviceId')
  String get deviceId;

  @BuiltValueField(wireName: r'location')
  CustomerZoneVoteDtoLocation get location;

  CustomerZoneVoteDto._();

  factory CustomerZoneVoteDto([void updates(CustomerZoneVoteDtoBuilder b)]) =
      _$CustomerZoneVoteDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerZoneVoteDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerZoneVoteDto> get serializer =>
      _$CustomerZoneVoteDtoSerializer();
}

class _$CustomerZoneVoteDtoSerializer
    implements PrimitiveSerializer<CustomerZoneVoteDto> {
  @override
  final Iterable<Type> types = const [
    CustomerZoneVoteDto,
    _$CustomerZoneVoteDto,
  ];

  @override
  final String wireName = r'CustomerZoneVoteDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerZoneVoteDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'deviceId';
    yield serializers.serialize(
      object.deviceId,
      specifiedType: const FullType(String),
    );
    yield r'location';
    yield serializers.serialize(
      object.location,
      specifiedType: const FullType(CustomerZoneVoteDtoLocation),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerZoneVoteDto object, {
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
    required CustomerZoneVoteDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'deviceId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.deviceId = valueDes;
          break;
        case r'location':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(CustomerZoneVoteDtoLocation),
                  )
                  as CustomerZoneVoteDtoLocation;
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
  CustomerZoneVoteDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerZoneVoteDtoBuilder();
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
