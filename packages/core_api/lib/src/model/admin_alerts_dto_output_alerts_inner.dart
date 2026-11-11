//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_alerts_dto_output_alerts_inner_acknowledged.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_alerts_dto_output_alerts_inner.g.dart';

/// AdminAlertsDtoOutputAlertsInner
///
/// Properties:
/// * [id]
/// * [code] - The rule of AP §9.1.3.
/// * [severity] - critical repeats its sound until acknowledged, warning plays once, information is silent (AP §7.3).
/// * [subjectType]
/// * [subjectId] - The order, captain or sending number it is about.
/// * [orderNumber] - For an alert about an order.
/// * [captainName] - For an alert about a captain.
/// * [restaurantName] - For an alert about a restaurant.
/// * [raisedAt]
/// * [acknowledged]
/// * [resolvedAt]
@BuiltValue()
abstract class AdminAlertsDtoOutputAlertsInner
    implements
        Built<
          AdminAlertsDtoOutputAlertsInner,
          AdminAlertsDtoOutputAlertsInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  /// The rule of AP §9.1.3.
  @BuiltValueField(wireName: r'code')
  AdminAlertsDtoOutputAlertsInnerCodeEnum get code;
  // enum codeEnum {  restaurant_not_accepted,  no_captain,  no_captain_after_ready,  captain_gps_lost,  pickup_disputed,  prep_late,  captain_waiting,  delivery_late,  collection_shortfall,  captain_cash_limit,  codes_cannot_send,  code_number_stopped,  away_from_address,  item_unavailable,  edit_unacknowledged,  captain_cannot_complete,  restaurant_auto_paused,  };

  /// critical repeats its sound until acknowledged, warning plays once, information is silent (AP §7.3).
  @BuiltValueField(wireName: r'severity')
  AdminAlertsDtoOutputAlertsInnerSeverityEnum get severity;
  // enum severityEnum {  critical,  warning,  information,  };

  @BuiltValueField(wireName: r'subjectType')
  AdminAlertsDtoOutputAlertsInnerSubjectTypeEnum get subjectType;
  // enum subjectTypeEnum {  order,  captain,  otp_pool,  otp_number,  restaurant,  };

  /// The order, captain or sending number it is about.
  @BuiltValueField(wireName: r'subjectId')
  String get subjectId;

  /// For an alert about an order.
  @BuiltValueField(wireName: r'orderNumber')
  String? get orderNumber;

  /// For an alert about a captain.
  @BuiltValueField(wireName: r'captainName')
  String? get captainName;

  /// For an alert about a restaurant.
  @BuiltValueField(wireName: r'restaurantName')
  String? get restaurantName;

  @BuiltValueField(wireName: r'raisedAt')
  DateTime get raisedAt;

  @BuiltValueField(wireName: r'acknowledged')
  AdminAlertsDtoOutputAlertsInnerAcknowledged? get acknowledged;

  @BuiltValueField(wireName: r'resolvedAt')
  DateTime? get resolvedAt;

  AdminAlertsDtoOutputAlertsInner._();

  factory AdminAlertsDtoOutputAlertsInner([
    void updates(AdminAlertsDtoOutputAlertsInnerBuilder b),
  ]) = _$AdminAlertsDtoOutputAlertsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminAlertsDtoOutputAlertsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminAlertsDtoOutputAlertsInner> get serializer =>
      _$AdminAlertsDtoOutputAlertsInnerSerializer();
}

class _$AdminAlertsDtoOutputAlertsInnerSerializer
    implements PrimitiveSerializer<AdminAlertsDtoOutputAlertsInner> {
  @override
  final Iterable<Type> types = const [
    AdminAlertsDtoOutputAlertsInner,
    _$AdminAlertsDtoOutputAlertsInner,
  ];

  @override
  final String wireName = r'AdminAlertsDtoOutputAlertsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminAlertsDtoOutputAlertsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(AdminAlertsDtoOutputAlertsInnerCodeEnum),
    );
    yield r'severity';
    yield serializers.serialize(
      object.severity,
      specifiedType: const FullType(
        AdminAlertsDtoOutputAlertsInnerSeverityEnum,
      ),
    );
    yield r'subjectType';
    yield serializers.serialize(
      object.subjectType,
      specifiedType: const FullType(
        AdminAlertsDtoOutputAlertsInnerSubjectTypeEnum,
      ),
    );
    yield r'subjectId';
    yield serializers.serialize(
      object.subjectId,
      specifiedType: const FullType(String),
    );
    yield r'orderNumber';
    yield object.orderNumber == null
        ? null
        : serializers.serialize(
            object.orderNumber,
            specifiedType: const FullType.nullable(String),
          );
    yield r'captainName';
    yield object.captainName == null
        ? null
        : serializers.serialize(
            object.captainName,
            specifiedType: const FullType.nullable(String),
          );
    yield r'restaurantName';
    yield object.restaurantName == null
        ? null
        : serializers.serialize(
            object.restaurantName,
            specifiedType: const FullType.nullable(String),
          );
    yield r'raisedAt';
    yield serializers.serialize(
      object.raisedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'acknowledged';
    yield object.acknowledged == null
        ? null
        : serializers.serialize(
            object.acknowledged,
            specifiedType: const FullType.nullable(
              AdminAlertsDtoOutputAlertsInnerAcknowledged,
            ),
          );
    yield r'resolvedAt';
    yield object.resolvedAt == null
        ? null
        : serializers.serialize(
            object.resolvedAt,
            specifiedType: const FullType.nullable(DateTime),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminAlertsDtoOutputAlertsInner object, {
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
    required AdminAlertsDtoOutputAlertsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.id = valueDes;
          break;
        case r'code':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminAlertsDtoOutputAlertsInnerCodeEnum,
                    ),
                  )
                  as AdminAlertsDtoOutputAlertsInnerCodeEnum;
          result.code = valueDes;
          break;
        case r'severity':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminAlertsDtoOutputAlertsInnerSeverityEnum,
                    ),
                  )
                  as AdminAlertsDtoOutputAlertsInnerSeverityEnum;
          result.severity = valueDes;
          break;
        case r'subjectType':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminAlertsDtoOutputAlertsInnerSubjectTypeEnum,
                    ),
                  )
                  as AdminAlertsDtoOutputAlertsInnerSubjectTypeEnum;
          result.subjectType = valueDes;
          break;
        case r'subjectId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.subjectId = valueDes;
          break;
        case r'orderNumber':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.orderNumber = valueDes;
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
        case r'restaurantName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.restaurantName = valueDes;
          break;
        case r'raisedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.raisedAt = valueDes;
          break;
        case r'acknowledged':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminAlertsDtoOutputAlertsInnerAcknowledged,
                    ),
                  )
                  as AdminAlertsDtoOutputAlertsInnerAcknowledged?;
          if (valueDes == null) continue;
          result.acknowledged.replace(valueDes);
          break;
        case r'resolvedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.resolvedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminAlertsDtoOutputAlertsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminAlertsDtoOutputAlertsInnerBuilder();
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

/// The rule of AP §9.1.3.
class AdminAlertsDtoOutputAlertsInnerCodeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'restaurant_not_accepted')
  static const AdminAlertsDtoOutputAlertsInnerCodeEnum restaurantNotAccepted =
      _$adminAlertsDtoOutputAlertsInnerCodeEnum_restaurantNotAccepted;
  @BuiltValueEnumConst(wireName: r'no_captain')
  static const AdminAlertsDtoOutputAlertsInnerCodeEnum noCaptain =
      _$adminAlertsDtoOutputAlertsInnerCodeEnum_noCaptain;
  @BuiltValueEnumConst(wireName: r'no_captain_after_ready')
  static const AdminAlertsDtoOutputAlertsInnerCodeEnum noCaptainAfterReady =
      _$adminAlertsDtoOutputAlertsInnerCodeEnum_noCaptainAfterReady;
  @BuiltValueEnumConst(wireName: r'captain_gps_lost')
  static const AdminAlertsDtoOutputAlertsInnerCodeEnum captainGpsLost =
      _$adminAlertsDtoOutputAlertsInnerCodeEnum_captainGpsLost;
  @BuiltValueEnumConst(wireName: r'pickup_disputed')
  static const AdminAlertsDtoOutputAlertsInnerCodeEnum pickupDisputed =
      _$adminAlertsDtoOutputAlertsInnerCodeEnum_pickupDisputed;
  @BuiltValueEnumConst(wireName: r'prep_late')
  static const AdminAlertsDtoOutputAlertsInnerCodeEnum prepLate =
      _$adminAlertsDtoOutputAlertsInnerCodeEnum_prepLate;
  @BuiltValueEnumConst(wireName: r'captain_waiting')
  static const AdminAlertsDtoOutputAlertsInnerCodeEnum captainWaiting =
      _$adminAlertsDtoOutputAlertsInnerCodeEnum_captainWaiting;
  @BuiltValueEnumConst(wireName: r'delivery_late')
  static const AdminAlertsDtoOutputAlertsInnerCodeEnum deliveryLate =
      _$adminAlertsDtoOutputAlertsInnerCodeEnum_deliveryLate;
  @BuiltValueEnumConst(wireName: r'collection_shortfall')
  static const AdminAlertsDtoOutputAlertsInnerCodeEnum collectionShortfall =
      _$adminAlertsDtoOutputAlertsInnerCodeEnum_collectionShortfall;
  @BuiltValueEnumConst(wireName: r'captain_cash_limit')
  static const AdminAlertsDtoOutputAlertsInnerCodeEnum captainCashLimit =
      _$adminAlertsDtoOutputAlertsInnerCodeEnum_captainCashLimit;
  @BuiltValueEnumConst(wireName: r'codes_cannot_send')
  static const AdminAlertsDtoOutputAlertsInnerCodeEnum codesCannotSend =
      _$adminAlertsDtoOutputAlertsInnerCodeEnum_codesCannotSend;
  @BuiltValueEnumConst(wireName: r'code_number_stopped')
  static const AdminAlertsDtoOutputAlertsInnerCodeEnum codeNumberStopped =
      _$adminAlertsDtoOutputAlertsInnerCodeEnum_codeNumberStopped;
  @BuiltValueEnumConst(wireName: r'away_from_address')
  static const AdminAlertsDtoOutputAlertsInnerCodeEnum awayFromAddress =
      _$adminAlertsDtoOutputAlertsInnerCodeEnum_awayFromAddress;
  @BuiltValueEnumConst(wireName: r'item_unavailable')
  static const AdminAlertsDtoOutputAlertsInnerCodeEnum itemUnavailable =
      _$adminAlertsDtoOutputAlertsInnerCodeEnum_itemUnavailable;
  @BuiltValueEnumConst(wireName: r'edit_unacknowledged')
  static const AdminAlertsDtoOutputAlertsInnerCodeEnum editUnacknowledged =
      _$adminAlertsDtoOutputAlertsInnerCodeEnum_editUnacknowledged;
  @BuiltValueEnumConst(wireName: r'captain_cannot_complete')
  static const AdminAlertsDtoOutputAlertsInnerCodeEnum captainCannotComplete =
      _$adminAlertsDtoOutputAlertsInnerCodeEnum_captainCannotComplete;
  @BuiltValueEnumConst(wireName: r'restaurant_auto_paused')
  static const AdminAlertsDtoOutputAlertsInnerCodeEnum restaurantAutoPaused =
      _$adminAlertsDtoOutputAlertsInnerCodeEnum_restaurantAutoPaused;

  static Serializer<AdminAlertsDtoOutputAlertsInnerCodeEnum> get serializer =>
      _$adminAlertsDtoOutputAlertsInnerCodeEnumSerializer;

  const AdminAlertsDtoOutputAlertsInnerCodeEnum._(String name) : super(name);

  static BuiltSet<AdminAlertsDtoOutputAlertsInnerCodeEnum> get values =>
      _$adminAlertsDtoOutputAlertsInnerCodeEnumValues;
  static AdminAlertsDtoOutputAlertsInnerCodeEnum valueOf(String name) =>
      _$adminAlertsDtoOutputAlertsInnerCodeEnumValueOf(name);
}

/// critical repeats its sound until acknowledged, warning plays once, information is silent (AP §7.3).
class AdminAlertsDtoOutputAlertsInnerSeverityEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'critical')
  static const AdminAlertsDtoOutputAlertsInnerSeverityEnum critical =
      _$adminAlertsDtoOutputAlertsInnerSeverityEnum_critical;
  @BuiltValueEnumConst(wireName: r'warning')
  static const AdminAlertsDtoOutputAlertsInnerSeverityEnum warning =
      _$adminAlertsDtoOutputAlertsInnerSeverityEnum_warning;
  @BuiltValueEnumConst(wireName: r'information')
  static const AdminAlertsDtoOutputAlertsInnerSeverityEnum information =
      _$adminAlertsDtoOutputAlertsInnerSeverityEnum_information;

  static Serializer<AdminAlertsDtoOutputAlertsInnerSeverityEnum>
  get serializer => _$adminAlertsDtoOutputAlertsInnerSeverityEnumSerializer;

  const AdminAlertsDtoOutputAlertsInnerSeverityEnum._(String name)
    : super(name);

  static BuiltSet<AdminAlertsDtoOutputAlertsInnerSeverityEnum> get values =>
      _$adminAlertsDtoOutputAlertsInnerSeverityEnumValues;
  static AdminAlertsDtoOutputAlertsInnerSeverityEnum valueOf(String name) =>
      _$adminAlertsDtoOutputAlertsInnerSeverityEnumValueOf(name);
}

class AdminAlertsDtoOutputAlertsInnerSubjectTypeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'order')
  static const AdminAlertsDtoOutputAlertsInnerSubjectTypeEnum order =
      _$adminAlertsDtoOutputAlertsInnerSubjectTypeEnum_order;
  @BuiltValueEnumConst(wireName: r'captain')
  static const AdminAlertsDtoOutputAlertsInnerSubjectTypeEnum captain =
      _$adminAlertsDtoOutputAlertsInnerSubjectTypeEnum_captain;
  @BuiltValueEnumConst(wireName: r'otp_pool')
  static const AdminAlertsDtoOutputAlertsInnerSubjectTypeEnum otpPool =
      _$adminAlertsDtoOutputAlertsInnerSubjectTypeEnum_otpPool;
  @BuiltValueEnumConst(wireName: r'otp_number')
  static const AdminAlertsDtoOutputAlertsInnerSubjectTypeEnum otpNumber =
      _$adminAlertsDtoOutputAlertsInnerSubjectTypeEnum_otpNumber;
  @BuiltValueEnumConst(wireName: r'restaurant')
  static const AdminAlertsDtoOutputAlertsInnerSubjectTypeEnum restaurant =
      _$adminAlertsDtoOutputAlertsInnerSubjectTypeEnum_restaurant;

  static Serializer<AdminAlertsDtoOutputAlertsInnerSubjectTypeEnum>
  get serializer => _$adminAlertsDtoOutputAlertsInnerSubjectTypeEnumSerializer;

  const AdminAlertsDtoOutputAlertsInnerSubjectTypeEnum._(String name)
    : super(name);

  static BuiltSet<AdminAlertsDtoOutputAlertsInnerSubjectTypeEnum> get values =>
      _$adminAlertsDtoOutputAlertsInnerSubjectTypeEnumValues;
  static AdminAlertsDtoOutputAlertsInnerSubjectTypeEnum valueOf(String name) =>
      _$adminAlertsDtoOutputAlertsInnerSubjectTypeEnumValueOf(name);
}
