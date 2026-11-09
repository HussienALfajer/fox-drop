//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_zone_voted_dto_output.g.dart';

/// CustomerZoneVotedDtoOutput
///
/// Properties:
/// * [status] - Either way the app shows «شكراً، سنخبرك عندما نصل إلى منطقتك».
@BuiltValue()
abstract class CustomerZoneVotedDtoOutput implements Built<CustomerZoneVotedDtoOutput, CustomerZoneVotedDtoOutputBuilder> {
  /// Either way the app shows «شكراً، سنخبرك عندما نصل إلى منطقتك».
  @BuiltValueField(wireName: r'status')
  CustomerZoneVotedDtoOutputStatusEnum get status;
  // enum statusEnum {  recorded,  already_voted,  };

  CustomerZoneVotedDtoOutput._();

  factory CustomerZoneVotedDtoOutput([void updates(CustomerZoneVotedDtoOutputBuilder b)]) = _$CustomerZoneVotedDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerZoneVotedDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerZoneVotedDtoOutput> get serializer => _$CustomerZoneVotedDtoOutputSerializer();
}

class _$CustomerZoneVotedDtoOutputSerializer implements PrimitiveSerializer<CustomerZoneVotedDtoOutput> {
  @override
  final Iterable<Type> types = const [CustomerZoneVotedDtoOutput, _$CustomerZoneVotedDtoOutput];

  @override
  final String wireName = r'CustomerZoneVotedDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerZoneVotedDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(CustomerZoneVotedDtoOutputStatusEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerZoneVotedDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CustomerZoneVotedDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CustomerZoneVotedDtoOutputStatusEnum),
          ) as CustomerZoneVotedDtoOutputStatusEnum;
          result.status = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerZoneVotedDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerZoneVotedDtoOutputBuilder();
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


/// Either way the app shows «شكراً، سنخبرك عندما نصل إلى منطقتك».
class CustomerZoneVotedDtoOutputStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'recorded')
  static const CustomerZoneVotedDtoOutputStatusEnum recorded = _$customerZoneVotedDtoOutputStatusEnum_recorded;
  @BuiltValueEnumConst(wireName: r'already_voted')
  static const CustomerZoneVotedDtoOutputStatusEnum alreadyVoted = _$customerZoneVotedDtoOutputStatusEnum_alreadyVoted;

  static Serializer<CustomerZoneVotedDtoOutputStatusEnum> get serializer => _$customerZoneVotedDtoOutputStatusEnumSerializer;

  const CustomerZoneVotedDtoOutputStatusEnum._(String name): super(name);

  static BuiltSet<CustomerZoneVotedDtoOutputStatusEnum> get values => _$customerZoneVotedDtoOutputStatusEnumValues;
  static CustomerZoneVotedDtoOutputStatusEnum valueOf(String name) => _$customerZoneVotedDtoOutputStatusEnumValueOf(name);
}

