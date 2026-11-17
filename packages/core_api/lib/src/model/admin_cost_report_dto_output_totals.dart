//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_cost_report_dto_output_totals.g.dart';

/// AdminCostReportDtoOutputTotals
///
/// Properties:
/// * [discounts] - Platform-funded discounts of the promo codes.
/// * [compensation]
/// * [operating]
/// * [total]
@BuiltValue()
abstract class AdminCostReportDtoOutputTotals
    implements
        Built<
          AdminCostReportDtoOutputTotals,
          AdminCostReportDtoOutputTotalsBuilder
        > {
  /// Platform-funded discounts of the promo codes.
  @BuiltValueField(wireName: r'discounts')
  String get discounts;

  @BuiltValueField(wireName: r'compensation')
  String get compensation;

  @BuiltValueField(wireName: r'operating')
  String get operating;

  @BuiltValueField(wireName: r'total')
  String get total;

  AdminCostReportDtoOutputTotals._();

  factory AdminCostReportDtoOutputTotals([
    void updates(AdminCostReportDtoOutputTotalsBuilder b),
  ]) = _$AdminCostReportDtoOutputTotals;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCostReportDtoOutputTotalsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCostReportDtoOutputTotals> get serializer =>
      _$AdminCostReportDtoOutputTotalsSerializer();
}

class _$AdminCostReportDtoOutputTotalsSerializer
    implements PrimitiveSerializer<AdminCostReportDtoOutputTotals> {
  @override
  final Iterable<Type> types = const [
    AdminCostReportDtoOutputTotals,
    _$AdminCostReportDtoOutputTotals,
  ];

  @override
  final String wireName = r'AdminCostReportDtoOutputTotals';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCostReportDtoOutputTotals object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'discounts';
    yield serializers.serialize(
      object.discounts,
      specifiedType: const FullType(String),
    );
    yield r'compensation';
    yield serializers.serialize(
      object.compensation,
      specifiedType: const FullType(String),
    );
    yield r'operating';
    yield serializers.serialize(
      object.operating,
      specifiedType: const FullType(String),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCostReportDtoOutputTotals object, {
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
    required AdminCostReportDtoOutputTotalsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'discounts':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.discounts = valueDes;
          break;
        case r'compensation':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.compensation = valueDes;
          break;
        case r'operating':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.operating = valueDes;
          break;
        case r'total':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.total = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCostReportDtoOutputTotals deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCostReportDtoOutputTotalsBuilder();
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
