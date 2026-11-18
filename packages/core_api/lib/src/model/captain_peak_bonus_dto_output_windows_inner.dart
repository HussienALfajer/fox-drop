//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_peak_bonus_dto_output_windows_inner_zones_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/captain_peak_bonus_dto_output_windows_inner_amount.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_peak_bonus_dto_output_windows_inner.g.dart';

/// CaptainPeakBonusDtoOutputWindowsInner
///
/// Properties:
/// * [days] - ISO days: 1 Monday to 7 Sunday.
/// * [startMinute] - Minutes from midnight on the city clock.
/// * [endMinute] - Minutes from midnight; at or before the start it ends the next day.
/// * [amount]
/// * [zones] - The zones of the restaurants it pays for; none: every zone.
@BuiltValue()
abstract class CaptainPeakBonusDtoOutputWindowsInner
    implements
        Built<
          CaptainPeakBonusDtoOutputWindowsInner,
          CaptainPeakBonusDtoOutputWindowsInnerBuilder
        > {
  /// ISO days: 1 Monday to 7 Sunday.
  @BuiltValueField(wireName: r'days')
  BuiltList<int> get days;

  /// Minutes from midnight on the city clock.
  @BuiltValueField(wireName: r'startMinute')
  int get startMinute;

  /// Minutes from midnight; at or before the start it ends the next day.
  @BuiltValueField(wireName: r'endMinute')
  int get endMinute;

  @BuiltValueField(wireName: r'amount')
  CaptainPeakBonusDtoOutputWindowsInnerAmount get amount;

  /// The zones of the restaurants it pays for; none: every zone.
  @BuiltValueField(wireName: r'zones')
  BuiltList<CaptainPeakBonusDtoOutputWindowsInnerZonesInner> get zones;

  CaptainPeakBonusDtoOutputWindowsInner._();

  factory CaptainPeakBonusDtoOutputWindowsInner([
    void updates(CaptainPeakBonusDtoOutputWindowsInnerBuilder b),
  ]) = _$CaptainPeakBonusDtoOutputWindowsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainPeakBonusDtoOutputWindowsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainPeakBonusDtoOutputWindowsInner> get serializer =>
      _$CaptainPeakBonusDtoOutputWindowsInnerSerializer();
}

class _$CaptainPeakBonusDtoOutputWindowsInnerSerializer
    implements PrimitiveSerializer<CaptainPeakBonusDtoOutputWindowsInner> {
  @override
  final Iterable<Type> types = const [
    CaptainPeakBonusDtoOutputWindowsInner,
    _$CaptainPeakBonusDtoOutputWindowsInner,
  ];

  @override
  final String wireName = r'CaptainPeakBonusDtoOutputWindowsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainPeakBonusDtoOutputWindowsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'days';
    yield serializers.serialize(
      object.days,
      specifiedType: const FullType(BuiltList, [FullType(int)]),
    );
    yield r'startMinute';
    yield serializers.serialize(
      object.startMinute,
      specifiedType: const FullType(int),
    );
    yield r'endMinute';
    yield serializers.serialize(
      object.endMinute,
      specifiedType: const FullType(int),
    );
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(
        CaptainPeakBonusDtoOutputWindowsInnerAmount,
      ),
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
    CaptainPeakBonusDtoOutputWindowsInner object, {
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
    required CaptainPeakBonusDtoOutputWindowsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'days':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [FullType(int)]),
                  )
                  as BuiltList<int>;
          result.days.replace(valueDes);
          break;
        case r'startMinute':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.startMinute = valueDes;
          break;
        case r'endMinute':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.endMinute = valueDes;
          break;
        case r'amount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainPeakBonusDtoOutputWindowsInnerAmount,
                    ),
                  )
                  as CaptainPeakBonusDtoOutputWindowsInnerAmount;
          result.amount.replace(valueDes);
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
  CaptainPeakBonusDtoOutputWindowsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainPeakBonusDtoOutputWindowsInnerBuilder();
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
