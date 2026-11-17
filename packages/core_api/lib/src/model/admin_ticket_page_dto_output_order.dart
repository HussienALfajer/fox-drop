//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_order_tickets_dto_output_tickets_inner_resolution_corrected_lines_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_ticket_page_dto_output_order_lines_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_ticket_page_dto_output_order.g.dart';

/// A customer's general ticket on an order: its lines and money (AP §8.10).
///
/// Properties:
/// * [orderId]
/// * [number]
/// * [currency]
/// * [total]
/// * [itemsValue]
/// * [deliveredNormally] - Delivered with the outcome «تم التسليم»: the affected items and M apply.
/// * [lines]
/// * [received] - «استلم الكابتن» (CU Q23).
/// * [change] - «أعاد لك».
@BuiltValue()
abstract class AdminTicketPageDtoOutputOrder
    implements
        Built<
          AdminTicketPageDtoOutputOrder,
          AdminTicketPageDtoOutputOrderBuilder
        > {
  @BuiltValueField(wireName: r'orderId')
  String get orderId;

  @BuiltValueField(wireName: r'number')
  String get number;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  @BuiltValueField(wireName: r'total')
  String get total;

  @BuiltValueField(wireName: r'itemsValue')
  String get itemsValue;

  /// Delivered with the outcome «تم التسليم»: the affected items and M apply.
  @BuiltValueField(wireName: r'deliveredNormally')
  bool get deliveredNormally;

  @BuiltValueField(wireName: r'lines')
  BuiltList<AdminTicketPageDtoOutputOrderLinesInner> get lines;

  /// «استلم الكابتن» (CU Q23).
  @BuiltValueField(wireName: r'received')
  BuiltList<AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner>
  get received;

  /// «أعاد لك».
  @BuiltValueField(wireName: r'change')
  BuiltList<AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner>
  get change;

  AdminTicketPageDtoOutputOrder._();

  factory AdminTicketPageDtoOutputOrder([
    void updates(AdminTicketPageDtoOutputOrderBuilder b),
  ]) = _$AdminTicketPageDtoOutputOrder;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminTicketPageDtoOutputOrderBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminTicketPageDtoOutputOrder> get serializer =>
      _$AdminTicketPageDtoOutputOrderSerializer();
}

class _$AdminTicketPageDtoOutputOrderSerializer
    implements PrimitiveSerializer<AdminTicketPageDtoOutputOrder> {
  @override
  final Iterable<Type> types = const [
    AdminTicketPageDtoOutputOrder,
    _$AdminTicketPageDtoOutputOrder,
  ];

  @override
  final String wireName = r'AdminTicketPageDtoOutputOrder';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminTicketPageDtoOutputOrder object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'orderId';
    yield serializers.serialize(
      object.orderId,
      specifiedType: const FullType(String),
    );
    yield r'number';
    yield serializers.serialize(
      object.number,
      specifiedType: const FullType(String),
    );
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(String),
    );
    yield r'itemsValue';
    yield serializers.serialize(
      object.itemsValue,
      specifiedType: const FullType(String),
    );
    yield r'deliveredNormally';
    yield serializers.serialize(
      object.deliveredNormally,
      specifiedType: const FullType(bool),
    );
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminTicketPageDtoOutputOrderLinesInner),
      ]),
    );
    yield r'received';
    yield serializers.serialize(
      object.received,
      specifiedType: const FullType(BuiltList, [
        FullType(
          AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner,
        ),
      ]),
    );
    yield r'change';
    yield serializers.serialize(
      object.change,
      specifiedType: const FullType(BuiltList, [
        FullType(
          AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner,
        ),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminTicketPageDtoOutputOrder object, {
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
    required AdminTicketPageDtoOutputOrderBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'orderId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.orderId = valueDes;
          break;
        case r'number':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.number = valueDes;
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
        case r'total':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.total = valueDes;
          break;
        case r'itemsValue':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.itemsValue = valueDes;
          break;
        case r'deliveredNormally':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.deliveredNormally = valueDes;
          break;
        case r'lines':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminTicketPageDtoOutputOrderLinesInner),
                    ]),
                  )
                  as BuiltList<AdminTicketPageDtoOutputOrderLinesInner>;
          result.lines.replace(valueDes);
          break;
        case r'received':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner
                  >;
          result.received.replace(valueDes);
          break;
        case r'change':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner
                  >;
          result.change.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminTicketPageDtoOutputOrder deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminTicketPageDtoOutputOrderBuilder();
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
