//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_staff_dto_output_staff_inner.g.dart';

/// MerchantStaffDtoOutputStaffInner
///
/// Properties:
/// * [accountId]
/// * [role]
/// * [name]
/// * [phone] - The number the user signs in with, in E.164.
/// * [devices] - The devices the user is signed in on now.
/// * [lastActiveAt] - The latest session’s last refresh or end; null before any sign-in.
@BuiltValue()
abstract class MerchantStaffDtoOutputStaffInner
    implements
        Built<
          MerchantStaffDtoOutputStaffInner,
          MerchantStaffDtoOutputStaffInnerBuilder
        > {
  @BuiltValueField(wireName: r'accountId')
  String get accountId;

  @BuiltValueField(wireName: r'role')
  MerchantStaffDtoOutputStaffInnerRoleEnum get role;
  // enum roleEnum {  owner,  cashier,  };

  @BuiltValueField(wireName: r'name')
  String get name;

  /// The number the user signs in with, in E.164.
  @BuiltValueField(wireName: r'phone')
  String get phone;

  /// The devices the user is signed in on now.
  @BuiltValueField(wireName: r'devices')
  int get devices;

  /// The latest session’s last refresh or end; null before any sign-in.
  @BuiltValueField(wireName: r'lastActiveAt')
  DateTime? get lastActiveAt;

  MerchantStaffDtoOutputStaffInner._();

  factory MerchantStaffDtoOutputStaffInner([
    void updates(MerchantStaffDtoOutputStaffInnerBuilder b),
  ]) = _$MerchantStaffDtoOutputStaffInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantStaffDtoOutputStaffInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantStaffDtoOutputStaffInner> get serializer =>
      _$MerchantStaffDtoOutputStaffInnerSerializer();
}

class _$MerchantStaffDtoOutputStaffInnerSerializer
    implements PrimitiveSerializer<MerchantStaffDtoOutputStaffInner> {
  @override
  final Iterable<Type> types = const [
    MerchantStaffDtoOutputStaffInner,
    _$MerchantStaffDtoOutputStaffInner,
  ];

  @override
  final String wireName = r'MerchantStaffDtoOutputStaffInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantStaffDtoOutputStaffInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'accountId';
    yield serializers.serialize(
      object.accountId,
      specifiedType: const FullType(String),
    );
    yield r'role';
    yield serializers.serialize(
      object.role,
      specifiedType: const FullType(MerchantStaffDtoOutputStaffInnerRoleEnum),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'phone';
    yield serializers.serialize(
      object.phone,
      specifiedType: const FullType(String),
    );
    yield r'devices';
    yield serializers.serialize(
      object.devices,
      specifiedType: const FullType(int),
    );
    yield r'lastActiveAt';
    yield object.lastActiveAt == null
        ? null
        : serializers.serialize(
            object.lastActiveAt,
            specifiedType: const FullType.nullable(DateTime),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantStaffDtoOutputStaffInner object, {
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
    required MerchantStaffDtoOutputStaffInnerBuilder result,
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
        case r'role':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      MerchantStaffDtoOutputStaffInnerRoleEnum,
                    ),
                  )
                  as MerchantStaffDtoOutputStaffInnerRoleEnum;
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
        case r'phone':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.phone = valueDes;
          break;
        case r'devices':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.devices = valueDes;
          break;
        case r'lastActiveAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.lastActiveAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantStaffDtoOutputStaffInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantStaffDtoOutputStaffInnerBuilder();
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

class MerchantStaffDtoOutputStaffInnerRoleEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'owner')
  static const MerchantStaffDtoOutputStaffInnerRoleEnum owner =
      _$merchantStaffDtoOutputStaffInnerRoleEnum_owner;
  @BuiltValueEnumConst(wireName: r'cashier')
  static const MerchantStaffDtoOutputStaffInnerRoleEnum cashier =
      _$merchantStaffDtoOutputStaffInnerRoleEnum_cashier;

  static Serializer<MerchantStaffDtoOutputStaffInnerRoleEnum> get serializer =>
      _$merchantStaffDtoOutputStaffInnerRoleEnumSerializer;

  const MerchantStaffDtoOutputStaffInnerRoleEnum._(String name) : super(name);

  static BuiltSet<MerchantStaffDtoOutputStaffInnerRoleEnum> get values =>
      _$merchantStaffDtoOutputStaffInnerRoleEnumValues;
  static MerchantStaffDtoOutputStaffInnerRoleEnum valueOf(String name) =>
      _$merchantStaffDtoOutputStaffInnerRoleEnumValueOf(name);
}
