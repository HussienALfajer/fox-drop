//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_application_dto_output_offboarding.g.dart';

/// «إنهاء التعاقد» and its checklist (AP §9.7.5, slice 2.35b).
///
/// Properties:
/// * [terminatedAt]
/// * [terminatedBy]
/// * [reason]
/// * [earlyExit] - Ended in «فترة التزام»: the flag «خروج مبكر».
/// * [kitReturned] - Step 1; null until checked.
/// * [custodyZero] - Step 2: every custody currency at zero.
/// * [earningsZero] - Step 3: the earnings settled.
/// * [depositHeld] - Minor units in the city’s base still held.
/// * [depositSettled] - Step 4, at the desk.
/// * [missing] - What «إغلاق الحساب» waits for.
/// * [endedAt] - Step 5: the account closed.
@BuiltValue()
abstract class AdminCaptainApplicationDtoOutputOffboarding
    implements
        Built<
          AdminCaptainApplicationDtoOutputOffboarding,
          AdminCaptainApplicationDtoOutputOffboardingBuilder
        > {
  @BuiltValueField(wireName: r'terminatedAt')
  DateTime get terminatedAt;

  @BuiltValueField(wireName: r'terminatedBy')
  String? get terminatedBy;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  /// Ended in «فترة التزام»: the flag «خروج مبكر».
  @BuiltValueField(wireName: r'earlyExit')
  bool get earlyExit;

  /// Step 1; null until checked.
  @BuiltValueField(wireName: r'kitReturned')
  bool? get kitReturned;

  /// Step 2: every custody currency at zero.
  @BuiltValueField(wireName: r'custodyZero')
  bool get custodyZero;

  /// Step 3: the earnings settled.
  @BuiltValueField(wireName: r'earningsZero')
  bool get earningsZero;

  /// Minor units in the city’s base still held.
  @BuiltValueField(wireName: r'depositHeld')
  String get depositHeld;

  /// Step 4, at the desk.
  @BuiltValueField(wireName: r'depositSettled')
  AdminCaptainApplicationDtoOutputOffboardingDepositSettledEnum?
  get depositSettled;
  // enum depositSettledEnum {  refunded,  withheld,  };

  /// What «إغلاق الحساب» waits for.
  @BuiltValueField(wireName: r'missing')
  BuiltList<AdminCaptainApplicationDtoOutputOffboardingMissingEnum> get missing;
  // enum missingEnum {  kit,  custody,  earnings,  deposit,  };

  /// Step 5: the account closed.
  @BuiltValueField(wireName: r'endedAt')
  DateTime? get endedAt;

  AdminCaptainApplicationDtoOutputOffboarding._();

  factory AdminCaptainApplicationDtoOutputOffboarding([
    void updates(AdminCaptainApplicationDtoOutputOffboardingBuilder b),
  ]) = _$AdminCaptainApplicationDtoOutputOffboarding;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCaptainApplicationDtoOutputOffboardingBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainApplicationDtoOutputOffboarding>
  get serializer => _$AdminCaptainApplicationDtoOutputOffboardingSerializer();
}

class _$AdminCaptainApplicationDtoOutputOffboardingSerializer
    implements
        PrimitiveSerializer<AdminCaptainApplicationDtoOutputOffboarding> {
  @override
  final Iterable<Type> types = const [
    AdminCaptainApplicationDtoOutputOffboarding,
    _$AdminCaptainApplicationDtoOutputOffboarding,
  ];

  @override
  final String wireName = r'AdminCaptainApplicationDtoOutputOffboarding';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainApplicationDtoOutputOffboarding object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'terminatedAt';
    yield serializers.serialize(
      object.terminatedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'terminatedBy';
    yield object.terminatedBy == null
        ? null
        : serializers.serialize(
            object.terminatedBy,
            specifiedType: const FullType.nullable(String),
          );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    yield r'earlyExit';
    yield serializers.serialize(
      object.earlyExit,
      specifiedType: const FullType(bool),
    );
    yield r'kitReturned';
    yield object.kitReturned == null
        ? null
        : serializers.serialize(
            object.kitReturned,
            specifiedType: const FullType.nullable(bool),
          );
    yield r'custodyZero';
    yield serializers.serialize(
      object.custodyZero,
      specifiedType: const FullType(bool),
    );
    yield r'earningsZero';
    yield serializers.serialize(
      object.earningsZero,
      specifiedType: const FullType(bool),
    );
    yield r'depositHeld';
    yield serializers.serialize(
      object.depositHeld,
      specifiedType: const FullType(String),
    );
    yield r'depositSettled';
    yield object.depositSettled == null
        ? null
        : serializers.serialize(
            object.depositSettled,
            specifiedType: const FullType.nullable(
              AdminCaptainApplicationDtoOutputOffboardingDepositSettledEnum,
            ),
          );
    yield r'missing';
    yield serializers.serialize(
      object.missing,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminCaptainApplicationDtoOutputOffboardingMissingEnum),
      ]),
    );
    yield r'endedAt';
    yield object.endedAt == null
        ? null
        : serializers.serialize(
            object.endedAt,
            specifiedType: const FullType.nullable(DateTime),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainApplicationDtoOutputOffboarding object, {
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
    required AdminCaptainApplicationDtoOutputOffboardingBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'terminatedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.terminatedAt = valueDes;
          break;
        case r'terminatedBy':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.terminatedBy = valueDes;
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
        case r'earlyExit':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.earlyExit = valueDes;
          break;
        case r'kitReturned':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(bool),
                  )
                  as bool?;
          if (valueDes == null) continue;
          result.kitReturned = valueDes;
          break;
        case r'custodyZero':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.custodyZero = valueDes;
          break;
        case r'earningsZero':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.earningsZero = valueDes;
          break;
        case r'depositHeld':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.depositHeld = valueDes;
          break;
        case r'depositSettled':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminCaptainApplicationDtoOutputOffboardingDepositSettledEnum,
                    ),
                  )
                  as AdminCaptainApplicationDtoOutputOffboardingDepositSettledEnum?;
          if (valueDes == null) continue;
          result.depositSettled = valueDes;
          break;
        case r'missing':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        AdminCaptainApplicationDtoOutputOffboardingMissingEnum,
                      ),
                    ]),
                  )
                  as BuiltList<
                    AdminCaptainApplicationDtoOutputOffboardingMissingEnum
                  >;
          result.missing.replace(valueDes);
          break;
        case r'endedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.endedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCaptainApplicationDtoOutputOffboarding deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainApplicationDtoOutputOffboardingBuilder();
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

/// Step 4, at the desk.
class AdminCaptainApplicationDtoOutputOffboardingDepositSettledEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'refunded')
  static const AdminCaptainApplicationDtoOutputOffboardingDepositSettledEnum
  refunded =
      _$adminCaptainApplicationDtoOutputOffboardingDepositSettledEnum_refunded;
  @BuiltValueEnumConst(wireName: r'withheld')
  static const AdminCaptainApplicationDtoOutputOffboardingDepositSettledEnum
  withheld =
      _$adminCaptainApplicationDtoOutputOffboardingDepositSettledEnum_withheld;

  static Serializer<
    AdminCaptainApplicationDtoOutputOffboardingDepositSettledEnum
  >
  get serializer =>
      _$adminCaptainApplicationDtoOutputOffboardingDepositSettledEnumSerializer;

  const AdminCaptainApplicationDtoOutputOffboardingDepositSettledEnum._(
    String name,
  ) : super(name);

  static BuiltSet<AdminCaptainApplicationDtoOutputOffboardingDepositSettledEnum>
  get values =>
      _$adminCaptainApplicationDtoOutputOffboardingDepositSettledEnumValues;
  static AdminCaptainApplicationDtoOutputOffboardingDepositSettledEnum valueOf(
    String name,
  ) => _$adminCaptainApplicationDtoOutputOffboardingDepositSettledEnumValueOf(
    name,
  );
}

class AdminCaptainApplicationDtoOutputOffboardingMissingEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'kit')
  static const AdminCaptainApplicationDtoOutputOffboardingMissingEnum kit =
      _$adminCaptainApplicationDtoOutputOffboardingMissingEnum_kit;
  @BuiltValueEnumConst(wireName: r'custody')
  static const AdminCaptainApplicationDtoOutputOffboardingMissingEnum custody =
      _$adminCaptainApplicationDtoOutputOffboardingMissingEnum_custody;
  @BuiltValueEnumConst(wireName: r'earnings')
  static const AdminCaptainApplicationDtoOutputOffboardingMissingEnum earnings =
      _$adminCaptainApplicationDtoOutputOffboardingMissingEnum_earnings;
  @BuiltValueEnumConst(wireName: r'deposit')
  static const AdminCaptainApplicationDtoOutputOffboardingMissingEnum deposit =
      _$adminCaptainApplicationDtoOutputOffboardingMissingEnum_deposit;

  static Serializer<AdminCaptainApplicationDtoOutputOffboardingMissingEnum>
  get serializer =>
      _$adminCaptainApplicationDtoOutputOffboardingMissingEnumSerializer;

  const AdminCaptainApplicationDtoOutputOffboardingMissingEnum._(String name)
    : super(name);

  static BuiltSet<AdminCaptainApplicationDtoOutputOffboardingMissingEnum>
  get values => _$adminCaptainApplicationDtoOutputOffboardingMissingEnumValues;
  static AdminCaptainApplicationDtoOutputOffboardingMissingEnum valueOf(
    String name,
  ) => _$adminCaptainApplicationDtoOutputOffboardingMissingEnumValueOf(name);
}
