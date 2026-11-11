//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_peak_bonus_dto_output_pending.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_peak_bonus_dto_output_zones_inner.dart';
import 'package:core_api/src/model/admin_peak_bonus_dto_output_in_force.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_peak_bonus_dto_output.g.dart';

/// AdminPeakBonusDtoOutput
///
/// Properties:
/// * [inForce]
/// * [pending]
/// * [zones]
/// * [baseCurrency] - The amounts are typed in it; null while the city has none.
@BuiltValue()
abstract class AdminPeakBonusDtoOutput
    implements Built<AdminPeakBonusDtoOutput, AdminPeakBonusDtoOutputBuilder> {
  @BuiltValueField(wireName: r'inForce')
  AdminPeakBonusDtoOutputInForce? get inForce;

  @BuiltValueField(wireName: r'pending')
  AdminPeakBonusDtoOutputPending? get pending;

  @BuiltValueField(wireName: r'zones')
  BuiltList<AdminPeakBonusDtoOutputZonesInner> get zones;

  /// The amounts are typed in it; null while the city has none.
  @BuiltValueField(wireName: r'baseCurrency')
  String? get baseCurrency;

  AdminPeakBonusDtoOutput._();

  factory AdminPeakBonusDtoOutput([
    void updates(AdminPeakBonusDtoOutputBuilder b),
  ]) = _$AdminPeakBonusDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminPeakBonusDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminPeakBonusDtoOutput> get serializer =>
      _$AdminPeakBonusDtoOutputSerializer();
}

class _$AdminPeakBonusDtoOutputSerializer
    implements PrimitiveSerializer<AdminPeakBonusDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminPeakBonusDtoOutput,
    _$AdminPeakBonusDtoOutput,
  ];

  @override
  final String wireName = r'AdminPeakBonusDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminPeakBonusDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'inForce';
    yield object.inForce == null
        ? null
        : serializers.serialize(
            object.inForce,
            specifiedType: const FullType.nullable(
              AdminPeakBonusDtoOutputInForce,
            ),
          );
    yield r'pending';
    yield object.pending == null
        ? null
        : serializers.serialize(
            object.pending,
            specifiedType: const FullType.nullable(
              AdminPeakBonusDtoOutputPending,
            ),
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
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminPeakBonusDtoOutput object, {
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
    required AdminPeakBonusDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'inForce':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminPeakBonusDtoOutputInForce,
                    ),
                  )
                  as AdminPeakBonusDtoOutputInForce?;
          if (valueDes == null) continue;
          result.inForce.replace(valueDes);
          break;
        case r'pending':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminPeakBonusDtoOutputPending,
                    ),
                  )
                  as AdminPeakBonusDtoOutputPending?;
          if (valueDes == null) continue;
          result.pending.replace(valueDes);
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminPeakBonusDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminPeakBonusDtoOutputBuilder();
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
