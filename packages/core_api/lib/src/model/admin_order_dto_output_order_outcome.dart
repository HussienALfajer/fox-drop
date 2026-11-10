//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_went_offline_dto_output_hand_in.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_dto_output_order_outcome.g.dart';

/// AP §9.3.2 «تحديد النتيجة»: the outcome operations set (AP §8.9).
///
/// Properties:
/// * [at]
/// * [awaitingCollection] - «بانتظار تسجيل التحصيل» (K9): the money below is provisional until the captain or operations record the payment.
/// * [collectedAt]
/// * [outcome] - AP §8.9; fake needs the customer responsible, and only fake takes the customer.
/// * [status]
/// * [responsible]
/// * [food] - A failed order's food (CA §9.12), null when delivered; returned_to_restaurant only with the restaurant responsible.
/// * [amountToCollect]
/// * [loss]
/// * [dues]
/// * [merchantDebit]
/// * [captainPay]
/// * [customerText] - What the customer sees of a failed order.
/// * [note] - Operations' internal note.
/// * [setBy] - The admin who set it.
@BuiltValue()
abstract class AdminOrderDtoOutputOrderOutcome
    implements
        Built<
          AdminOrderDtoOutputOrderOutcome,
          AdminOrderDtoOutputOrderOutcomeBuilder
        > {
  @BuiltValueField(wireName: r'at')
  DateTime get at;

  /// «بانتظار تسجيل التحصيل» (K9): the money below is provisional until the captain or operations record the payment.
  @BuiltValueField(wireName: r'awaitingCollection')
  bool get awaitingCollection;

  @BuiltValueField(wireName: r'collectedAt')
  DateTime? get collectedAt;

  /// AP §8.9; fake needs the customer responsible, and only fake takes the customer.
  @BuiltValueField(wireName: r'outcome')
  AdminOrderDtoOutputOrderOutcomeOutcomeEnum get outcome;
  // enum outcomeEnum {  free,  fake,  damaged,  wrong_refused,  failed_other,  };

  @BuiltValueField(wireName: r'status')
  AdminOrderDtoOutputOrderOutcomeStatusEnum get status;
  // enum statusEnum {  delivered,  failed,  };

  @BuiltValueField(wireName: r'responsible')
  AdminOrderDtoOutputOrderOutcomeResponsibleEnum get responsible;
  // enum responsibleEnum {  restaurant,  captain,  customer,  platform,  };

  /// A failed order's food (CA §9.12), null when delivered; returned_to_restaurant only with the restaurant responsible.
  @BuiltValueField(wireName: r'food')
  AdminOrderDtoOutputOrderOutcomeFoodEnum? get food;
  // enum foodEnum {  kept_by_captain,  returned_to_restaurant,  destroyed,  };

  @BuiltValueField(wireName: r'amountToCollect')
  CaptainWentOfflineDtoOutputHandIn? get amountToCollect;

  @BuiltValueField(wireName: r'loss')
  CaptainWentOfflineDtoOutputHandIn? get loss;

  @BuiltValueField(wireName: r'dues')
  CaptainWentOfflineDtoOutputHandIn? get dues;

  @BuiltValueField(wireName: r'merchantDebit')
  CaptainWentOfflineDtoOutputHandIn? get merchantDebit;

  @BuiltValueField(wireName: r'captainPay')
  CaptainWentOfflineDtoOutputHandIn? get captainPay;

  /// What the customer sees of a failed order.
  @BuiltValueField(wireName: r'customerText')
  String? get customerText;

  /// Operations' internal note.
  @BuiltValueField(wireName: r'note')
  String get note;

  /// The admin who set it.
  @BuiltValueField(wireName: r'setBy')
  String get setBy;

  AdminOrderDtoOutputOrderOutcome._();

  factory AdminOrderDtoOutputOrderOutcome([
    void updates(AdminOrderDtoOutputOrderOutcomeBuilder b),
  ]) = _$AdminOrderDtoOutputOrderOutcome;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderDtoOutputOrderOutcomeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderDtoOutputOrderOutcome> get serializer =>
      _$AdminOrderDtoOutputOrderOutcomeSerializer();
}

class _$AdminOrderDtoOutputOrderOutcomeSerializer
    implements PrimitiveSerializer<AdminOrderDtoOutputOrderOutcome> {
  @override
  final Iterable<Type> types = const [
    AdminOrderDtoOutputOrderOutcome,
    _$AdminOrderDtoOutputOrderOutcome,
  ];

  @override
  final String wireName = r'AdminOrderDtoOutputOrderOutcome';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderDtoOutputOrderOutcome object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
    yield r'awaitingCollection';
    yield serializers.serialize(
      object.awaitingCollection,
      specifiedType: const FullType(bool),
    );
    yield r'collectedAt';
    yield object.collectedAt == null
        ? null
        : serializers.serialize(
            object.collectedAt,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'outcome';
    yield serializers.serialize(
      object.outcome,
      specifiedType: const FullType(AdminOrderDtoOutputOrderOutcomeOutcomeEnum),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AdminOrderDtoOutputOrderOutcomeStatusEnum),
    );
    yield r'responsible';
    yield serializers.serialize(
      object.responsible,
      specifiedType: const FullType(
        AdminOrderDtoOutputOrderOutcomeResponsibleEnum,
      ),
    );
    yield r'food';
    yield object.food == null
        ? null
        : serializers.serialize(
            object.food,
            specifiedType: const FullType.nullable(
              AdminOrderDtoOutputOrderOutcomeFoodEnum,
            ),
          );
    yield r'amountToCollect';
    yield object.amountToCollect == null
        ? null
        : serializers.serialize(
            object.amountToCollect,
            specifiedType: const FullType.nullable(
              CaptainWentOfflineDtoOutputHandIn,
            ),
          );
    yield r'loss';
    yield object.loss == null
        ? null
        : serializers.serialize(
            object.loss,
            specifiedType: const FullType.nullable(
              CaptainWentOfflineDtoOutputHandIn,
            ),
          );
    yield r'dues';
    yield object.dues == null
        ? null
        : serializers.serialize(
            object.dues,
            specifiedType: const FullType.nullable(
              CaptainWentOfflineDtoOutputHandIn,
            ),
          );
    yield r'merchantDebit';
    yield object.merchantDebit == null
        ? null
        : serializers.serialize(
            object.merchantDebit,
            specifiedType: const FullType.nullable(
              CaptainWentOfflineDtoOutputHandIn,
            ),
          );
    yield r'captainPay';
    yield object.captainPay == null
        ? null
        : serializers.serialize(
            object.captainPay,
            specifiedType: const FullType.nullable(
              CaptainWentOfflineDtoOutputHandIn,
            ),
          );
    yield r'customerText';
    yield object.customerText == null
        ? null
        : serializers.serialize(
            object.customerText,
            specifiedType: const FullType.nullable(String),
          );
    yield r'note';
    yield serializers.serialize(
      object.note,
      specifiedType: const FullType(String),
    );
    yield r'setBy';
    yield serializers.serialize(
      object.setBy,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderOutcome object, {
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
    required AdminOrderDtoOutputOrderOutcomeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'at':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.at = valueDes;
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
        case r'collectedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.collectedAt = valueDes;
          break;
        case r'outcome':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminOrderDtoOutputOrderOutcomeOutcomeEnum,
                    ),
                  )
                  as AdminOrderDtoOutputOrderOutcomeOutcomeEnum;
          result.outcome = valueDes;
          break;
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminOrderDtoOutputOrderOutcomeStatusEnum,
                    ),
                  )
                  as AdminOrderDtoOutputOrderOutcomeStatusEnum;
          result.status = valueDes;
          break;
        case r'responsible':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminOrderDtoOutputOrderOutcomeResponsibleEnum,
                    ),
                  )
                  as AdminOrderDtoOutputOrderOutcomeResponsibleEnum;
          result.responsible = valueDes;
          break;
        case r'food':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminOrderDtoOutputOrderOutcomeFoodEnum,
                    ),
                  )
                  as AdminOrderDtoOutputOrderOutcomeFoodEnum?;
          if (valueDes == null) continue;
          result.food = valueDes;
          break;
        case r'amountToCollect':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CaptainWentOfflineDtoOutputHandIn,
                    ),
                  )
                  as CaptainWentOfflineDtoOutputHandIn?;
          if (valueDes == null) continue;
          result.amountToCollect.replace(valueDes);
          break;
        case r'loss':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CaptainWentOfflineDtoOutputHandIn,
                    ),
                  )
                  as CaptainWentOfflineDtoOutputHandIn?;
          if (valueDes == null) continue;
          result.loss.replace(valueDes);
          break;
        case r'dues':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CaptainWentOfflineDtoOutputHandIn,
                    ),
                  )
                  as CaptainWentOfflineDtoOutputHandIn?;
          if (valueDes == null) continue;
          result.dues.replace(valueDes);
          break;
        case r'merchantDebit':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CaptainWentOfflineDtoOutputHandIn,
                    ),
                  )
                  as CaptainWentOfflineDtoOutputHandIn?;
          if (valueDes == null) continue;
          result.merchantDebit.replace(valueDes);
          break;
        case r'captainPay':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CaptainWentOfflineDtoOutputHandIn,
                    ),
                  )
                  as CaptainWentOfflineDtoOutputHandIn?;
          if (valueDes == null) continue;
          result.captainPay.replace(valueDes);
          break;
        case r'customerText':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.customerText = valueDes;
          break;
        case r'note':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.note = valueDes;
          break;
        case r'setBy':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.setBy = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderDtoOutputOrderOutcome deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderDtoOutputOrderOutcomeBuilder();
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

/// AP §8.9; fake needs the customer responsible, and only fake takes the customer.
class AdminOrderDtoOutputOrderOutcomeOutcomeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'free')
  static const AdminOrderDtoOutputOrderOutcomeOutcomeEnum free =
      _$adminOrderDtoOutputOrderOutcomeOutcomeEnum_free;
  @BuiltValueEnumConst(wireName: r'fake')
  static const AdminOrderDtoOutputOrderOutcomeOutcomeEnum fake =
      _$adminOrderDtoOutputOrderOutcomeOutcomeEnum_fake;
  @BuiltValueEnumConst(wireName: r'damaged')
  static const AdminOrderDtoOutputOrderOutcomeOutcomeEnum damaged =
      _$adminOrderDtoOutputOrderOutcomeOutcomeEnum_damaged;
  @BuiltValueEnumConst(wireName: r'wrong_refused')
  static const AdminOrderDtoOutputOrderOutcomeOutcomeEnum wrongRefused =
      _$adminOrderDtoOutputOrderOutcomeOutcomeEnum_wrongRefused;
  @BuiltValueEnumConst(wireName: r'failed_other')
  static const AdminOrderDtoOutputOrderOutcomeOutcomeEnum failedOther =
      _$adminOrderDtoOutputOrderOutcomeOutcomeEnum_failedOther;

  static Serializer<AdminOrderDtoOutputOrderOutcomeOutcomeEnum>
  get serializer => _$adminOrderDtoOutputOrderOutcomeOutcomeEnumSerializer;

  const AdminOrderDtoOutputOrderOutcomeOutcomeEnum._(String name) : super(name);

  static BuiltSet<AdminOrderDtoOutputOrderOutcomeOutcomeEnum> get values =>
      _$adminOrderDtoOutputOrderOutcomeOutcomeEnumValues;
  static AdminOrderDtoOutputOrderOutcomeOutcomeEnum valueOf(String name) =>
      _$adminOrderDtoOutputOrderOutcomeOutcomeEnumValueOf(name);
}

class AdminOrderDtoOutputOrderOutcomeStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'delivered')
  static const AdminOrderDtoOutputOrderOutcomeStatusEnum delivered =
      _$adminOrderDtoOutputOrderOutcomeStatusEnum_delivered;
  @BuiltValueEnumConst(wireName: r'failed')
  static const AdminOrderDtoOutputOrderOutcomeStatusEnum failed =
      _$adminOrderDtoOutputOrderOutcomeStatusEnum_failed;

  static Serializer<AdminOrderDtoOutputOrderOutcomeStatusEnum> get serializer =>
      _$adminOrderDtoOutputOrderOutcomeStatusEnumSerializer;

  const AdminOrderDtoOutputOrderOutcomeStatusEnum._(String name) : super(name);

  static BuiltSet<AdminOrderDtoOutputOrderOutcomeStatusEnum> get values =>
      _$adminOrderDtoOutputOrderOutcomeStatusEnumValues;
  static AdminOrderDtoOutputOrderOutcomeStatusEnum valueOf(String name) =>
      _$adminOrderDtoOutputOrderOutcomeStatusEnumValueOf(name);
}

class AdminOrderDtoOutputOrderOutcomeResponsibleEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'restaurant')
  static const AdminOrderDtoOutputOrderOutcomeResponsibleEnum restaurant =
      _$adminOrderDtoOutputOrderOutcomeResponsibleEnum_restaurant;
  @BuiltValueEnumConst(wireName: r'captain')
  static const AdminOrderDtoOutputOrderOutcomeResponsibleEnum captain =
      _$adminOrderDtoOutputOrderOutcomeResponsibleEnum_captain;
  @BuiltValueEnumConst(wireName: r'customer')
  static const AdminOrderDtoOutputOrderOutcomeResponsibleEnum customer =
      _$adminOrderDtoOutputOrderOutcomeResponsibleEnum_customer;
  @BuiltValueEnumConst(wireName: r'platform')
  static const AdminOrderDtoOutputOrderOutcomeResponsibleEnum platform =
      _$adminOrderDtoOutputOrderOutcomeResponsibleEnum_platform;

  static Serializer<AdminOrderDtoOutputOrderOutcomeResponsibleEnum>
  get serializer => _$adminOrderDtoOutputOrderOutcomeResponsibleEnumSerializer;

  const AdminOrderDtoOutputOrderOutcomeResponsibleEnum._(String name)
    : super(name);

  static BuiltSet<AdminOrderDtoOutputOrderOutcomeResponsibleEnum> get values =>
      _$adminOrderDtoOutputOrderOutcomeResponsibleEnumValues;
  static AdminOrderDtoOutputOrderOutcomeResponsibleEnum valueOf(String name) =>
      _$adminOrderDtoOutputOrderOutcomeResponsibleEnumValueOf(name);
}

/// A failed order's food (CA §9.12), null when delivered; returned_to_restaurant only with the restaurant responsible.
class AdminOrderDtoOutputOrderOutcomeFoodEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'kept_by_captain')
  static const AdminOrderDtoOutputOrderOutcomeFoodEnum keptByCaptain =
      _$adminOrderDtoOutputOrderOutcomeFoodEnum_keptByCaptain;
  @BuiltValueEnumConst(wireName: r'returned_to_restaurant')
  static const AdminOrderDtoOutputOrderOutcomeFoodEnum returnedToRestaurant =
      _$adminOrderDtoOutputOrderOutcomeFoodEnum_returnedToRestaurant;
  @BuiltValueEnumConst(wireName: r'destroyed')
  static const AdminOrderDtoOutputOrderOutcomeFoodEnum destroyed =
      _$adminOrderDtoOutputOrderOutcomeFoodEnum_destroyed;

  static Serializer<AdminOrderDtoOutputOrderOutcomeFoodEnum> get serializer =>
      _$adminOrderDtoOutputOrderOutcomeFoodEnumSerializer;

  const AdminOrderDtoOutputOrderOutcomeFoodEnum._(String name) : super(name);

  static BuiltSet<AdminOrderDtoOutputOrderOutcomeFoodEnum> get values =>
      _$adminOrderDtoOutputOrderOutcomeFoodEnumValues;
  static AdminOrderDtoOutputOrderOutcomeFoodEnum valueOf(String name) =>
      _$adminOrderDtoOutputOrderOutcomeFoodEnumValueOf(name);
}
