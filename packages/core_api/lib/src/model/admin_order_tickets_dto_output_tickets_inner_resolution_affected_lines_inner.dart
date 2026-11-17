//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_tickets_dto_output_tickets_inner_resolution_affected_lines_inner.g.dart';

/// AdminOrderTicketsDtoOutputTicketsInnerResolutionAffectedLinesInner
///
/// Properties:
/// * [position]
/// * [quantity]
/// * [name]
/// * [value]
@BuiltValue()
abstract class AdminOrderTicketsDtoOutputTicketsInnerResolutionAffectedLinesInner
    implements
        Built<
          AdminOrderTicketsDtoOutputTicketsInnerResolutionAffectedLinesInner,
          AdminOrderTicketsDtoOutputTicketsInnerResolutionAffectedLinesInnerBuilder
        > {
  @BuiltValueField(wireName: r'position')
  int get position;

  @BuiltValueField(wireName: r'quantity')
  int get quantity;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'value')
  String get value;

  AdminOrderTicketsDtoOutputTicketsInnerResolutionAffectedLinesInner._();

  factory AdminOrderTicketsDtoOutputTicketsInnerResolutionAffectedLinesInner([
    void updates(
      AdminOrderTicketsDtoOutputTicketsInnerResolutionAffectedLinesInnerBuilder
      b,
    ),
  ]) = _$AdminOrderTicketsDtoOutputTicketsInnerResolutionAffectedLinesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminOrderTicketsDtoOutputTicketsInnerResolutionAffectedLinesInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<
    AdminOrderTicketsDtoOutputTicketsInnerResolutionAffectedLinesInner
  >
  get serializer =>
      _$AdminOrderTicketsDtoOutputTicketsInnerResolutionAffectedLinesInnerSerializer();
}

class _$AdminOrderTicketsDtoOutputTicketsInnerResolutionAffectedLinesInnerSerializer
    implements
        PrimitiveSerializer<
          AdminOrderTicketsDtoOutputTicketsInnerResolutionAffectedLinesInner
        > {
  @override
  final Iterable<Type> types = const [
    AdminOrderTicketsDtoOutputTicketsInnerResolutionAffectedLinesInner,
    _$AdminOrderTicketsDtoOutputTicketsInnerResolutionAffectedLinesInner,
  ];

  @override
  final String wireName =
      r'AdminOrderTicketsDtoOutputTicketsInnerResolutionAffectedLinesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderTicketsDtoOutputTicketsInnerResolutionAffectedLinesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'position';
    yield serializers.serialize(
      object.position,
      specifiedType: const FullType(int),
    );
    yield r'quantity';
    yield serializers.serialize(
      object.quantity,
      specifiedType: const FullType(int),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'value';
    yield serializers.serialize(
      object.value,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderTicketsDtoOutputTicketsInnerResolutionAffectedLinesInner object, {
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
    required AdminOrderTicketsDtoOutputTicketsInnerResolutionAffectedLinesInnerBuilder
    result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'position':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.position = valueDes;
          break;
        case r'quantity':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.quantity = valueDes;
          break;
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.name = valueDes;
          break;
        case r'value':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.value = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderTicketsDtoOutputTicketsInnerResolutionAffectedLinesInner
  deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        AdminOrderTicketsDtoOutputTicketsInnerResolutionAffectedLinesInnerBuilder();
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
