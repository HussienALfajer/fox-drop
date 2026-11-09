//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_holiday_close_dto.g.dart';

/// MerchantHolidayCloseDto
///
/// Properties:
/// * [startsAt] - null: from now.
/// * [endsAt] 
/// * [message] - To customers, up to 100 characters.
@BuiltValue()
abstract class MerchantHolidayCloseDto implements Built<MerchantHolidayCloseDto, MerchantHolidayCloseDtoBuilder> {
  /// null: from now.
  @BuiltValueField(wireName: r'startsAt')
  DateTime? get startsAt;

  @BuiltValueField(wireName: r'endsAt')
  DateTime get endsAt;

  /// To customers, up to 100 characters.
  @BuiltValueField(wireName: r'message')
  String? get message;

  MerchantHolidayCloseDto._();

  factory MerchantHolidayCloseDto([void updates(MerchantHolidayCloseDtoBuilder b)]) = _$MerchantHolidayCloseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantHolidayCloseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantHolidayCloseDto> get serializer => _$MerchantHolidayCloseDtoSerializer();
}

class _$MerchantHolidayCloseDtoSerializer implements PrimitiveSerializer<MerchantHolidayCloseDto> {
  @override
  final Iterable<Type> types = const [MerchantHolidayCloseDto, _$MerchantHolidayCloseDto];

  @override
  final String wireName = r'MerchantHolidayCloseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantHolidayCloseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'startsAt';
    yield object.startsAt == null ? null : serializers.serialize(
      object.startsAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'endsAt';
    yield serializers.serialize(
      object.endsAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'message';
    yield object.message == null ? null : serializers.serialize(
      object.message,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantHolidayCloseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MerchantHolidayCloseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'startsAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.startsAt = valueDes;
          break;
        case r'endsAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.endsAt = valueDes;
          break;
        case r'message':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
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
  MerchantHolidayCloseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantHolidayCloseDtoBuilder();
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


