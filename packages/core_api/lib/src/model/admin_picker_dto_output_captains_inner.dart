//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_picker_dto_output_captains_inner_custody.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_picker_dto_output_captains_inner.g.dart';

/// AdminPickerDtoOutputCaptainsInner
///
/// Properties:
/// * [captainId] 
/// * [name] 
/// * [vehicle] 
/// * [eligible] 
/// * [reasons] - Why it is greyed out: «مشغول», over the cash limit, blocked for unhanded cash, a simulated location, out of range, vehicle not allowed.
/// * [distanceMetres] - To the restaurant: by road within the search radius, else the straight line.
/// * [etaMin] - To the restaurant; null beyond the search radius.
/// * [ordersToday] 
/// * [custody] 
/// * [acceptanceRate] - A percentage over the last offers answered (CA §11.1); null without one.
@BuiltValue()
abstract class AdminPickerDtoOutputCaptainsInner implements Built<AdminPickerDtoOutputCaptainsInner, AdminPickerDtoOutputCaptainsInnerBuilder> {
  @BuiltValueField(wireName: r'captainId')
  String get captainId;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'vehicle')
  AdminPickerDtoOutputCaptainsInnerVehicleEnum get vehicle;
  // enum vehicleEnum {  walking,  bicycle,  motorbike,  car,  };

  @BuiltValueField(wireName: r'eligible')
  bool get eligible;

  /// Why it is greyed out: «مشغول», over the cash limit, blocked for unhanded cash, a simulated location, out of range, vehicle not allowed.
  @BuiltValueField(wireName: r'reasons')
  BuiltList<AdminPickerDtoOutputCaptainsInnerReasonsEnum> get reasons;
  // enum reasonsEnum {  busy,  cash_limit,  closed_due,  simulated_location,  out_of_range,  vehicle_not_allowed,  };

  /// To the restaurant: by road within the search radius, else the straight line.
  @BuiltValueField(wireName: r'distanceMetres')
  int get distanceMetres;

  /// To the restaurant; null beyond the search radius.
  @BuiltValueField(wireName: r'etaMin')
  int? get etaMin;

  @BuiltValueField(wireName: r'ordersToday')
  int get ordersToday;

  @BuiltValueField(wireName: r'custody')
  AdminPickerDtoOutputCaptainsInnerCustody get custody;

  /// A percentage over the last offers answered (CA §11.1); null without one.
  @BuiltValueField(wireName: r'acceptanceRate')
  int? get acceptanceRate;

  AdminPickerDtoOutputCaptainsInner._();

  factory AdminPickerDtoOutputCaptainsInner([void updates(AdminPickerDtoOutputCaptainsInnerBuilder b)]) = _$AdminPickerDtoOutputCaptainsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminPickerDtoOutputCaptainsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminPickerDtoOutputCaptainsInner> get serializer => _$AdminPickerDtoOutputCaptainsInnerSerializer();
}

class _$AdminPickerDtoOutputCaptainsInnerSerializer implements PrimitiveSerializer<AdminPickerDtoOutputCaptainsInner> {
  @override
  final Iterable<Type> types = const [AdminPickerDtoOutputCaptainsInner, _$AdminPickerDtoOutputCaptainsInner];

  @override
  final String wireName = r'AdminPickerDtoOutputCaptainsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminPickerDtoOutputCaptainsInner object, {
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
      specifiedType: const FullType(AdminPickerDtoOutputCaptainsInnerVehicleEnum),
    );
    yield r'eligible';
    yield serializers.serialize(
      object.eligible,
      specifiedType: const FullType(bool),
    );
    yield r'reasons';
    yield serializers.serialize(
      object.reasons,
      specifiedType: const FullType(BuiltList, [FullType(AdminPickerDtoOutputCaptainsInnerReasonsEnum)]),
    );
    yield r'distanceMetres';
    yield serializers.serialize(
      object.distanceMetres,
      specifiedType: const FullType(int),
    );
    yield r'etaMin';
    yield object.etaMin == null ? null : serializers.serialize(
      object.etaMin,
      specifiedType: const FullType.nullable(int),
    );
    yield r'ordersToday';
    yield serializers.serialize(
      object.ordersToday,
      specifiedType: const FullType(int),
    );
    yield r'custody';
    yield serializers.serialize(
      object.custody,
      specifiedType: const FullType(AdminPickerDtoOutputCaptainsInnerCustody),
    );
    yield r'acceptanceRate';
    yield object.acceptanceRate == null ? null : serializers.serialize(
      object.acceptanceRate,
      specifiedType: const FullType.nullable(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminPickerDtoOutputCaptainsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminPickerDtoOutputCaptainsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'captainId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.captainId = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'vehicle':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminPickerDtoOutputCaptainsInnerVehicleEnum),
          ) as AdminPickerDtoOutputCaptainsInnerVehicleEnum;
          result.vehicle = valueDes;
          break;
        case r'eligible':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.eligible = valueDes;
          break;
        case r'reasons':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminPickerDtoOutputCaptainsInnerReasonsEnum)]),
          ) as BuiltList<AdminPickerDtoOutputCaptainsInnerReasonsEnum>;
          result.reasons.replace(valueDes);
          break;
        case r'distanceMetres':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.distanceMetres = valueDes;
          break;
        case r'etaMin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.etaMin = valueDes;
          break;
        case r'ordersToday':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.ordersToday = valueDes;
          break;
        case r'custody':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminPickerDtoOutputCaptainsInnerCustody),
          ) as AdminPickerDtoOutputCaptainsInnerCustody;
          result.custody.replace(valueDes);
          break;
        case r'acceptanceRate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.acceptanceRate = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminPickerDtoOutputCaptainsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminPickerDtoOutputCaptainsInnerBuilder();
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


class AdminPickerDtoOutputCaptainsInnerVehicleEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'walking')
  static const AdminPickerDtoOutputCaptainsInnerVehicleEnum walking = _$adminPickerDtoOutputCaptainsInnerVehicleEnum_walking;
  @BuiltValueEnumConst(wireName: r'bicycle')
  static const AdminPickerDtoOutputCaptainsInnerVehicleEnum bicycle = _$adminPickerDtoOutputCaptainsInnerVehicleEnum_bicycle;
  @BuiltValueEnumConst(wireName: r'motorbike')
  static const AdminPickerDtoOutputCaptainsInnerVehicleEnum motorbike = _$adminPickerDtoOutputCaptainsInnerVehicleEnum_motorbike;
  @BuiltValueEnumConst(wireName: r'car')
  static const AdminPickerDtoOutputCaptainsInnerVehicleEnum car = _$adminPickerDtoOutputCaptainsInnerVehicleEnum_car;

  static Serializer<AdminPickerDtoOutputCaptainsInnerVehicleEnum> get serializer => _$adminPickerDtoOutputCaptainsInnerVehicleEnumSerializer;

  const AdminPickerDtoOutputCaptainsInnerVehicleEnum._(String name): super(name);

  static BuiltSet<AdminPickerDtoOutputCaptainsInnerVehicleEnum> get values => _$adminPickerDtoOutputCaptainsInnerVehicleEnumValues;
  static AdminPickerDtoOutputCaptainsInnerVehicleEnum valueOf(String name) => _$adminPickerDtoOutputCaptainsInnerVehicleEnumValueOf(name);
}

class AdminPickerDtoOutputCaptainsInnerReasonsEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'busy')
  static const AdminPickerDtoOutputCaptainsInnerReasonsEnum busy = _$adminPickerDtoOutputCaptainsInnerReasonsEnum_busy;
  @BuiltValueEnumConst(wireName: r'cash_limit')
  static const AdminPickerDtoOutputCaptainsInnerReasonsEnum cashLimit = _$adminPickerDtoOutputCaptainsInnerReasonsEnum_cashLimit;
  @BuiltValueEnumConst(wireName: r'closed_due')
  static const AdminPickerDtoOutputCaptainsInnerReasonsEnum closedDue = _$adminPickerDtoOutputCaptainsInnerReasonsEnum_closedDue;
  @BuiltValueEnumConst(wireName: r'simulated_location')
  static const AdminPickerDtoOutputCaptainsInnerReasonsEnum simulatedLocation = _$adminPickerDtoOutputCaptainsInnerReasonsEnum_simulatedLocation;
  @BuiltValueEnumConst(wireName: r'out_of_range')
  static const AdminPickerDtoOutputCaptainsInnerReasonsEnum outOfRange = _$adminPickerDtoOutputCaptainsInnerReasonsEnum_outOfRange;
  @BuiltValueEnumConst(wireName: r'vehicle_not_allowed')
  static const AdminPickerDtoOutputCaptainsInnerReasonsEnum vehicleNotAllowed = _$adminPickerDtoOutputCaptainsInnerReasonsEnum_vehicleNotAllowed;

  static Serializer<AdminPickerDtoOutputCaptainsInnerReasonsEnum> get serializer => _$adminPickerDtoOutputCaptainsInnerReasonsEnumSerializer;

  const AdminPickerDtoOutputCaptainsInnerReasonsEnum._(String name): super(name);

  static BuiltSet<AdminPickerDtoOutputCaptainsInnerReasonsEnum> get values => _$adminPickerDtoOutputCaptainsInnerReasonsEnumValues;
  static AdminPickerDtoOutputCaptainsInnerReasonsEnum valueOf(String name) => _$adminPickerDtoOutputCaptainsInnerReasonsEnumValueOf(name);
}

