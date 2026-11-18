//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_banners_dto_output_codes_inner.dart';
import 'package:core_api/src/model/admin_banners_dto_output_banners_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_peak_bonus_dto_output_in_force_windows_inner_zones_inner.dart';
import 'package:core_api/src/model/admin_peak_bonus_dto_output_zones_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_banners_dto_output.g.dart';

/// AdminBannersDtoOutput
///
/// Properties:
/// * [banners] - The city’s banners in the strip’s order, ended ones included.
/// * [restaurants] - The city's restaurants a target picks from.
/// * [categories] - The active categories, in their order.
/// * [codes] - The city's visible codes that have not ended, newest first.
/// * [zones]
/// * [canManage] - Whether this admin may publish (marketing.banners).
@BuiltValue()
abstract class AdminBannersDtoOutput
    implements Built<AdminBannersDtoOutput, AdminBannersDtoOutputBuilder> {
  /// The city’s banners in the strip’s order, ended ones included.
  @BuiltValueField(wireName: r'banners')
  BuiltList<AdminBannersDtoOutputBannersInner> get banners;

  /// The city's restaurants a target picks from.
  @BuiltValueField(wireName: r'restaurants')
  BuiltList<AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner?>
  get restaurants;

  /// The active categories, in their order.
  @BuiltValueField(wireName: r'categories')
  BuiltList<AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner?>
  get categories;

  /// The city's visible codes that have not ended, newest first.
  @BuiltValueField(wireName: r'codes')
  BuiltList<AdminBannersDtoOutputCodesInner> get codes;

  @BuiltValueField(wireName: r'zones')
  BuiltList<AdminPeakBonusDtoOutputZonesInner> get zones;

  /// Whether this admin may publish (marketing.banners).
  @BuiltValueField(wireName: r'canManage')
  bool get canManage;

  AdminBannersDtoOutput._();

  factory AdminBannersDtoOutput([
    void updates(AdminBannersDtoOutputBuilder b),
  ]) = _$AdminBannersDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminBannersDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminBannersDtoOutput> get serializer =>
      _$AdminBannersDtoOutputSerializer();
}

class _$AdminBannersDtoOutputSerializer
    implements PrimitiveSerializer<AdminBannersDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminBannersDtoOutput,
    _$AdminBannersDtoOutput,
  ];

  @override
  final String wireName = r'AdminBannersDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminBannersDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'banners';
    yield serializers.serialize(
      object.banners,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminBannersDtoOutputBannersInner),
      ]),
    );
    yield r'restaurants';
    yield serializers.serialize(
      object.restaurants,
      specifiedType: const FullType(BuiltList, [
        FullType.nullable(AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner),
      ]),
    );
    yield r'categories';
    yield serializers.serialize(
      object.categories,
      specifiedType: const FullType(BuiltList, [
        FullType.nullable(AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner),
      ]),
    );
    yield r'codes';
    yield serializers.serialize(
      object.codes,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminBannersDtoOutputCodesInner),
      ]),
    );
    yield r'zones';
    yield serializers.serialize(
      object.zones,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminPeakBonusDtoOutputZonesInner),
      ]),
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
    AdminBannersDtoOutput object, {
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
    required AdminBannersDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'banners':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminBannersDtoOutputBannersInner),
                    ]),
                  )
                  as BuiltList<AdminBannersDtoOutputBannersInner>;
          result.banners.replace(valueDes);
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
        case r'categories':
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
          result.categories.replace(valueDes);
          break;
        case r'codes':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminBannersDtoOutputCodesInner),
                    ]),
                  )
                  as BuiltList<AdminBannersDtoOutputCodesInner>;
          result.codes.replace(valueDes);
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
  AdminBannersDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminBannersDtoOutputBuilder();
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
