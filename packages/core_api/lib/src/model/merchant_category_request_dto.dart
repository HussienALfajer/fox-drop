//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_category_request_dto.g.dart';

/// MerchantCategoryRequestDto
///
/// Properties:
/// * [name]
@BuiltValue()
abstract class MerchantCategoryRequestDto
    implements
        Built<MerchantCategoryRequestDto, MerchantCategoryRequestDtoBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  MerchantCategoryRequestDto._();

  factory MerchantCategoryRequestDto([
    void updates(MerchantCategoryRequestDtoBuilder b),
  ]) = _$MerchantCategoryRequestDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantCategoryRequestDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantCategoryRequestDto> get serializer =>
      _$MerchantCategoryRequestDtoSerializer();
}

class _$MerchantCategoryRequestDtoSerializer
    implements PrimitiveSerializer<MerchantCategoryRequestDto> {
  @override
  final Iterable<Type> types = const [
    MerchantCategoryRequestDto,
    _$MerchantCategoryRequestDto,
  ];

  @override
  final String wireName = r'MerchantCategoryRequestDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantCategoryRequestDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantCategoryRequestDto object, {
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
    required MerchantCategoryRequestDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.name = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantCategoryRequestDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantCategoryRequestDtoBuilder();
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
