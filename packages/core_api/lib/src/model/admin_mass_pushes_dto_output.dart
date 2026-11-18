//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_banners_dto_output_codes_inner.dart';
import 'package:core_api/src/model/captain_peak_bonus_dto_output_windows_inner_zones_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_peak_bonus_dto_output_in_force_windows_inner_zones_inner.dart';
import 'package:core_api/src/model/admin_mass_pushes_dto_output_pushes_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_mass_pushes_dto_output.g.dart';

/// AdminMassPushesDtoOutput
///
/// Properties:
/// * [pushes] - The latest 100, newest first.
/// * [restaurants] - The city's restaurants a target picks from.
/// * [codes] - The city's visible codes running now in its base currency, newest first.
/// * [zones] - The active zones.
/// * [canManage] - Whether this admin may send (marketing.manage).
@BuiltValue()
abstract class AdminMassPushesDtoOutput
    implements
        Built<AdminMassPushesDtoOutput, AdminMassPushesDtoOutputBuilder> {
  /// The latest 100, newest first.
  @BuiltValueField(wireName: r'pushes')
  BuiltList<AdminMassPushesDtoOutputPushesInner> get pushes;

  /// The city's restaurants a target picks from.
  @BuiltValueField(wireName: r'restaurants')
  BuiltList<CaptainPeakBonusDtoOutputWindowsInnerZonesInner> get restaurants;

  /// The city's visible codes running now in its base currency, newest first.
  @BuiltValueField(wireName: r'codes')
  BuiltList<AdminBannersDtoOutputCodesInner> get codes;

  /// The active zones.
  @BuiltValueField(wireName: r'zones')
  BuiltList<AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner?> get zones;

  /// Whether this admin may send (marketing.manage).
  @BuiltValueField(wireName: r'canManage')
  bool get canManage;

  AdminMassPushesDtoOutput._();

  factory AdminMassPushesDtoOutput([
    void updates(AdminMassPushesDtoOutputBuilder b),
  ]) = _$AdminMassPushesDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminMassPushesDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminMassPushesDtoOutput> get serializer =>
      _$AdminMassPushesDtoOutputSerializer();
}

class _$AdminMassPushesDtoOutputSerializer
    implements PrimitiveSerializer<AdminMassPushesDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminMassPushesDtoOutput,
    _$AdminMassPushesDtoOutput,
  ];

  @override
  final String wireName = r'AdminMassPushesDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminMassPushesDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'pushes';
    yield serializers.serialize(
      object.pushes,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminMassPushesDtoOutputPushesInner),
      ]),
    );
    yield r'restaurants';
    yield serializers.serialize(
      object.restaurants,
      specifiedType: const FullType(BuiltList, [
        FullType(CaptainPeakBonusDtoOutputWindowsInnerZonesInner),
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
        FullType.nullable(AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner),
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
    AdminMassPushesDtoOutput object, {
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
    required AdminMassPushesDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'pushes':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminMassPushesDtoOutputPushesInner),
                    ]),
                  )
                  as BuiltList<AdminMassPushesDtoOutputPushesInner>;
          result.pushes.replace(valueDes);
          break;
        case r'restaurants':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(CaptainPeakBonusDtoOutputWindowsInnerZonesInner),
                    ]),
                  )
                  as BuiltList<CaptainPeakBonusDtoOutputWindowsInnerZonesInner>;
          result.restaurants.replace(valueDes);
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
                      FullType.nullable(
                        AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner?
                  >;
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
  AdminMassPushesDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminMassPushesDtoOutputBuilder();
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
