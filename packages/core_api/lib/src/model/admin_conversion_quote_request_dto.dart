//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_conversion_quote_request_dto.g.dart';

/// AdminConversionQuoteRequestDto
///
/// Properties:
/// * [cityId]
/// * [from]
/// * [to]
/// * [amount]
@BuiltValue()
abstract class AdminConversionQuoteRequestDto
    implements
        Built<
          AdminConversionQuoteRequestDto,
          AdminConversionQuoteRequestDtoBuilder
        > {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  @BuiltValueField(wireName: r'from')
  String get from;

  @BuiltValueField(wireName: r'to')
  String get to;

  @BuiltValueField(wireName: r'amount')
  String get amount;

  AdminConversionQuoteRequestDto._();

  factory AdminConversionQuoteRequestDto([
    void updates(AdminConversionQuoteRequestDtoBuilder b),
  ]) = _$AdminConversionQuoteRequestDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminConversionQuoteRequestDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminConversionQuoteRequestDto> get serializer =>
      _$AdminConversionQuoteRequestDtoSerializer();
}

class _$AdminConversionQuoteRequestDtoSerializer
    implements PrimitiveSerializer<AdminConversionQuoteRequestDto> {
  @override
  final Iterable<Type> types = const [
    AdminConversionQuoteRequestDto,
    _$AdminConversionQuoteRequestDto,
  ];

  @override
  final String wireName = r'AdminConversionQuoteRequestDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminConversionQuoteRequestDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
    yield r'from';
    yield serializers.serialize(
      object.from,
      specifiedType: const FullType(String),
    );
    yield r'to';
    yield serializers.serialize(
      object.to,
      specifiedType: const FullType(String),
    );
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminConversionQuoteRequestDto object, {
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
    required AdminConversionQuoteRequestDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'cityId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.cityId = valueDes;
          break;
        case r'from':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.from = valueDes;
          break;
        case r'to':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.to = valueDes;
          break;
        case r'amount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.amount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminConversionQuoteRequestDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminConversionQuoteRequestDtoBuilder();
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
