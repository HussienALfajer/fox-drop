//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_peak_bonus_dto_output_windows_inner_zones_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_home_sections_dto_output_sections_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_home_sections_dto_output.g.dart';

/// AdminHomeSectionsDtoOutput
///
/// Properties:
/// * [sections] - Every section of the city in the home’s order, hidden ones included.
/// * [restaurants] - The city's restaurants a custom section picks from.
/// * [canManage] - Whether this admin may change them (marketing.manage).
@BuiltValue()
abstract class AdminHomeSectionsDtoOutput
    implements
        Built<AdminHomeSectionsDtoOutput, AdminHomeSectionsDtoOutputBuilder> {
  /// Every section of the city in the home’s order, hidden ones included.
  @BuiltValueField(wireName: r'sections')
  BuiltList<AdminHomeSectionsDtoOutputSectionsInner> get sections;

  /// The city's restaurants a custom section picks from.
  @BuiltValueField(wireName: r'restaurants')
  BuiltList<CaptainPeakBonusDtoOutputWindowsInnerZonesInner?> get restaurants;

  /// Whether this admin may change them (marketing.manage).
  @BuiltValueField(wireName: r'canManage')
  bool get canManage;

  AdminHomeSectionsDtoOutput._();

  factory AdminHomeSectionsDtoOutput([
    void updates(AdminHomeSectionsDtoOutputBuilder b),
  ]) = _$AdminHomeSectionsDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminHomeSectionsDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminHomeSectionsDtoOutput> get serializer =>
      _$AdminHomeSectionsDtoOutputSerializer();
}

class _$AdminHomeSectionsDtoOutputSerializer
    implements PrimitiveSerializer<AdminHomeSectionsDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminHomeSectionsDtoOutput,
    _$AdminHomeSectionsDtoOutput,
  ];

  @override
  final String wireName = r'AdminHomeSectionsDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminHomeSectionsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'sections';
    yield serializers.serialize(
      object.sections,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminHomeSectionsDtoOutputSectionsInner),
      ]),
    );
    yield r'restaurants';
    yield serializers.serialize(
      object.restaurants,
      specifiedType: const FullType(BuiltList, [
        FullType.nullable(CaptainPeakBonusDtoOutputWindowsInnerZonesInner),
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
    AdminHomeSectionsDtoOutput object, {
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
    required AdminHomeSectionsDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'sections':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminHomeSectionsDtoOutputSectionsInner),
                    ]),
                  )
                  as BuiltList<AdminHomeSectionsDtoOutputSectionsInner>;
          result.sections.replace(valueDes);
          break;
        case r'restaurants':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType.nullable(
                        CaptainPeakBonusDtoOutputWindowsInnerZonesInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    CaptainPeakBonusDtoOutputWindowsInnerZonesInner?
                  >;
          result.restaurants.replace(valueDes);
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
  AdminHomeSectionsDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminHomeSectionsDtoOutputBuilder();
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
