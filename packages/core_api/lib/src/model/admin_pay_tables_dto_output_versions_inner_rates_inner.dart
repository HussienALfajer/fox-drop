//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_pay_tables_dto_output_versions_inner_rates_inner.g.dart';

/// AdminPayTablesDtoOutputVersionsInnerRatesInner
///
/// Properties:
/// * [vehicle]
/// * [basePay] - Pays the first includedMetres.
/// * [includedMetres] - The distance the base pay includes.
/// * [perExtraKm] - Per km past the included distance, pro rata by the metre.
/// * [waitingPerMinute] - Per whole minute past captain.waiting_threshold_min.
/// * [minimumPay] - The order pay is raised to it.
@BuiltValue()
abstract class AdminPayTablesDtoOutputVersionsInnerRatesInner
    implements
        Built<
          AdminPayTablesDtoOutputVersionsInnerRatesInner,
          AdminPayTablesDtoOutputVersionsInnerRatesInnerBuilder
        > {
  @BuiltValueField(wireName: r'vehicle')
  AdminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnum get vehicle;
  // enum vehicleEnum {  walking,  bicycle,  motorbike,  car,  };

  /// Pays the first includedMetres.
  @BuiltValueField(wireName: r'basePay')
  String get basePay;

  /// The distance the base pay includes.
  @BuiltValueField(wireName: r'includedMetres')
  int get includedMetres;

  /// Per km past the included distance, pro rata by the metre.
  @BuiltValueField(wireName: r'perExtraKm')
  String get perExtraKm;

  /// Per whole minute past captain.waiting_threshold_min.
  @BuiltValueField(wireName: r'waitingPerMinute')
  String get waitingPerMinute;

  /// The order pay is raised to it.
  @BuiltValueField(wireName: r'minimumPay')
  String get minimumPay;

  AdminPayTablesDtoOutputVersionsInnerRatesInner._();

  factory AdminPayTablesDtoOutputVersionsInnerRatesInner([
    void updates(AdminPayTablesDtoOutputVersionsInnerRatesInnerBuilder b),
  ]) = _$AdminPayTablesDtoOutputVersionsInnerRatesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminPayTablesDtoOutputVersionsInnerRatesInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminPayTablesDtoOutputVersionsInnerRatesInner>
  get serializer =>
      _$AdminPayTablesDtoOutputVersionsInnerRatesInnerSerializer();
}

class _$AdminPayTablesDtoOutputVersionsInnerRatesInnerSerializer
    implements
        PrimitiveSerializer<AdminPayTablesDtoOutputVersionsInnerRatesInner> {
  @override
  final Iterable<Type> types = const [
    AdminPayTablesDtoOutputVersionsInnerRatesInner,
    _$AdminPayTablesDtoOutputVersionsInnerRatesInner,
  ];

  @override
  final String wireName = r'AdminPayTablesDtoOutputVersionsInnerRatesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminPayTablesDtoOutputVersionsInnerRatesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'vehicle';
    yield serializers.serialize(
      object.vehicle,
      specifiedType: const FullType(
        AdminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnum,
      ),
    );
    yield r'basePay';
    yield serializers.serialize(
      object.basePay,
      specifiedType: const FullType(String),
    );
    yield r'includedMetres';
    yield serializers.serialize(
      object.includedMetres,
      specifiedType: const FullType(int),
    );
    yield r'perExtraKm';
    yield serializers.serialize(
      object.perExtraKm,
      specifiedType: const FullType(String),
    );
    yield r'waitingPerMinute';
    yield serializers.serialize(
      object.waitingPerMinute,
      specifiedType: const FullType(String),
    );
    yield r'minimumPay';
    yield serializers.serialize(
      object.minimumPay,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminPayTablesDtoOutputVersionsInnerRatesInner object, {
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
    required AdminPayTablesDtoOutputVersionsInnerRatesInnerBuilder result,
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
                      AdminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnum,
                    ),
                  )
                  as AdminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnum;
          result.vehicle = valueDes;
          break;
        case r'basePay':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.basePay = valueDes;
          break;
        case r'includedMetres':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.includedMetres = valueDes;
          break;
        case r'perExtraKm':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.perExtraKm = valueDes;
          break;
        case r'waitingPerMinute':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.waitingPerMinute = valueDes;
          break;
        case r'minimumPay':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.minimumPay = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminPayTablesDtoOutputVersionsInnerRatesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminPayTablesDtoOutputVersionsInnerRatesInnerBuilder();
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

class AdminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'walking')
  static const AdminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnum
  walking = _$adminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnum_walking;
  @BuiltValueEnumConst(wireName: r'bicycle')
  static const AdminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnum
  bicycle = _$adminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnum_bicycle;
  @BuiltValueEnumConst(wireName: r'motorbike')
  static const AdminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnum
  motorbike =
      _$adminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnum_motorbike;
  @BuiltValueEnumConst(wireName: r'car')
  static const AdminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnum car =
      _$adminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnum_car;

  static Serializer<AdminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnum>
  get serializer =>
      _$adminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnumSerializer;

  const AdminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnum._(String name)
    : super(name);

  static BuiltSet<AdminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnum>
  get values =>
      _$adminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnumValues;
  static AdminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnum valueOf(
    String name,
  ) => _$adminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnumValueOf(name);
}
