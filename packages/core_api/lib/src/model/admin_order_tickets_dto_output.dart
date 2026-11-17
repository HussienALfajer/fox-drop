//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_order_tickets_dto_output_tickets_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_tickets_dto_output.g.dart';

/// AdminOrderTicketsDtoOutput
///
/// Properties:
/// * [tickets] - Newest first.
@BuiltValue()
abstract class AdminOrderTicketsDtoOutput
    implements
        Built<AdminOrderTicketsDtoOutput, AdminOrderTicketsDtoOutputBuilder> {
  /// Newest first.
  @BuiltValueField(wireName: r'tickets')
  BuiltList<AdminOrderTicketsDtoOutputTicketsInner> get tickets;

  AdminOrderTicketsDtoOutput._();

  factory AdminOrderTicketsDtoOutput([
    void updates(AdminOrderTicketsDtoOutputBuilder b),
  ]) = _$AdminOrderTicketsDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderTicketsDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderTicketsDtoOutput> get serializer =>
      _$AdminOrderTicketsDtoOutputSerializer();
}

class _$AdminOrderTicketsDtoOutputSerializer
    implements PrimitiveSerializer<AdminOrderTicketsDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminOrderTicketsDtoOutput,
    _$AdminOrderTicketsDtoOutput,
  ];

  @override
  final String wireName = r'AdminOrderTicketsDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderTicketsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'tickets';
    yield serializers.serialize(
      object.tickets,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminOrderTicketsDtoOutputTicketsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderTicketsDtoOutput object, {
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
    required AdminOrderTicketsDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'tickets':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminOrderTicketsDtoOutputTicketsInner),
                    ]),
                  )
                  as BuiltList<AdminOrderTicketsDtoOutputTicketsInner>;
          result.tickets.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderTicketsDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderTicketsDtoOutputBuilder();
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
