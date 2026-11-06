//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_availability_dto_output_availability_one_of1.g.dart';

/// CaptainAvailabilityDtoOutputAvailabilityOneOf1
///
/// Properties:
/// * [state]
/// * [since]
@BuiltValue()
abstract class CaptainAvailabilityDtoOutputAvailabilityOneOf1
    implements
        Built<
          CaptainAvailabilityDtoOutputAvailabilityOneOf1,
          CaptainAvailabilityDtoOutputAvailabilityOneOf1Builder
        > {
  @BuiltValueField(wireName: r'state')
  CaptainAvailabilityDtoOutputAvailabilityOneOf1StateEnum get state;
  // enum stateEnum {  online_available,  };

  @BuiltValueField(wireName: r'since')
  DateTime get since;

  CaptainAvailabilityDtoOutputAvailabilityOneOf1._();

  factory CaptainAvailabilityDtoOutputAvailabilityOneOf1([
    void updates(CaptainAvailabilityDtoOutputAvailabilityOneOf1Builder b),
  ]) = _$CaptainAvailabilityDtoOutputAvailabilityOneOf1;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CaptainAvailabilityDtoOutputAvailabilityOneOf1Builder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainAvailabilityDtoOutputAvailabilityOneOf1>
  get serializer =>
      _$CaptainAvailabilityDtoOutputAvailabilityOneOf1Serializer();
}

class _$CaptainAvailabilityDtoOutputAvailabilityOneOf1Serializer
    implements
        PrimitiveSerializer<CaptainAvailabilityDtoOutputAvailabilityOneOf1> {
  @override
  final Iterable<Type> types = const [
    CaptainAvailabilityDtoOutputAvailabilityOneOf1,
    _$CaptainAvailabilityDtoOutputAvailabilityOneOf1,
  ];

  @override
  final String wireName = r'CaptainAvailabilityDtoOutputAvailabilityOneOf1';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainAvailabilityDtoOutputAvailabilityOneOf1 object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(
        CaptainAvailabilityDtoOutputAvailabilityOneOf1StateEnum,
      ),
    );
    yield r'since';
    yield serializers.serialize(
      object.since,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainAvailabilityDtoOutputAvailabilityOneOf1 object, {
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
    required CaptainAvailabilityDtoOutputAvailabilityOneOf1Builder result,
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
                      CaptainAvailabilityDtoOutputAvailabilityOneOf1StateEnum,
                    ),
                  )
                  as CaptainAvailabilityDtoOutputAvailabilityOneOf1StateEnum;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainAvailabilityDtoOutputAvailabilityOneOf1 deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainAvailabilityDtoOutputAvailabilityOneOf1Builder();
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

class CaptainAvailabilityDtoOutputAvailabilityOneOf1StateEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'online_available')
  static const CaptainAvailabilityDtoOutputAvailabilityOneOf1StateEnum
  onlineAvailable =
      _$captainAvailabilityDtoOutputAvailabilityOneOf1StateEnum_onlineAvailable;

  static Serializer<CaptainAvailabilityDtoOutputAvailabilityOneOf1StateEnum>
  get serializer =>
      _$captainAvailabilityDtoOutputAvailabilityOneOf1StateEnumSerializer;

  const CaptainAvailabilityDtoOutputAvailabilityOneOf1StateEnum._(String name)
    : super(name);

  static BuiltSet<CaptainAvailabilityDtoOutputAvailabilityOneOf1StateEnum>
  get values => _$captainAvailabilityDtoOutputAvailabilityOneOf1StateEnumValues;
  static CaptainAvailabilityDtoOutputAvailabilityOneOf1StateEnum valueOf(
    String name,
  ) => _$captainAvailabilityDtoOutputAvailabilityOneOf1StateEnumValueOf(name);
}
