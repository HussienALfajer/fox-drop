//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_set_peak_bonus_dto_windows_inner.g.dart';

/// AdminSetPeakBonusDtoWindowsInner
///
/// Properties:
/// * [days] - ISO days: 1 Monday to 7 Sunday.
/// * [startMinute] - Minutes from midnight on the city clock, 20:00 is 1200.
/// * [endMinute] - Minutes from midnight; at or before the start the window runs past midnight.
/// * [amount] - Per delivered order, minor units of the base currency.
/// * [zoneIds]
@BuiltValue()
abstract class AdminSetPeakBonusDtoWindowsInner
    implements
        Built<
          AdminSetPeakBonusDtoWindowsInner,
          AdminSetPeakBonusDtoWindowsInnerBuilder
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

  @BuiltValueField(wireName: r'zoneIds')
  BuiltList<String> get zoneIds;

  AdminSetPeakBonusDtoWindowsInner._();

  factory AdminSetPeakBonusDtoWindowsInner([
    void updates(AdminSetPeakBonusDtoWindowsInnerBuilder b),
  ]) = _$AdminSetPeakBonusDtoWindowsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSetPeakBonusDtoWindowsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSetPeakBonusDtoWindowsInner> get serializer =>
      _$AdminSetPeakBonusDtoWindowsInnerSerializer();
}

class _$AdminSetPeakBonusDtoWindowsInnerSerializer
    implements PrimitiveSerializer<AdminSetPeakBonusDtoWindowsInner> {
  @override
  final Iterable<Type> types = const [
    AdminSetPeakBonusDtoWindowsInner,
    _$AdminSetPeakBonusDtoWindowsInner,
  ];

  @override
  final String wireName = r'AdminSetPeakBonusDtoWindowsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSetPeakBonusDtoWindowsInner object, {
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
    yield r'zoneIds';
    yield serializers.serialize(
      object.zoneIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminSetPeakBonusDtoWindowsInner object, {
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
    required AdminSetPeakBonusDtoWindowsInnerBuilder result,
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
        case r'zoneIds':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.zoneIds.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminSetPeakBonusDtoWindowsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSetPeakBonusDtoWindowsInnerBuilder();
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
