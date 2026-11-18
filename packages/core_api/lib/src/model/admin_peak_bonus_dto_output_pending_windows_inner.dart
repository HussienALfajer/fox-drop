//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_peak_bonus_dto_output_windows_inner_zones_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_peak_bonus_dto_output_pending_windows_inner.g.dart';

/// AdminPeakBonusDtoOutputPendingWindowsInner
///
/// Properties:
/// * [days] - ISO days: 1 Monday to 7 Sunday.
/// * [startMinute] - Minutes from midnight on the city clock, 20:00 is 1200.
/// * [endMinute] - Minutes from midnight; at or before the start the window runs past midnight.
/// * [amount] - Per delivered order, minor units of the base currency.
/// * [zones] - None: every zone.
@BuiltValue()
abstract class AdminPeakBonusDtoOutputPendingWindowsInner
    implements
        Built<
          AdminPeakBonusDtoOutputPendingWindowsInner,
          AdminPeakBonusDtoOutputPendingWindowsInnerBuilder
        > {
  /// ISO days: 1 Monday to 7 Sunday.
  @BuiltValueField(wireName: r'days')
  BuiltList<int> get days;

  /// Minutes from midnight on the city clock, 20:00 is 1200.
  @BuiltValueField(wireName: r'startMinute')
  int get startMinute;

  /// Minutes from midnight; at or before the start the window runs past midnight.
  @BuiltValueField(wireName: r'endMinute')
  int get endMinute;

  /// Per delivered order, minor units of the base currency.
  @BuiltValueField(wireName: r'amount')
  String get amount;

  /// None: every zone.
  @BuiltValueField(wireName: r'zones')
  BuiltList<CaptainPeakBonusDtoOutputWindowsInnerZonesInner> get zones;

  AdminPeakBonusDtoOutputPendingWindowsInner._();

  factory AdminPeakBonusDtoOutputPendingWindowsInner([
    void updates(AdminPeakBonusDtoOutputPendingWindowsInnerBuilder b),
  ]) = _$AdminPeakBonusDtoOutputPendingWindowsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminPeakBonusDtoOutputPendingWindowsInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminPeakBonusDtoOutputPendingWindowsInner>
  get serializer => _$AdminPeakBonusDtoOutputPendingWindowsInnerSerializer();
}

class _$AdminPeakBonusDtoOutputPendingWindowsInnerSerializer
    implements PrimitiveSerializer<AdminPeakBonusDtoOutputPendingWindowsInner> {
  @override
  final Iterable<Type> types = const [
    AdminPeakBonusDtoOutputPendingWindowsInner,
    _$AdminPeakBonusDtoOutputPendingWindowsInner,
  ];

  @override
  final String wireName = r'AdminPeakBonusDtoOutputPendingWindowsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminPeakBonusDtoOutputPendingWindowsInner object, {
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
      specifiedType: const FullType(String),
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
    AdminPeakBonusDtoOutputPendingWindowsInner object, {
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
    required AdminPeakBonusDtoOutputPendingWindowsInnerBuilder result,
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
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.amount = valueDes;
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
  AdminPeakBonusDtoOutputPendingWindowsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminPeakBonusDtoOutputPendingWindowsInnerBuilder();
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
