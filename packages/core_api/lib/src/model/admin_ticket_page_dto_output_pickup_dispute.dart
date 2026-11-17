//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_ticket_page_dto_output_pickup_dispute_pickup_payment.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_ticket_page_dto_output_pickup_dispute.g.dart';

/// «خلاف على دفعة الاستلام» only.
///
/// Properties:
/// * [pickupPayment]
/// * [recorded] - The captain's payment lines as booked.
/// * [received] - What the restaurant says it received, or, opened by the captain, what the captain says they handed over.
/// * [openedBy] - Who disputed: the restaurant's «المبلغ غير صحيح» or the captain's «مشكلة في مبلغ الاستلام».
/// * [confirmedBy]
/// * [captainName]
/// * [disputedAt]
/// * [currencies] - The currencies the corrected lines may use.
@BuiltValue()
abstract class AdminTicketPageDtoOutputPickupDispute
    implements
        Built<
          AdminTicketPageDtoOutputPickupDispute,
          AdminTicketPageDtoOutputPickupDisputeBuilder
        > {
  @BuiltValueField(wireName: r'pickupPayment')
  AdminTicketPageDtoOutputPickupDisputePickupPayment? get pickupPayment;

  /// The captain's payment lines as booked.
  @BuiltValueField(wireName: r'recorded')
  BuiltList<AdminTicketPageDtoOutputPickupDisputePickupPayment?> get recorded;

  /// What the restaurant says it received, or, opened by the captain, what the captain says they handed over.
  @BuiltValueField(wireName: r'received')
  BuiltList<AdminTicketPageDtoOutputPickupDisputePickupPayment?> get received;

  /// Who disputed: the restaurant's «المبلغ غير صحيح» or the captain's «مشكلة في مبلغ الاستلام».
  @BuiltValueField(wireName: r'openedBy')
  AdminTicketPageDtoOutputPickupDisputeOpenedByEnum get openedBy;
  // enum openedByEnum {  restaurant,  captain,  };

  @BuiltValueField(wireName: r'confirmedBy')
  AdminTicketPageDtoOutputPickupDisputeConfirmedByEnum get confirmedBy;
  // enum confirmedByEnum {  restaurant,  automatic,  operations,  };

  @BuiltValueField(wireName: r'captainName')
  String? get captainName;

  @BuiltValueField(wireName: r'disputedAt')
  DateTime get disputedAt;

  /// The currencies the corrected lines may use.
  @BuiltValueField(wireName: r'currencies')
  BuiltList<String> get currencies;

  AdminTicketPageDtoOutputPickupDispute._();

  factory AdminTicketPageDtoOutputPickupDispute([
    void updates(AdminTicketPageDtoOutputPickupDisputeBuilder b),
  ]) = _$AdminTicketPageDtoOutputPickupDispute;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminTicketPageDtoOutputPickupDisputeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminTicketPageDtoOutputPickupDispute> get serializer =>
      _$AdminTicketPageDtoOutputPickupDisputeSerializer();
}

class _$AdminTicketPageDtoOutputPickupDisputeSerializer
    implements PrimitiveSerializer<AdminTicketPageDtoOutputPickupDispute> {
  @override
  final Iterable<Type> types = const [
    AdminTicketPageDtoOutputPickupDispute,
    _$AdminTicketPageDtoOutputPickupDispute,
  ];

  @override
  final String wireName = r'AdminTicketPageDtoOutputPickupDispute';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminTicketPageDtoOutputPickupDispute object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'pickupPayment';
    yield object.pickupPayment == null
        ? null
        : serializers.serialize(
            object.pickupPayment,
            specifiedType: const FullType.nullable(
              AdminTicketPageDtoOutputPickupDisputePickupPayment,
            ),
          );
    yield r'recorded';
    yield serializers.serialize(
      object.recorded,
      specifiedType: const FullType(BuiltList, [
        FullType.nullable(AdminTicketPageDtoOutputPickupDisputePickupPayment),
      ]),
    );
    yield r'received';
    yield serializers.serialize(
      object.received,
      specifiedType: const FullType(BuiltList, [
        FullType.nullable(AdminTicketPageDtoOutputPickupDisputePickupPayment),
      ]),
    );
    yield r'openedBy';
    yield serializers.serialize(
      object.openedBy,
      specifiedType: const FullType(
        AdminTicketPageDtoOutputPickupDisputeOpenedByEnum,
      ),
    );
    yield r'confirmedBy';
    yield serializers.serialize(
      object.confirmedBy,
      specifiedType: const FullType(
        AdminTicketPageDtoOutputPickupDisputeConfirmedByEnum,
      ),
    );
    yield r'captainName';
    yield object.captainName == null
        ? null
        : serializers.serialize(
            object.captainName,
            specifiedType: const FullType.nullable(String),
          );
    yield r'disputedAt';
    yield serializers.serialize(
      object.disputedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'currencies';
    yield serializers.serialize(
      object.currencies,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminTicketPageDtoOutputPickupDispute object, {
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
    required AdminTicketPageDtoOutputPickupDisputeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'pickupPayment':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminTicketPageDtoOutputPickupDisputePickupPayment,
                    ),
                  )
                  as AdminTicketPageDtoOutputPickupDisputePickupPayment?;
          if (valueDes == null) continue;
          result.pickupPayment.replace(valueDes);
          break;
        case r'recorded':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType.nullable(
                        AdminTicketPageDtoOutputPickupDisputePickupPayment,
                      ),
                    ]),
                  )
                  as BuiltList<
                    AdminTicketPageDtoOutputPickupDisputePickupPayment?
                  >;
          result.recorded.replace(valueDes);
          break;
        case r'received':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType.nullable(
                        AdminTicketPageDtoOutputPickupDisputePickupPayment,
                      ),
                    ]),
                  )
                  as BuiltList<
                    AdminTicketPageDtoOutputPickupDisputePickupPayment?
                  >;
          result.received.replace(valueDes);
          break;
        case r'openedBy':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminTicketPageDtoOutputPickupDisputeOpenedByEnum,
                    ),
                  )
                  as AdminTicketPageDtoOutputPickupDisputeOpenedByEnum;
          result.openedBy = valueDes;
          break;
        case r'confirmedBy':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminTicketPageDtoOutputPickupDisputeConfirmedByEnum,
                    ),
                  )
                  as AdminTicketPageDtoOutputPickupDisputeConfirmedByEnum;
          result.confirmedBy = valueDes;
          break;
        case r'captainName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.captainName = valueDes;
          break;
        case r'disputedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.disputedAt = valueDes;
          break;
        case r'currencies':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.currencies.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminTicketPageDtoOutputPickupDispute deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminTicketPageDtoOutputPickupDisputeBuilder();
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

/// Who disputed: the restaurant's «المبلغ غير صحيح» or the captain's «مشكلة في مبلغ الاستلام».
class AdminTicketPageDtoOutputPickupDisputeOpenedByEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'restaurant')
  static const AdminTicketPageDtoOutputPickupDisputeOpenedByEnum restaurant =
      _$adminTicketPageDtoOutputPickupDisputeOpenedByEnum_restaurant;
  @BuiltValueEnumConst(wireName: r'captain')
  static const AdminTicketPageDtoOutputPickupDisputeOpenedByEnum captain =
      _$adminTicketPageDtoOutputPickupDisputeOpenedByEnum_captain;

  static Serializer<AdminTicketPageDtoOutputPickupDisputeOpenedByEnum>
  get serializer =>
      _$adminTicketPageDtoOutputPickupDisputeOpenedByEnumSerializer;

  const AdminTicketPageDtoOutputPickupDisputeOpenedByEnum._(String name)
    : super(name);

  static BuiltSet<AdminTicketPageDtoOutputPickupDisputeOpenedByEnum>
  get values => _$adminTicketPageDtoOutputPickupDisputeOpenedByEnumValues;
  static AdminTicketPageDtoOutputPickupDisputeOpenedByEnum valueOf(
    String name,
  ) => _$adminTicketPageDtoOutputPickupDisputeOpenedByEnumValueOf(name);
}

class AdminTicketPageDtoOutputPickupDisputeConfirmedByEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'restaurant')
  static const AdminTicketPageDtoOutputPickupDisputeConfirmedByEnum restaurant =
      _$adminTicketPageDtoOutputPickupDisputeConfirmedByEnum_restaurant;
  @BuiltValueEnumConst(wireName: r'automatic')
  static const AdminTicketPageDtoOutputPickupDisputeConfirmedByEnum automatic =
      _$adminTicketPageDtoOutputPickupDisputeConfirmedByEnum_automatic;
  @BuiltValueEnumConst(wireName: r'operations')
  static const AdminTicketPageDtoOutputPickupDisputeConfirmedByEnum operations =
      _$adminTicketPageDtoOutputPickupDisputeConfirmedByEnum_operations;

  static Serializer<AdminTicketPageDtoOutputPickupDisputeConfirmedByEnum>
  get serializer =>
      _$adminTicketPageDtoOutputPickupDisputeConfirmedByEnumSerializer;

  const AdminTicketPageDtoOutputPickupDisputeConfirmedByEnum._(String name)
    : super(name);

  static BuiltSet<AdminTicketPageDtoOutputPickupDisputeConfirmedByEnum>
  get values => _$adminTicketPageDtoOutputPickupDisputeConfirmedByEnumValues;
  static AdminTicketPageDtoOutputPickupDisputeConfirmedByEnum valueOf(
    String name,
  ) => _$adminTicketPageDtoOutputPickupDisputeConfirmedByEnumValueOf(name);
}
