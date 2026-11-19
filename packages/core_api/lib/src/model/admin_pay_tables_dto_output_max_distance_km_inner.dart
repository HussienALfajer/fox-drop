//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_pay_tables_dto_output_max_distance_km_inner.g.dart';

/// AdminPayTablesDtoOutputMaxDistanceKmInner
///
/// Properties:
/// * [vehicle]
/// * [km]
@BuiltValue()
abstract class AdminPayTablesDtoOutputMaxDistanceKmInner
    implements
        Built<
          AdminPayTablesDtoOutputMaxDistanceKmInner,
          AdminPayTablesDtoOutputMaxDistanceKmInnerBuilder
        > {
  @BuiltValueField(wireName: r'vehicle')
  AdminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnum get vehicle;
  // enum vehicleEnum {  walking,  bicycle,  motorbike,  car,  };

  @BuiltValueField(wireName: r'km')
  num get km;

  AdminPayTablesDtoOutputMaxDistanceKmInner._();

  factory AdminPayTablesDtoOutputMaxDistanceKmInner([
    void updates(AdminPayTablesDtoOutputMaxDistanceKmInnerBuilder b),
  ]) = _$AdminPayTablesDtoOutputMaxDistanceKmInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminPayTablesDtoOutputMaxDistanceKmInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminPayTablesDtoOutputMaxDistanceKmInner> get serializer =>
      _$AdminPayTablesDtoOutputMaxDistanceKmInnerSerializer();
}

class _$AdminPayTablesDtoOutputMaxDistanceKmInnerSerializer
    implements PrimitiveSerializer<AdminPayTablesDtoOutputMaxDistanceKmInner> {
  @override
  final Iterable<Type> types = const [
    AdminPayTablesDtoOutputMaxDistanceKmInner,
    _$AdminPayTablesDtoOutputMaxDistanceKmInner,
  ];

  @override
  final String wireName = r'AdminPayTablesDtoOutputMaxDistanceKmInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminPayTablesDtoOutputMaxDistanceKmInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'vehicle';
    yield serializers.serialize(
      object.vehicle,
      specifiedType: const FullType(
        AdminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnum,
      ),
    );
    yield r'km';
    yield serializers.serialize(object.km, specifiedType: const FullType(num));
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminPayTablesDtoOutputMaxDistanceKmInner object, {
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
    required AdminPayTablesDtoOutputMaxDistanceKmInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'vehicle':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnum,
                    ),
                  )
                  as AdminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnum;
          result.vehicle = valueDes;
          break;
        case r'km':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(num))
                  as num;
          result.km = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminPayTablesDtoOutputMaxDistanceKmInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminPayTablesDtoOutputMaxDistanceKmInnerBuilder();
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

class AdminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'walking')
  static const AdminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnum walking =
      _$adminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnum_walking;
  @BuiltValueEnumConst(wireName: r'bicycle')
  static const AdminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnum bicycle =
      _$adminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnum_bicycle;
  @BuiltValueEnumConst(wireName: r'motorbike')
  static const AdminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnum motorbike =
      _$adminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnum_motorbike;
  @BuiltValueEnumConst(wireName: r'car')
  static const AdminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnum car =
      _$adminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnum_car;

  static Serializer<AdminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnum>
  get serializer =>
      _$adminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnumSerializer;

  const AdminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnum._(String name)
    : super(name);

  static BuiltSet<AdminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnum>
  get values => _$adminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnumValues;
  static AdminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnum valueOf(
    String name,
  ) => _$adminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnumValueOf(name);
}
