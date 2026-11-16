//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_approve_compensation_dto_value.g.dart';

/// «تعديل القيمة»: the value OWN gives instead; null keeps the one asked.
///
/// Properties:
/// * [kind]
/// * [amount] - A fixed amount; null for a percentage.
/// * [percentBp] - A percentage: 2000 is 20%; null for an amount.
/// * [maxDiscount] - A percentage's maximum, what counts against the cap; null for an amount.
@BuiltValue()
abstract class AdminApproveCompensationDtoValue
    implements
        Built<
          AdminApproveCompensationDtoValue,
          AdminApproveCompensationDtoValueBuilder
        > {
  @BuiltValueField(wireName: r'kind')
  AdminApproveCompensationDtoValueKindEnum get kind;
  // enum kindEnum {  fixed_amount,  percentage,  };

  /// A fixed amount; null for a percentage.
  @BuiltValueField(wireName: r'amount')
  String? get amount;

  /// A percentage: 2000 is 20%; null for an amount.
  @BuiltValueField(wireName: r'percentBp')
  int? get percentBp;

  /// A percentage's maximum, what counts against the cap; null for an amount.
  @BuiltValueField(wireName: r'maxDiscount')
  String? get maxDiscount;

  AdminApproveCompensationDtoValue._();

  factory AdminApproveCompensationDtoValue([
    void updates(AdminApproveCompensationDtoValueBuilder b),
  ]) = _$AdminApproveCompensationDtoValue;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminApproveCompensationDtoValueBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminApproveCompensationDtoValue> get serializer =>
      _$AdminApproveCompensationDtoValueSerializer();
}

class _$AdminApproveCompensationDtoValueSerializer
    implements PrimitiveSerializer<AdminApproveCompensationDtoValue> {
  @override
  final Iterable<Type> types = const [
    AdminApproveCompensationDtoValue,
    _$AdminApproveCompensationDtoValue,
  ];

  @override
  final String wireName = r'AdminApproveCompensationDtoValue';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminApproveCompensationDtoValue object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(AdminApproveCompensationDtoValueKindEnum),
    );
    yield r'amount';
    yield object.amount == null
        ? null
        : serializers.serialize(
            object.amount,
            specifiedType: const FullType.nullable(String),
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
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminApproveCompensationDtoValue object, {
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
    required AdminApproveCompensationDtoValueBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'kind':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminApproveCompensationDtoValueKindEnum,
                    ),
                  )
                  as AdminApproveCompensationDtoValueKindEnum;
          result.kind = valueDes;
          break;
        case r'amount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.amount = valueDes;
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
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.maxDiscount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminApproveCompensationDtoValue deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminApproveCompensationDtoValueBuilder();
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

class AdminApproveCompensationDtoValueKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'fixed_amount')
  static const AdminApproveCompensationDtoValueKindEnum fixedAmount =
      _$adminApproveCompensationDtoValueKindEnum_fixedAmount;
  @BuiltValueEnumConst(wireName: r'percentage')
  static const AdminApproveCompensationDtoValueKindEnum percentage =
      _$adminApproveCompensationDtoValueKindEnum_percentage;

  static Serializer<AdminApproveCompensationDtoValueKindEnum> get serializer =>
      _$adminApproveCompensationDtoValueKindEnumSerializer;

  const AdminApproveCompensationDtoValueKindEnum._(String name) : super(name);

  static BuiltSet<AdminApproveCompensationDtoValueKindEnum> get values =>
      _$adminApproveCompensationDtoValueKindEnumValues;
  static AdminApproveCompensationDtoValueKindEnum valueOf(String name) =>
      _$adminApproveCompensationDtoValueKindEnumValueOf(name);
}
