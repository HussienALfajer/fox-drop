//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_pause_dto.g.dart';

/// MerchantPauseDto
///
/// Properties:
/// * [minutes] - 15, 30 or 60; null for «حتى أعيد الفتح», until the opening period ends.
@BuiltValue()
abstract class MerchantPauseDto
    implements Built<MerchantPauseDto, MerchantPauseDtoBuilder> {
  /// 15, 30 or 60; null for «حتى أعيد الفتح», until the opening period ends.
  @BuiltValueField(wireName: r'minutes')
  int? get minutes;

  MerchantPauseDto._();

  factory MerchantPauseDto([void updates(MerchantPauseDtoBuilder b)]) =
      _$MerchantPauseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantPauseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantPauseDto> get serializer =>
      _$MerchantPauseDtoSerializer();
}

class _$MerchantPauseDtoSerializer
    implements PrimitiveSerializer<MerchantPauseDto> {
  @override
  final Iterable<Type> types = const [MerchantPauseDto, _$MerchantPauseDto];

  @override
  final String wireName = r'MerchantPauseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantPauseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'minutes';
    yield object.minutes == null
        ? null
        : serializers.serialize(
            object.minutes,
            specifiedType: const FullType.nullable(int),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantPauseDto object, {
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
    required MerchantPauseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'minutes':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.minutes = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantPauseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantPauseDtoBuilder();
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
