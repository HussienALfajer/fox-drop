//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/customer_active_orders_dto_output_orders_inner_late_code_amount.dart';
import 'package:core_api/src/model/customer_active_orders_dto_output_orders_inner_late_code_max_discount.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_active_orders_dto_output_orders_inner_cancellation_compensation.g.dart';

/// CU §11.9 (slice 2.22b): the compensation code given on this order, the latest issued, shown on «أُلغي طلبك»; it is also in «أكوادي». Null without one, and while OWN's approval waits.
///
/// Properties:
/// * [code]
/// * [kind]
/// * [amount]
/// * [percentBp] - A percentage in basis points.
/// * [maxDiscount]
/// * [validTo]
@BuiltValue()
abstract class CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensation
    implements
        Built<
          CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensation,
          CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationBuilder
        > {
  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'kind')
  CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationKindEnum
  get kind;
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

  CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensation._();

  factory CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensation([
    void updates(
      CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationBuilder b,
    ),
  ]) = _$CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<
    CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensation
  >
  get serializer =>
      _$CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationSerializer();
}

class _$CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationSerializer
    implements
        PrimitiveSerializer<
          CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensation
        > {
  @override
  final Iterable<Type> types = const [
    CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensation,
    _$CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensation,
  ];

  @override
  final String wireName =
      r'CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensation object, {
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
        CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationKindEnum,
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
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensation object, {
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
    required CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationBuilder
    result,
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
                      CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationKindEnum,
                    ),
                  )
                  as CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationKindEnum;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationBuilder();
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

class CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationKindEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'fixed_amount')
  static const CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationKindEnum
  fixedAmount =
      _$customerActiveOrdersDtoOutputOrdersInnerCancellationCompensationKindEnum_fixedAmount;
  @BuiltValueEnumConst(wireName: r'percentage')
  static const CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationKindEnum
  percentage =
      _$customerActiveOrdersDtoOutputOrdersInnerCancellationCompensationKindEnum_percentage;

  static Serializer<
    CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationKindEnum
  >
  get serializer =>
      _$customerActiveOrdersDtoOutputOrdersInnerCancellationCompensationKindEnumSerializer;

  const CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationKindEnum._(
    String name,
  ) : super(name);

  static BuiltSet<
    CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationKindEnum
  >
  get values =>
      _$customerActiveOrdersDtoOutputOrdersInnerCancellationCompensationKindEnumValues;
  static CustomerActiveOrdersDtoOutputOrdersInnerCancellationCompensationKindEnum
  valueOf(String name) =>
      _$customerActiveOrdersDtoOutputOrdersInnerCancellationCompensationKindEnumValueOf(
        name,
      );
}
