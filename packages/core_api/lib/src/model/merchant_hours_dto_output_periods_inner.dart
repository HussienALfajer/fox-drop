//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_hours_dto_output_periods_inner.g.dart';

/// MerchantHoursDtoOutputPeriodsInner
///
/// Properties:
/// * [weekday] - 0 Sunday to 6 Saturday.
/// * [opensAt] - Minutes after midnight on the city clock.
/// * [closesAt] - Minutes after midnight; not after opensAt crosses midnight (18:00–02:00).
@BuiltValue()
abstract class MerchantHoursDtoOutputPeriodsInner implements Built<MerchantHoursDtoOutputPeriodsInner, MerchantHoursDtoOutputPeriodsInnerBuilder> {
  /// 0 Sunday to 6 Saturday.
  @BuiltValueField(wireName: r'weekday')
  int get weekday;

  /// Minutes after midnight on the city clock.
  @BuiltValueField(wireName: r'opensAt')
  int get opensAt;

  /// Minutes after midnight; not after opensAt crosses midnight (18:00–02:00).
  @BuiltValueField(wireName: r'closesAt')
  int get closesAt;

  MerchantHoursDtoOutputPeriodsInner._();

  factory MerchantHoursDtoOutputPeriodsInner([void updates(MerchantHoursDtoOutputPeriodsInnerBuilder b)]) = _$MerchantHoursDtoOutputPeriodsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantHoursDtoOutputPeriodsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantHoursDtoOutputPeriodsInner> get serializer => _$MerchantHoursDtoOutputPeriodsInnerSerializer();
}

class _$MerchantHoursDtoOutputPeriodsInnerSerializer implements PrimitiveSerializer<MerchantHoursDtoOutputPeriodsInner> {
  @override
  final Iterable<Type> types = const [MerchantHoursDtoOutputPeriodsInner, _$MerchantHoursDtoOutputPeriodsInner];

  @override
  final String wireName = r'MerchantHoursDtoOutputPeriodsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantHoursDtoOutputPeriodsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'weekday';
    yield serializers.serialize(
      object.weekday,
      specifiedType: const FullType(int),
    );
    yield r'opensAt';
    yield serializers.serialize(
      object.opensAt,
      specifiedType: const FullType(int),
    );
    yield r'closesAt';
    yield serializers.serialize(
      object.closesAt,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantHoursDtoOutputPeriodsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MerchantHoursDtoOutputPeriodsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'weekday':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.weekday = valueDes;
          break;
        case r'opensAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.opensAt = valueDes;
          break;
        case r'closesAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.closesAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantHoursDtoOutputPeriodsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantHoursDtoOutputPeriodsInnerBuilder();
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


