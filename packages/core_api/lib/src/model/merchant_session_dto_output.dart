//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_session_dto_output.g.dart';

/// MerchantSessionDtoOutput
///
/// Properties:
/// * [accountId] 
/// * [restaurantId] 
/// * [role] - RA §5.4: what the app shows and the server allows.
/// * [name] 
/// * [deviceNamed] - False on the first sign-in of this device: the app asks for its name (RA §5.2).
/// * [sessionId] 
@BuiltValue()
abstract class MerchantSessionDtoOutput implements Built<MerchantSessionDtoOutput, MerchantSessionDtoOutputBuilder> {
  @BuiltValueField(wireName: r'accountId')
  String get accountId;

  @BuiltValueField(wireName: r'restaurantId')
  String get restaurantId;

  /// RA §5.4: what the app shows and the server allows.
  @BuiltValueField(wireName: r'role')
  MerchantSessionDtoOutputRoleEnum get role;
  // enum roleEnum {  owner,  cashier,  };

  @BuiltValueField(wireName: r'name')
  String get name;

  /// False on the first sign-in of this device: the app asks for its name (RA §5.2).
  @BuiltValueField(wireName: r'deviceNamed')
  bool get deviceNamed;

  @BuiltValueField(wireName: r'sessionId')
  String get sessionId;

  MerchantSessionDtoOutput._();

  factory MerchantSessionDtoOutput([void updates(MerchantSessionDtoOutputBuilder b)]) = _$MerchantSessionDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantSessionDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantSessionDtoOutput> get serializer => _$MerchantSessionDtoOutputSerializer();
}

class _$MerchantSessionDtoOutputSerializer implements PrimitiveSerializer<MerchantSessionDtoOutput> {
  @override
  final Iterable<Type> types = const [MerchantSessionDtoOutput, _$MerchantSessionDtoOutput];

  @override
  final String wireName = r'MerchantSessionDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantSessionDtoOutput object, {
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
      specifiedType: const FullType(MerchantSessionDtoOutputRoleEnum),
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
    yield r'sessionId';
    yield serializers.serialize(
      object.sessionId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantSessionDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MerchantSessionDtoOutputBuilder result,
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
        case r'restaurantId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.restaurantId = valueDes;
          break;
        case r'role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MerchantSessionDtoOutputRoleEnum),
          ) as MerchantSessionDtoOutputRoleEnum;
          result.role = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'deviceNamed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.deviceNamed = valueDes;
          break;
        case r'sessionId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.sessionId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantSessionDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantSessionDtoOutputBuilder();
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
class MerchantSessionDtoOutputRoleEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'owner')
  static const MerchantSessionDtoOutputRoleEnum owner = _$merchantSessionDtoOutputRoleEnum_owner;
  @BuiltValueEnumConst(wireName: r'cashier')
  static const MerchantSessionDtoOutputRoleEnum cashier = _$merchantSessionDtoOutputRoleEnum_cashier;

  static Serializer<MerchantSessionDtoOutputRoleEnum> get serializer => _$merchantSessionDtoOutputRoleEnumSerializer;

  const MerchantSessionDtoOutputRoleEnum._(String name): super(name);

  static BuiltSet<MerchantSessionDtoOutputRoleEnum> get values => _$merchantSessionDtoOutputRoleEnumValues;
  static MerchantSessionDtoOutputRoleEnum valueOf(String name) => _$merchantSessionDtoOutputRoleEnumValueOf(name);
}

