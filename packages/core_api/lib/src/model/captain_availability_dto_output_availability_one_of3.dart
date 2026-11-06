//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_availability_dto_output_availability_one_of3.g.dart';

/// CaptainAvailabilityDtoOutputAvailabilityOneOf3
///
/// Properties:
/// * [state]
/// * [reason]
/// * [until] - Null: until further notice.
@BuiltValue()
abstract class CaptainAvailabilityDtoOutputAvailabilityOneOf3
    implements
        Built<
          CaptainAvailabilityDtoOutputAvailabilityOneOf3,
          CaptainAvailabilityDtoOutputAvailabilityOneOf3Builder
        > {
  @BuiltValueField(wireName: r'state')
  CaptainAvailabilityDtoOutputAvailabilityOneOf3StateEnum get state;
  // enum stateEnum {  suspended,  };

  @BuiltValueField(wireName: r'reason')
  String get reason;

  /// Null: until further notice.
  @BuiltValueField(wireName: r'until')
  DateTime? get until;

  CaptainAvailabilityDtoOutputAvailabilityOneOf3._();

  factory CaptainAvailabilityDtoOutputAvailabilityOneOf3([
    void updates(CaptainAvailabilityDtoOutputAvailabilityOneOf3Builder b),
  ]) = _$CaptainAvailabilityDtoOutputAvailabilityOneOf3;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CaptainAvailabilityDtoOutputAvailabilityOneOf3Builder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainAvailabilityDtoOutputAvailabilityOneOf3>
  get serializer =>
      _$CaptainAvailabilityDtoOutputAvailabilityOneOf3Serializer();
}

class _$CaptainAvailabilityDtoOutputAvailabilityOneOf3Serializer
    implements
        PrimitiveSerializer<CaptainAvailabilityDtoOutputAvailabilityOneOf3> {
  @override
  final Iterable<Type> types = const [
    CaptainAvailabilityDtoOutputAvailabilityOneOf3,
    _$CaptainAvailabilityDtoOutputAvailabilityOneOf3,
  ];

  @override
  final String wireName = r'CaptainAvailabilityDtoOutputAvailabilityOneOf3';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainAvailabilityDtoOutputAvailabilityOneOf3 object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(
        CaptainAvailabilityDtoOutputAvailabilityOneOf3StateEnum,
      ),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    yield r'until';
    yield object.until == null
        ? null
        : serializers.serialize(
            object.until,
            specifiedType: const FullType.nullable(DateTime),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainAvailabilityDtoOutputAvailabilityOneOf3 object, {
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
    required CaptainAvailabilityDtoOutputAvailabilityOneOf3Builder result,
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
                      CaptainAvailabilityDtoOutputAvailabilityOneOf3StateEnum,
                    ),
                  )
                  as CaptainAvailabilityDtoOutputAvailabilityOneOf3StateEnum;
          result.state = valueDes;
          break;
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.reason = valueDes;
          break;
        case r'until':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.until = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainAvailabilityDtoOutputAvailabilityOneOf3 deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainAvailabilityDtoOutputAvailabilityOneOf3Builder();
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

class CaptainAvailabilityDtoOutputAvailabilityOneOf3StateEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'suspended')
  static const CaptainAvailabilityDtoOutputAvailabilityOneOf3StateEnum
  suspended =
      _$captainAvailabilityDtoOutputAvailabilityOneOf3StateEnum_suspended;

  static Serializer<CaptainAvailabilityDtoOutputAvailabilityOneOf3StateEnum>
  get serializer =>
      _$captainAvailabilityDtoOutputAvailabilityOneOf3StateEnumSerializer;

  const CaptainAvailabilityDtoOutputAvailabilityOneOf3StateEnum._(String name)
    : super(name);

  static BuiltSet<CaptainAvailabilityDtoOutputAvailabilityOneOf3StateEnum>
  get values => _$captainAvailabilityDtoOutputAvailabilityOneOf3StateEnumValues;
  static CaptainAvailabilityDtoOutputAvailabilityOneOf3StateEnum valueOf(
    String name,
  ) => _$captainAvailabilityDtoOutputAvailabilityOneOf3StateEnumValueOf(name);
}
