//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_captain_application_dto_output_activation_kit.dart';
import 'package:core_api/src/model/admin_captain_application_dto_output_activation_cash_limit.dart';
import 'package:core_api/src/model/admin_captain_application_dto_output_activation_missing_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_captain_application_dto_output_activation_contract.dart';
import 'package:core_api/src/model/admin_captain_application_dto_output_activation_deposit.dart';
import 'package:core_api/src/model/admin_captain_application_dto_output_activation_suggested_cash_limit.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_application_dto_output_activation.g.dart';

/// «بانتظار العدة» and «تفعيل» (slice 2.35a).
///
/// Properties:
/// * [kit]
/// * [cashLimit]
/// * [suggestedCashLimit]
/// * [contract]
/// * [deposit]
/// * [suggestedDeposit]
/// * [missing] - What «تفعيل» still waits for.
/// * [captainId]
/// * [activatedAt]
@BuiltValue()
abstract class AdminCaptainApplicationDtoOutputActivation
    implements
        Built<
          AdminCaptainApplicationDtoOutputActivation,
          AdminCaptainApplicationDtoOutputActivationBuilder
        > {
  @BuiltValueField(wireName: r'kit')
  AdminCaptainApplicationDtoOutputActivationKit? get kit;

  @BuiltValueField(wireName: r'cashLimit')
  AdminCaptainApplicationDtoOutputActivationCashLimit? get cashLimit;

  @BuiltValueField(wireName: r'suggestedCashLimit')
  AdminCaptainApplicationDtoOutputActivationSuggestedCashLimit?
  get suggestedCashLimit;

  @BuiltValueField(wireName: r'contract')
  AdminCaptainApplicationDtoOutputActivationContract? get contract;

  @BuiltValueField(wireName: r'deposit')
  AdminCaptainApplicationDtoOutputActivationDeposit get deposit;

  @BuiltValueField(wireName: r'suggestedDeposit')
  AdminCaptainApplicationDtoOutputActivationSuggestedCashLimit?
  get suggestedDeposit;

  /// What «تفعيل» still waits for.
  @BuiltValueField(wireName: r'missing')
  BuiltList<AdminCaptainApplicationDtoOutputActivationMissingInner> get missing;

  @BuiltValueField(wireName: r'captainId')
  String? get captainId;

  @BuiltValueField(wireName: r'activatedAt')
  DateTime? get activatedAt;

  AdminCaptainApplicationDtoOutputActivation._();

  factory AdminCaptainApplicationDtoOutputActivation([
    void updates(AdminCaptainApplicationDtoOutputActivationBuilder b),
  ]) = _$AdminCaptainApplicationDtoOutputActivation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCaptainApplicationDtoOutputActivationBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainApplicationDtoOutputActivation>
  get serializer => _$AdminCaptainApplicationDtoOutputActivationSerializer();
}

class _$AdminCaptainApplicationDtoOutputActivationSerializer
    implements PrimitiveSerializer<AdminCaptainApplicationDtoOutputActivation> {
  @override
  final Iterable<Type> types = const [
    AdminCaptainApplicationDtoOutputActivation,
    _$AdminCaptainApplicationDtoOutputActivation,
  ];

  @override
  final String wireName = r'AdminCaptainApplicationDtoOutputActivation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainApplicationDtoOutputActivation object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'kit';
    yield object.kit == null
        ? null
        : serializers.serialize(
            object.kit,
            specifiedType: const FullType.nullable(
              AdminCaptainApplicationDtoOutputActivationKit,
            ),
          );
    yield r'cashLimit';
    yield object.cashLimit == null
        ? null
        : serializers.serialize(
            object.cashLimit,
            specifiedType: const FullType.nullable(
              AdminCaptainApplicationDtoOutputActivationCashLimit,
            ),
          );
    yield r'suggestedCashLimit';
    yield object.suggestedCashLimit == null
        ? null
        : serializers.serialize(
            object.suggestedCashLimit,
            specifiedType: const FullType.nullable(
              AdminCaptainApplicationDtoOutputActivationSuggestedCashLimit,
            ),
          );
    yield r'contract';
    yield object.contract == null
        ? null
        : serializers.serialize(
            object.contract,
            specifiedType: const FullType.nullable(
              AdminCaptainApplicationDtoOutputActivationContract,
            ),
          );
    yield r'deposit';
    yield serializers.serialize(
      object.deposit,
      specifiedType: const FullType(
        AdminCaptainApplicationDtoOutputActivationDeposit,
      ),
    );
    yield r'suggestedDeposit';
    yield object.suggestedDeposit == null
        ? null
        : serializers.serialize(
            object.suggestedDeposit,
            specifiedType: const FullType.nullable(
              AdminCaptainApplicationDtoOutputActivationSuggestedCashLimit,
            ),
          );
    yield r'missing';
    yield serializers.serialize(
      object.missing,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminCaptainApplicationDtoOutputActivationMissingInner),
      ]),
    );
    yield r'captainId';
    yield object.captainId == null
        ? null
        : serializers.serialize(
            object.captainId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'activatedAt';
    yield object.activatedAt == null
        ? null
        : serializers.serialize(
            object.activatedAt,
            specifiedType: const FullType.nullable(DateTime),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainApplicationDtoOutputActivation object, {
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
    required AdminCaptainApplicationDtoOutputActivationBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'kit':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminCaptainApplicationDtoOutputActivationKit,
                    ),
                  )
                  as AdminCaptainApplicationDtoOutputActivationKit?;
          if (valueDes == null) continue;
          result.kit.replace(valueDes);
          break;
        case r'cashLimit':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminCaptainApplicationDtoOutputActivationCashLimit,
                    ),
                  )
                  as AdminCaptainApplicationDtoOutputActivationCashLimit?;
          if (valueDes == null) continue;
          result.cashLimit.replace(valueDes);
          break;
        case r'suggestedCashLimit':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminCaptainApplicationDtoOutputActivationSuggestedCashLimit,
                    ),
                  )
                  as AdminCaptainApplicationDtoOutputActivationSuggestedCashLimit?;
          if (valueDes == null) continue;
          result.suggestedCashLimit.replace(valueDes);
          break;
        case r'contract':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminCaptainApplicationDtoOutputActivationContract,
                    ),
                  )
                  as AdminCaptainApplicationDtoOutputActivationContract?;
          if (valueDes == null) continue;
          result.contract.replace(valueDes);
          break;
        case r'deposit':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCaptainApplicationDtoOutputActivationDeposit,
                    ),
                  )
                  as AdminCaptainApplicationDtoOutputActivationDeposit;
          result.deposit.replace(valueDes);
          break;
        case r'suggestedDeposit':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminCaptainApplicationDtoOutputActivationSuggestedCashLimit,
                    ),
                  )
                  as AdminCaptainApplicationDtoOutputActivationSuggestedCashLimit?;
          if (valueDes == null) continue;
          result.suggestedDeposit.replace(valueDes);
          break;
        case r'missing':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        AdminCaptainApplicationDtoOutputActivationMissingInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    AdminCaptainApplicationDtoOutputActivationMissingInner
                  >;
          result.missing.replace(valueDes);
          break;
        case r'captainId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.captainId = valueDes;
          break;
        case r'activatedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.activatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCaptainApplicationDtoOutputActivation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainApplicationDtoOutputActivationBuilder();
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
