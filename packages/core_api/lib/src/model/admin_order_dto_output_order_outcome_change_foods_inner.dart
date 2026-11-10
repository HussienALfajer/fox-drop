//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_dto_output_order_outcome_change_foods_inner.g.dart';

/// AdminOrderDtoOutputOrderOutcomeChangeFoodsInner
///
/// Properties:
/// * [code]
/// * [label]
@BuiltValue()
abstract class AdminOrderDtoOutputOrderOutcomeChangeFoodsInner
    implements
        Built<
          AdminOrderDtoOutputOrderOutcomeChangeFoodsInner,
          AdminOrderDtoOutputOrderOutcomeChangeFoodsInnerBuilder
        > {
  @BuiltValueField(wireName: r'code')
  AdminOrderDtoOutputOrderOutcomeChangeFoodsInnerCodeEnum get code;
  // enum codeEnum {  kept_by_captain,  returned_to_restaurant,  destroyed,  };

  @BuiltValueField(wireName: r'label')
  String get label;

  AdminOrderDtoOutputOrderOutcomeChangeFoodsInner._();

  factory AdminOrderDtoOutputOrderOutcomeChangeFoodsInner([
    void updates(AdminOrderDtoOutputOrderOutcomeChangeFoodsInnerBuilder b),
  ]) = _$AdminOrderDtoOutputOrderOutcomeChangeFoodsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminOrderDtoOutputOrderOutcomeChangeFoodsInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderDtoOutputOrderOutcomeChangeFoodsInner>
  get serializer =>
      _$AdminOrderDtoOutputOrderOutcomeChangeFoodsInnerSerializer();
}

class _$AdminOrderDtoOutputOrderOutcomeChangeFoodsInnerSerializer
    implements
        PrimitiveSerializer<AdminOrderDtoOutputOrderOutcomeChangeFoodsInner> {
  @override
  final Iterable<Type> types = const [
    AdminOrderDtoOutputOrderOutcomeChangeFoodsInner,
    _$AdminOrderDtoOutputOrderOutcomeChangeFoodsInner,
  ];

  @override
  final String wireName = r'AdminOrderDtoOutputOrderOutcomeChangeFoodsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderDtoOutputOrderOutcomeChangeFoodsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(
        AdminOrderDtoOutputOrderOutcomeChangeFoodsInnerCodeEnum,
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
    AdminOrderDtoOutputOrderOutcomeChangeFoodsInner object, {
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
    required AdminOrderDtoOutputOrderOutcomeChangeFoodsInnerBuilder result,
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
                      AdminOrderDtoOutputOrderOutcomeChangeFoodsInnerCodeEnum,
                    ),
                  )
                  as AdminOrderDtoOutputOrderOutcomeChangeFoodsInnerCodeEnum;
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
  AdminOrderDtoOutputOrderOutcomeChangeFoodsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderDtoOutputOrderOutcomeChangeFoodsInnerBuilder();
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

class AdminOrderDtoOutputOrderOutcomeChangeFoodsInnerCodeEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'kept_by_captain')
  static const AdminOrderDtoOutputOrderOutcomeChangeFoodsInnerCodeEnum
  keptByCaptain =
      _$adminOrderDtoOutputOrderOutcomeChangeFoodsInnerCodeEnum_keptByCaptain;
  @BuiltValueEnumConst(wireName: r'returned_to_restaurant')
  static const AdminOrderDtoOutputOrderOutcomeChangeFoodsInnerCodeEnum
  returnedToRestaurant =
      _$adminOrderDtoOutputOrderOutcomeChangeFoodsInnerCodeEnum_returnedToRestaurant;
  @BuiltValueEnumConst(wireName: r'destroyed')
  static const AdminOrderDtoOutputOrderOutcomeChangeFoodsInnerCodeEnum
  destroyed =
      _$adminOrderDtoOutputOrderOutcomeChangeFoodsInnerCodeEnum_destroyed;

  static Serializer<AdminOrderDtoOutputOrderOutcomeChangeFoodsInnerCodeEnum>
  get serializer =>
      _$adminOrderDtoOutputOrderOutcomeChangeFoodsInnerCodeEnumSerializer;

  const AdminOrderDtoOutputOrderOutcomeChangeFoodsInnerCodeEnum._(String name)
    : super(name);

  static BuiltSet<AdminOrderDtoOutputOrderOutcomeChangeFoodsInnerCodeEnum>
  get values => _$adminOrderDtoOutputOrderOutcomeChangeFoodsInnerCodeEnumValues;
  static AdminOrderDtoOutputOrderOutcomeChangeFoodsInnerCodeEnum valueOf(
    String name,
  ) => _$adminOrderDtoOutputOrderOutcomeChangeFoodsInnerCodeEnumValueOf(name);
}
