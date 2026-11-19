//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_ticket_page_dto_output_pickup_dispute_pickup_payment.dart';
import 'package:core_api/src/model/admin_deposits_dto_output_applications_inner_deposit.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_deposits_dto_output_applications_inner.g.dart';

/// AdminDepositsDtoOutputApplicationsInner
///
/// Properties:
/// * [applicationId]
/// * [fullName]
/// * [deposit]
/// * [suggested]
@BuiltValue()
abstract class AdminDepositsDtoOutputApplicationsInner
    implements
        Built<
          AdminDepositsDtoOutputApplicationsInner,
          AdminDepositsDtoOutputApplicationsInnerBuilder
        > {
  @BuiltValueField(wireName: r'applicationId')
  String get applicationId;

  @BuiltValueField(wireName: r'fullName')
  String get fullName;

  @BuiltValueField(wireName: r'deposit')
  AdminDepositsDtoOutputApplicationsInnerDeposit get deposit;

  @BuiltValueField(wireName: r'suggested')
  AdminTicketPageDtoOutputPickupDisputePickupPayment? get suggested;

  AdminDepositsDtoOutputApplicationsInner._();

  factory AdminDepositsDtoOutputApplicationsInner([
    void updates(AdminDepositsDtoOutputApplicationsInnerBuilder b),
  ]) = _$AdminDepositsDtoOutputApplicationsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDepositsDtoOutputApplicationsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDepositsDtoOutputApplicationsInner> get serializer =>
      _$AdminDepositsDtoOutputApplicationsInnerSerializer();
}

class _$AdminDepositsDtoOutputApplicationsInnerSerializer
    implements PrimitiveSerializer<AdminDepositsDtoOutputApplicationsInner> {
  @override
  final Iterable<Type> types = const [
    AdminDepositsDtoOutputApplicationsInner,
    _$AdminDepositsDtoOutputApplicationsInner,
  ];

  @override
  final String wireName = r'AdminDepositsDtoOutputApplicationsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDepositsDtoOutputApplicationsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'applicationId';
    yield serializers.serialize(
      object.applicationId,
      specifiedType: const FullType(String),
    );
    yield r'fullName';
    yield serializers.serialize(
      object.fullName,
      specifiedType: const FullType(String),
    );
    yield r'deposit';
    yield serializers.serialize(
      object.deposit,
      specifiedType: const FullType(
        AdminDepositsDtoOutputApplicationsInnerDeposit,
      ),
    );
    yield r'suggested';
    yield object.suggested == null
        ? null
        : serializers.serialize(
            object.suggested,
            specifiedType: const FullType.nullable(
              AdminTicketPageDtoOutputPickupDisputePickupPayment,
            ),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDepositsDtoOutputApplicationsInner object, {
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
    required AdminDepositsDtoOutputApplicationsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'applicationId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.applicationId = valueDes;
          break;
        case r'fullName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.fullName = valueDes;
          break;
        case r'deposit':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminDepositsDtoOutputApplicationsInnerDeposit,
                    ),
                  )
                  as AdminDepositsDtoOutputApplicationsInnerDeposit;
          result.deposit.replace(valueDes);
          break;
        case r'suggested':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminTicketPageDtoOutputPickupDisputePickupPayment,
                    ),
                  )
                  as AdminTicketPageDtoOutputPickupDisputePickupPayment?;
          if (valueDes == null) continue;
          result.suggested.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDepositsDtoOutputApplicationsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDepositsDtoOutputApplicationsInnerBuilder();
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
