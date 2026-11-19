//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_captain_application_dto_output_activation_cash_limit.dart';
import 'package:core_api/src/model/admin_captain_application_dto_output_activation_suggested_cash_limit.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_application_dto_output_activation_deposit.g.dart';

/// AdminCaptainApplicationDtoOutputActivationDeposit
///
/// Properties:
/// * [amount]
/// * [instalment]
/// * [paid] - Minor units in the city’s base, paid at the desk.
/// * [recorded]
@BuiltValue()
abstract class AdminCaptainApplicationDtoOutputActivationDeposit
    implements
        Built<
          AdminCaptainApplicationDtoOutputActivationDeposit,
          AdminCaptainApplicationDtoOutputActivationDepositBuilder
        > {
  @BuiltValueField(wireName: r'amount')
  AdminCaptainApplicationDtoOutputActivationCashLimit? get amount;

  @BuiltValueField(wireName: r'instalment')
  AdminCaptainApplicationDtoOutputActivationSuggestedCashLimit? get instalment;

  /// Minor units in the city’s base, paid at the desk.
  @BuiltValueField(wireName: r'paid')
  String get paid;

  @BuiltValueField(wireName: r'recorded')
  bool get recorded;

  AdminCaptainApplicationDtoOutputActivationDeposit._();

  factory AdminCaptainApplicationDtoOutputActivationDeposit([
    void updates(AdminCaptainApplicationDtoOutputActivationDepositBuilder b),
  ]) = _$AdminCaptainApplicationDtoOutputActivationDeposit;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminCaptainApplicationDtoOutputActivationDepositBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainApplicationDtoOutputActivationDeposit>
  get serializer =>
      _$AdminCaptainApplicationDtoOutputActivationDepositSerializer();
}

class _$AdminCaptainApplicationDtoOutputActivationDepositSerializer
    implements
        PrimitiveSerializer<AdminCaptainApplicationDtoOutputActivationDeposit> {
  @override
  final Iterable<Type> types = const [
    AdminCaptainApplicationDtoOutputActivationDeposit,
    _$AdminCaptainApplicationDtoOutputActivationDeposit,
  ];

  @override
  final String wireName = r'AdminCaptainApplicationDtoOutputActivationDeposit';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainApplicationDtoOutputActivationDeposit object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'amount';
    yield object.amount == null
        ? null
        : serializers.serialize(
            object.amount,
            specifiedType: const FullType.nullable(
              AdminCaptainApplicationDtoOutputActivationCashLimit,
            ),
          );
    yield r'instalment';
    yield object.instalment == null
        ? null
        : serializers.serialize(
            object.instalment,
            specifiedType: const FullType.nullable(
              AdminCaptainApplicationDtoOutputActivationSuggestedCashLimit,
            ),
          );
    yield r'paid';
    yield serializers.serialize(
      object.paid,
      specifiedType: const FullType(String),
    );
    yield r'recorded';
    yield serializers.serialize(
      object.recorded,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainApplicationDtoOutputActivationDeposit object, {
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
    required AdminCaptainApplicationDtoOutputActivationDepositBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'amount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminCaptainApplicationDtoOutputActivationCashLimit,
                    ),
                  )
                  as AdminCaptainApplicationDtoOutputActivationCashLimit?;
          if (valueDes == null) continue;
          result.amount.replace(valueDes);
          break;
        case r'instalment':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminCaptainApplicationDtoOutputActivationSuggestedCashLimit,
                    ),
                  )
                  as AdminCaptainApplicationDtoOutputActivationSuggestedCashLimit?;
          if (valueDes == null) continue;
          result.instalment.replace(valueDes);
          break;
        case r'paid':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.paid = valueDes;
          break;
        case r'recorded':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.recorded = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCaptainApplicationDtoOutputActivationDeposit deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainApplicationDtoOutputActivationDepositBuilder();
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
