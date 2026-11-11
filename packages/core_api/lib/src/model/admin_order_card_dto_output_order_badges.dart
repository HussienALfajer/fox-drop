//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_card_dto_output_order_badges.g.dart';

/// AdminOrderCardDtoOutputOrderBadges
///
/// Properties:
/// * [needsAssignment] - «بحاجة لتعيين» (AP §8.3).
/// * [note] - «ملاحظة».
/// * [newCustomer] - «زبون جديد»: no delivered order yet.
/// * [pickupPending] - «بانتظار تأكيد الاستلام» (AP §9.2.1).
/// * [awaitingCollection] - «بانتظار تسجيل التحصيل»: an outcome with an amount to collect waits for the payment (CA §9.10, K9).
/// * [itemReport] - «صنف نفد»: an open item-unavailable report (RA §8.12).
/// * [cannotComplete] - «بانتظار العمليات»: the captain's open «لا أستطيع إكمال الطلب» (CA §9.11, slice 2.13b).
@BuiltValue()
abstract class AdminOrderCardDtoOutputOrderBadges
    implements
        Built<
          AdminOrderCardDtoOutputOrderBadges,
          AdminOrderCardDtoOutputOrderBadgesBuilder
        > {
  /// «بحاجة لتعيين» (AP §8.3).
  @BuiltValueField(wireName: r'needsAssignment')
  bool get needsAssignment;

  /// «ملاحظة».
  @BuiltValueField(wireName: r'note')
  bool get note;

  /// «زبون جديد»: no delivered order yet.
  @BuiltValueField(wireName: r'newCustomer')
  bool get newCustomer;

  /// «بانتظار تأكيد الاستلام» (AP §9.2.1).
  @BuiltValueField(wireName: r'pickupPending')
  bool get pickupPending;

  /// «بانتظار تسجيل التحصيل»: an outcome with an amount to collect waits for the payment (CA §9.10, K9).
  @BuiltValueField(wireName: r'awaitingCollection')
  bool get awaitingCollection;

  /// «صنف نفد»: an open item-unavailable report (RA §8.12).
  @BuiltValueField(wireName: r'itemReport')
  bool get itemReport;

  /// «بانتظار العمليات»: the captain's open «لا أستطيع إكمال الطلب» (CA §9.11, slice 2.13b).
  @BuiltValueField(wireName: r'cannotComplete')
  bool get cannotComplete;

  AdminOrderCardDtoOutputOrderBadges._();

  factory AdminOrderCardDtoOutputOrderBadges([
    void updates(AdminOrderCardDtoOutputOrderBadgesBuilder b),
  ]) = _$AdminOrderCardDtoOutputOrderBadges;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderCardDtoOutputOrderBadgesBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderCardDtoOutputOrderBadges> get serializer =>
      _$AdminOrderCardDtoOutputOrderBadgesSerializer();
}

class _$AdminOrderCardDtoOutputOrderBadgesSerializer
    implements PrimitiveSerializer<AdminOrderCardDtoOutputOrderBadges> {
  @override
  final Iterable<Type> types = const [
    AdminOrderCardDtoOutputOrderBadges,
    _$AdminOrderCardDtoOutputOrderBadges,
  ];

  @override
  final String wireName = r'AdminOrderCardDtoOutputOrderBadges';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderCardDtoOutputOrderBadges object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'needsAssignment';
    yield serializers.serialize(
      object.needsAssignment,
      specifiedType: const FullType(bool),
    );
    yield r'note';
    yield serializers.serialize(
      object.note,
      specifiedType: const FullType(bool),
    );
    yield r'newCustomer';
    yield serializers.serialize(
      object.newCustomer,
      specifiedType: const FullType(bool),
    );
    yield r'pickupPending';
    yield serializers.serialize(
      object.pickupPending,
      specifiedType: const FullType(bool),
    );
    yield r'awaitingCollection';
    yield serializers.serialize(
      object.awaitingCollection,
      specifiedType: const FullType(bool),
    );
    yield r'itemReport';
    yield serializers.serialize(
      object.itemReport,
      specifiedType: const FullType(bool),
    );
    yield r'cannotComplete';
    yield serializers.serialize(
      object.cannotComplete,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderCardDtoOutputOrderBadges object, {
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
    required AdminOrderCardDtoOutputOrderBadgesBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'needsAssignment':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.needsAssignment = valueDes;
          break;
        case r'note':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.note = valueDes;
          break;
        case r'newCustomer':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.newCustomer = valueDes;
          break;
        case r'pickupPending':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.pickupPending = valueDes;
          break;
        case r'awaitingCollection':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.awaitingCollection = valueDes;
          break;
        case r'itemReport':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.itemReport = valueDes;
          break;
        case r'cannotComplete':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.cannotComplete = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderCardDtoOutputOrderBadges deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderCardDtoOutputOrderBadgesBuilder();
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
