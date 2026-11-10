//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_active_orders_dto_output_orders_inner_item_report.g.dart';

/// CU §11.6: the restaurant reported an item unavailable; the banner «المطعم أبلغ أن صنفاً في طلبك غير متوفر. سيتصل بك فريق FOX DROP الآن.» shows until the report is closed, withdrawn, or the order edited or cancelled. Null otherwise.
///
/// Properties:
/// * [at]
@BuiltValue()
abstract class CustomerActiveOrdersDtoOutputOrdersInnerItemReport
    implements
        Built<
          CustomerActiveOrdersDtoOutputOrdersInnerItemReport,
          CustomerActiveOrdersDtoOutputOrdersInnerItemReportBuilder
        > {
  @BuiltValueField(wireName: r'at')
  DateTime get at;

  CustomerActiveOrdersDtoOutputOrdersInnerItemReport._();

  factory CustomerActiveOrdersDtoOutputOrdersInnerItemReport([
    void updates(CustomerActiveOrdersDtoOutputOrdersInnerItemReportBuilder b),
  ]) = _$CustomerActiveOrdersDtoOutputOrdersInnerItemReport;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CustomerActiveOrdersDtoOutputOrdersInnerItemReportBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerActiveOrdersDtoOutputOrdersInnerItemReport>
  get serializer =>
      _$CustomerActiveOrdersDtoOutputOrdersInnerItemReportSerializer();
}

class _$CustomerActiveOrdersDtoOutputOrdersInnerItemReportSerializer
    implements
        PrimitiveSerializer<
          CustomerActiveOrdersDtoOutputOrdersInnerItemReport
        > {
  @override
  final Iterable<Type> types = const [
    CustomerActiveOrdersDtoOutputOrdersInnerItemReport,
    _$CustomerActiveOrdersDtoOutputOrdersInnerItemReport,
  ];

  @override
  final String wireName = r'CustomerActiveOrdersDtoOutputOrdersInnerItemReport';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerActiveOrdersDtoOutputOrdersInnerItemReport object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerActiveOrdersDtoOutputOrdersInnerItemReport object, {
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
    required CustomerActiveOrdersDtoOutputOrdersInnerItemReportBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'at':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.at = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerItemReport deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerActiveOrdersDtoOutputOrdersInnerItemReportBuilder();
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
