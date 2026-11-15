//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_earnings_dto_output_today.g.dart';

/// The business day now.
///
/// Properties:
/// * [from] - The start of the window: a business-day cutoff.
/// * [earnings] - Every earning since, the payouts left out.
/// * [orders] - The orders whose pay nets above zero.
/// * [onlineMinutes]
@BuiltValue()
abstract class CaptainEarningsDtoOutputToday
    implements
        Built<
          CaptainEarningsDtoOutputToday,
          CaptainEarningsDtoOutputTodayBuilder
        > {
  /// The start of the window: a business-day cutoff.
  @BuiltValueField(wireName: r'from')
  DateTime get from;

  /// Every earning since, the payouts left out.
  @BuiltValueField(wireName: r'earnings')
  String get earnings;

  /// The orders whose pay nets above zero.
  @BuiltValueField(wireName: r'orders')
  int get orders;

  @BuiltValueField(wireName: r'onlineMinutes')
  int get onlineMinutes;

  CaptainEarningsDtoOutputToday._();

  factory CaptainEarningsDtoOutputToday([
    void updates(CaptainEarningsDtoOutputTodayBuilder b),
  ]) = _$CaptainEarningsDtoOutputToday;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainEarningsDtoOutputTodayBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainEarningsDtoOutputToday> get serializer =>
      _$CaptainEarningsDtoOutputTodaySerializer();
}

class _$CaptainEarningsDtoOutputTodaySerializer
    implements PrimitiveSerializer<CaptainEarningsDtoOutputToday> {
  @override
  final Iterable<Type> types = const [
    CaptainEarningsDtoOutputToday,
    _$CaptainEarningsDtoOutputToday,
  ];

  @override
  final String wireName = r'CaptainEarningsDtoOutputToday';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainEarningsDtoOutputToday object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'from';
    yield serializers.serialize(
      object.from,
      specifiedType: const FullType(DateTime),
    );
    yield r'earnings';
    yield serializers.serialize(
      object.earnings,
      specifiedType: const FullType(String),
    );
    yield r'orders';
    yield serializers.serialize(
      object.orders,
      specifiedType: const FullType(int),
    );
    yield r'onlineMinutes';
    yield serializers.serialize(
      object.onlineMinutes,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainEarningsDtoOutputToday object, {
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
    required CaptainEarningsDtoOutputTodayBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'from':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.from = valueDes;
          break;
        case r'earnings':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.earnings = valueDes;
          break;
        case r'orders':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.orders = valueDes;
          break;
        case r'onlineMinutes':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.onlineMinutes = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainEarningsDtoOutputToday deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainEarningsDtoOutputTodayBuilder();
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
