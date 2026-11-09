//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_status_dto_output_holiday.g.dart';

/// The holiday close in force, or the next one set (RA §10).
///
/// Properties:
/// * [startsAt]
/// * [endsAt]
/// * [message]
@BuiltValue()
abstract class MerchantStatusDtoOutputHoliday
    implements
        Built<
          MerchantStatusDtoOutputHoliday,
          MerchantStatusDtoOutputHolidayBuilder
        > {
  @BuiltValueField(wireName: r'startsAt')
  DateTime get startsAt;

  @BuiltValueField(wireName: r'endsAt')
  DateTime get endsAt;

  @BuiltValueField(wireName: r'message')
  String? get message;

  MerchantStatusDtoOutputHoliday._();

  factory MerchantStatusDtoOutputHoliday([
    void updates(MerchantStatusDtoOutputHolidayBuilder b),
  ]) = _$MerchantStatusDtoOutputHoliday;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantStatusDtoOutputHolidayBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantStatusDtoOutputHoliday> get serializer =>
      _$MerchantStatusDtoOutputHolidaySerializer();
}

class _$MerchantStatusDtoOutputHolidaySerializer
    implements PrimitiveSerializer<MerchantStatusDtoOutputHoliday> {
  @override
  final Iterable<Type> types = const [
    MerchantStatusDtoOutputHoliday,
    _$MerchantStatusDtoOutputHoliday,
  ];

  @override
  final String wireName = r'MerchantStatusDtoOutputHoliday';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantStatusDtoOutputHoliday object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'startsAt';
    yield serializers.serialize(
      object.startsAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'endsAt';
    yield serializers.serialize(
      object.endsAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'message';
    yield object.message == null
        ? null
        : serializers.serialize(
            object.message,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantStatusDtoOutputHoliday object, {
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
    required MerchantStatusDtoOutputHolidayBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'startsAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.startsAt = valueDes;
          break;
        case r'endsAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.endsAt = valueDes;
          break;
        case r'message':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.message = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantStatusDtoOutputHoliday deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantStatusDtoOutputHolidayBuilder();
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
