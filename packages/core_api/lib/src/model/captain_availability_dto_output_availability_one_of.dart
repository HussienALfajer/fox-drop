//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_availability_dto_output_availability_one_of.g.dart';

/// CaptainAvailabilityDtoOutputAvailabilityOneOf
///
/// Properties:
/// * [state]
@BuiltValue()
abstract class CaptainAvailabilityDtoOutputAvailabilityOneOf
    implements
        Built<
          CaptainAvailabilityDtoOutputAvailabilityOneOf,
          CaptainAvailabilityDtoOutputAvailabilityOneOfBuilder
        > {
  @BuiltValueField(wireName: r'state')
  CaptainAvailabilityDtoOutputAvailabilityOneOfStateEnum get state;
  // enum stateEnum {  offline,  };

  CaptainAvailabilityDtoOutputAvailabilityOneOf._();

  factory CaptainAvailabilityDtoOutputAvailabilityOneOf([
    void updates(CaptainAvailabilityDtoOutputAvailabilityOneOfBuilder b),
  ]) = _$CaptainAvailabilityDtoOutputAvailabilityOneOf;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CaptainAvailabilityDtoOutputAvailabilityOneOfBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainAvailabilityDtoOutputAvailabilityOneOf>
  get serializer => _$CaptainAvailabilityDtoOutputAvailabilityOneOfSerializer();
}

class _$CaptainAvailabilityDtoOutputAvailabilityOneOfSerializer
    implements
        PrimitiveSerializer<CaptainAvailabilityDtoOutputAvailabilityOneOf> {
  @override
  final Iterable<Type> types = const [
    CaptainAvailabilityDtoOutputAvailabilityOneOf,
    _$CaptainAvailabilityDtoOutputAvailabilityOneOf,
  ];

  @override
  final String wireName = r'CaptainAvailabilityDtoOutputAvailabilityOneOf';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainAvailabilityDtoOutputAvailabilityOneOf object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(
        CaptainAvailabilityDtoOutputAvailabilityOneOfStateEnum,
      ),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainAvailabilityDtoOutputAvailabilityOneOf object, {
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
    required CaptainAvailabilityDtoOutputAvailabilityOneOfBuilder result,
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
                      CaptainAvailabilityDtoOutputAvailabilityOneOfStateEnum,
                    ),
                  )
                  as CaptainAvailabilityDtoOutputAvailabilityOneOfStateEnum;
          result.state = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainAvailabilityDtoOutputAvailabilityOneOf deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainAvailabilityDtoOutputAvailabilityOneOfBuilder();
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

class CaptainAvailabilityDtoOutputAvailabilityOneOfStateEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'offline')
  static const CaptainAvailabilityDtoOutputAvailabilityOneOfStateEnum offline =
      _$captainAvailabilityDtoOutputAvailabilityOneOfStateEnum_offline;

  static Serializer<CaptainAvailabilityDtoOutputAvailabilityOneOfStateEnum>
  get serializer =>
      _$captainAvailabilityDtoOutputAvailabilityOneOfStateEnumSerializer;

  const CaptainAvailabilityDtoOutputAvailabilityOneOfStateEnum._(String name)
    : super(name);

  static BuiltSet<CaptainAvailabilityDtoOutputAvailabilityOneOfStateEnum>
  get values => _$captainAvailabilityDtoOutputAvailabilityOneOfStateEnumValues;
  static CaptainAvailabilityDtoOutputAvailabilityOneOfStateEnum valueOf(
    String name,
  ) => _$captainAvailabilityDtoOutputAvailabilityOneOfStateEnumValueOf(name);
}
