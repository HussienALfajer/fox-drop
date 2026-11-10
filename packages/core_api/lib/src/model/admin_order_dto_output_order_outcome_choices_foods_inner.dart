//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_dto_output_order_outcome_choices_foods_inner.g.dart';

/// AdminOrderDtoOutputOrderOutcomeChoicesFoodsInner
///
/// Properties:
/// * [code]
/// * [label]
@BuiltValue()
abstract class AdminOrderDtoOutputOrderOutcomeChoicesFoodsInner
    implements
        Built<
          AdminOrderDtoOutputOrderOutcomeChoicesFoodsInner,
          AdminOrderDtoOutputOrderOutcomeChoicesFoodsInnerBuilder
        > {
  @BuiltValueField(wireName: r'code')
  AdminOrderDtoOutputOrderOutcomeChoicesFoodsInnerCodeEnum get code;
  // enum codeEnum {  kept_by_captain,  returned_to_restaurant,  destroyed,  };

  @BuiltValueField(wireName: r'label')
  String get label;

  AdminOrderDtoOutputOrderOutcomeChoicesFoodsInner._();

  factory AdminOrderDtoOutputOrderOutcomeChoicesFoodsInner([
    void updates(AdminOrderDtoOutputOrderOutcomeChoicesFoodsInnerBuilder b),
  ]) = _$AdminOrderDtoOutputOrderOutcomeChoicesFoodsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminOrderDtoOutputOrderOutcomeChoicesFoodsInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderDtoOutputOrderOutcomeChoicesFoodsInner>
  get serializer =>
      _$AdminOrderDtoOutputOrderOutcomeChoicesFoodsInnerSerializer();
}

class _$AdminOrderDtoOutputOrderOutcomeChoicesFoodsInnerSerializer
    implements
        PrimitiveSerializer<AdminOrderDtoOutputOrderOutcomeChoicesFoodsInner> {
  @override
  final Iterable<Type> types = const [
    AdminOrderDtoOutputOrderOutcomeChoicesFoodsInner,
    _$AdminOrderDtoOutputOrderOutcomeChoicesFoodsInner,
  ];

  @override
  final String wireName = r'AdminOrderDtoOutputOrderOutcomeChoicesFoodsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderDtoOutputOrderOutcomeChoicesFoodsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(
        AdminOrderDtoOutputOrderOutcomeChoicesFoodsInnerCodeEnum,
      ),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderOutcomeChoicesFoodsInner object, {
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
    required AdminOrderDtoOutputOrderOutcomeChoicesFoodsInnerBuilder result,
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
                    specifiedType: const FullType(
                      AdminOrderDtoOutputOrderOutcomeChoicesFoodsInnerCodeEnum,
                    ),
                  )
                  as AdminOrderDtoOutputOrderOutcomeChoicesFoodsInnerCodeEnum;
          result.code = valueDes;
          break;
        case r'label':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.label = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderDtoOutputOrderOutcomeChoicesFoodsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderDtoOutputOrderOutcomeChoicesFoodsInnerBuilder();
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

class AdminOrderDtoOutputOrderOutcomeChoicesFoodsInnerCodeEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'kept_by_captain')
  static const AdminOrderDtoOutputOrderOutcomeChoicesFoodsInnerCodeEnum
  keptByCaptain =
      _$adminOrderDtoOutputOrderOutcomeChoicesFoodsInnerCodeEnum_keptByCaptain;
  @BuiltValueEnumConst(wireName: r'returned_to_restaurant')
  static const AdminOrderDtoOutputOrderOutcomeChoicesFoodsInnerCodeEnum
  returnedToRestaurant =
      _$adminOrderDtoOutputOrderOutcomeChoicesFoodsInnerCodeEnum_returnedToRestaurant;
  @BuiltValueEnumConst(wireName: r'destroyed')
  static const AdminOrderDtoOutputOrderOutcomeChoicesFoodsInnerCodeEnum
  destroyed =
      _$adminOrderDtoOutputOrderOutcomeChoicesFoodsInnerCodeEnum_destroyed;

  static Serializer<AdminOrderDtoOutputOrderOutcomeChoicesFoodsInnerCodeEnum>
  get serializer =>
      _$adminOrderDtoOutputOrderOutcomeChoicesFoodsInnerCodeEnumSerializer;

  const AdminOrderDtoOutputOrderOutcomeChoicesFoodsInnerCodeEnum._(String name)
    : super(name);

  static BuiltSet<AdminOrderDtoOutputOrderOutcomeChoicesFoodsInnerCodeEnum>
  get values =>
      _$adminOrderDtoOutputOrderOutcomeChoicesFoodsInnerCodeEnumValues;
  static AdminOrderDtoOutputOrderOutcomeChoicesFoodsInnerCodeEnum valueOf(
    String name,
  ) => _$adminOrderDtoOutputOrderOutcomeChoicesFoodsInnerCodeEnumValueOf(name);
}
