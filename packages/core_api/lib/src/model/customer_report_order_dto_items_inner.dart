//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_report_order_dto_items_inner.g.dart';

/// CustomerReportOrderDtoItemsInner
///
/// Properties:
/// * [position]
/// * [quantity]
@BuiltValue()
abstract class CustomerReportOrderDtoItemsInner
    implements
        Built<
          CustomerReportOrderDtoItemsInner,
          CustomerReportOrderDtoItemsInnerBuilder
        > {
  @BuiltValueField(wireName: r'position')
  int get position;

  @BuiltValueField(wireName: r'quantity')
  int get quantity;

  CustomerReportOrderDtoItemsInner._();

  factory CustomerReportOrderDtoItemsInner([
    void updates(CustomerReportOrderDtoItemsInnerBuilder b),
  ]) = _$CustomerReportOrderDtoItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerReportOrderDtoItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerReportOrderDtoItemsInner> get serializer =>
      _$CustomerReportOrderDtoItemsInnerSerializer();
}

class _$CustomerReportOrderDtoItemsInnerSerializer
    implements PrimitiveSerializer<CustomerReportOrderDtoItemsInner> {
  @override
  final Iterable<Type> types = const [
    CustomerReportOrderDtoItemsInner,
    _$CustomerReportOrderDtoItemsInner,
  ];

  @override
  final String wireName = r'CustomerReportOrderDtoItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerReportOrderDtoItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'position';
    yield serializers.serialize(
      object.position,
      specifiedType: const FullType(int),
    );
    yield r'quantity';
    yield serializers.serialize(
      object.quantity,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerReportOrderDtoItemsInner object, {
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
    required CustomerReportOrderDtoItemsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'position':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.position = valueDes;
          break;
        case r'quantity':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.quantity = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerReportOrderDtoItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerReportOrderDtoItemsInnerBuilder();
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
