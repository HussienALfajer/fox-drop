//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/customer_active_orders_dto_output_orders_inner_late_code_amount.dart';
import 'package:core_api/src/model/customer_active_orders_dto_output_orders_inner_late_code_max_discount.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_active_orders_dto_output_orders_inner_late_code.g.dart';

/// CU §11.6, AP §8.3 (slice 2.22c): the late code the order earned, still not delivered at the promised time + order.delivery_late_compensation_min; it is also in «أكوادي». Null without one, and in the list of active orders.
///
/// Properties:
/// * [code]
/// * [kind]
/// * [amount]
/// * [percentBp] - A percentage in basis points.
/// * [maxDiscount]
/// * [validTo]
/// * [issuedAt]
@BuiltValue()
abstract class CustomerActiveOrdersDtoOutputOrdersInnerLateCode
    implements
        Built<
          CustomerActiveOrdersDtoOutputOrdersInnerLateCode,
          CustomerActiveOrdersDtoOutputOrdersInnerLateCodeBuilder
        > {
  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'kind')
  CustomerActiveOrdersDtoOutputOrdersInnerLateCodeKindEnum get kind;
  // enum kindEnum {  fixed_amount,  percentage,  };

  @BuiltValueField(wireName: r'amount')
  CustomerActiveOrdersDtoOutputOrdersInnerLateCodeAmount? get amount;

  /// A percentage in basis points.
  @BuiltValueField(wireName: r'percentBp')
  int? get percentBp;

  @BuiltValueField(wireName: r'maxDiscount')
  CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscount? get maxDiscount;

  @BuiltValueField(wireName: r'validTo')
  DateTime get validTo;

  @BuiltValueField(wireName: r'issuedAt')
  DateTime get issuedAt;

  CustomerActiveOrdersDtoOutputOrdersInnerLateCode._();

  factory CustomerActiveOrdersDtoOutputOrdersInnerLateCode([
    void updates(CustomerActiveOrdersDtoOutputOrdersInnerLateCodeBuilder b),
  ]) = _$CustomerActiveOrdersDtoOutputOrdersInnerLateCode;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CustomerActiveOrdersDtoOutputOrdersInnerLateCodeBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerActiveOrdersDtoOutputOrdersInnerLateCode>
  get serializer =>
      _$CustomerActiveOrdersDtoOutputOrdersInnerLateCodeSerializer();
}

class _$CustomerActiveOrdersDtoOutputOrdersInnerLateCodeSerializer
    implements
        PrimitiveSerializer<CustomerActiveOrdersDtoOutputOrdersInnerLateCode> {
  @override
  final Iterable<Type> types = const [
    CustomerActiveOrdersDtoOutputOrdersInnerLateCode,
    _$CustomerActiveOrdersDtoOutputOrdersInnerLateCode,
  ];

  @override
  final String wireName = r'CustomerActiveOrdersDtoOutputOrdersInnerLateCode';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerActiveOrdersDtoOutputOrdersInnerLateCode object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(
        CustomerActiveOrdersDtoOutputOrdersInnerLateCodeKindEnum,
      ),
    );
    yield r'amount';
    yield object.amount == null
        ? null
        : serializers.serialize(
            object.amount,
            specifiedType: const FullType.nullable(
              CustomerActiveOrdersDtoOutputOrdersInnerLateCodeAmount,
            ),
          );
    yield r'percentBp';
    yield object.percentBp == null
        ? null
        : serializers.serialize(
            object.percentBp,
            specifiedType: const FullType.nullable(int),
          );
    yield r'maxDiscount';
    yield object.maxDiscount == null
        ? null
        : serializers.serialize(
            object.maxDiscount,
            specifiedType: const FullType.nullable(
              CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscount,
            ),
          );
    yield r'validTo';
    yield serializers.serialize(
      object.validTo,
      specifiedType: const FullType(DateTime),
    );
    yield r'issuedAt';
    yield serializers.serialize(
      object.issuedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerActiveOrdersDtoOutputOrdersInnerLateCode object, {
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
    required CustomerActiveOrdersDtoOutputOrdersInnerLateCodeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'code':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.code = valueDes;
          break;
        case r'kind':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CustomerActiveOrdersDtoOutputOrdersInnerLateCodeKindEnum,
                    ),
                  )
                  as CustomerActiveOrdersDtoOutputOrdersInnerLateCodeKindEnum;
          result.kind = valueDes;
          break;
        case r'amount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CustomerActiveOrdersDtoOutputOrdersInnerLateCodeAmount,
                    ),
                  )
                  as CustomerActiveOrdersDtoOutputOrdersInnerLateCodeAmount?;
          if (valueDes == null) continue;
          result.amount.replace(valueDes);
          break;
        case r'percentBp':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.percentBp = valueDes;
          break;
        case r'maxDiscount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscount,
                    ),
                  )
                  as CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscount?;
          if (valueDes == null) continue;
          result.maxDiscount.replace(valueDes);
          break;
        case r'validTo':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.validTo = valueDes;
          break;
        case r'issuedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.issuedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerLateCode deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerActiveOrdersDtoOutputOrdersInnerLateCodeBuilder();
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

class CustomerActiveOrdersDtoOutputOrdersInnerLateCodeKindEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'fixed_amount')
  static const CustomerActiveOrdersDtoOutputOrdersInnerLateCodeKindEnum
  fixedAmount =
      _$customerActiveOrdersDtoOutputOrdersInnerLateCodeKindEnum_fixedAmount;
  @BuiltValueEnumConst(wireName: r'percentage')
  static const CustomerActiveOrdersDtoOutputOrdersInnerLateCodeKindEnum
  percentage =
      _$customerActiveOrdersDtoOutputOrdersInnerLateCodeKindEnum_percentage;

  static Serializer<CustomerActiveOrdersDtoOutputOrdersInnerLateCodeKindEnum>
  get serializer =>
      _$customerActiveOrdersDtoOutputOrdersInnerLateCodeKindEnumSerializer;

  const CustomerActiveOrdersDtoOutputOrdersInnerLateCodeKindEnum._(String name)
    : super(name);

  static BuiltSet<CustomerActiveOrdersDtoOutputOrdersInnerLateCodeKindEnum>
  get values =>
      _$customerActiveOrdersDtoOutputOrdersInnerLateCodeKindEnumValues;
  static CustomerActiveOrdersDtoOutputOrdersInnerLateCodeKindEnum valueOf(
    String name,
  ) => _$customerActiveOrdersDtoOutputOrdersInnerLateCodeKindEnumValueOf(name);
}
