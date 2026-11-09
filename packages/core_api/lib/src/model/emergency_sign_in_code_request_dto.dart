//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'emergency_sign_in_code_request_dto.g.dart';

/// EmergencySignInCodeRequestDto
///
/// Properties:
/// * [party] - The captain app or the restaurant app; customers are not covered.
/// * [phone] - The mobile number in E.164: +9639xxxxxxxx or +905xxxxxxxxx.
/// * [reason] - Why, kept in the audit log (owner decision 2026-11-07).
@BuiltValue()
abstract class EmergencySignInCodeRequestDto
    implements
        Built<
          EmergencySignInCodeRequestDto,
          EmergencySignInCodeRequestDtoBuilder
        > {
  /// The captain app or the restaurant app; customers are not covered.
  @BuiltValueField(wireName: r'party')
  EmergencySignInCodeRequestDtoPartyEnum get party;
  // enum partyEnum {  captain,  merchant,  };

  /// The mobile number in E.164: +9639xxxxxxxx or +905xxxxxxxxx.
  @BuiltValueField(wireName: r'phone')
  String get phone;

  /// Why, kept in the audit log (owner decision 2026-11-07).
  @BuiltValueField(wireName: r'reason')
  String get reason;

  EmergencySignInCodeRequestDto._();

  factory EmergencySignInCodeRequestDto([
    void updates(EmergencySignInCodeRequestDtoBuilder b),
  ]) = _$EmergencySignInCodeRequestDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EmergencySignInCodeRequestDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EmergencySignInCodeRequestDto> get serializer =>
      _$EmergencySignInCodeRequestDtoSerializer();
}

class _$EmergencySignInCodeRequestDtoSerializer
    implements PrimitiveSerializer<EmergencySignInCodeRequestDto> {
  @override
  final Iterable<Type> types = const [
    EmergencySignInCodeRequestDto,
    _$EmergencySignInCodeRequestDto,
  ];

  @override
  final String wireName = r'EmergencySignInCodeRequestDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EmergencySignInCodeRequestDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'party';
    yield serializers.serialize(
      object.party,
      specifiedType: const FullType(EmergencySignInCodeRequestDtoPartyEnum),
    );
    yield r'phone';
    yield serializers.serialize(
      object.phone,
      specifiedType: const FullType(String),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    EmergencySignInCodeRequestDto object, {
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
    required EmergencySignInCodeRequestDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'party':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      EmergencySignInCodeRequestDtoPartyEnum,
                    ),
                  )
                  as EmergencySignInCodeRequestDtoPartyEnum;
          result.party = valueDes;
          break;
        case r'phone':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.phone = valueDes;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EmergencySignInCodeRequestDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EmergencySignInCodeRequestDtoBuilder();
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

/// The captain app or the restaurant app; customers are not covered.
class EmergencySignInCodeRequestDtoPartyEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'captain')
  static const EmergencySignInCodeRequestDtoPartyEnum captain =
      _$emergencySignInCodeRequestDtoPartyEnum_captain;
  @BuiltValueEnumConst(wireName: r'merchant')
  static const EmergencySignInCodeRequestDtoPartyEnum merchant =
      _$emergencySignInCodeRequestDtoPartyEnum_merchant;

  static Serializer<EmergencySignInCodeRequestDtoPartyEnum> get serializer =>
      _$emergencySignInCodeRequestDtoPartyEnumSerializer;

  const EmergencySignInCodeRequestDtoPartyEnum._(String name) : super(name);

  static BuiltSet<EmergencySignInCodeRequestDtoPartyEnum> get values =>
      _$emergencySignInCodeRequestDtoPartyEnumValues;
  static EmergencySignInCodeRequestDtoPartyEnum valueOf(String name) =>
      _$emergencySignInCodeRequestDtoPartyEnumValueOf(name);
}
