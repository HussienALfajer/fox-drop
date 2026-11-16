//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_codes_dto_output_codes_inner_hours.g.dart';

/// The hours on the city clock, minutes from midnight; an end at or before the start runs past midnight.
///
/// Properties:
/// * [startMinute]
/// * [endMinute]
@BuiltValue()
abstract class CustomerCodesDtoOutputCodesInnerHours
    implements
        Built<
          CustomerCodesDtoOutputCodesInnerHours,
          CustomerCodesDtoOutputCodesInnerHoursBuilder
        > {
  @BuiltValueField(wireName: r'startMinute')
  int get startMinute;

  @BuiltValueField(wireName: r'endMinute')
  int get endMinute;

  CustomerCodesDtoOutputCodesInnerHours._();

  factory CustomerCodesDtoOutputCodesInnerHours([
    void updates(CustomerCodesDtoOutputCodesInnerHoursBuilder b),
  ]) = _$CustomerCodesDtoOutputCodesInnerHours;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerCodesDtoOutputCodesInnerHoursBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerCodesDtoOutputCodesInnerHours> get serializer =>
      _$CustomerCodesDtoOutputCodesInnerHoursSerializer();
}

class _$CustomerCodesDtoOutputCodesInnerHoursSerializer
    implements PrimitiveSerializer<CustomerCodesDtoOutputCodesInnerHours> {
  @override
  final Iterable<Type> types = const [
    CustomerCodesDtoOutputCodesInnerHours,
    _$CustomerCodesDtoOutputCodesInnerHours,
  ];

  @override
  final String wireName = r'CustomerCodesDtoOutputCodesInnerHours';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerCodesDtoOutputCodesInnerHours object, {
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
    CustomerCodesDtoOutputCodesInnerHours object, {
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
    required CustomerCodesDtoOutputCodesInnerHoursBuilder result,
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
  CustomerCodesDtoOutputCodesInnerHours deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerCodesDtoOutputCodesInnerHoursBuilder();
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
