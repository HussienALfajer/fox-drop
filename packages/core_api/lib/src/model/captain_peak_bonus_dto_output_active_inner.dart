//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_peak_bonus_dto_output_windows_inner_zones_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/captain_peak_bonus_dto_output_active_inner_amount.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_peak_bonus_dto_output_active_inner.g.dart';

/// CaptainPeakBonusDtoOutputActiveInner
///
/// Properties:
/// * [amount]
/// * [until]
/// * [zones] - The zones of the restaurants it pays for; none: every zone.
@BuiltValue()
abstract class CaptainPeakBonusDtoOutputActiveInner
    implements
        Built<
          CaptainPeakBonusDtoOutputActiveInner,
          CaptainPeakBonusDtoOutputActiveInnerBuilder
        > {
  @BuiltValueField(wireName: r'amount')
  CaptainPeakBonusDtoOutputActiveInnerAmount get amount;

  @BuiltValueField(wireName: r'until')
  DateTime get until;

  /// The zones of the restaurants it pays for; none: every zone.
  @BuiltValueField(wireName: r'zones')
  BuiltList<CaptainPeakBonusDtoOutputWindowsInnerZonesInner> get zones;

  CaptainPeakBonusDtoOutputActiveInner._();

  factory CaptainPeakBonusDtoOutputActiveInner([
    void updates(CaptainPeakBonusDtoOutputActiveInnerBuilder b),
  ]) = _$CaptainPeakBonusDtoOutputActiveInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainPeakBonusDtoOutputActiveInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainPeakBonusDtoOutputActiveInner> get serializer =>
      _$CaptainPeakBonusDtoOutputActiveInnerSerializer();
}

class _$CaptainPeakBonusDtoOutputActiveInnerSerializer
    implements PrimitiveSerializer<CaptainPeakBonusDtoOutputActiveInner> {
  @override
  final Iterable<Type> types = const [
    CaptainPeakBonusDtoOutputActiveInner,
    _$CaptainPeakBonusDtoOutputActiveInner,
  ];

  @override
  final String wireName = r'CaptainPeakBonusDtoOutputActiveInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainPeakBonusDtoOutputActiveInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(CaptainPeakBonusDtoOutputActiveInnerAmount),
    );
    yield r'until';
    yield serializers.serialize(
      object.until,
      specifiedType: const FullType(DateTime),
    );
    yield r'zones';
    yield serializers.serialize(
      object.zones,
      specifiedType: const FullType(BuiltList, [
        FullType(CaptainPeakBonusDtoOutputWindowsInnerZonesInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainPeakBonusDtoOutputActiveInner object, {
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
    required CaptainPeakBonusDtoOutputActiveInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'amount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainPeakBonusDtoOutputActiveInnerAmount,
                    ),
                  )
                  as CaptainPeakBonusDtoOutputActiveInnerAmount;
          result.amount.replace(valueDes);
          break;
        case r'until':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.until = valueDes;
          break;
        case r'zones':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(CaptainPeakBonusDtoOutputWindowsInnerZonesInner),
                    ]),
                  )
                  as BuiltList<CaptainPeakBonusDtoOutputWindowsInnerZonesInner>;
          result.zones.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainPeakBonusDtoOutputActiveInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainPeakBonusDtoOutputActiveInnerBuilder();
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
