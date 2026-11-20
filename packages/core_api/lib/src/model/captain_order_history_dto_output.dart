//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/captain_order_history_dto_output_orders_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_order_history_dto_output.g.dart';

/// CaptainOrderHistoryDtoOutput
///
/// Properties:
/// * [payCurrency] - The city's base currency, the pay's.
/// * [orders] - Newest first, 20 a page.
/// * [next] - The cursor of the next page; null at the end.
@BuiltValue()
abstract class CaptainOrderHistoryDtoOutput
    implements
        Built<
          CaptainOrderHistoryDtoOutput,
          CaptainOrderHistoryDtoOutputBuilder
        > {
  /// The city's base currency, the pay's.
  @BuiltValueField(wireName: r'payCurrency')
  String get payCurrency;

  /// Newest first, 20 a page.
  @BuiltValueField(wireName: r'orders')
  BuiltList<CaptainOrderHistoryDtoOutputOrdersInner> get orders;

  /// The cursor of the next page; null at the end.
  @BuiltValueField(wireName: r'next')
  String? get next;

  CaptainOrderHistoryDtoOutput._();

  factory CaptainOrderHistoryDtoOutput([
    void updates(CaptainOrderHistoryDtoOutputBuilder b),
  ]) = _$CaptainOrderHistoryDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainOrderHistoryDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainOrderHistoryDtoOutput> get serializer =>
      _$CaptainOrderHistoryDtoOutputSerializer();
}

class _$CaptainOrderHistoryDtoOutputSerializer
    implements PrimitiveSerializer<CaptainOrderHistoryDtoOutput> {
  @override
  final Iterable<Type> types = const [
    CaptainOrderHistoryDtoOutput,
    _$CaptainOrderHistoryDtoOutput,
  ];

  @override
  final String wireName = r'CaptainOrderHistoryDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainOrderHistoryDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'payCurrency';
    yield serializers.serialize(
      object.payCurrency,
      specifiedType: const FullType(String),
    );
    yield r'orders';
    yield serializers.serialize(
      object.orders,
      specifiedType: const FullType(BuiltList, [
        FullType(CaptainOrderHistoryDtoOutputOrdersInner),
      ]),
    );
    yield r'next';
    yield object.next == null
        ? null
        : serializers.serialize(
            object.next,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainOrderHistoryDtoOutput object, {
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
    required CaptainOrderHistoryDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'payCurrency':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.payCurrency = valueDes;
          break;
        case r'orders':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(CaptainOrderHistoryDtoOutputOrdersInner),
                    ]),
                  )
                  as BuiltList<CaptainOrderHistoryDtoOutputOrdersInner>;
          result.orders.replace(valueDes);
          break;
        case r'next':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.next = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainOrderHistoryDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainOrderHistoryDtoOutputBuilder();
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
