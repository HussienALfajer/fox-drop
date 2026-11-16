//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_peak_bonus_dto_output_in_force_windows_inner_zones_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_manual_parties_dto_output.g.dart';

/// AdminManualPartiesDtoOutput
///
/// Properties:
/// * [parties]
@BuiltValue()
abstract class AdminManualPartiesDtoOutput
    implements
        Built<AdminManualPartiesDtoOutput, AdminManualPartiesDtoOutputBuilder> {
  @BuiltValueField(wireName: r'parties')
  BuiltList<AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner?> get parties;

  AdminManualPartiesDtoOutput._();

  factory AdminManualPartiesDtoOutput([
    void updates(AdminManualPartiesDtoOutputBuilder b),
  ]) = _$AdminManualPartiesDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminManualPartiesDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminManualPartiesDtoOutput> get serializer =>
      _$AdminManualPartiesDtoOutputSerializer();
}

class _$AdminManualPartiesDtoOutputSerializer
    implements PrimitiveSerializer<AdminManualPartiesDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminManualPartiesDtoOutput,
    _$AdminManualPartiesDtoOutput,
  ];

  @override
  final String wireName = r'AdminManualPartiesDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminManualPartiesDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'parties';
    yield serializers.serialize(
      object.parties,
      specifiedType: const FullType(BuiltList, [
        FullType.nullable(AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminManualPartiesDtoOutput object, {
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
    required AdminManualPartiesDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'parties':
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
          result.parties.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminManualPartiesDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminManualPartiesDtoOutputBuilder();
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
