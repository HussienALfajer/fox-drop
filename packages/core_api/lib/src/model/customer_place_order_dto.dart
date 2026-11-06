//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/customer_place_order_dto_unsaved_address.dart';
import 'package:core_api/src/model/customer_quote_request_dto_lines_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_place_order_dto.g.dart';

/// CustomerPlaceOrderDto
///
/// Properties:
/// * [restaurantId]
/// * [lines]
/// * [payIn] - «سأدفع بـ»: an accepted currency, or null for «لم أحدد» (CU §10.5); one no longer accepted gives payIn null.
/// * [appVersion]
/// * [quoteVersion] - The version of the quote the customer confirmed (CU §10.7).
/// * [addressId] - A saved address (CU §7.3), or null.
/// * [unsavedAddress]
/// * [note] - To the restaurant and the captain, up to 200 characters; no phone number.
@BuiltValue()
abstract class CustomerPlaceOrderDto
    implements Built<CustomerPlaceOrderDto, CustomerPlaceOrderDtoBuilder> {
  @BuiltValueField(wireName: r'restaurantId')
  String get restaurantId;

  @BuiltValueField(wireName: r'lines')
  BuiltList<CustomerQuoteRequestDtoLinesInner> get lines;

  /// «سأدفع بـ»: an accepted currency, or null for «لم أحدد» (CU §10.5); one no longer accepted gives payIn null.
  @BuiltValueField(wireName: r'payIn')
  String? get payIn;

  @BuiltValueField(wireName: r'appVersion')
  String get appVersion;

  /// The version of the quote the customer confirmed (CU §10.7).
  @BuiltValueField(wireName: r'quoteVersion')
  String get quoteVersion;

  /// A saved address (CU §7.3), or null.
  @BuiltValueField(wireName: r'addressId')
  String? get addressId;

  @BuiltValueField(wireName: r'unsavedAddress')
  CustomerPlaceOrderDtoUnsavedAddress? get unsavedAddress;

  /// To the restaurant and the captain, up to 200 characters; no phone number.
  @BuiltValueField(wireName: r'note')
  String? get note;

  CustomerPlaceOrderDto._();

  factory CustomerPlaceOrderDto([
    void updates(CustomerPlaceOrderDtoBuilder b),
  ]) = _$CustomerPlaceOrderDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerPlaceOrderDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerPlaceOrderDto> get serializer =>
      _$CustomerPlaceOrderDtoSerializer();
}

class _$CustomerPlaceOrderDtoSerializer
    implements PrimitiveSerializer<CustomerPlaceOrderDto> {
  @override
  final Iterable<Type> types = const [
    CustomerPlaceOrderDto,
    _$CustomerPlaceOrderDto,
  ];

  @override
  final String wireName = r'CustomerPlaceOrderDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerPlaceOrderDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'restaurantId';
    yield serializers.serialize(
      object.restaurantId,
      specifiedType: const FullType(String),
    );
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [
        FullType(CustomerQuoteRequestDtoLinesInner),
      ]),
    );
    yield r'payIn';
    yield object.payIn == null
        ? null
        : serializers.serialize(
            object.payIn,
            specifiedType: const FullType.nullable(String),
          );
    yield r'appVersion';
    yield serializers.serialize(
      object.appVersion,
      specifiedType: const FullType(String),
    );
    yield r'quoteVersion';
    yield serializers.serialize(
      object.quoteVersion,
      specifiedType: const FullType(String),
    );
    yield r'addressId';
    yield object.addressId == null
        ? null
        : serializers.serialize(
            object.addressId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'unsavedAddress';
    yield object.unsavedAddress == null
        ? null
        : serializers.serialize(
            object.unsavedAddress,
            specifiedType: const FullType.nullable(
              CustomerPlaceOrderDtoUnsavedAddress,
            ),
          );
    yield r'note';
    yield object.note == null
        ? null
        : serializers.serialize(
            object.note,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerPlaceOrderDto object, {
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
    required CustomerPlaceOrderDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'restaurantId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.restaurantId = valueDes;
          break;
        case r'lines':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(CustomerQuoteRequestDtoLinesInner),
                    ]),
                  )
                  as BuiltList<CustomerQuoteRequestDtoLinesInner>;
          result.lines.replace(valueDes);
          break;
        case r'payIn':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.payIn = valueDes;
          break;
        case r'appVersion':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.appVersion = valueDes;
          break;
        case r'quoteVersion':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.quoteVersion = valueDes;
          break;
        case r'addressId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.addressId = valueDes;
          break;
        case r'unsavedAddress':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CustomerPlaceOrderDtoUnsavedAddress,
                    ),
                  )
                  as CustomerPlaceOrderDtoUnsavedAddress?;
          if (valueDes == null) continue;
          result.unsavedAddress.replace(valueDes);
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerPlaceOrderDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerPlaceOrderDtoBuilder();
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
