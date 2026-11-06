//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/customer_quote_request_dto_location.dart';
import 'package:core_api/src/model/customer_quote_request_dto_lines_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_quote_request_dto.g.dart';

/// CustomerQuoteRequestDto
///
/// Properties:
/// * [restaurantId]
/// * [location]
/// * [lines]
/// * [payIn] - «سأدفع بـ»: an accepted currency, or null for «لم أحدد» (CU §10.5); one no longer accepted gives payIn null.
/// * [appVersion]
@BuiltValue()
abstract class CustomerQuoteRequestDto
    implements Built<CustomerQuoteRequestDto, CustomerQuoteRequestDtoBuilder> {
  @BuiltValueField(wireName: r'restaurantId')
  String get restaurantId;

  @BuiltValueField(wireName: r'location')
  CustomerQuoteRequestDtoLocation get location;

  @BuiltValueField(wireName: r'lines')
  BuiltList<CustomerQuoteRequestDtoLinesInner> get lines;

  /// «سأدفع بـ»: an accepted currency, or null for «لم أحدد» (CU §10.5); one no longer accepted gives payIn null.
  @BuiltValueField(wireName: r'payIn')
  String? get payIn;

  @BuiltValueField(wireName: r'appVersion')
  String get appVersion;

  CustomerQuoteRequestDto._();

  factory CustomerQuoteRequestDto([
    void updates(CustomerQuoteRequestDtoBuilder b),
  ]) = _$CustomerQuoteRequestDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerQuoteRequestDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerQuoteRequestDto> get serializer =>
      _$CustomerQuoteRequestDtoSerializer();
}

class _$CustomerQuoteRequestDtoSerializer
    implements PrimitiveSerializer<CustomerQuoteRequestDto> {
  @override
  final Iterable<Type> types = const [
    CustomerQuoteRequestDto,
    _$CustomerQuoteRequestDto,
  ];

  @override
  final String wireName = r'CustomerQuoteRequestDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerQuoteRequestDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'restaurantId';
    yield serializers.serialize(
      object.restaurantId,
      specifiedType: const FullType(String),
    );
    yield r'location';
    yield serializers.serialize(
      object.location,
      specifiedType: const FullType(CustomerQuoteRequestDtoLocation),
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
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerQuoteRequestDto object, {
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
    required CustomerQuoteRequestDtoBuilder result,
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
        case r'location':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CustomerQuoteRequestDtoLocation,
                    ),
                  )
                  as CustomerQuoteRequestDtoLocation;
          result.location.replace(valueDes);
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerQuoteRequestDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerQuoteRequestDtoBuilder();
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
