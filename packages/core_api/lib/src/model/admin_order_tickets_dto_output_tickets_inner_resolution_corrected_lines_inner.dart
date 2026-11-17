//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_tickets_dto_output_tickets_inner_resolution_corrected_lines_inner.g.dart';

/// AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner
///
/// Properties:
/// * [amount]
/// * [currency]
@BuiltValue()
abstract class AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner
    implements
        Built<
          AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner,
          AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInnerBuilder
        > {
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner._();

  factory AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner([
    void updates(
      AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInnerBuilder
      b,
    ),
  ]) = _$AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInnerBuilder
    b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<
    AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner
  >
  get serializer =>
      _$AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInnerSerializer();
}

class _$AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInnerSerializer
    implements
        PrimitiveSerializer<
          AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner
        > {
  @override
  final Iterable<Type> types = const [
    AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner,
    _$AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner,
  ];

  @override
  final String wireName =
      r'AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner
    object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(String),
    );
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner
    object, {
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
    required AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInnerBuilder
    result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'amount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.amount = valueDes;
          break;
        case r'currency':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.currency = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner
  deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInnerBuilder();
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
