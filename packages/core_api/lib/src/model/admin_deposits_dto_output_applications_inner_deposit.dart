//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_ticket_page_dto_output_pickup_dispute_pickup_payment.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_deposits_dto_output_applications_inner_deposit.g.dart';

/// AdminDepositsDtoOutputApplicationsInnerDeposit
///
/// Properties:
/// * [amount]
/// * [instalment]
/// * [paid] - Paid so far, in the city's base.
/// * [recorded] - As «تفعيل» counts it: with instalments or paid in full.
@BuiltValue()
abstract class AdminDepositsDtoOutputApplicationsInnerDeposit
    implements
        Built<
          AdminDepositsDtoOutputApplicationsInnerDeposit,
          AdminDepositsDtoOutputApplicationsInnerDepositBuilder
        > {
  @BuiltValueField(wireName: r'amount')
  AdminTicketPageDtoOutputPickupDisputePickupPayment? get amount;

  @BuiltValueField(wireName: r'instalment')
  AdminTicketPageDtoOutputPickupDisputePickupPayment? get instalment;

  /// Paid so far, in the city's base.
  @BuiltValueField(wireName: r'paid')
  String get paid;

  /// As «تفعيل» counts it: with instalments or paid in full.
  @BuiltValueField(wireName: r'recorded')
  bool get recorded;

  AdminDepositsDtoOutputApplicationsInnerDeposit._();

  factory AdminDepositsDtoOutputApplicationsInnerDeposit([
    void updates(AdminDepositsDtoOutputApplicationsInnerDepositBuilder b),
  ]) = _$AdminDepositsDtoOutputApplicationsInnerDeposit;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminDepositsDtoOutputApplicationsInnerDepositBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDepositsDtoOutputApplicationsInnerDeposit>
  get serializer =>
      _$AdminDepositsDtoOutputApplicationsInnerDepositSerializer();
}

class _$AdminDepositsDtoOutputApplicationsInnerDepositSerializer
    implements
        PrimitiveSerializer<AdminDepositsDtoOutputApplicationsInnerDeposit> {
  @override
  final Iterable<Type> types = const [
    AdminDepositsDtoOutputApplicationsInnerDeposit,
    _$AdminDepositsDtoOutputApplicationsInnerDeposit,
  ];

  @override
  final String wireName = r'AdminDepositsDtoOutputApplicationsInnerDeposit';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDepositsDtoOutputApplicationsInnerDeposit object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'amount';
    yield object.amount == null
        ? null
        : serializers.serialize(
            object.amount,
            specifiedType: const FullType.nullable(
              AdminTicketPageDtoOutputPickupDisputePickupPayment,
            ),
          );
    yield r'instalment';
    yield object.instalment == null
        ? null
        : serializers.serialize(
            object.instalment,
            specifiedType: const FullType.nullable(
              AdminTicketPageDtoOutputPickupDisputePickupPayment,
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
    AdminDepositsDtoOutputApplicationsInnerDeposit object, {
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
    required AdminDepositsDtoOutputApplicationsInnerDepositBuilder result,
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
                      AdminTicketPageDtoOutputPickupDisputePickupPayment,
                    ),
                  )
                  as AdminTicketPageDtoOutputPickupDisputePickupPayment?;
          if (valueDes == null) continue;
          result.amount.replace(valueDes);
          break;
        case r'instalment':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminTicketPageDtoOutputPickupDisputePickupPayment,
                    ),
                  )
                  as AdminTicketPageDtoOutputPickupDisputePickupPayment?;
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
  AdminDepositsDtoOutputApplicationsInnerDeposit deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDepositsDtoOutputApplicationsInnerDepositBuilder();
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
