//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_customer_dto_output_block_reasons_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_ticket_types_dto_output.g.dart';

/// AdminTicketTypesDtoOutput
///
/// Properties:
/// * [customer]
/// * [restaurant]
/// * [captain]
@BuiltValue()
abstract class AdminTicketTypesDtoOutput
    implements
        Built<AdminTicketTypesDtoOutput, AdminTicketTypesDtoOutputBuilder> {
  @BuiltValueField(wireName: r'customer')
  BuiltList<AdminCustomerDtoOutputBlockReasonsInner> get customer;

  @BuiltValueField(wireName: r'restaurant')
  BuiltList<AdminCustomerDtoOutputBlockReasonsInner> get restaurant;

  @BuiltValueField(wireName: r'captain')
  BuiltList<AdminCustomerDtoOutputBlockReasonsInner> get captain;

  AdminTicketTypesDtoOutput._();

  factory AdminTicketTypesDtoOutput([
    void updates(AdminTicketTypesDtoOutputBuilder b),
  ]) = _$AdminTicketTypesDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminTicketTypesDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminTicketTypesDtoOutput> get serializer =>
      _$AdminTicketTypesDtoOutputSerializer();
}

class _$AdminTicketTypesDtoOutputSerializer
    implements PrimitiveSerializer<AdminTicketTypesDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminTicketTypesDtoOutput,
    _$AdminTicketTypesDtoOutput,
  ];

  @override
  final String wireName = r'AdminTicketTypesDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminTicketTypesDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'customer';
    yield serializers.serialize(
      object.customer,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminCustomerDtoOutputBlockReasonsInner),
      ]),
    );
    yield r'restaurant';
    yield serializers.serialize(
      object.restaurant,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminCustomerDtoOutputBlockReasonsInner),
      ]),
    );
    yield r'captain';
    yield serializers.serialize(
      object.captain,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminCustomerDtoOutputBlockReasonsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminTicketTypesDtoOutput object, {
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
    required AdminTicketTypesDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'customer':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminCustomerDtoOutputBlockReasonsInner),
                    ]),
                  )
                  as BuiltList<AdminCustomerDtoOutputBlockReasonsInner>;
          result.customer.replace(valueDes);
          break;
        case r'restaurant':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminCustomerDtoOutputBlockReasonsInner),
                    ]),
                  )
                  as BuiltList<AdminCustomerDtoOutputBlockReasonsInner>;
          result.restaurant.replace(valueDes);
          break;
        case r'captain':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminCustomerDtoOutputBlockReasonsInner),
                    ]),
                  )
                  as BuiltList<AdminCustomerDtoOutputBlockReasonsInner>;
          result.captain.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminTicketTypesDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminTicketTypesDtoOutputBuilder();
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
