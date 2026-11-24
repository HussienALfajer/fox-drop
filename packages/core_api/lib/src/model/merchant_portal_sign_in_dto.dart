//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_portal_sign_in_dto.g.dart';

/// MerchantPortalSignInDto
///
/// Properties:
/// * [phone] - The mobile number in E.164, of any country (CU U3), such as +963944123456; a landline is refused.
/// * [browserId] - The browser: a random id the portal keeps, which the code is bound to.
/// * [code]
@BuiltValue()
abstract class MerchantPortalSignInDto
    implements Built<MerchantPortalSignInDto, MerchantPortalSignInDtoBuilder> {
  /// The mobile number in E.164, of any country (CU U3), such as +963944123456; a landline is refused.
  @BuiltValueField(wireName: r'phone')
  String get phone;

  /// The browser: a random id the portal keeps, which the code is bound to.
  @BuiltValueField(wireName: r'browserId')
  String get browserId;

  @BuiltValueField(wireName: r'code')
  String get code;

  MerchantPortalSignInDto._();

  factory MerchantPortalSignInDto([
    void updates(MerchantPortalSignInDtoBuilder b),
  ]) = _$MerchantPortalSignInDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantPortalSignInDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantPortalSignInDto> get serializer =>
      _$MerchantPortalSignInDtoSerializer();
}

class _$MerchantPortalSignInDtoSerializer
    implements PrimitiveSerializer<MerchantPortalSignInDto> {
  @override
  final Iterable<Type> types = const [
    MerchantPortalSignInDto,
    _$MerchantPortalSignInDto,
  ];

  @override
  final String wireName = r'MerchantPortalSignInDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantPortalSignInDto object, {
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
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantPortalSignInDto object, {
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
    required MerchantPortalSignInDtoBuilder result,
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
        case r'code':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.code = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantPortalSignInDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantPortalSignInDtoBuilder();
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
