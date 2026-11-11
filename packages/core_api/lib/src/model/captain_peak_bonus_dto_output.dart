//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/captain_peak_bonus_dto_output_windows_inner.dart';
import 'package:core_api/src/model/captain_peak_bonus_dto_output_active_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_peak_bonus_dto_output.g.dart';

/// CaptainPeakBonusDtoOutput
///
/// Properties:
/// * [windows] - The windows in force while the bonus is on (CA §12.5); empty while it is off.
/// * [active] - «مكافأة الذروة الآن: +{المبلغ} لكل طلب حتى {الساعة}» on the home screen.
@BuiltValue()
abstract class CaptainPeakBonusDtoOutput
    implements
        Built<CaptainPeakBonusDtoOutput, CaptainPeakBonusDtoOutputBuilder> {
  /// The windows in force while the bonus is on (CA §12.5); empty while it is off.
  @BuiltValueField(wireName: r'windows')
  BuiltList<CaptainPeakBonusDtoOutputWindowsInner> get windows;

  /// «مكافأة الذروة الآن: +{المبلغ} لكل طلب حتى {الساعة}» on the home screen.
  @BuiltValueField(wireName: r'active')
  BuiltList<CaptainPeakBonusDtoOutputActiveInner> get active;

  CaptainPeakBonusDtoOutput._();

  factory CaptainPeakBonusDtoOutput([
    void updates(CaptainPeakBonusDtoOutputBuilder b),
  ]) = _$CaptainPeakBonusDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainPeakBonusDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainPeakBonusDtoOutput> get serializer =>
      _$CaptainPeakBonusDtoOutputSerializer();
}

class _$CaptainPeakBonusDtoOutputSerializer
    implements PrimitiveSerializer<CaptainPeakBonusDtoOutput> {
  @override
  final Iterable<Type> types = const [
    CaptainPeakBonusDtoOutput,
    _$CaptainPeakBonusDtoOutput,
  ];

  @override
  final String wireName = r'CaptainPeakBonusDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainPeakBonusDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'windows';
    yield serializers.serialize(
      object.windows,
      specifiedType: const FullType(BuiltList, [
        FullType(CaptainPeakBonusDtoOutputWindowsInner),
      ]),
    );
    yield r'active';
    yield serializers.serialize(
      object.active,
      specifiedType: const FullType(BuiltList, [
        FullType(CaptainPeakBonusDtoOutputActiveInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainPeakBonusDtoOutput object, {
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
    required CaptainPeakBonusDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'windows':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(CaptainPeakBonusDtoOutputWindowsInner),
                    ]),
                  )
                  as BuiltList<CaptainPeakBonusDtoOutputWindowsInner>;
          result.windows.replace(valueDes);
          break;
        case r'active':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(CaptainPeakBonusDtoOutputActiveInner),
                    ]),
                  )
                  as BuiltList<CaptainPeakBonusDtoOutputActiveInner>;
          result.active.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainPeakBonusDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainPeakBonusDtoOutputBuilder();
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
