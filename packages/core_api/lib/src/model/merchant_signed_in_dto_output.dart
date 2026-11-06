//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_signed_in_dto_output.g.dart';

/// MerchantSignedInDtoOutput
///
/// Properties:
/// * [accountId]
/// * [restaurantId]
/// * [role] - RA §5.4: what the app shows and the server allows.
/// * [name]
/// * [deviceNamed] - False on the first sign-in of this device: the app asks for its name (RA §5.2).
/// * [accessToken] - A JWT for the Authorization header, valid 15 minutes.
/// * [accessTokenExpiresAt]
/// * [refreshToken] - Used once at /refresh for a new pair; using it twice signs the device out.
@BuiltValue()
abstract class MerchantSignedInDtoOutput
    implements
        Built<MerchantSignedInDtoOutput, MerchantSignedInDtoOutputBuilder> {
  @BuiltValueField(wireName: r'accountId')
  String get accountId;

  @BuiltValueField(wireName: r'restaurantId')
  String get restaurantId;

  /// RA §5.4: what the app shows and the server allows.
  @BuiltValueField(wireName: r'role')
  MerchantSignedInDtoOutputRoleEnum get role;
  // enum roleEnum {  owner,  cashier,  };

  @BuiltValueField(wireName: r'name')
  String get name;

  /// False on the first sign-in of this device: the app asks for its name (RA §5.2).
  @BuiltValueField(wireName: r'deviceNamed')
  bool get deviceNamed;

  /// A JWT for the Authorization header, valid 15 minutes.
  @BuiltValueField(wireName: r'accessToken')
  String get accessToken;

  @BuiltValueField(wireName: r'accessTokenExpiresAt')
  DateTime get accessTokenExpiresAt;

  /// Used once at /refresh for a new pair; using it twice signs the device out.
  @BuiltValueField(wireName: r'refreshToken')
  String get refreshToken;

  MerchantSignedInDtoOutput._();

  factory MerchantSignedInDtoOutput([
    void updates(MerchantSignedInDtoOutputBuilder b),
  ]) = _$MerchantSignedInDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantSignedInDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantSignedInDtoOutput> get serializer =>
      _$MerchantSignedInDtoOutputSerializer();
}

class _$MerchantSignedInDtoOutputSerializer
    implements PrimitiveSerializer<MerchantSignedInDtoOutput> {
  @override
  final Iterable<Type> types = const [
    MerchantSignedInDtoOutput,
    _$MerchantSignedInDtoOutput,
  ];

  @override
  final String wireName = r'MerchantSignedInDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantSignedInDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'accountId';
    yield serializers.serialize(
      object.accountId,
      specifiedType: const FullType(String),
    );
    yield r'restaurantId';
    yield serializers.serialize(
      object.restaurantId,
      specifiedType: const FullType(String),
    );
    yield r'role';
    yield serializers.serialize(
      object.role,
      specifiedType: const FullType(MerchantSignedInDtoOutputRoleEnum),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'deviceNamed';
    yield serializers.serialize(
      object.deviceNamed,
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
    MerchantSignedInDtoOutput object, {
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
    required MerchantSignedInDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'accountId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.accountId = valueDes;
          break;
        case r'restaurantId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.restaurantId = valueDes;
          break;
        case r'role':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      MerchantSignedInDtoOutputRoleEnum,
                    ),
                  )
                  as MerchantSignedInDtoOutputRoleEnum;
          result.role = valueDes;
          break;
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.name = valueDes;
          break;
        case r'deviceNamed':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.deviceNamed = valueDes;
          break;
        case r'accessToken':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.accessToken = valueDes;
          break;
        case r'accessTokenExpiresAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.accessTokenExpiresAt = valueDes;
          break;
        case r'refreshToken':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
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
  MerchantSignedInDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantSignedInDtoOutputBuilder();
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

/// RA §5.4: what the app shows and the server allows.
class MerchantSignedInDtoOutputRoleEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'owner')
  static const MerchantSignedInDtoOutputRoleEnum owner =
      _$merchantSignedInDtoOutputRoleEnum_owner;
  @BuiltValueEnumConst(wireName: r'cashier')
  static const MerchantSignedInDtoOutputRoleEnum cashier =
      _$merchantSignedInDtoOutputRoleEnum_cashier;

  static Serializer<MerchantSignedInDtoOutputRoleEnum> get serializer =>
      _$merchantSignedInDtoOutputRoleEnumSerializer;

  const MerchantSignedInDtoOutputRoleEnum._(String name) : super(name);

  static BuiltSet<MerchantSignedInDtoOutputRoleEnum> get values =>
      _$merchantSignedInDtoOutputRoleEnumValues;
  static MerchantSignedInDtoOutputRoleEnum valueOf(String name) =>
      _$merchantSignedInDtoOutputRoleEnumValueOf(name);
}
