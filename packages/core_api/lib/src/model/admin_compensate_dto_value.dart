//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_compensate_dto_value.g.dart';

/// AdminCompensateDtoValue
///
/// Properties:
/// * [kind]
/// * [amount] - A fixed amount; null for a percentage.
/// * [percentBp] - A percentage: 2000 is 20%; null for an amount.
/// * [maxDiscount] - A percentage's maximum, what counts against the cap; null for an amount.
@BuiltValue()
abstract class AdminCompensateDtoValue
    implements Built<AdminCompensateDtoValue, AdminCompensateDtoValueBuilder> {
  @BuiltValueField(wireName: r'kind')
  AdminCompensateDtoValueKindEnum get kind;
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

  AdminCompensateDtoValue._();

  factory AdminCompensateDtoValue([
    void updates(AdminCompensateDtoValueBuilder b),
  ]) = _$AdminCompensateDtoValue;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCompensateDtoValueBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCompensateDtoValue> get serializer =>
      _$AdminCompensateDtoValueSerializer();
}

class _$AdminCompensateDtoValueSerializer
    implements PrimitiveSerializer<AdminCompensateDtoValue> {
  @override
  final Iterable<Type> types = const [
    AdminCompensateDtoValue,
    _$AdminCompensateDtoValue,
  ];

  @override
  final String wireName = r'AdminCompensateDtoValue';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCompensateDtoValue object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(AdminCompensateDtoValueKindEnum),
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
    AdminCompensateDtoValue object, {
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
    required AdminCompensateDtoValueBuilder result,
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
                      AdminCompensateDtoValueKindEnum,
                    ),
                  )
                  as AdminCompensateDtoValueKindEnum;
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
  AdminCompensateDtoValue deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCompensateDtoValueBuilder();
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

class AdminCompensateDtoValueKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'fixed_amount')
  static const AdminCompensateDtoValueKindEnum fixedAmount =
      _$adminCompensateDtoValueKindEnum_fixedAmount;
  @BuiltValueEnumConst(wireName: r'percentage')
  static const AdminCompensateDtoValueKindEnum percentage =
      _$adminCompensateDtoValueKindEnum_percentage;

  static Serializer<AdminCompensateDtoValueKindEnum> get serializer =>
      _$adminCompensateDtoValueKindEnumSerializer;

  const AdminCompensateDtoValueKindEnum._(String name) : super(name);

  static BuiltSet<AdminCompensateDtoValueKindEnum> get values =>
      _$adminCompensateDtoValueKindEnumValues;
  static AdminCompensateDtoValueKindEnum valueOf(String name) =>
      _$adminCompensateDtoValueKindEnumValueOf(name);
}
