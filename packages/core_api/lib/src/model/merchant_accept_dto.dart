//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_accept_dto.g.dart';

/// MerchantAcceptDto
///
/// Properties:
/// * [prepMin] - Whole minutes from merchant.prep_time_floor_min to merchant.prep_time_ceiling_min (RA §8.5); 400 invalid_prep_time otherwise.
@BuiltValue()
abstract class MerchantAcceptDto implements Built<MerchantAcceptDto, MerchantAcceptDtoBuilder> {
  /// Whole minutes from merchant.prep_time_floor_min to merchant.prep_time_ceiling_min (RA §8.5); 400 invalid_prep_time otherwise.
  @BuiltValueField(wireName: r'prepMin')
  int get prepMin;

  MerchantAcceptDto._();

  factory MerchantAcceptDto([void updates(MerchantAcceptDtoBuilder b)]) = _$MerchantAcceptDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantAcceptDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantAcceptDto> get serializer => _$MerchantAcceptDtoSerializer();
}

class _$MerchantAcceptDtoSerializer implements PrimitiveSerializer<MerchantAcceptDto> {
  @override
  final Iterable<Type> types = const [MerchantAcceptDto, _$MerchantAcceptDto];

  @override
  final String wireName = r'MerchantAcceptDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantAcceptDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'prepMin';
    yield serializers.serialize(
      object.prepMin,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantAcceptDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MerchantAcceptDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'prepMin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.prepMin = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantAcceptDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantAcceptDtoBuilder();
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


