//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_suggestion_dto.g.dart';

/// CustomerSuggestionDto
///
/// Properties:
/// * [latitude]
/// * [longitude]
/// * [restaurantName] - «اسم المطعم», required.
/// * [note] - «ملاحظة», optional; an empty one is none.
/// * [query] - The search that found nothing, if the form followed one.
@BuiltValue()
abstract class CustomerSuggestionDto
    implements Built<CustomerSuggestionDto, CustomerSuggestionDtoBuilder> {
  @BuiltValueField(wireName: r'latitude')
  num get latitude;

  @BuiltValueField(wireName: r'longitude')
  num get longitude;

  /// «اسم المطعم», required.
  @BuiltValueField(wireName: r'restaurantName')
  String get restaurantName;

  /// «ملاحظة», optional; an empty one is none.
  @BuiltValueField(wireName: r'note')
  String? get note;

  /// The search that found nothing, if the form followed one.
  @BuiltValueField(wireName: r'query')
  String? get query;

  CustomerSuggestionDto._();

  factory CustomerSuggestionDto([
    void updates(CustomerSuggestionDtoBuilder b),
  ]) = _$CustomerSuggestionDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerSuggestionDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerSuggestionDto> get serializer =>
      _$CustomerSuggestionDtoSerializer();
}

class _$CustomerSuggestionDtoSerializer
    implements PrimitiveSerializer<CustomerSuggestionDto> {
  @override
  final Iterable<Type> types = const [
    CustomerSuggestionDto,
    _$CustomerSuggestionDto,
  ];

  @override
  final String wireName = r'CustomerSuggestionDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerSuggestionDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'latitude';
    yield serializers.serialize(
      object.latitude,
      specifiedType: const FullType(num),
    );
    yield r'longitude';
    yield serializers.serialize(
      object.longitude,
      specifiedType: const FullType(num),
    );
    yield r'restaurantName';
    yield serializers.serialize(
      object.restaurantName,
      specifiedType: const FullType(String),
    );
    yield r'note';
    yield object.note == null
        ? null
        : serializers.serialize(
            object.note,
            specifiedType: const FullType.nullable(String),
          );
    yield r'query';
    yield object.query == null
        ? null
        : serializers.serialize(
            object.query,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerSuggestionDto object, {
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
    required CustomerSuggestionDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'latitude':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(num))
                  as num;
          result.latitude = valueDes;
          break;
        case r'longitude':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(num))
                  as num;
          result.longitude = valueDes;
          break;
        case r'restaurantName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.restaurantName = valueDes;
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
        case r'query':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.query = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerSuggestionDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerSuggestionDtoBuilder();
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
