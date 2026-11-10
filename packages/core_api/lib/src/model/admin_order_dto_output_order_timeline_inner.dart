//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_order_dto_output_order_timeline_inner_time_change.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_order_dto_output_order_timeline_inner_actor.dart';
import 'package:core_api/src/model/admin_order_dto_output_order_timeline_inner_item_report.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_dto_output_order_timeline_inner.g.dart';

/// AdminOrderDtoOutputOrderTimelineInner
///
/// Properties:
/// * [version]
/// * [at]
/// * [type] - Such as order.accepted or order.offered.
/// * [from]
/// * [to]
/// * [actor]
/// * [captainId] - The offer's captain, or the one assigned.
/// * [reason]
/// * [timeChange]
/// * [itemReport]
@BuiltValue()
abstract class AdminOrderDtoOutputOrderTimelineInner
    implements
        Built<
          AdminOrderDtoOutputOrderTimelineInner,
          AdminOrderDtoOutputOrderTimelineInnerBuilder
        > {
  @BuiltValueField(wireName: r'version')
  int get version;

  @BuiltValueField(wireName: r'at')
  DateTime get at;

  /// Such as order.accepted or order.offered.
  @BuiltValueField(wireName: r'type')
  String? get type;

  @BuiltValueField(wireName: r'from')
  AdminOrderDtoOutputOrderTimelineInnerFromEnum? get from;
  // enum fromEnum {  placed,  accepted,  ready,  picked_up,  arrived,  delivered,  rejected,  cancelled,  failed,  };

  @BuiltValueField(wireName: r'to')
  AdminOrderDtoOutputOrderTimelineInnerToEnum get to;
  // enum toEnum {  placed,  accepted,  ready,  picked_up,  arrived,  delivered,  rejected,  cancelled,  failed,  };

  @BuiltValueField(wireName: r'actor')
  AdminOrderDtoOutputOrderTimelineInnerActor get actor;

  /// The offer's captain, or the one assigned.
  @BuiltValueField(wireName: r'captainId')
  String? get captainId;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'timeChange')
  AdminOrderDtoOutputOrderTimelineInnerTimeChange? get timeChange;

  @BuiltValueField(wireName: r'itemReport')
  AdminOrderDtoOutputOrderTimelineInnerItemReport? get itemReport;

  AdminOrderDtoOutputOrderTimelineInner._();

  factory AdminOrderDtoOutputOrderTimelineInner([
    void updates(AdminOrderDtoOutputOrderTimelineInnerBuilder b),
  ]) = _$AdminOrderDtoOutputOrderTimelineInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderDtoOutputOrderTimelineInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderDtoOutputOrderTimelineInner> get serializer =>
      _$AdminOrderDtoOutputOrderTimelineInnerSerializer();
}

class _$AdminOrderDtoOutputOrderTimelineInnerSerializer
    implements PrimitiveSerializer<AdminOrderDtoOutputOrderTimelineInner> {
  @override
  final Iterable<Type> types = const [
    AdminOrderDtoOutputOrderTimelineInner,
    _$AdminOrderDtoOutputOrderTimelineInner,
  ];

  @override
  final String wireName = r'AdminOrderDtoOutputOrderTimelineInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderDtoOutputOrderTimelineInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(int),
    );
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
    yield r'type';
    yield object.type == null
        ? null
        : serializers.serialize(
            object.type,
            specifiedType: const FullType.nullable(String),
          );
    yield r'from';
    yield object.from == null
        ? null
        : serializers.serialize(
            object.from,
            specifiedType: const FullType.nullable(
              AdminOrderDtoOutputOrderTimelineInnerFromEnum,
            ),
          );
    yield r'to';
    yield serializers.serialize(
      object.to,
      specifiedType: const FullType(
        AdminOrderDtoOutputOrderTimelineInnerToEnum,
      ),
    );
    yield r'actor';
    yield serializers.serialize(
      object.actor,
      specifiedType: const FullType(AdminOrderDtoOutputOrderTimelineInnerActor),
    );
    yield r'captainId';
    yield object.captainId == null
        ? null
        : serializers.serialize(
            object.captainId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'reason';
    yield object.reason == null
        ? null
        : serializers.serialize(
            object.reason,
            specifiedType: const FullType.nullable(String),
          );
    yield r'timeChange';
    yield object.timeChange == null
        ? null
        : serializers.serialize(
            object.timeChange,
            specifiedType: const FullType.nullable(
              AdminOrderDtoOutputOrderTimelineInnerTimeChange,
            ),
          );
    yield r'itemReport';
    yield object.itemReport == null
        ? null
        : serializers.serialize(
            object.itemReport,
            specifiedType: const FullType.nullable(
              AdminOrderDtoOutputOrderTimelineInnerItemReport,
            ),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderTimelineInner object, {
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
    required AdminOrderDtoOutputOrderTimelineInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'version':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.version = valueDes;
          break;
        case r'at':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.at = valueDes;
          break;
        case r'type':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.type = valueDes;
          break;
        case r'from':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminOrderDtoOutputOrderTimelineInnerFromEnum,
                    ),
                  )
                  as AdminOrderDtoOutputOrderTimelineInnerFromEnum?;
          if (valueDes == null) continue;
          result.from = valueDes;
          break;
        case r'to':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminOrderDtoOutputOrderTimelineInnerToEnum,
                    ),
                  )
                  as AdminOrderDtoOutputOrderTimelineInnerToEnum;
          result.to = valueDes;
          break;
        case r'actor':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminOrderDtoOutputOrderTimelineInnerActor,
                    ),
                  )
                  as AdminOrderDtoOutputOrderTimelineInnerActor;
          result.actor.replace(valueDes);
          break;
        case r'captainId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.captainId = valueDes;
          break;
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        case r'timeChange':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminOrderDtoOutputOrderTimelineInnerTimeChange,
                    ),
                  )
                  as AdminOrderDtoOutputOrderTimelineInnerTimeChange?;
          if (valueDes == null) continue;
          result.timeChange.replace(valueDes);
          break;
        case r'itemReport':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminOrderDtoOutputOrderTimelineInnerItemReport,
                    ),
                  )
                  as AdminOrderDtoOutputOrderTimelineInnerItemReport?;
          if (valueDes == null) continue;
          result.itemReport.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderDtoOutputOrderTimelineInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderDtoOutputOrderTimelineInnerBuilder();
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

class AdminOrderDtoOutputOrderTimelineInnerFromEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'placed')
  static const AdminOrderDtoOutputOrderTimelineInnerFromEnum placed =
      _$adminOrderDtoOutputOrderTimelineInnerFromEnum_placed;
  @BuiltValueEnumConst(wireName: r'accepted')
  static const AdminOrderDtoOutputOrderTimelineInnerFromEnum accepted =
      _$adminOrderDtoOutputOrderTimelineInnerFromEnum_accepted;
  @BuiltValueEnumConst(wireName: r'ready')
  static const AdminOrderDtoOutputOrderTimelineInnerFromEnum ready =
      _$adminOrderDtoOutputOrderTimelineInnerFromEnum_ready;
  @BuiltValueEnumConst(wireName: r'picked_up')
  static const AdminOrderDtoOutputOrderTimelineInnerFromEnum pickedUp =
      _$adminOrderDtoOutputOrderTimelineInnerFromEnum_pickedUp;
  @BuiltValueEnumConst(wireName: r'arrived')
  static const AdminOrderDtoOutputOrderTimelineInnerFromEnum arrived =
      _$adminOrderDtoOutputOrderTimelineInnerFromEnum_arrived;
  @BuiltValueEnumConst(wireName: r'delivered')
  static const AdminOrderDtoOutputOrderTimelineInnerFromEnum delivered =
      _$adminOrderDtoOutputOrderTimelineInnerFromEnum_delivered;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const AdminOrderDtoOutputOrderTimelineInnerFromEnum rejected =
      _$adminOrderDtoOutputOrderTimelineInnerFromEnum_rejected;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const AdminOrderDtoOutputOrderTimelineInnerFromEnum cancelled =
      _$adminOrderDtoOutputOrderTimelineInnerFromEnum_cancelled;
  @BuiltValueEnumConst(wireName: r'failed')
  static const AdminOrderDtoOutputOrderTimelineInnerFromEnum failed =
      _$adminOrderDtoOutputOrderTimelineInnerFromEnum_failed;

  static Serializer<AdminOrderDtoOutputOrderTimelineInnerFromEnum>
  get serializer => _$adminOrderDtoOutputOrderTimelineInnerFromEnumSerializer;

  const AdminOrderDtoOutputOrderTimelineInnerFromEnum._(String name)
    : super(name);

  static BuiltSet<AdminOrderDtoOutputOrderTimelineInnerFromEnum> get values =>
      _$adminOrderDtoOutputOrderTimelineInnerFromEnumValues;
  static AdminOrderDtoOutputOrderTimelineInnerFromEnum valueOf(String name) =>
      _$adminOrderDtoOutputOrderTimelineInnerFromEnumValueOf(name);
}

class AdminOrderDtoOutputOrderTimelineInnerToEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'placed')
  static const AdminOrderDtoOutputOrderTimelineInnerToEnum placed =
      _$adminOrderDtoOutputOrderTimelineInnerToEnum_placed;
  @BuiltValueEnumConst(wireName: r'accepted')
  static const AdminOrderDtoOutputOrderTimelineInnerToEnum accepted =
      _$adminOrderDtoOutputOrderTimelineInnerToEnum_accepted;
  @BuiltValueEnumConst(wireName: r'ready')
  static const AdminOrderDtoOutputOrderTimelineInnerToEnum ready =
      _$adminOrderDtoOutputOrderTimelineInnerToEnum_ready;
  @BuiltValueEnumConst(wireName: r'picked_up')
  static const AdminOrderDtoOutputOrderTimelineInnerToEnum pickedUp =
      _$adminOrderDtoOutputOrderTimelineInnerToEnum_pickedUp;
  @BuiltValueEnumConst(wireName: r'arrived')
  static const AdminOrderDtoOutputOrderTimelineInnerToEnum arrived =
      _$adminOrderDtoOutputOrderTimelineInnerToEnum_arrived;
  @BuiltValueEnumConst(wireName: r'delivered')
  static const AdminOrderDtoOutputOrderTimelineInnerToEnum delivered =
      _$adminOrderDtoOutputOrderTimelineInnerToEnum_delivered;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const AdminOrderDtoOutputOrderTimelineInnerToEnum rejected =
      _$adminOrderDtoOutputOrderTimelineInnerToEnum_rejected;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const AdminOrderDtoOutputOrderTimelineInnerToEnum cancelled =
      _$adminOrderDtoOutputOrderTimelineInnerToEnum_cancelled;
  @BuiltValueEnumConst(wireName: r'failed')
  static const AdminOrderDtoOutputOrderTimelineInnerToEnum failed =
      _$adminOrderDtoOutputOrderTimelineInnerToEnum_failed;

  static Serializer<AdminOrderDtoOutputOrderTimelineInnerToEnum>
  get serializer => _$adminOrderDtoOutputOrderTimelineInnerToEnumSerializer;

  const AdminOrderDtoOutputOrderTimelineInnerToEnum._(String name)
    : super(name);

  static BuiltSet<AdminOrderDtoOutputOrderTimelineInnerToEnum> get values =>
      _$adminOrderDtoOutputOrderTimelineInnerToEnumValues;
  static AdminOrderDtoOutputOrderTimelineInnerToEnum valueOf(String name) =>
      _$adminOrderDtoOutputOrderTimelineInnerToEnumValueOf(name);
}
