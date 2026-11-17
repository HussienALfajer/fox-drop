//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_dto_output_order_redelivery.g.dart';

/// «إعادة توصيل مجانية» (AP §9.9.3): the order and ticket it comes from.
///
/// Properties:
/// * [ofOrderId]
/// * [ofNumber]
/// * [ticketId]
/// * [responsible]
/// * [chargePay] - Its captain's pay charged to the responsible party.
@BuiltValue()
abstract class AdminOrderDtoOutputOrderRedelivery
    implements
        Built<
          AdminOrderDtoOutputOrderRedelivery,
          AdminOrderDtoOutputOrderRedeliveryBuilder
        > {
  @BuiltValueField(wireName: r'ofOrderId')
  String get ofOrderId;

  @BuiltValueField(wireName: r'ofNumber')
  String get ofNumber;

  @BuiltValueField(wireName: r'ticketId')
  String get ticketId;

  @BuiltValueField(wireName: r'responsible')
  AdminOrderDtoOutputOrderRedeliveryResponsibleEnum get responsible;
  // enum responsibleEnum {  restaurant,  captain,  platform,  };

  /// Its captain's pay charged to the responsible party.
  @BuiltValueField(wireName: r'chargePay')
  bool get chargePay;

  AdminOrderDtoOutputOrderRedelivery._();

  factory AdminOrderDtoOutputOrderRedelivery([
    void updates(AdminOrderDtoOutputOrderRedeliveryBuilder b),
  ]) = _$AdminOrderDtoOutputOrderRedelivery;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderDtoOutputOrderRedeliveryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderDtoOutputOrderRedelivery> get serializer =>
      _$AdminOrderDtoOutputOrderRedeliverySerializer();
}

class _$AdminOrderDtoOutputOrderRedeliverySerializer
    implements PrimitiveSerializer<AdminOrderDtoOutputOrderRedelivery> {
  @override
  final Iterable<Type> types = const [
    AdminOrderDtoOutputOrderRedelivery,
    _$AdminOrderDtoOutputOrderRedelivery,
  ];

  @override
  final String wireName = r'AdminOrderDtoOutputOrderRedelivery';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderDtoOutputOrderRedelivery object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'ofOrderId';
    yield serializers.serialize(
      object.ofOrderId,
      specifiedType: const FullType(String),
    );
    yield r'ofNumber';
    yield serializers.serialize(
      object.ofNumber,
      specifiedType: const FullType(String),
    );
    yield r'ticketId';
    yield serializers.serialize(
      object.ticketId,
      specifiedType: const FullType(String),
    );
    yield r'responsible';
    yield serializers.serialize(
      object.responsible,
      specifiedType: const FullType(
        AdminOrderDtoOutputOrderRedeliveryResponsibleEnum,
      ),
    );
    yield r'chargePay';
    yield serializers.serialize(
      object.chargePay,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderRedelivery object, {
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
    required AdminOrderDtoOutputOrderRedeliveryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'ofOrderId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.ofOrderId = valueDes;
          break;
        case r'ofNumber':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.ofNumber = valueDes;
          break;
        case r'ticketId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.ticketId = valueDes;
          break;
        case r'responsible':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminOrderDtoOutputOrderRedeliveryResponsibleEnum,
                    ),
                  )
                  as AdminOrderDtoOutputOrderRedeliveryResponsibleEnum;
          result.responsible = valueDes;
          break;
        case r'chargePay':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.chargePay = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderDtoOutputOrderRedelivery deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderDtoOutputOrderRedeliveryBuilder();
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

class AdminOrderDtoOutputOrderRedeliveryResponsibleEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'restaurant')
  static const AdminOrderDtoOutputOrderRedeliveryResponsibleEnum restaurant =
      _$adminOrderDtoOutputOrderRedeliveryResponsibleEnum_restaurant;
  @BuiltValueEnumConst(wireName: r'captain')
  static const AdminOrderDtoOutputOrderRedeliveryResponsibleEnum captain =
      _$adminOrderDtoOutputOrderRedeliveryResponsibleEnum_captain;
  @BuiltValueEnumConst(wireName: r'platform')
  static const AdminOrderDtoOutputOrderRedeliveryResponsibleEnum platform =
      _$adminOrderDtoOutputOrderRedeliveryResponsibleEnum_platform;

  static Serializer<AdminOrderDtoOutputOrderRedeliveryResponsibleEnum>
  get serializer =>
      _$adminOrderDtoOutputOrderRedeliveryResponsibleEnumSerializer;

  const AdminOrderDtoOutputOrderRedeliveryResponsibleEnum._(String name)
    : super(name);

  static BuiltSet<AdminOrderDtoOutputOrderRedeliveryResponsibleEnum>
  get values => _$adminOrderDtoOutputOrderRedeliveryResponsibleEnumValues;
  static AdminOrderDtoOutputOrderRedeliveryResponsibleEnum valueOf(
    String name,
  ) => _$adminOrderDtoOutputOrderRedeliveryResponsibleEnumValueOf(name);
}
