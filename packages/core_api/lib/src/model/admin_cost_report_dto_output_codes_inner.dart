//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_cost_report_dto_output_codes_inner.g.dart';

/// AdminCostReportDtoOutputCodesInner
///
/// Properties:
/// * [codeId]
/// * [code]
/// * [orders]
/// * [amount]
@BuiltValue()
abstract class AdminCostReportDtoOutputCodesInner
    implements
        Built<
          AdminCostReportDtoOutputCodesInner,
          AdminCostReportDtoOutputCodesInnerBuilder
        > {
  @BuiltValueField(wireName: r'codeId')
  String? get codeId;

  @BuiltValueField(wireName: r'code')
  String? get code;

  @BuiltValueField(wireName: r'orders')
  int get orders;

  @BuiltValueField(wireName: r'amount')
  String get amount;

  AdminCostReportDtoOutputCodesInner._();

  factory AdminCostReportDtoOutputCodesInner([
    void updates(AdminCostReportDtoOutputCodesInnerBuilder b),
  ]) = _$AdminCostReportDtoOutputCodesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCostReportDtoOutputCodesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCostReportDtoOutputCodesInner> get serializer =>
      _$AdminCostReportDtoOutputCodesInnerSerializer();
}

class _$AdminCostReportDtoOutputCodesInnerSerializer
    implements PrimitiveSerializer<AdminCostReportDtoOutputCodesInner> {
  @override
  final Iterable<Type> types = const [
    AdminCostReportDtoOutputCodesInner,
    _$AdminCostReportDtoOutputCodesInner,
  ];

  @override
  final String wireName = r'AdminCostReportDtoOutputCodesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCostReportDtoOutputCodesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'codeId';
    yield object.codeId == null
        ? null
        : serializers.serialize(
            object.codeId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'code';
    yield object.code == null
        ? null
        : serializers.serialize(
            object.code,
            specifiedType: const FullType.nullable(String),
          );
    yield r'orders';
    yield serializers.serialize(
      object.orders,
      specifiedType: const FullType(int),
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
    AdminCostReportDtoOutputCodesInner object, {
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
    required AdminCostReportDtoOutputCodesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'codeId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.codeId = valueDes;
          break;
        case r'code':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.code = valueDes;
          break;
        case r'orders':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.orders = valueDes;
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
  AdminCostReportDtoOutputCodesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCostReportDtoOutputCodesInnerBuilder();
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
