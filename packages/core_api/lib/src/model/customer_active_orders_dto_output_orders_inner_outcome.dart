//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/customer_active_orders_dto_output_orders_inner_outcome_amount_to_collect.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_active_orders_dto_output_orders_inner_outcome.g.dart';

/// Once operations set an outcome other than normal (AP §8.9).
///
/// Properties:
/// * [at]
/// * [outcome]
/// * [status]
/// * [text] - A failed order: «تعذّر التسليم» with this reason (CU §11.9, Appendix C).
/// * [amountToCollect]
@BuiltValue()
abstract class CustomerActiveOrdersDtoOutputOrdersInnerOutcome
    implements
        Built<
          CustomerActiveOrdersDtoOutputOrdersInnerOutcome,
          CustomerActiveOrdersDtoOutputOrdersInnerOutcomeBuilder
        > {
  @BuiltValueField(wireName: r'at')
  DateTime get at;

  @BuiltValueField(wireName: r'outcome')
  CustomerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum get outcome;
  // enum outcomeEnum {  free,  fake,  damaged,  wrong_refused,  failed_other,  };

  @BuiltValueField(wireName: r'status')
  CustomerActiveOrdersDtoOutputOrdersInnerOutcomeStatusEnum get status;
  // enum statusEnum {  delivered,  failed,  };

  /// A failed order: «تعذّر التسليم» with this reason (CU §11.9, Appendix C).
  @BuiltValueField(wireName: r'text')
  String? get text;

  @BuiltValueField(wireName: r'amountToCollect')
  CustomerActiveOrdersDtoOutputOrdersInnerOutcomeAmountToCollect
  get amountToCollect;

  CustomerActiveOrdersDtoOutputOrdersInnerOutcome._();

  factory CustomerActiveOrdersDtoOutputOrdersInnerOutcome([
    void updates(CustomerActiveOrdersDtoOutputOrdersInnerOutcomeBuilder b),
  ]) = _$CustomerActiveOrdersDtoOutputOrdersInnerOutcome;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CustomerActiveOrdersDtoOutputOrdersInnerOutcomeBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerActiveOrdersDtoOutputOrdersInnerOutcome>
  get serializer =>
      _$CustomerActiveOrdersDtoOutputOrdersInnerOutcomeSerializer();
}

class _$CustomerActiveOrdersDtoOutputOrdersInnerOutcomeSerializer
    implements
        PrimitiveSerializer<CustomerActiveOrdersDtoOutputOrdersInnerOutcome> {
  @override
  final Iterable<Type> types = const [
    CustomerActiveOrdersDtoOutputOrdersInnerOutcome,
    _$CustomerActiveOrdersDtoOutputOrdersInnerOutcome,
  ];

  @override
  final String wireName = r'CustomerActiveOrdersDtoOutputOrdersInnerOutcome';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerActiveOrdersDtoOutputOrdersInnerOutcome object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
    yield r'outcome';
    yield serializers.serialize(
      object.outcome,
      specifiedType: const FullType(
        CustomerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum,
      ),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(
        CustomerActiveOrdersDtoOutputOrdersInnerOutcomeStatusEnum,
      ),
    );
    yield r'text';
    yield object.text == null
        ? null
        : serializers.serialize(
            object.text,
            specifiedType: const FullType.nullable(String),
          );
    yield r'amountToCollect';
    yield serializers.serialize(
      object.amountToCollect,
      specifiedType: const FullType(
        CustomerActiveOrdersDtoOutputOrdersInnerOutcomeAmountToCollect,
      ),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerActiveOrdersDtoOutputOrdersInnerOutcome object, {
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
    required CustomerActiveOrdersDtoOutputOrdersInnerOutcomeBuilder result,
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
        case r'outcome':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CustomerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum,
                    ),
                  )
                  as CustomerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum;
          result.outcome = valueDes;
          break;
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CustomerActiveOrdersDtoOutputOrdersInnerOutcomeStatusEnum,
                    ),
                  )
                  as CustomerActiveOrdersDtoOutputOrdersInnerOutcomeStatusEnum;
          result.status = valueDes;
          break;
        case r'text':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.text = valueDes;
          break;
        case r'amountToCollect':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CustomerActiveOrdersDtoOutputOrdersInnerOutcomeAmountToCollect,
                    ),
                  )
                  as CustomerActiveOrdersDtoOutputOrdersInnerOutcomeAmountToCollect;
          result.amountToCollect.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerOutcome deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerActiveOrdersDtoOutputOrdersInnerOutcomeBuilder();
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

class CustomerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'free')
  static const CustomerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum free =
      _$customerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum_free;
  @BuiltValueEnumConst(wireName: r'fake')
  static const CustomerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum fake =
      _$customerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum_fake;
  @BuiltValueEnumConst(wireName: r'damaged')
  static const CustomerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum
  damaged =
      _$customerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum_damaged;
  @BuiltValueEnumConst(wireName: r'wrong_refused')
  static const CustomerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum
  wrongRefused =
      _$customerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum_wrongRefused;
  @BuiltValueEnumConst(wireName: r'failed_other')
  static const CustomerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum
  failedOther =
      _$customerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum_failedOther;

  static Serializer<CustomerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum>
  get serializer =>
      _$customerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnumSerializer;

  const CustomerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum._(
    String name,
  ) : super(name);

  static BuiltSet<CustomerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum>
  get values =>
      _$customerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnumValues;
  static CustomerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnum valueOf(
    String name,
  ) =>
      _$customerActiveOrdersDtoOutputOrdersInnerOutcomeOutcomeEnumValueOf(name);
}

class CustomerActiveOrdersDtoOutputOrdersInnerOutcomeStatusEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'delivered')
  static const CustomerActiveOrdersDtoOutputOrdersInnerOutcomeStatusEnum
  delivered =
      _$customerActiveOrdersDtoOutputOrdersInnerOutcomeStatusEnum_delivered;
  @BuiltValueEnumConst(wireName: r'failed')
  static const CustomerActiveOrdersDtoOutputOrdersInnerOutcomeStatusEnum
  failed = _$customerActiveOrdersDtoOutputOrdersInnerOutcomeStatusEnum_failed;

  static Serializer<CustomerActiveOrdersDtoOutputOrdersInnerOutcomeStatusEnum>
  get serializer =>
      _$customerActiveOrdersDtoOutputOrdersInnerOutcomeStatusEnumSerializer;

  const CustomerActiveOrdersDtoOutputOrdersInnerOutcomeStatusEnum._(String name)
    : super(name);

  static BuiltSet<CustomerActiveOrdersDtoOutputOrdersInnerOutcomeStatusEnum>
  get values =>
      _$customerActiveOrdersDtoOutputOrdersInnerOutcomeStatusEnumValues;
  static CustomerActiveOrdersDtoOutputOrdersInnerOutcomeStatusEnum valueOf(
    String name,
  ) => _$customerActiveOrdersDtoOutputOrdersInnerOutcomeStatusEnumValueOf(name);
}
