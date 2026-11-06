//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_availability_dto_output_availability.g.dart';

/// CA §7.1: «غير متصل», «متصل متاح», «لا تصلك عروض» with its reasons, «موقوف».
///
/// Properties:
/// * [state]
/// * [since] - Online since; null unless online.
/// * [reasons] - Why no offers arrive; empty unless not_receiving_offers.
/// * [suspensionReason]
/// * [suspendedUntil] - While suspended: the end, or null until further notice.
@BuiltValue()
abstract class CaptainAvailabilityDtoOutputAvailability
    implements
        Built<
          CaptainAvailabilityDtoOutputAvailability,
          CaptainAvailabilityDtoOutputAvailabilityBuilder
        > {
  @BuiltValueField(wireName: r'state')
  CaptainAvailabilityDtoOutputAvailabilityStateEnum get state;
  // enum stateEnum {  offline,  online_available,  not_receiving_offers,  suspended,  };

  /// Online since; null unless online.
  @BuiltValueField(wireName: r'since')
  DateTime? get since;

  /// Why no offers arrive; empty unless not_receiving_offers.
  @BuiltValueField(wireName: r'reasons')
  BuiltList<CaptainAvailabilityDtoOutputAvailabilityReasonsEnum> get reasons;
  // enum reasonsEnum {  cash_limit,  closed_due,  simulated_location,  };

  @BuiltValueField(wireName: r'suspensionReason')
  String? get suspensionReason;

  /// While suspended: the end, or null until further notice.
  @BuiltValueField(wireName: r'suspendedUntil')
  DateTime? get suspendedUntil;

  CaptainAvailabilityDtoOutputAvailability._();

  factory CaptainAvailabilityDtoOutputAvailability([
    void updates(CaptainAvailabilityDtoOutputAvailabilityBuilder b),
  ]) = _$CaptainAvailabilityDtoOutputAvailability;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainAvailabilityDtoOutputAvailabilityBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainAvailabilityDtoOutputAvailability> get serializer =>
      _$CaptainAvailabilityDtoOutputAvailabilitySerializer();
}

class _$CaptainAvailabilityDtoOutputAvailabilitySerializer
    implements PrimitiveSerializer<CaptainAvailabilityDtoOutputAvailability> {
  @override
  final Iterable<Type> types = const [
    CaptainAvailabilityDtoOutputAvailability,
    _$CaptainAvailabilityDtoOutputAvailability,
  ];

  @override
  final String wireName = r'CaptainAvailabilityDtoOutputAvailability';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainAvailabilityDtoOutputAvailability object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(
        CaptainAvailabilityDtoOutputAvailabilityStateEnum,
      ),
    );
    yield r'since';
    yield object.since == null
        ? null
        : serializers.serialize(
            object.since,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'reasons';
    yield serializers.serialize(
      object.reasons,
      specifiedType: const FullType(BuiltList, [
        FullType(CaptainAvailabilityDtoOutputAvailabilityReasonsEnum),
      ]),
    );
    yield r'suspensionReason';
    yield object.suspensionReason == null
        ? null
        : serializers.serialize(
            object.suspensionReason,
            specifiedType: const FullType.nullable(String),
          );
    yield r'suspendedUntil';
    yield object.suspendedUntil == null
        ? null
        : serializers.serialize(
            object.suspendedUntil,
            specifiedType: const FullType.nullable(DateTime),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainAvailabilityDtoOutputAvailability object, {
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
    required CaptainAvailabilityDtoOutputAvailabilityBuilder result,
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
                      CaptainAvailabilityDtoOutputAvailabilityStateEnum,
                    ),
                  )
                  as CaptainAvailabilityDtoOutputAvailabilityStateEnum;
          result.state = valueDes;
          break;
        case r'since':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.since = valueDes;
          break;
        case r'reasons':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        CaptainAvailabilityDtoOutputAvailabilityReasonsEnum,
                      ),
                    ]),
                  )
                  as BuiltList<
                    CaptainAvailabilityDtoOutputAvailabilityReasonsEnum
                  >;
          result.reasons.replace(valueDes);
          break;
        case r'suspensionReason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.suspensionReason = valueDes;
          break;
        case r'suspendedUntil':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.suspendedUntil = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainAvailabilityDtoOutputAvailability deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainAvailabilityDtoOutputAvailabilityBuilder();
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

class CaptainAvailabilityDtoOutputAvailabilityStateEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'offline')
  static const CaptainAvailabilityDtoOutputAvailabilityStateEnum offline =
      _$captainAvailabilityDtoOutputAvailabilityStateEnum_offline;
  @BuiltValueEnumConst(wireName: r'online_available')
  static const CaptainAvailabilityDtoOutputAvailabilityStateEnum
  onlineAvailable =
      _$captainAvailabilityDtoOutputAvailabilityStateEnum_onlineAvailable;
  @BuiltValueEnumConst(wireName: r'not_receiving_offers')
  static const CaptainAvailabilityDtoOutputAvailabilityStateEnum
  notReceivingOffers =
      _$captainAvailabilityDtoOutputAvailabilityStateEnum_notReceivingOffers;
  @BuiltValueEnumConst(wireName: r'suspended')
  static const CaptainAvailabilityDtoOutputAvailabilityStateEnum suspended =
      _$captainAvailabilityDtoOutputAvailabilityStateEnum_suspended;

  static Serializer<CaptainAvailabilityDtoOutputAvailabilityStateEnum>
  get serializer =>
      _$captainAvailabilityDtoOutputAvailabilityStateEnumSerializer;

  const CaptainAvailabilityDtoOutputAvailabilityStateEnum._(String name)
    : super(name);

  static BuiltSet<CaptainAvailabilityDtoOutputAvailabilityStateEnum>
  get values => _$captainAvailabilityDtoOutputAvailabilityStateEnumValues;
  static CaptainAvailabilityDtoOutputAvailabilityStateEnum valueOf(
    String name,
  ) => _$captainAvailabilityDtoOutputAvailabilityStateEnumValueOf(name);
}

class CaptainAvailabilityDtoOutputAvailabilityReasonsEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'cash_limit')
  static const CaptainAvailabilityDtoOutputAvailabilityReasonsEnum cashLimit =
      _$captainAvailabilityDtoOutputAvailabilityReasonsEnum_cashLimit;
  @BuiltValueEnumConst(wireName: r'closed_due')
  static const CaptainAvailabilityDtoOutputAvailabilityReasonsEnum closedDue =
      _$captainAvailabilityDtoOutputAvailabilityReasonsEnum_closedDue;
  @BuiltValueEnumConst(wireName: r'simulated_location')
  static const CaptainAvailabilityDtoOutputAvailabilityReasonsEnum
  simulatedLocation =
      _$captainAvailabilityDtoOutputAvailabilityReasonsEnum_simulatedLocation;

  static Serializer<CaptainAvailabilityDtoOutputAvailabilityReasonsEnum>
  get serializer =>
      _$captainAvailabilityDtoOutputAvailabilityReasonsEnumSerializer;

  const CaptainAvailabilityDtoOutputAvailabilityReasonsEnum._(String name)
    : super(name);

  static BuiltSet<CaptainAvailabilityDtoOutputAvailabilityReasonsEnum>
  get values => _$captainAvailabilityDtoOutputAvailabilityReasonsEnumValues;
  static CaptainAvailabilityDtoOutputAvailabilityReasonsEnum valueOf(
    String name,
  ) => _$captainAvailabilityDtoOutputAvailabilityReasonsEnumValueOf(name);
}
