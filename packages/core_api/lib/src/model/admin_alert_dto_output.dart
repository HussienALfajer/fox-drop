//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_alerts_dto_output_alerts_inner_acknowledged.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_alert_dto_output.g.dart';

/// AdminAlertDtoOutput
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
abstract class AdminAlertDtoOutput
    implements Built<AdminAlertDtoOutput, AdminAlertDtoOutputBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  /// The rule of AP §9.1.3.
  @BuiltValueField(wireName: r'code')
  AdminAlertDtoOutputCodeEnum get code;
  // enum codeEnum {  restaurant_not_accepted,  no_captain,  no_captain_after_ready,  captain_gps_lost,  pickup_disputed,  prep_late,  captain_waiting,  delivery_late,  collection_shortfall,  captain_cash_limit,  codes_cannot_send,  code_number_stopped,  away_from_address,  item_unavailable,  edit_unacknowledged,  captain_cannot_complete,  restaurant_auto_paused,  };

  /// critical repeats its sound until acknowledged, warning plays once, information is silent (AP §7.3).
  @BuiltValueField(wireName: r'severity')
  AdminAlertDtoOutputSeverityEnum get severity;
  // enum severityEnum {  critical,  warning,  information,  };

  @BuiltValueField(wireName: r'subjectType')
  AdminAlertDtoOutputSubjectTypeEnum get subjectType;
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

  AdminAlertDtoOutput._();

  factory AdminAlertDtoOutput([void updates(AdminAlertDtoOutputBuilder b)]) =
      _$AdminAlertDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminAlertDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminAlertDtoOutput> get serializer =>
      _$AdminAlertDtoOutputSerializer();
}

class _$AdminAlertDtoOutputSerializer
    implements PrimitiveSerializer<AdminAlertDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminAlertDtoOutput,
    _$AdminAlertDtoOutput,
  ];

  @override
  final String wireName = r'AdminAlertDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminAlertDtoOutput object, {
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
      specifiedType: const FullType(AdminAlertDtoOutputCodeEnum),
    );
    yield r'severity';
    yield serializers.serialize(
      object.severity,
      specifiedType: const FullType(AdminAlertDtoOutputSeverityEnum),
    );
    yield r'subjectType';
    yield serializers.serialize(
      object.subjectType,
      specifiedType: const FullType(AdminAlertDtoOutputSubjectTypeEnum),
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
    AdminAlertDtoOutput object, {
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
    required AdminAlertDtoOutputBuilder result,
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
                    specifiedType: const FullType(AdminAlertDtoOutputCodeEnum),
                  )
                  as AdminAlertDtoOutputCodeEnum;
          result.code = valueDes;
          break;
        case r'severity':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminAlertDtoOutputSeverityEnum,
                    ),
                  )
                  as AdminAlertDtoOutputSeverityEnum;
          result.severity = valueDes;
          break;
        case r'subjectType':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminAlertDtoOutputSubjectTypeEnum,
                    ),
                  )
                  as AdminAlertDtoOutputSubjectTypeEnum;
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
  AdminAlertDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminAlertDtoOutputBuilder();
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
class AdminAlertDtoOutputCodeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'restaurant_not_accepted')
  static const AdminAlertDtoOutputCodeEnum restaurantNotAccepted =
      _$adminAlertDtoOutputCodeEnum_restaurantNotAccepted;
  @BuiltValueEnumConst(wireName: r'no_captain')
  static const AdminAlertDtoOutputCodeEnum noCaptain =
      _$adminAlertDtoOutputCodeEnum_noCaptain;
  @BuiltValueEnumConst(wireName: r'no_captain_after_ready')
  static const AdminAlertDtoOutputCodeEnum noCaptainAfterReady =
      _$adminAlertDtoOutputCodeEnum_noCaptainAfterReady;
  @BuiltValueEnumConst(wireName: r'captain_gps_lost')
  static const AdminAlertDtoOutputCodeEnum captainGpsLost =
      _$adminAlertDtoOutputCodeEnum_captainGpsLost;
  @BuiltValueEnumConst(wireName: r'pickup_disputed')
  static const AdminAlertDtoOutputCodeEnum pickupDisputed =
      _$adminAlertDtoOutputCodeEnum_pickupDisputed;
  @BuiltValueEnumConst(wireName: r'prep_late')
  static const AdminAlertDtoOutputCodeEnum prepLate =
      _$adminAlertDtoOutputCodeEnum_prepLate;
  @BuiltValueEnumConst(wireName: r'captain_waiting')
  static const AdminAlertDtoOutputCodeEnum captainWaiting =
      _$adminAlertDtoOutputCodeEnum_captainWaiting;
  @BuiltValueEnumConst(wireName: r'delivery_late')
  static const AdminAlertDtoOutputCodeEnum deliveryLate =
      _$adminAlertDtoOutputCodeEnum_deliveryLate;
  @BuiltValueEnumConst(wireName: r'collection_shortfall')
  static const AdminAlertDtoOutputCodeEnum collectionShortfall =
      _$adminAlertDtoOutputCodeEnum_collectionShortfall;
  @BuiltValueEnumConst(wireName: r'captain_cash_limit')
  static const AdminAlertDtoOutputCodeEnum captainCashLimit =
      _$adminAlertDtoOutputCodeEnum_captainCashLimit;
  @BuiltValueEnumConst(wireName: r'codes_cannot_send')
  static const AdminAlertDtoOutputCodeEnum codesCannotSend =
      _$adminAlertDtoOutputCodeEnum_codesCannotSend;
  @BuiltValueEnumConst(wireName: r'code_number_stopped')
  static const AdminAlertDtoOutputCodeEnum codeNumberStopped =
      _$adminAlertDtoOutputCodeEnum_codeNumberStopped;
  @BuiltValueEnumConst(wireName: r'away_from_address')
  static const AdminAlertDtoOutputCodeEnum awayFromAddress =
      _$adminAlertDtoOutputCodeEnum_awayFromAddress;
  @BuiltValueEnumConst(wireName: r'item_unavailable')
  static const AdminAlertDtoOutputCodeEnum itemUnavailable =
      _$adminAlertDtoOutputCodeEnum_itemUnavailable;
  @BuiltValueEnumConst(wireName: r'edit_unacknowledged')
  static const AdminAlertDtoOutputCodeEnum editUnacknowledged =
      _$adminAlertDtoOutputCodeEnum_editUnacknowledged;
  @BuiltValueEnumConst(wireName: r'captain_cannot_complete')
  static const AdminAlertDtoOutputCodeEnum captainCannotComplete =
      _$adminAlertDtoOutputCodeEnum_captainCannotComplete;
  @BuiltValueEnumConst(wireName: r'restaurant_auto_paused')
  static const AdminAlertDtoOutputCodeEnum restaurantAutoPaused =
      _$adminAlertDtoOutputCodeEnum_restaurantAutoPaused;

  static Serializer<AdminAlertDtoOutputCodeEnum> get serializer =>
      _$adminAlertDtoOutputCodeEnumSerializer;

  const AdminAlertDtoOutputCodeEnum._(String name) : super(name);

  static BuiltSet<AdminAlertDtoOutputCodeEnum> get values =>
      _$adminAlertDtoOutputCodeEnumValues;
  static AdminAlertDtoOutputCodeEnum valueOf(String name) =>
      _$adminAlertDtoOutputCodeEnumValueOf(name);
}

/// critical repeats its sound until acknowledged, warning plays once, information is silent (AP §7.3).
class AdminAlertDtoOutputSeverityEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'critical')
  static const AdminAlertDtoOutputSeverityEnum critical =
      _$adminAlertDtoOutputSeverityEnum_critical;
  @BuiltValueEnumConst(wireName: r'warning')
  static const AdminAlertDtoOutputSeverityEnum warning =
      _$adminAlertDtoOutputSeverityEnum_warning;
  @BuiltValueEnumConst(wireName: r'information')
  static const AdminAlertDtoOutputSeverityEnum information =
      _$adminAlertDtoOutputSeverityEnum_information;

  static Serializer<AdminAlertDtoOutputSeverityEnum> get serializer =>
      _$adminAlertDtoOutputSeverityEnumSerializer;

  const AdminAlertDtoOutputSeverityEnum._(String name) : super(name);

  static BuiltSet<AdminAlertDtoOutputSeverityEnum> get values =>
      _$adminAlertDtoOutputSeverityEnumValues;
  static AdminAlertDtoOutputSeverityEnum valueOf(String name) =>
      _$adminAlertDtoOutputSeverityEnumValueOf(name);
}

class AdminAlertDtoOutputSubjectTypeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'order')
  static const AdminAlertDtoOutputSubjectTypeEnum order =
      _$adminAlertDtoOutputSubjectTypeEnum_order;
  @BuiltValueEnumConst(wireName: r'captain')
  static const AdminAlertDtoOutputSubjectTypeEnum captain =
      _$adminAlertDtoOutputSubjectTypeEnum_captain;
  @BuiltValueEnumConst(wireName: r'otp_pool')
  static const AdminAlertDtoOutputSubjectTypeEnum otpPool =
      _$adminAlertDtoOutputSubjectTypeEnum_otpPool;
  @BuiltValueEnumConst(wireName: r'otp_number')
  static const AdminAlertDtoOutputSubjectTypeEnum otpNumber =
      _$adminAlertDtoOutputSubjectTypeEnum_otpNumber;
  @BuiltValueEnumConst(wireName: r'restaurant')
  static const AdminAlertDtoOutputSubjectTypeEnum restaurant =
      _$adminAlertDtoOutputSubjectTypeEnum_restaurant;

  static Serializer<AdminAlertDtoOutputSubjectTypeEnum> get serializer =>
      _$adminAlertDtoOutputSubjectTypeEnumSerializer;

  const AdminAlertDtoOutputSubjectTypeEnum._(String name) : super(name);

  static BuiltSet<AdminAlertDtoOutputSubjectTypeEnum> get values =>
      _$adminAlertDtoOutputSubjectTypeEnumValues;
  static AdminAlertDtoOutputSubjectTypeEnum valueOf(String name) =>
      _$adminAlertDtoOutputSubjectTypeEnumValueOf(name);
}
