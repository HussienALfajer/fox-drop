//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_quote_dto_output_available_codes_inner_hours.g.dart';

/// The hours on the city clock, minutes from midnight; an end at or before the start runs past midnight.
///
/// Properties:
/// * [startMinute]
/// * [endMinute]
@BuiltValue()
abstract class CustomerQuoteDtoOutputAvailableCodesInnerHours
    implements
        Built<
          CustomerQuoteDtoOutputAvailableCodesInnerHours,
          CustomerQuoteDtoOutputAvailableCodesInnerHoursBuilder
        > {
  @BuiltValueField(wireName: r'startMinute')
  int get startMinute;

  @BuiltValueField(wireName: r'endMinute')
  int get endMinute;

  CustomerQuoteDtoOutputAvailableCodesInnerHours._();

  factory CustomerQuoteDtoOutputAvailableCodesInnerHours([
    void updates(CustomerQuoteDtoOutputAvailableCodesInnerHoursBuilder b),
  ]) = _$CustomerQuoteDtoOutputAvailableCodesInnerHours;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CustomerQuoteDtoOutputAvailableCodesInnerHoursBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerQuoteDtoOutputAvailableCodesInnerHours>
  get serializer =>
      _$CustomerQuoteDtoOutputAvailableCodesInnerHoursSerializer();
}

class _$CustomerQuoteDtoOutputAvailableCodesInnerHoursSerializer
    implements
        PrimitiveSerializer<CustomerQuoteDtoOutputAvailableCodesInnerHours> {
  @override
  final Iterable<Type> types = const [
    CustomerQuoteDtoOutputAvailableCodesInnerHours,
    _$CustomerQuoteDtoOutputAvailableCodesInnerHours,
  ];

  @override
  final String wireName = r'CustomerQuoteDtoOutputAvailableCodesInnerHours';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerQuoteDtoOutputAvailableCodesInnerHours object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'startMinute';
    yield serializers.serialize(
      object.startMinute,
      specifiedType: const FullType(int),
    );
    yield r'endMinute';
    yield serializers.serialize(
      object.endMinute,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerQuoteDtoOutputAvailableCodesInnerHours object, {
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
    required CustomerQuoteDtoOutputAvailableCodesInnerHoursBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'startMinute':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.startMinute = valueDes;
          break;
        case r'endMinute':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.endMinute = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerQuoteDtoOutputAvailableCodesInnerHours deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerQuoteDtoOutputAvailableCodesInnerHoursBuilder();
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
