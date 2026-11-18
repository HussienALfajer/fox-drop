//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_promo_codes_dto_output_codes_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_peak_bonus_dto_output_in_force_windows_inner_zones_inner.dart';
import 'package:core_api/src/model/admin_peak_bonus_dto_output_zones_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_promo_codes_dto_output.g.dart';

/// AdminPromoCodesDtoOutput
///
/// Properties:
/// * [codes]
/// * [restaurants]
/// * [zones]
/// * [baseCurrency] - The amounts are typed in it; null while the city has none.
/// * [canManage] - Whether this admin may create, edit, pause and resume.
@BuiltValue()
abstract class AdminPromoCodesDtoOutput
    implements
        Built<AdminPromoCodesDtoOutput, AdminPromoCodesDtoOutputBuilder> {
  @BuiltValueField(wireName: r'codes')
  BuiltList<AdminPromoCodesDtoOutputCodesInner> get codes;

  @BuiltValueField(wireName: r'restaurants')
  BuiltList<AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner?>
  get restaurants;

  @BuiltValueField(wireName: r'zones')
  BuiltList<AdminPeakBonusDtoOutputZonesInner> get zones;

  /// The amounts are typed in it; null while the city has none.
  @BuiltValueField(wireName: r'baseCurrency')
  String? get baseCurrency;

  /// Whether this admin may create, edit, pause and resume.
  @BuiltValueField(wireName: r'canManage')
  bool get canManage;

  AdminPromoCodesDtoOutput._();

  factory AdminPromoCodesDtoOutput([
    void updates(AdminPromoCodesDtoOutputBuilder b),
  ]) = _$AdminPromoCodesDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminPromoCodesDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminPromoCodesDtoOutput> get serializer =>
      _$AdminPromoCodesDtoOutputSerializer();
}

class _$AdminPromoCodesDtoOutputSerializer
    implements PrimitiveSerializer<AdminPromoCodesDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminPromoCodesDtoOutput,
    _$AdminPromoCodesDtoOutput,
  ];

  @override
  final String wireName = r'AdminPromoCodesDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminPromoCodesDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'codes';
    yield serializers.serialize(
      object.codes,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminPromoCodesDtoOutputCodesInner),
      ]),
    );
    yield r'restaurants';
    yield serializers.serialize(
      object.restaurants,
      specifiedType: const FullType(BuiltList, [
        FullType.nullable(AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner),
      ]),
    );
    yield r'zones';
    yield serializers.serialize(
      object.zones,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminPeakBonusDtoOutputZonesInner),
      ]),
    );
    yield r'baseCurrency';
    yield object.baseCurrency == null
        ? null
        : serializers.serialize(
            object.baseCurrency,
            specifiedType: const FullType.nullable(String),
          );
    yield r'canManage';
    yield serializers.serialize(
      object.canManage,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminPromoCodesDtoOutput object, {
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
    required AdminPromoCodesDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'codes':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminPromoCodesDtoOutputCodesInner),
                    ]),
                  )
                  as BuiltList<AdminPromoCodesDtoOutputCodesInner>;
          result.codes.replace(valueDes);
          break;
        case r'restaurants':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType.nullable(
                        AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner?
                  >;
          result.restaurants.replace(valueDes);
          break;
        case r'zones':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminPeakBonusDtoOutputZonesInner),
                    ]),
                  )
                  as BuiltList<AdminPeakBonusDtoOutputZonesInner>;
          result.zones.replace(valueDes);
          break;
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
        case r'canManage':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.canManage = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminPromoCodesDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminPromoCodesDtoOutputBuilder();
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
