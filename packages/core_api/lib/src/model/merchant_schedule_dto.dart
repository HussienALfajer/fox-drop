//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/merchant_schedule_dto_periods_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_schedule_dto.g.dart';

/// MerchantScheduleDto
///
/// Properties:
/// * [periods] 
@BuiltValue()
abstract class MerchantScheduleDto implements Built<MerchantScheduleDto, MerchantScheduleDtoBuilder> {
  @BuiltValueField(wireName: r'periods')
  BuiltList<MerchantScheduleDtoPeriodsInner> get periods;

  MerchantScheduleDto._();

  factory MerchantScheduleDto([void updates(MerchantScheduleDtoBuilder b)]) = _$MerchantScheduleDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantScheduleDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantScheduleDto> get serializer => _$MerchantScheduleDtoSerializer();
}

class _$MerchantScheduleDtoSerializer implements PrimitiveSerializer<MerchantScheduleDto> {
  @override
  final Iterable<Type> types = const [MerchantScheduleDto, _$MerchantScheduleDto];

  @override
  final String wireName = r'MerchantScheduleDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantScheduleDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'periods';
    yield serializers.serialize(
      object.periods,
      specifiedType: const FullType(BuiltList, [FullType(MerchantScheduleDtoPeriodsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantScheduleDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MerchantScheduleDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'periods':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(MerchantScheduleDtoPeriodsInner)]),
          ) as BuiltList<MerchantScheduleDtoPeriodsInner>;
          result.periods.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantScheduleDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantScheduleDtoBuilder();
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


