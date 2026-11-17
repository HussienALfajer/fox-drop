//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_price_report_dto_output.g.dart';

/// CustomerPriceReportDtoOutput
///
/// Properties:
/// * [number] - The ticket «سعر مختلف عن المحل», shown as T-{number}.
@BuiltValue()
abstract class CustomerPriceReportDtoOutput
    implements
        Built<
          CustomerPriceReportDtoOutput,
          CustomerPriceReportDtoOutputBuilder
        > {
  /// The ticket «سعر مختلف عن المحل», shown as T-{number}.
  @BuiltValueField(wireName: r'number')
  String get number;

  CustomerPriceReportDtoOutput._();

  factory CustomerPriceReportDtoOutput([
    void updates(CustomerPriceReportDtoOutputBuilder b),
  ]) = _$CustomerPriceReportDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerPriceReportDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerPriceReportDtoOutput> get serializer =>
      _$CustomerPriceReportDtoOutputSerializer();
}

class _$CustomerPriceReportDtoOutputSerializer
    implements PrimitiveSerializer<CustomerPriceReportDtoOutput> {
  @override
  final Iterable<Type> types = const [
    CustomerPriceReportDtoOutput,
    _$CustomerPriceReportDtoOutput,
  ];

  @override
  final String wireName = r'CustomerPriceReportDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerPriceReportDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'number';
    yield serializers.serialize(
      object.number,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerPriceReportDtoOutput object, {
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
    required CustomerPriceReportDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'number':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.number = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerPriceReportDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerPriceReportDtoOutputBuilder();
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
