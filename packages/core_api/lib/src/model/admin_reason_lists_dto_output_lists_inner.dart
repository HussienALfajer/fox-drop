//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_reason_lists_dto_output_lists_inner_reasons_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_reason_lists_dto_output_lists_inner.g.dart';

/// AdminReasonListsDtoOutputListsInner
///
/// Properties:
/// * [list] 
/// * [apps] 
/// * [customerText] - Its reasons may carry «نص للزبون».
/// * [closed] - No reason can be added.
/// * [reasons] 
@BuiltValue()
abstract class AdminReasonListsDtoOutputListsInner implements Built<AdminReasonListsDtoOutputListsInner, AdminReasonListsDtoOutputListsInnerBuilder> {
  @BuiltValueField(wireName: r'list')
  AdminReasonListsDtoOutputListsInnerListEnum get list;
  // enum listEnum {  merchant_rejection,  merchant_problem,  item_unavailable_note,  merchant_ticket_type,  captain_cannot_complete,  captain_away,  shortfall,  food_after_failed,  captain_ticket_type,  captain_problem,  customer_cancel,  customer_problem,  order_note,  restaurant_rating_low,  restaurant_rating_mid,  restaurant_rating_high,  captain_rating_low,  captain_rating_mid,  captain_rating_high,  ops_cancel,  reassignment,  captain_suspension,  customer_block,  emergency_stop,  failed_outcome,  system_cancellation,  };

  @BuiltValueField(wireName: r'apps')
  BuiltList<AdminReasonListsDtoOutputListsInnerAppsEnum> get apps;
  // enum appsEnum {  merchant,  captain,  customer,  };

  /// Its reasons may carry «نص للزبون».
  @BuiltValueField(wireName: r'customerText')
  bool get customerText;

  /// No reason can be added.
  @BuiltValueField(wireName: r'closed')
  bool get closed;

  @BuiltValueField(wireName: r'reasons')
  BuiltList<AdminReasonListsDtoOutputListsInnerReasonsInner> get reasons;

  AdminReasonListsDtoOutputListsInner._();

  factory AdminReasonListsDtoOutputListsInner([void updates(AdminReasonListsDtoOutputListsInnerBuilder b)]) = _$AdminReasonListsDtoOutputListsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminReasonListsDtoOutputListsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminReasonListsDtoOutputListsInner> get serializer => _$AdminReasonListsDtoOutputListsInnerSerializer();
}

class _$AdminReasonListsDtoOutputListsInnerSerializer implements PrimitiveSerializer<AdminReasonListsDtoOutputListsInner> {
  @override
  final Iterable<Type> types = const [AdminReasonListsDtoOutputListsInner, _$AdminReasonListsDtoOutputListsInner];

  @override
  final String wireName = r'AdminReasonListsDtoOutputListsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminReasonListsDtoOutputListsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'list';
    yield serializers.serialize(
      object.list,
      specifiedType: const FullType(AdminReasonListsDtoOutputListsInnerListEnum),
    );
    yield r'apps';
    yield serializers.serialize(
      object.apps,
      specifiedType: const FullType(BuiltList, [FullType(AdminReasonListsDtoOutputListsInnerAppsEnum)]),
    );
    yield r'customerText';
    yield serializers.serialize(
      object.customerText,
      specifiedType: const FullType(bool),
    );
    yield r'closed';
    yield serializers.serialize(
      object.closed,
      specifiedType: const FullType(bool),
    );
    yield r'reasons';
    yield serializers.serialize(
      object.reasons,
      specifiedType: const FullType(BuiltList, [FullType(AdminReasonListsDtoOutputListsInnerReasonsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminReasonListsDtoOutputListsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminReasonListsDtoOutputListsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'list':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminReasonListsDtoOutputListsInnerListEnum),
          ) as AdminReasonListsDtoOutputListsInnerListEnum;
          result.list = valueDes;
          break;
        case r'apps':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminReasonListsDtoOutputListsInnerAppsEnum)]),
          ) as BuiltList<AdminReasonListsDtoOutputListsInnerAppsEnum>;
          result.apps.replace(valueDes);
          break;
        case r'customerText':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.customerText = valueDes;
          break;
        case r'closed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.closed = valueDes;
          break;
        case r'reasons':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminReasonListsDtoOutputListsInnerReasonsInner)]),
          ) as BuiltList<AdminReasonListsDtoOutputListsInnerReasonsInner>;
          result.reasons.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminReasonListsDtoOutputListsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminReasonListsDtoOutputListsInnerBuilder();
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


class AdminReasonListsDtoOutputListsInnerListEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'merchant_rejection')
  static const AdminReasonListsDtoOutputListsInnerListEnum merchantRejection = _$adminReasonListsDtoOutputListsInnerListEnum_merchantRejection;
  @BuiltValueEnumConst(wireName: r'merchant_problem')
  static const AdminReasonListsDtoOutputListsInnerListEnum merchantProblem = _$adminReasonListsDtoOutputListsInnerListEnum_merchantProblem;
  @BuiltValueEnumConst(wireName: r'item_unavailable_note')
  static const AdminReasonListsDtoOutputListsInnerListEnum itemUnavailableNote = _$adminReasonListsDtoOutputListsInnerListEnum_itemUnavailableNote;
  @BuiltValueEnumConst(wireName: r'merchant_ticket_type')
  static const AdminReasonListsDtoOutputListsInnerListEnum merchantTicketType = _$adminReasonListsDtoOutputListsInnerListEnum_merchantTicketType;
  @BuiltValueEnumConst(wireName: r'captain_cannot_complete')
  static const AdminReasonListsDtoOutputListsInnerListEnum captainCannotComplete = _$adminReasonListsDtoOutputListsInnerListEnum_captainCannotComplete;
  @BuiltValueEnumConst(wireName: r'captain_away')
  static const AdminReasonListsDtoOutputListsInnerListEnum captainAway = _$adminReasonListsDtoOutputListsInnerListEnum_captainAway;
  @BuiltValueEnumConst(wireName: r'shortfall')
  static const AdminReasonListsDtoOutputListsInnerListEnum shortfall = _$adminReasonListsDtoOutputListsInnerListEnum_shortfall;
  @BuiltValueEnumConst(wireName: r'food_after_failed')
  static const AdminReasonListsDtoOutputListsInnerListEnum foodAfterFailed = _$adminReasonListsDtoOutputListsInnerListEnum_foodAfterFailed;
  @BuiltValueEnumConst(wireName: r'captain_ticket_type')
  static const AdminReasonListsDtoOutputListsInnerListEnum captainTicketType = _$adminReasonListsDtoOutputListsInnerListEnum_captainTicketType;
  @BuiltValueEnumConst(wireName: r'captain_problem')
  static const AdminReasonListsDtoOutputListsInnerListEnum captainProblem = _$adminReasonListsDtoOutputListsInnerListEnum_captainProblem;
  @BuiltValueEnumConst(wireName: r'customer_cancel')
  static const AdminReasonListsDtoOutputListsInnerListEnum customerCancel = _$adminReasonListsDtoOutputListsInnerListEnum_customerCancel;
  @BuiltValueEnumConst(wireName: r'customer_problem')
  static const AdminReasonListsDtoOutputListsInnerListEnum customerProblem = _$adminReasonListsDtoOutputListsInnerListEnum_customerProblem;
  @BuiltValueEnumConst(wireName: r'order_note')
  static const AdminReasonListsDtoOutputListsInnerListEnum orderNote = _$adminReasonListsDtoOutputListsInnerListEnum_orderNote;
  @BuiltValueEnumConst(wireName: r'restaurant_rating_low')
  static const AdminReasonListsDtoOutputListsInnerListEnum restaurantRatingLow = _$adminReasonListsDtoOutputListsInnerListEnum_restaurantRatingLow;
  @BuiltValueEnumConst(wireName: r'restaurant_rating_mid')
  static const AdminReasonListsDtoOutputListsInnerListEnum restaurantRatingMid = _$adminReasonListsDtoOutputListsInnerListEnum_restaurantRatingMid;
  @BuiltValueEnumConst(wireName: r'restaurant_rating_high')
  static const AdminReasonListsDtoOutputListsInnerListEnum restaurantRatingHigh = _$adminReasonListsDtoOutputListsInnerListEnum_restaurantRatingHigh;
  @BuiltValueEnumConst(wireName: r'captain_rating_low')
  static const AdminReasonListsDtoOutputListsInnerListEnum captainRatingLow = _$adminReasonListsDtoOutputListsInnerListEnum_captainRatingLow;
  @BuiltValueEnumConst(wireName: r'captain_rating_mid')
  static const AdminReasonListsDtoOutputListsInnerListEnum captainRatingMid = _$adminReasonListsDtoOutputListsInnerListEnum_captainRatingMid;
  @BuiltValueEnumConst(wireName: r'captain_rating_high')
  static const AdminReasonListsDtoOutputListsInnerListEnum captainRatingHigh = _$adminReasonListsDtoOutputListsInnerListEnum_captainRatingHigh;
  @BuiltValueEnumConst(wireName: r'ops_cancel')
  static const AdminReasonListsDtoOutputListsInnerListEnum opsCancel = _$adminReasonListsDtoOutputListsInnerListEnum_opsCancel;
  @BuiltValueEnumConst(wireName: r'reassignment')
  static const AdminReasonListsDtoOutputListsInnerListEnum reassignment = _$adminReasonListsDtoOutputListsInnerListEnum_reassignment;
  @BuiltValueEnumConst(wireName: r'captain_suspension')
  static const AdminReasonListsDtoOutputListsInnerListEnum captainSuspension = _$adminReasonListsDtoOutputListsInnerListEnum_captainSuspension;
  @BuiltValueEnumConst(wireName: r'customer_block')
  static const AdminReasonListsDtoOutputListsInnerListEnum customerBlock = _$adminReasonListsDtoOutputListsInnerListEnum_customerBlock;
  @BuiltValueEnumConst(wireName: r'emergency_stop')
  static const AdminReasonListsDtoOutputListsInnerListEnum emergencyStop = _$adminReasonListsDtoOutputListsInnerListEnum_emergencyStop;
  @BuiltValueEnumConst(wireName: r'failed_outcome')
  static const AdminReasonListsDtoOutputListsInnerListEnum failedOutcome = _$adminReasonListsDtoOutputListsInnerListEnum_failedOutcome;
  @BuiltValueEnumConst(wireName: r'system_cancellation')
  static const AdminReasonListsDtoOutputListsInnerListEnum systemCancellation = _$adminReasonListsDtoOutputListsInnerListEnum_systemCancellation;

  static Serializer<AdminReasonListsDtoOutputListsInnerListEnum> get serializer => _$adminReasonListsDtoOutputListsInnerListEnumSerializer;

  const AdminReasonListsDtoOutputListsInnerListEnum._(String name): super(name);

  static BuiltSet<AdminReasonListsDtoOutputListsInnerListEnum> get values => _$adminReasonListsDtoOutputListsInnerListEnumValues;
  static AdminReasonListsDtoOutputListsInnerListEnum valueOf(String name) => _$adminReasonListsDtoOutputListsInnerListEnumValueOf(name);
}

class AdminReasonListsDtoOutputListsInnerAppsEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'merchant')
  static const AdminReasonListsDtoOutputListsInnerAppsEnum merchant = _$adminReasonListsDtoOutputListsInnerAppsEnum_merchant;
  @BuiltValueEnumConst(wireName: r'captain')
  static const AdminReasonListsDtoOutputListsInnerAppsEnum captain = _$adminReasonListsDtoOutputListsInnerAppsEnum_captain;
  @BuiltValueEnumConst(wireName: r'customer')
  static const AdminReasonListsDtoOutputListsInnerAppsEnum customer = _$adminReasonListsDtoOutputListsInnerAppsEnum_customer;

  static Serializer<AdminReasonListsDtoOutputListsInnerAppsEnum> get serializer => _$adminReasonListsDtoOutputListsInnerAppsEnumSerializer;

  const AdminReasonListsDtoOutputListsInnerAppsEnum._(String name): super(name);

  static BuiltSet<AdminReasonListsDtoOutputListsInnerAppsEnum> get values => _$adminReasonListsDtoOutputListsInnerAppsEnumValues;
  static AdminReasonListsDtoOutputListsInnerAppsEnum valueOf(String name) => _$adminReasonListsDtoOutputListsInnerAppsEnumValueOf(name);
}

