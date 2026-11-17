//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_tickets_dto_output_tickets_inner_closure.g.dart';

/// «مغلقة» without a resolution.
///
/// Properties:
/// * [reason]
/// * [closedAt]
/// * [closedByName]
@BuiltValue()
abstract class AdminOrderTicketsDtoOutputTicketsInnerClosure
    implements
        Built<
          AdminOrderTicketsDtoOutputTicketsInnerClosure,
          AdminOrderTicketsDtoOutputTicketsInnerClosureBuilder
        > {
  @BuiltValueField(wireName: r'reason')
  String get reason;

  @BuiltValueField(wireName: r'closedAt')
  DateTime get closedAt;

  @BuiltValueField(wireName: r'closedByName')
  String? get closedByName;

  AdminOrderTicketsDtoOutputTicketsInnerClosure._();

  factory AdminOrderTicketsDtoOutputTicketsInnerClosure([
    void updates(AdminOrderTicketsDtoOutputTicketsInnerClosureBuilder b),
  ]) = _$AdminOrderTicketsDtoOutputTicketsInnerClosure;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminOrderTicketsDtoOutputTicketsInnerClosureBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderTicketsDtoOutputTicketsInnerClosure>
  get serializer => _$AdminOrderTicketsDtoOutputTicketsInnerClosureSerializer();
}

class _$AdminOrderTicketsDtoOutputTicketsInnerClosureSerializer
    implements
        PrimitiveSerializer<AdminOrderTicketsDtoOutputTicketsInnerClosure> {
  @override
  final Iterable<Type> types = const [
    AdminOrderTicketsDtoOutputTicketsInnerClosure,
    _$AdminOrderTicketsDtoOutputTicketsInnerClosure,
  ];

  @override
  final String wireName = r'AdminOrderTicketsDtoOutputTicketsInnerClosure';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderTicketsDtoOutputTicketsInnerClosure object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    yield r'closedAt';
    yield serializers.serialize(
      object.closedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'closedByName';
    yield object.closedByName == null
        ? null
        : serializers.serialize(
            object.closedByName,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderTicketsDtoOutputTicketsInnerClosure object, {
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
    required AdminOrderTicketsDtoOutputTicketsInnerClosureBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.reason = valueDes;
          break;
        case r'closedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.closedAt = valueDes;
          break;
        case r'closedByName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.closedByName = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderTicketsDtoOutputTicketsInnerClosure deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderTicketsDtoOutputTicketsInnerClosureBuilder();
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
