//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_item_photo_request_dto.g.dart';

/// MerchantItemPhotoRequestDto
///
/// Properties:
/// * [uploadId]
@BuiltValue()
abstract class MerchantItemPhotoRequestDto
    implements
        Built<MerchantItemPhotoRequestDto, MerchantItemPhotoRequestDtoBuilder> {
  @BuiltValueField(wireName: r'uploadId')
  String get uploadId;

  MerchantItemPhotoRequestDto._();

  factory MerchantItemPhotoRequestDto([
    void updates(MerchantItemPhotoRequestDtoBuilder b),
  ]) = _$MerchantItemPhotoRequestDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantItemPhotoRequestDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantItemPhotoRequestDto> get serializer =>
      _$MerchantItemPhotoRequestDtoSerializer();
}

class _$MerchantItemPhotoRequestDtoSerializer
    implements PrimitiveSerializer<MerchantItemPhotoRequestDto> {
  @override
  final Iterable<Type> types = const [
    MerchantItemPhotoRequestDto,
    _$MerchantItemPhotoRequestDto,
  ];

  @override
  final String wireName = r'MerchantItemPhotoRequestDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantItemPhotoRequestDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'uploadId';
    yield serializers.serialize(
      object.uploadId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantItemPhotoRequestDto object, {
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
    required MerchantItemPhotoRequestDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'uploadId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.uploadId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantItemPhotoRequestDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantItemPhotoRequestDtoBuilder();
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
