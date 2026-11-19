//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/merchant_menu_item_price_dto_price.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_new_item_request_dto.g.dart';

/// MerchantNewItemRequestDto
///
/// Properties:
/// * [categoryId]
/// * [name]
/// * [description]
/// * [price]
/// * [uploadId] - A new photo from POST /v1/merchant/uploads/item-photo; null keeps the one asked.
@BuiltValue()
abstract class MerchantNewItemRequestDto
    implements
        Built<MerchantNewItemRequestDto, MerchantNewItemRequestDtoBuilder> {
  @BuiltValueField(wireName: r'categoryId')
  String get categoryId;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'price')
  MerchantMenuItemPriceDtoPrice get price;

  /// A new photo from POST /v1/merchant/uploads/item-photo; null keeps the one asked.
  @BuiltValueField(wireName: r'uploadId')
  String? get uploadId;

  MerchantNewItemRequestDto._();

  factory MerchantNewItemRequestDto([
    void updates(MerchantNewItemRequestDtoBuilder b),
  ]) = _$MerchantNewItemRequestDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantNewItemRequestDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantNewItemRequestDto> get serializer =>
      _$MerchantNewItemRequestDtoSerializer();
}

class _$MerchantNewItemRequestDtoSerializer
    implements PrimitiveSerializer<MerchantNewItemRequestDto> {
  @override
  final Iterable<Type> types = const [
    MerchantNewItemRequestDto,
    _$MerchantNewItemRequestDto,
  ];

  @override
  final String wireName = r'MerchantNewItemRequestDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantNewItemRequestDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'categoryId';
    yield serializers.serialize(
      object.categoryId,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'description';
    yield object.description == null
        ? null
        : serializers.serialize(
            object.description,
            specifiedType: const FullType.nullable(String),
          );
    yield r'price';
    yield serializers.serialize(
      object.price,
      specifiedType: const FullType(MerchantMenuItemPriceDtoPrice),
    );
    yield r'uploadId';
    yield object.uploadId == null
        ? null
        : serializers.serialize(
            object.uploadId,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantNewItemRequestDto object, {
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
    required MerchantNewItemRequestDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'categoryId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.categoryId = valueDes;
          break;
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.name = valueDes;
          break;
        case r'description':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'price':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      MerchantMenuItemPriceDtoPrice,
                    ),
                  )
                  as MerchantMenuItemPriceDtoPrice;
          result.price.replace(valueDes);
          break;
        case r'uploadId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
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
  MerchantNewItemRequestDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantNewItemRequestDtoBuilder();
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
