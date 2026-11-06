//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_availability_dto_output_availability_one_of2.g.dart';

/// CaptainAvailabilityDtoOutputAvailabilityOneOf2
///
/// Properties:
/// * [state]
/// * [since]
/// * [reasons]
@BuiltValue()
abstract class CaptainAvailabilityDtoOutputAvailabilityOneOf2
    implements
        Built<
          CaptainAvailabilityDtoOutputAvailabilityOneOf2,
          CaptainAvailabilityDtoOutputAvailabilityOneOf2Builder
        > {
  @BuiltValueField(wireName: r'state')
  CaptainAvailabilityDtoOutputAvailabilityOneOf2StateEnum get state;
  // enum stateEnum {  not_receiving_offers,  };

  @BuiltValueField(wireName: r'since')
  DateTime get since;

  @BuiltValueField(wireName: r'reasons')
  BuiltList<CaptainAvailabilityDtoOutputAvailabilityOneOf2ReasonsEnum>
  get reasons;
  // enum reasonsEnum {  cash_limit,  closed_due,  simulated_location,  };

  CaptainAvailabilityDtoOutputAvailabilityOneOf2._();

  factory CaptainAvailabilityDtoOutputAvailabilityOneOf2([
    void updates(CaptainAvailabilityDtoOutputAvailabilityOneOf2Builder b),
  ]) = _$CaptainAvailabilityDtoOutputAvailabilityOneOf2;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CaptainAvailabilityDtoOutputAvailabilityOneOf2Builder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainAvailabilityDtoOutputAvailabilityOneOf2>
  get serializer =>
      _$CaptainAvailabilityDtoOutputAvailabilityOneOf2Serializer();
}

class _$CaptainAvailabilityDtoOutputAvailabilityOneOf2Serializer
    implements
        PrimitiveSerializer<CaptainAvailabilityDtoOutputAvailabilityOneOf2> {
  @override
  final Iterable<Type> types = const [
    CaptainAvailabilityDtoOutputAvailabilityOneOf2,
    _$CaptainAvailabilityDtoOutputAvailabilityOneOf2,
  ];

  @override
  final String wireName = r'CaptainAvailabilityDtoOutputAvailabilityOneOf2';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainAvailabilityDtoOutputAvailabilityOneOf2 object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(
        CaptainAvailabilityDtoOutputAvailabilityOneOf2StateEnum,
      ),
    );
    yield r'since';
    yield serializers.serialize(
      object.since,
      specifiedType: const FullType(DateTime),
    );
    yield r'reasons';
    yield serializers.serialize(
      object.reasons,
      specifiedType: const FullType(BuiltList, [
        FullType(CaptainAvailabilityDtoOutputAvailabilityOneOf2ReasonsEnum),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainAvailabilityDtoOutputAvailabilityOneOf2 object, {
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
    required CaptainAvailabilityDtoOutputAvailabilityOneOf2Builder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'state':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainAvailabilityDtoOutputAvailabilityOneOf2StateEnum,
                    ),
                  )
                  as CaptainAvailabilityDtoOutputAvailabilityOneOf2StateEnum;
          result.state = valueDes;
          break;
        case r'since':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.since = valueDes;
          break;
        case r'reasons':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        CaptainAvailabilityDtoOutputAvailabilityOneOf2ReasonsEnum,
                      ),
                    ]),
                  )
                  as BuiltList<
                    CaptainAvailabilityDtoOutputAvailabilityOneOf2ReasonsEnum
                  >;
          result.reasons.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainAvailabilityDtoOutputAvailabilityOneOf2 deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainAvailabilityDtoOutputAvailabilityOneOf2Builder();
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

class CaptainAvailabilityDtoOutputAvailabilityOneOf2StateEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'not_receiving_offers')
  static const CaptainAvailabilityDtoOutputAvailabilityOneOf2StateEnum
  notReceivingOffers =
      _$captainAvailabilityDtoOutputAvailabilityOneOf2StateEnum_notReceivingOffers;

  static Serializer<CaptainAvailabilityDtoOutputAvailabilityOneOf2StateEnum>
  get serializer =>
      _$captainAvailabilityDtoOutputAvailabilityOneOf2StateEnumSerializer;

  const CaptainAvailabilityDtoOutputAvailabilityOneOf2StateEnum._(String name)
    : super(name);

  static BuiltSet<CaptainAvailabilityDtoOutputAvailabilityOneOf2StateEnum>
  get values => _$captainAvailabilityDtoOutputAvailabilityOneOf2StateEnumValues;
  static CaptainAvailabilityDtoOutputAvailabilityOneOf2StateEnum valueOf(
    String name,
  ) => _$captainAvailabilityDtoOutputAvailabilityOneOf2StateEnumValueOf(name);
}

class CaptainAvailabilityDtoOutputAvailabilityOneOf2ReasonsEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'cash_limit')
  static const CaptainAvailabilityDtoOutputAvailabilityOneOf2ReasonsEnum
  cashLimit =
      _$captainAvailabilityDtoOutputAvailabilityOneOf2ReasonsEnum_cashLimit;
  @BuiltValueEnumConst(wireName: r'closed_due')
  static const CaptainAvailabilityDtoOutputAvailabilityOneOf2ReasonsEnum
  closedDue =
      _$captainAvailabilityDtoOutputAvailabilityOneOf2ReasonsEnum_closedDue;
  @BuiltValueEnumConst(wireName: r'simulated_location')
  static const CaptainAvailabilityDtoOutputAvailabilityOneOf2ReasonsEnum
  simulatedLocation =
      _$captainAvailabilityDtoOutputAvailabilityOneOf2ReasonsEnum_simulatedLocation;

  static Serializer<CaptainAvailabilityDtoOutputAvailabilityOneOf2ReasonsEnum>
  get serializer =>
      _$captainAvailabilityDtoOutputAvailabilityOneOf2ReasonsEnumSerializer;

  const CaptainAvailabilityDtoOutputAvailabilityOneOf2ReasonsEnum._(String name)
    : super(name);

  static BuiltSet<CaptainAvailabilityDtoOutputAvailabilityOneOf2ReasonsEnum>
  get values =>
      _$captainAvailabilityDtoOutputAvailabilityOneOf2ReasonsEnumValues;
  static CaptainAvailabilityDtoOutputAvailabilityOneOf2ReasonsEnum valueOf(
    String name,
  ) => _$captainAvailabilityDtoOutputAvailabilityOneOf2ReasonsEnumValueOf(name);
}
