//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_refresh_dto.g.dart';

/// MerchantRefreshDto
///
/// Properties:
/// * [refreshToken]
@BuiltValue()
abstract class MerchantRefreshDto
    implements Built<MerchantRefreshDto, MerchantRefreshDtoBuilder> {
  @BuiltValueField(wireName: r'refreshToken')
  String get refreshToken;

  MerchantRefreshDto._();

  factory MerchantRefreshDto([void updates(MerchantRefreshDtoBuilder b)]) =
      _$MerchantRefreshDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantRefreshDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantRefreshDto> get serializer =>
      _$MerchantRefreshDtoSerializer();
}

class _$MerchantRefreshDtoSerializer
    implements PrimitiveSerializer<MerchantRefreshDto> {
  @override
  final Iterable<Type> types = const [MerchantRefreshDto, _$MerchantRefreshDto];

  @override
  final String wireName = r'MerchantRefreshDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantRefreshDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'refreshToken';
    yield serializers.serialize(
      object.refreshToken,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantRefreshDto object, {
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
    required MerchantRefreshDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'refreshToken':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.refreshToken = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantRefreshDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantRefreshDtoBuilder();
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
