//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_promo_code_report_dto_output_report.g.dart';

/// AP §9.11.1 «Code report».
///
/// Properties:
/// * [orders] - Orders with the code, uses given back left out.
/// * [returned] - Uses given back (rejected, cancelled, failed not by the customer).
/// * [customers] - Customer accounts behind those orders.
/// * [newCustomers] - Numbers whose order with the code was placed with no delivered order before and ended delivered.
/// * [cost] - The discounts, minor units of the code currency; null without the cost permission.
/// * [merchantShare] - The restaurants part of the cost; null without the cost permission.
@BuiltValue()
abstract class AdminPromoCodeReportDtoOutputReport
    implements
        Built<
          AdminPromoCodeReportDtoOutputReport,
          AdminPromoCodeReportDtoOutputReportBuilder
        > {
  /// Orders with the code, uses given back left out.
  @BuiltValueField(wireName: r'orders')
  int get orders;

  /// Uses given back (rejected, cancelled, failed not by the customer).
  @BuiltValueField(wireName: r'returned')
  int get returned;

  /// Customer accounts behind those orders.
  @BuiltValueField(wireName: r'customers')
  int get customers;

  /// Numbers whose order with the code was placed with no delivered order before and ended delivered.
  @BuiltValueField(wireName: r'newCustomers')
  int get newCustomers;

  /// The discounts, minor units of the code currency; null without the cost permission.
  @BuiltValueField(wireName: r'cost')
  String? get cost;

  /// The restaurants part of the cost; null without the cost permission.
  @BuiltValueField(wireName: r'merchantShare')
  String? get merchantShare;

  AdminPromoCodeReportDtoOutputReport._();

  factory AdminPromoCodeReportDtoOutputReport([
    void updates(AdminPromoCodeReportDtoOutputReportBuilder b),
  ]) = _$AdminPromoCodeReportDtoOutputReport;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminPromoCodeReportDtoOutputReportBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminPromoCodeReportDtoOutputReport> get serializer =>
      _$AdminPromoCodeReportDtoOutputReportSerializer();
}

class _$AdminPromoCodeReportDtoOutputReportSerializer
    implements PrimitiveSerializer<AdminPromoCodeReportDtoOutputReport> {
  @override
  final Iterable<Type> types = const [
    AdminPromoCodeReportDtoOutputReport,
    _$AdminPromoCodeReportDtoOutputReport,
  ];

  @override
  final String wireName = r'AdminPromoCodeReportDtoOutputReport';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminPromoCodeReportDtoOutputReport object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'orders';
    yield serializers.serialize(
      object.orders,
      specifiedType: const FullType(int),
    );
    yield r'returned';
    yield serializers.serialize(
      object.returned,
      specifiedType: const FullType(int),
    );
    yield r'customers';
    yield serializers.serialize(
      object.customers,
      specifiedType: const FullType(int),
    );
    yield r'newCustomers';
    yield serializers.serialize(
      object.newCustomers,
      specifiedType: const FullType(int),
    );
    yield r'cost';
    yield object.cost == null
        ? null
        : serializers.serialize(
            object.cost,
            specifiedType: const FullType.nullable(String),
          );
    yield r'merchantShare';
    yield object.merchantShare == null
        ? null
        : serializers.serialize(
            object.merchantShare,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminPromoCodeReportDtoOutputReport object, {
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
    required AdminPromoCodeReportDtoOutputReportBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'orders':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.orders = valueDes;
          break;
        case r'returned':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.returned = valueDes;
          break;
        case r'customers':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.customers = valueDes;
          break;
        case r'newCustomers':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.newCustomers = valueDes;
          break;
        case r'cost':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.cost = valueDes;
          break;
        case r'merchantShare':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.merchantShare = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminPromoCodeReportDtoOutputReport deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminPromoCodeReportDtoOutputReportBuilder();
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
