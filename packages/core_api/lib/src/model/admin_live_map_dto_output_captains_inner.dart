//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_live_map_dto_output_captains_inner_custody.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/customer_order_route_dto_output_captain.dart';
import 'package:core_api/src/model/admin_live_map_dto_output_captains_inner_order.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_live_map_dto_output_captains_inner.g.dart';

/// AdminLiveMapDtoOutputCaptainsInner
///
/// Properties:
/// * [captainId]
/// * [name]
/// * [vehicle]
/// * [state] - CA §7.1. The map: online_available green, busy and last_order orange, the others grey (offline and suspended show the last known position and its time).
/// * [blocks] - AP §9.4 «red outline»: blocked for unhanded cash or at the cash limit.
/// * [custody]
/// * [position]
/// * [order]
@BuiltValue()
abstract class AdminLiveMapDtoOutputCaptainsInner
    implements
        Built<
          AdminLiveMapDtoOutputCaptainsInner,
          AdminLiveMapDtoOutputCaptainsInnerBuilder
        > {
  @BuiltValueField(wireName: r'captainId')
  String get captainId;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'vehicle')
  AdminLiveMapDtoOutputCaptainsInnerVehicleEnum get vehicle;
  // enum vehicleEnum {  walking,  bicycle,  motorbike,  car,  };

  /// CA §7.1. The map: online_available green, busy and last_order orange, the others grey (offline and suspended show the last known position and its time).
  @BuiltValueField(wireName: r'state')
  AdminLiveMapDtoOutputCaptainsInnerStateEnum get state;
  // enum stateEnum {  offline,  online_available,  busy,  last_order,  not_receiving_offers,  suspended,  };

  /// AP §9.4 «red outline»: blocked for unhanded cash or at the cash limit.
  @BuiltValueField(wireName: r'blocks')
  BuiltList<AdminLiveMapDtoOutputCaptainsInnerBlocksEnum> get blocks;
  // enum blocksEnum {  closed_due,  cash_limit,  };

  @BuiltValueField(wireName: r'custody')
  AdminLiveMapDtoOutputCaptainsInnerCustody get custody;

  @BuiltValueField(wireName: r'position')
  CustomerOrderRouteDtoOutputCaptain? get position;

  @BuiltValueField(wireName: r'order')
  AdminLiveMapDtoOutputCaptainsInnerOrder? get order;

  AdminLiveMapDtoOutputCaptainsInner._();

  factory AdminLiveMapDtoOutputCaptainsInner([
    void updates(AdminLiveMapDtoOutputCaptainsInnerBuilder b),
  ]) = _$AdminLiveMapDtoOutputCaptainsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminLiveMapDtoOutputCaptainsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminLiveMapDtoOutputCaptainsInner> get serializer =>
      _$AdminLiveMapDtoOutputCaptainsInnerSerializer();
}

class _$AdminLiveMapDtoOutputCaptainsInnerSerializer
    implements PrimitiveSerializer<AdminLiveMapDtoOutputCaptainsInner> {
  @override
  final Iterable<Type> types = const [
    AdminLiveMapDtoOutputCaptainsInner,
    _$AdminLiveMapDtoOutputCaptainsInner,
  ];

  @override
  final String wireName = r'AdminLiveMapDtoOutputCaptainsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminLiveMapDtoOutputCaptainsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'captainId';
    yield serializers.serialize(
      object.captainId,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'vehicle';
    yield serializers.serialize(
      object.vehicle,
      specifiedType: const FullType(
        AdminLiveMapDtoOutputCaptainsInnerVehicleEnum,
      ),
    );
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(
        AdminLiveMapDtoOutputCaptainsInnerStateEnum,
      ),
    );
    yield r'blocks';
    yield serializers.serialize(
      object.blocks,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminLiveMapDtoOutputCaptainsInnerBlocksEnum),
      ]),
    );
    yield r'custody';
    yield serializers.serialize(
      object.custody,
      specifiedType: const FullType(AdminLiveMapDtoOutputCaptainsInnerCustody),
    );
    yield r'position';
    yield object.position == null
        ? null
        : serializers.serialize(
            object.position,
            specifiedType: const FullType.nullable(
              CustomerOrderRouteDtoOutputCaptain,
            ),
          );
    yield r'order';
    yield object.order == null
        ? null
        : serializers.serialize(
            object.order,
            specifiedType: const FullType.nullable(
              AdminLiveMapDtoOutputCaptainsInnerOrder,
            ),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminLiveMapDtoOutputCaptainsInner object, {
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
    required AdminLiveMapDtoOutputCaptainsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'captainId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.captainId = valueDes;
          break;
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.name = valueDes;
          break;
        case r'vehicle':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminLiveMapDtoOutputCaptainsInnerVehicleEnum,
                    ),
                  )
                  as AdminLiveMapDtoOutputCaptainsInnerVehicleEnum;
          result.vehicle = valueDes;
          break;
        case r'state':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminLiveMapDtoOutputCaptainsInnerStateEnum,
                    ),
                  )
                  as AdminLiveMapDtoOutputCaptainsInnerStateEnum;
          result.state = valueDes;
          break;
        case r'blocks':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminLiveMapDtoOutputCaptainsInnerBlocksEnum),
                    ]),
                  )
                  as BuiltList<AdminLiveMapDtoOutputCaptainsInnerBlocksEnum>;
          result.blocks.replace(valueDes);
          break;
        case r'custody':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminLiveMapDtoOutputCaptainsInnerCustody,
                    ),
                  )
                  as AdminLiveMapDtoOutputCaptainsInnerCustody;
          result.custody.replace(valueDes);
          break;
        case r'position':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CustomerOrderRouteDtoOutputCaptain,
                    ),
                  )
                  as CustomerOrderRouteDtoOutputCaptain?;
          if (valueDes == null) continue;
          result.position.replace(valueDes);
          break;
        case r'order':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminLiveMapDtoOutputCaptainsInnerOrder,
                    ),
                  )
                  as AdminLiveMapDtoOutputCaptainsInnerOrder?;
          if (valueDes == null) continue;
          result.order.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminLiveMapDtoOutputCaptainsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminLiveMapDtoOutputCaptainsInnerBuilder();
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

class AdminLiveMapDtoOutputCaptainsInnerVehicleEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'walking')
  static const AdminLiveMapDtoOutputCaptainsInnerVehicleEnum walking =
      _$adminLiveMapDtoOutputCaptainsInnerVehicleEnum_walking;
  @BuiltValueEnumConst(wireName: r'bicycle')
  static const AdminLiveMapDtoOutputCaptainsInnerVehicleEnum bicycle =
      _$adminLiveMapDtoOutputCaptainsInnerVehicleEnum_bicycle;
  @BuiltValueEnumConst(wireName: r'motorbike')
  static const AdminLiveMapDtoOutputCaptainsInnerVehicleEnum motorbike =
      _$adminLiveMapDtoOutputCaptainsInnerVehicleEnum_motorbike;
  @BuiltValueEnumConst(wireName: r'car')
  static const AdminLiveMapDtoOutputCaptainsInnerVehicleEnum car =
      _$adminLiveMapDtoOutputCaptainsInnerVehicleEnum_car;

  static Serializer<AdminLiveMapDtoOutputCaptainsInnerVehicleEnum>
  get serializer => _$adminLiveMapDtoOutputCaptainsInnerVehicleEnumSerializer;

  const AdminLiveMapDtoOutputCaptainsInnerVehicleEnum._(String name)
    : super(name);

  static BuiltSet<AdminLiveMapDtoOutputCaptainsInnerVehicleEnum> get values =>
      _$adminLiveMapDtoOutputCaptainsInnerVehicleEnumValues;
  static AdminLiveMapDtoOutputCaptainsInnerVehicleEnum valueOf(String name) =>
      _$adminLiveMapDtoOutputCaptainsInnerVehicleEnumValueOf(name);
}

/// CA §7.1. The map: online_available green, busy and last_order orange, the others grey (offline and suspended show the last known position and its time).
class AdminLiveMapDtoOutputCaptainsInnerStateEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'offline')
  static const AdminLiveMapDtoOutputCaptainsInnerStateEnum offline =
      _$adminLiveMapDtoOutputCaptainsInnerStateEnum_offline;
  @BuiltValueEnumConst(wireName: r'online_available')
  static const AdminLiveMapDtoOutputCaptainsInnerStateEnum onlineAvailable =
      _$adminLiveMapDtoOutputCaptainsInnerStateEnum_onlineAvailable;
  @BuiltValueEnumConst(wireName: r'busy')
  static const AdminLiveMapDtoOutputCaptainsInnerStateEnum busy =
      _$adminLiveMapDtoOutputCaptainsInnerStateEnum_busy;
  @BuiltValueEnumConst(wireName: r'last_order')
  static const AdminLiveMapDtoOutputCaptainsInnerStateEnum lastOrder =
      _$adminLiveMapDtoOutputCaptainsInnerStateEnum_lastOrder;
  @BuiltValueEnumConst(wireName: r'not_receiving_offers')
  static const AdminLiveMapDtoOutputCaptainsInnerStateEnum notReceivingOffers =
      _$adminLiveMapDtoOutputCaptainsInnerStateEnum_notReceivingOffers;
  @BuiltValueEnumConst(wireName: r'suspended')
  static const AdminLiveMapDtoOutputCaptainsInnerStateEnum suspended =
      _$adminLiveMapDtoOutputCaptainsInnerStateEnum_suspended;

  static Serializer<AdminLiveMapDtoOutputCaptainsInnerStateEnum>
  get serializer => _$adminLiveMapDtoOutputCaptainsInnerStateEnumSerializer;

  const AdminLiveMapDtoOutputCaptainsInnerStateEnum._(String name)
    : super(name);

  static BuiltSet<AdminLiveMapDtoOutputCaptainsInnerStateEnum> get values =>
      _$adminLiveMapDtoOutputCaptainsInnerStateEnumValues;
  static AdminLiveMapDtoOutputCaptainsInnerStateEnum valueOf(String name) =>
      _$adminLiveMapDtoOutputCaptainsInnerStateEnumValueOf(name);
}

class AdminLiveMapDtoOutputCaptainsInnerBlocksEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'closed_due')
  static const AdminLiveMapDtoOutputCaptainsInnerBlocksEnum closedDue =
      _$adminLiveMapDtoOutputCaptainsInnerBlocksEnum_closedDue;
  @BuiltValueEnumConst(wireName: r'cash_limit')
  static const AdminLiveMapDtoOutputCaptainsInnerBlocksEnum cashLimit =
      _$adminLiveMapDtoOutputCaptainsInnerBlocksEnum_cashLimit;

  static Serializer<AdminLiveMapDtoOutputCaptainsInnerBlocksEnum>
  get serializer => _$adminLiveMapDtoOutputCaptainsInnerBlocksEnumSerializer;

  const AdminLiveMapDtoOutputCaptainsInnerBlocksEnum._(String name)
    : super(name);

  static BuiltSet<AdminLiveMapDtoOutputCaptainsInnerBlocksEnum> get values =>
      _$adminLiveMapDtoOutputCaptainsInnerBlocksEnumValues;
  static AdminLiveMapDtoOutputCaptainsInnerBlocksEnum valueOf(String name) =>
      _$adminLiveMapDtoOutputCaptainsInnerBlocksEnumValueOf(name);
}
