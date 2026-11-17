//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_price_report_body_dto.g.dart';

/// CustomerPriceReportBodyDto
///
/// Properties:
/// * [itemId] - Optional, picked from the menu.
/// * [shopPrice] - Optional: the shop's price in minor units of the city's base currency.
/// * [note] - Optional, up to 300 characters.
/// * [photoUploadId] - Optional, 1, such as of the shop's menu board (POST /v1/customer/uploads/report-photo).
@BuiltValue()
abstract class CustomerPriceReportBodyDto
    implements
        Built<CustomerPriceReportBodyDto, CustomerPriceReportBodyDtoBuilder> {
  /// Optional, picked from the menu.
  @BuiltValueField(wireName: r'itemId')
  String? get itemId;

  /// Optional: the shop's price in minor units of the city's base currency.
  @BuiltValueField(wireName: r'shopPrice')
  String? get shopPrice;

  /// Optional, up to 300 characters.
  @BuiltValueField(wireName: r'note')
  String? get note;

  /// Optional, 1, such as of the shop's menu board (POST /v1/customer/uploads/report-photo).
  @BuiltValueField(wireName: r'photoUploadId')
  String? get photoUploadId;

  CustomerPriceReportBodyDto._();

  factory CustomerPriceReportBodyDto([
    void updates(CustomerPriceReportBodyDtoBuilder b),
  ]) = _$CustomerPriceReportBodyDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerPriceReportBodyDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerPriceReportBodyDto> get serializer =>
      _$CustomerPriceReportBodyDtoSerializer();
}

class _$CustomerPriceReportBodyDtoSerializer
    implements PrimitiveSerializer<CustomerPriceReportBodyDto> {
  @override
  final Iterable<Type> types = const [
    CustomerPriceReportBodyDto,
    _$CustomerPriceReportBodyDto,
  ];

  @override
  final String wireName = r'CustomerPriceReportBodyDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerPriceReportBodyDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'itemId';
    yield object.itemId == null
        ? null
        : serializers.serialize(
            object.itemId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'shopPrice';
    yield object.shopPrice == null
        ? null
        : serializers.serialize(
            object.shopPrice,
            specifiedType: const FullType.nullable(String),
          );
    yield r'note';
    yield object.note == null
        ? null
        : serializers.serialize(
            object.note,
            specifiedType: const FullType.nullable(String),
          );
    yield r'photoUploadId';
    yield object.photoUploadId == null
        ? null
        : serializers.serialize(
            object.photoUploadId,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerPriceReportBodyDto object, {
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
    required CustomerPriceReportBodyDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'itemId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.itemId = valueDes;
          break;
        case r'shopPrice':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.shopPrice = valueDes;
          break;
        case r'note':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        case r'photoUploadId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.photoUploadId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerPriceReportBodyDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerPriceReportBodyDtoBuilder();
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
