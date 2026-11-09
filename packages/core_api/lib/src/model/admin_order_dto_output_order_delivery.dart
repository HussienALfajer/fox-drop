//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_went_offline_dto_output_hand_in.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_order_dto_output_order_delivery_recorded_by.dart';
import 'package:core_api/src/model/admin_order_dto_output_order_delivery_shortfall.dart';
import 'package:core_api/src/model/admin_order_dto_output_order_delivery_net_received.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_dto_output_order_delivery.g.dart';

/// After «تم التسليم» (AP §9.3.1).
///
/// Properties:
/// * [at] 
/// * [outcome] 
/// * [received] - The payment lines (AP §9.3.1).
/// * [change] - The change given.
/// * [netReceived] 
/// * [shortfall] 
/// * [recordedBy] 
@BuiltValue()
abstract class AdminOrderDtoOutputOrderDelivery implements Built<AdminOrderDtoOutputOrderDelivery, AdminOrderDtoOutputOrderDeliveryBuilder> {
  @BuiltValueField(wireName: r'at')
  DateTime get at;

  @BuiltValueField(wireName: r'outcome')
  AdminOrderDtoOutputOrderDeliveryOutcomeEnum get outcome;
  // enum outcomeEnum {  normal,  free,  fake,  damaged,  wrong_refused,  failed_other,  };

  /// The payment lines (AP §9.3.1).
  @BuiltValueField(wireName: r'received')
  BuiltList<CaptainWentOfflineDtoOutputHandIn?> get received;

  /// The change given.
  @BuiltValueField(wireName: r'change')
  BuiltList<CaptainWentOfflineDtoOutputHandIn?> get change;

  @BuiltValueField(wireName: r'netReceived')
  AdminOrderDtoOutputOrderDeliveryNetReceived get netReceived;

  @BuiltValueField(wireName: r'shortfall')
  AdminOrderDtoOutputOrderDeliveryShortfall? get shortfall;

  @BuiltValueField(wireName: r'recordedBy')
  AdminOrderDtoOutputOrderDeliveryRecordedBy get recordedBy;

  AdminOrderDtoOutputOrderDelivery._();

  factory AdminOrderDtoOutputOrderDelivery([void updates(AdminOrderDtoOutputOrderDeliveryBuilder b)]) = _$AdminOrderDtoOutputOrderDelivery;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderDtoOutputOrderDeliveryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderDtoOutputOrderDelivery> get serializer => _$AdminOrderDtoOutputOrderDeliverySerializer();
}

class _$AdminOrderDtoOutputOrderDeliverySerializer implements PrimitiveSerializer<AdminOrderDtoOutputOrderDelivery> {
  @override
  final Iterable<Type> types = const [AdminOrderDtoOutputOrderDelivery, _$AdminOrderDtoOutputOrderDelivery];

  @override
  final String wireName = r'AdminOrderDtoOutputOrderDelivery';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderDtoOutputOrderDelivery object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
    yield r'outcome';
    yield serializers.serialize(
      object.outcome,
      specifiedType: const FullType(AdminOrderDtoOutputOrderDeliveryOutcomeEnum),
    );
    yield r'received';
    yield serializers.serialize(
      object.received,
      specifiedType: const FullType(BuiltList, [FullType.nullable(CaptainWentOfflineDtoOutputHandIn)]),
    );
    yield r'change';
    yield serializers.serialize(
      object.change,
      specifiedType: const FullType(BuiltList, [FullType.nullable(CaptainWentOfflineDtoOutputHandIn)]),
    );
    yield r'netReceived';
    yield serializers.serialize(
      object.netReceived,
      specifiedType: const FullType(AdminOrderDtoOutputOrderDeliveryNetReceived),
    );
    yield r'shortfall';
    yield object.shortfall == null ? null : serializers.serialize(
      object.shortfall,
      specifiedType: const FullType.nullable(AdminOrderDtoOutputOrderDeliveryShortfall),
    );
    yield r'recordedBy';
    yield serializers.serialize(
      object.recordedBy,
      specifiedType: const FullType(AdminOrderDtoOutputOrderDeliveryRecordedBy),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderDelivery object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminOrderDtoOutputOrderDeliveryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.at = valueDes;
          break;
        case r'outcome':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminOrderDtoOutputOrderDeliveryOutcomeEnum),
          ) as AdminOrderDtoOutputOrderDeliveryOutcomeEnum;
          result.outcome = valueDes;
          break;
        case r'received':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType.nullable(CaptainWentOfflineDtoOutputHandIn)]),
          ) as BuiltList<CaptainWentOfflineDtoOutputHandIn?>;
          result.received.replace(valueDes);
          break;
        case r'change':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType.nullable(CaptainWentOfflineDtoOutputHandIn)]),
          ) as BuiltList<CaptainWentOfflineDtoOutputHandIn?>;
          result.change.replace(valueDes);
          break;
        case r'netReceived':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminOrderDtoOutputOrderDeliveryNetReceived),
          ) as AdminOrderDtoOutputOrderDeliveryNetReceived;
          result.netReceived.replace(valueDes);
          break;
        case r'shortfall':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AdminOrderDtoOutputOrderDeliveryShortfall),
          ) as AdminOrderDtoOutputOrderDeliveryShortfall?;
          if (valueDes == null) continue;
          result.shortfall.replace(valueDes);
          break;
        case r'recordedBy':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminOrderDtoOutputOrderDeliveryRecordedBy),
          ) as AdminOrderDtoOutputOrderDeliveryRecordedBy;
          result.recordedBy.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderDtoOutputOrderDelivery deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderDtoOutputOrderDeliveryBuilder();
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


class AdminOrderDtoOutputOrderDeliveryOutcomeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'normal')
  static const AdminOrderDtoOutputOrderDeliveryOutcomeEnum normal = _$adminOrderDtoOutputOrderDeliveryOutcomeEnum_normal;
  @BuiltValueEnumConst(wireName: r'free')
  static const AdminOrderDtoOutputOrderDeliveryOutcomeEnum free = _$adminOrderDtoOutputOrderDeliveryOutcomeEnum_free;
  @BuiltValueEnumConst(wireName: r'fake')
  static const AdminOrderDtoOutputOrderDeliveryOutcomeEnum fake = _$adminOrderDtoOutputOrderDeliveryOutcomeEnum_fake;
  @BuiltValueEnumConst(wireName: r'damaged')
  static const AdminOrderDtoOutputOrderDeliveryOutcomeEnum damaged = _$adminOrderDtoOutputOrderDeliveryOutcomeEnum_damaged;
  @BuiltValueEnumConst(wireName: r'wrong_refused')
  static const AdminOrderDtoOutputOrderDeliveryOutcomeEnum wrongRefused = _$adminOrderDtoOutputOrderDeliveryOutcomeEnum_wrongRefused;
  @BuiltValueEnumConst(wireName: r'failed_other')
  static const AdminOrderDtoOutputOrderDeliveryOutcomeEnum failedOther = _$adminOrderDtoOutputOrderDeliveryOutcomeEnum_failedOther;

  static Serializer<AdminOrderDtoOutputOrderDeliveryOutcomeEnum> get serializer => _$adminOrderDtoOutputOrderDeliveryOutcomeEnumSerializer;

  const AdminOrderDtoOutputOrderDeliveryOutcomeEnum._(String name): super(name);

  static BuiltSet<AdminOrderDtoOutputOrderDeliveryOutcomeEnum> get values => _$adminOrderDtoOutputOrderDeliveryOutcomeEnumValues;
  static AdminOrderDtoOutputOrderDeliveryOutcomeEnum valueOf(String name) => _$adminOrderDtoOutputOrderDeliveryOutcomeEnumValueOf(name);
}

