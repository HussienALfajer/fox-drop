//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_portal_code_request_dto.g.dart';

/// MerchantPortalCodeRequestDto
///
/// Properties:
/// * [phone] - The mobile number in E.164: +9639xxxxxxxx or +905xxxxxxxxx.
/// * [browserId] - The browser: a random id the portal keeps, which the code is bound to.
@BuiltValue()
abstract class MerchantPortalCodeRequestDto
    implements
        Built<
          MerchantPortalCodeRequestDto,
          MerchantPortalCodeRequestDtoBuilder
        > {
  /// The mobile number in E.164: +9639xxxxxxxx or +905xxxxxxxxx.
  @BuiltValueField(wireName: r'phone')
  String get phone;

  /// The browser: a random id the portal keeps, which the code is bound to.
  @BuiltValueField(wireName: r'browserId')
  String get browserId;

  MerchantPortalCodeRequestDto._();

  factory MerchantPortalCodeRequestDto([
    void updates(MerchantPortalCodeRequestDtoBuilder b),
  ]) = _$MerchantPortalCodeRequestDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantPortalCodeRequestDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantPortalCodeRequestDto> get serializer =>
      _$MerchantPortalCodeRequestDtoSerializer();
}

class _$MerchantPortalCodeRequestDtoSerializer
    implements PrimitiveSerializer<MerchantPortalCodeRequestDto> {
  @override
  final Iterable<Type> types = const [
    MerchantPortalCodeRequestDto,
    _$MerchantPortalCodeRequestDto,
  ];

  @override
  final String wireName = r'MerchantPortalCodeRequestDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantPortalCodeRequestDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'phone';
    yield serializers.serialize(
      object.phone,
      specifiedType: const FullType(String),
    );
    yield r'browserId';
    yield serializers.serialize(
      object.browserId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantPortalCodeRequestDto object, {
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
    required MerchantPortalCodeRequestDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'phone':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.phone = valueDes;
          break;
        case r'browserId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.browserId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantPortalCodeRequestDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantPortalCodeRequestDtoBuilder();
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
