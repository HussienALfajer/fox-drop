//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_signed_in_dto_output.g.dart';

/// CustomerSignedInDtoOutput
///
/// Properties:
/// * [accountId] 
/// * [newAccount] - The app shows «أكمل بياناتك» (CU §5.3).
/// * [accessToken] - A JWT for the Authorization header, valid 15 minutes.
/// * [accessTokenExpiresAt] 
/// * [refreshToken] - Used once at /refresh for a new pair; using it twice signs the device out.
@BuiltValue()
abstract class CustomerSignedInDtoOutput implements Built<CustomerSignedInDtoOutput, CustomerSignedInDtoOutputBuilder> {
  @BuiltValueField(wireName: r'accountId')
  String get accountId;

  /// The app shows «أكمل بياناتك» (CU §5.3).
  @BuiltValueField(wireName: r'newAccount')
  bool get newAccount;

  /// A JWT for the Authorization header, valid 15 minutes.
  @BuiltValueField(wireName: r'accessToken')
  String get accessToken;

  @BuiltValueField(wireName: r'accessTokenExpiresAt')
  DateTime get accessTokenExpiresAt;

  /// Used once at /refresh for a new pair; using it twice signs the device out.
  @BuiltValueField(wireName: r'refreshToken')
  String get refreshToken;

  CustomerSignedInDtoOutput._();

  factory CustomerSignedInDtoOutput([void updates(CustomerSignedInDtoOutputBuilder b)]) = _$CustomerSignedInDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerSignedInDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerSignedInDtoOutput> get serializer => _$CustomerSignedInDtoOutputSerializer();
}

class _$CustomerSignedInDtoOutputSerializer implements PrimitiveSerializer<CustomerSignedInDtoOutput> {
  @override
  final Iterable<Type> types = const [CustomerSignedInDtoOutput, _$CustomerSignedInDtoOutput];

  @override
  final String wireName = r'CustomerSignedInDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerSignedInDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'accountId';
    yield serializers.serialize(
      object.accountId,
      specifiedType: const FullType(String),
    );
    yield r'newAccount';
    yield serializers.serialize(
      object.newAccount,
      specifiedType: const FullType(bool),
    );
    yield r'accessToken';
    yield serializers.serialize(
      object.accessToken,
      specifiedType: const FullType(String),
    );
    yield r'accessTokenExpiresAt';
    yield serializers.serialize(
      object.accessTokenExpiresAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'refreshToken';
    yield serializers.serialize(
      object.refreshToken,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerSignedInDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CustomerSignedInDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'accountId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.accountId = valueDes;
          break;
        case r'newAccount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.newAccount = valueDes;
          break;
        case r'accessToken':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.accessToken = valueDes;
          break;
        case r'accessTokenExpiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.accessTokenExpiresAt = valueDes;
          break;
        case r'refreshToken':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.refreshToken = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerSignedInDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerSignedInDtoOutputBuilder();
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


