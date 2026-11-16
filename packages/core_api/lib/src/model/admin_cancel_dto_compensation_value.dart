//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_cancel_dto_compensation_value.g.dart';

/// AdminCancelDtoCompensationValue
///
/// Properties:
/// * [kind]
/// * [amount] - A fixed amount; null for a percentage.
/// * [percentBp] - A percentage: 2000 is 20%; null for an amount.
/// * [maxDiscount] - A percentage's maximum, what counts against the cap; null for an amount.
@BuiltValue()
abstract class AdminCancelDtoCompensationValue
    implements
        Built<
          AdminCancelDtoCompensationValue,
          AdminCancelDtoCompensationValueBuilder
        > {
  @BuiltValueField(wireName: r'kind')
  AdminCancelDtoCompensationValueKindEnum get kind;
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

  AdminCancelDtoCompensationValue._();

  factory AdminCancelDtoCompensationValue([
    void updates(AdminCancelDtoCompensationValueBuilder b),
  ]) = _$AdminCancelDtoCompensationValue;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCancelDtoCompensationValueBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCancelDtoCompensationValue> get serializer =>
      _$AdminCancelDtoCompensationValueSerializer();
}

class _$AdminCancelDtoCompensationValueSerializer
    implements PrimitiveSerializer<AdminCancelDtoCompensationValue> {
  @override
  final Iterable<Type> types = const [
    AdminCancelDtoCompensationValue,
    _$AdminCancelDtoCompensationValue,
  ];

  @override
  final String wireName = r'AdminCancelDtoCompensationValue';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCancelDtoCompensationValue object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(AdminCancelDtoCompensationValueKindEnum),
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
    AdminCancelDtoCompensationValue object, {
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
    required AdminCancelDtoCompensationValueBuilder result,
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
                      AdminCancelDtoCompensationValueKindEnum,
                    ),
                  )
                  as AdminCancelDtoCompensationValueKindEnum;
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
  AdminCancelDtoCompensationValue deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCancelDtoCompensationValueBuilder();
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

class AdminCancelDtoCompensationValueKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'fixed_amount')
  static const AdminCancelDtoCompensationValueKindEnum fixedAmount =
      _$adminCancelDtoCompensationValueKindEnum_fixedAmount;
  @BuiltValueEnumConst(wireName: r'percentage')
  static const AdminCancelDtoCompensationValueKindEnum percentage =
      _$adminCancelDtoCompensationValueKindEnum_percentage;

  static Serializer<AdminCancelDtoCompensationValueKindEnum> get serializer =>
      _$adminCancelDtoCompensationValueKindEnumSerializer;

  const AdminCancelDtoCompensationValueKindEnum._(String name) : super(name);

  static BuiltSet<AdminCancelDtoCompensationValueKindEnum> get values =>
      _$adminCancelDtoCompensationValueKindEnumValues;
  static AdminCancelDtoCompensationValueKindEnum valueOf(String name) =>
      _$adminCancelDtoCompensationValueKindEnumValueOf(name);
}
