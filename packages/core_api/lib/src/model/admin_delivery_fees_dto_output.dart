//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_delivery_fees_dto_output_versions_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_delivery_fees_dto_output_restaurants_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_delivery_fees_dto_output.g.dart';

/// AdminDeliveryFeesDtoOutput
///
/// Properties:
/// * [baseCurrency] - The amounts are typed in it; null while the city has none.
/// * [distanceMethod] - pricing.distance_method: how a distance-band fee is measured.
/// * [versions] - The city's rule, newest first (the first is in effect), the latest 50.
/// * [restaurants] - The restaurants with a pin, not terminated, by name.
@BuiltValue()
abstract class AdminDeliveryFeesDtoOutput
    implements
        Built<AdminDeliveryFeesDtoOutput, AdminDeliveryFeesDtoOutputBuilder> {
  /// The amounts are typed in it; null while the city has none.
  @BuiltValueField(wireName: r'baseCurrency')
  String? get baseCurrency;

  /// pricing.distance_method: how a distance-band fee is measured.
  @BuiltValueField(wireName: r'distanceMethod')
  AdminDeliveryFeesDtoOutputDistanceMethodEnum get distanceMethod;
  // enum distanceMethodEnum {  road,  straight_line,  };

  /// The city's rule, newest first (the first is in effect), the latest 50.
  @BuiltValueField(wireName: r'versions')
  BuiltList<AdminDeliveryFeesDtoOutputVersionsInner> get versions;

  /// The restaurants with a pin, not terminated, by name.
  @BuiltValueField(wireName: r'restaurants')
  BuiltList<AdminDeliveryFeesDtoOutputRestaurantsInner> get restaurants;

  AdminDeliveryFeesDtoOutput._();

  factory AdminDeliveryFeesDtoOutput([
    void updates(AdminDeliveryFeesDtoOutputBuilder b),
  ]) = _$AdminDeliveryFeesDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDeliveryFeesDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDeliveryFeesDtoOutput> get serializer =>
      _$AdminDeliveryFeesDtoOutputSerializer();
}

class _$AdminDeliveryFeesDtoOutputSerializer
    implements PrimitiveSerializer<AdminDeliveryFeesDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminDeliveryFeesDtoOutput,
    _$AdminDeliveryFeesDtoOutput,
  ];

  @override
  final String wireName = r'AdminDeliveryFeesDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDeliveryFeesDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'baseCurrency';
    yield object.baseCurrency == null
        ? null
        : serializers.serialize(
            object.baseCurrency,
            specifiedType: const FullType.nullable(String),
          );
    yield r'distanceMethod';
    yield serializers.serialize(
      object.distanceMethod,
      specifiedType: const FullType(
        AdminDeliveryFeesDtoOutputDistanceMethodEnum,
      ),
    );
    yield r'versions';
    yield serializers.serialize(
      object.versions,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminDeliveryFeesDtoOutputVersionsInner),
      ]),
    );
    yield r'restaurants';
    yield serializers.serialize(
      object.restaurants,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminDeliveryFeesDtoOutputRestaurantsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDeliveryFeesDtoOutput object, {
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
    required AdminDeliveryFeesDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'baseCurrency':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.baseCurrency = valueDes;
          break;
        case r'distanceMethod':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminDeliveryFeesDtoOutputDistanceMethodEnum,
                    ),
                  )
                  as AdminDeliveryFeesDtoOutputDistanceMethodEnum;
          result.distanceMethod = valueDes;
          break;
        case r'versions':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminDeliveryFeesDtoOutputVersionsInner),
                    ]),
                  )
                  as BuiltList<AdminDeliveryFeesDtoOutputVersionsInner>;
          result.versions.replace(valueDes);
          break;
        case r'restaurants':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminDeliveryFeesDtoOutputRestaurantsInner),
                    ]),
                  )
                  as BuiltList<AdminDeliveryFeesDtoOutputRestaurantsInner>;
          result.restaurants.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDeliveryFeesDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDeliveryFeesDtoOutputBuilder();
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

/// pricing.distance_method: how a distance-band fee is measured.
class AdminDeliveryFeesDtoOutputDistanceMethodEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'road')
  static const AdminDeliveryFeesDtoOutputDistanceMethodEnum road =
      _$adminDeliveryFeesDtoOutputDistanceMethodEnum_road;
  @BuiltValueEnumConst(wireName: r'straight_line')
  static const AdminDeliveryFeesDtoOutputDistanceMethodEnum straightLine =
      _$adminDeliveryFeesDtoOutputDistanceMethodEnum_straightLine;

  static Serializer<AdminDeliveryFeesDtoOutputDistanceMethodEnum>
  get serializer => _$adminDeliveryFeesDtoOutputDistanceMethodEnumSerializer;

  const AdminDeliveryFeesDtoOutputDistanceMethodEnum._(String name)
    : super(name);

  static BuiltSet<AdminDeliveryFeesDtoOutputDistanceMethodEnum> get values =>
      _$adminDeliveryFeesDtoOutputDistanceMethodEnumValues;
  static AdminDeliveryFeesDtoOutputDistanceMethodEnum valueOf(String name) =>
      _$adminDeliveryFeesDtoOutputDistanceMethodEnumValueOf(name);
}
