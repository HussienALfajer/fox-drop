//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/date.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/merchant_order_history_dto_output_orders_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_order_history_dto_output.g.dart';

/// MerchantOrderHistoryDtoOutput
///
/// Properties:
/// * [owner] - An owner sees the commission and the net and picks any range; a cashier not (S12).
/// * [fromDay] - The range read: by default today and the 7 business days before.
/// * [toDay]
/// * [orders] - Newest first, 20 a page.
/// * [next] - The cursor of the next page; null at the end.
@BuiltValue()
abstract class MerchantOrderHistoryDtoOutput
    implements
        Built<
          MerchantOrderHistoryDtoOutput,
          MerchantOrderHistoryDtoOutputBuilder
        > {
  /// An owner sees the commission and the net and picks any range; a cashier not (S12).
  @BuiltValueField(wireName: r'owner')
  bool get owner;

  /// The range read: by default today and the 7 business days before.
  @BuiltValueField(wireName: r'fromDay')
  Date get fromDay;

  @BuiltValueField(wireName: r'toDay')
  Date get toDay;

  /// Newest first, 20 a page.
  @BuiltValueField(wireName: r'orders')
  BuiltList<MerchantOrderHistoryDtoOutputOrdersInner> get orders;

  /// The cursor of the next page; null at the end.
  @BuiltValueField(wireName: r'next')
  String? get next;

  MerchantOrderHistoryDtoOutput._();

  factory MerchantOrderHistoryDtoOutput([
    void updates(MerchantOrderHistoryDtoOutputBuilder b),
  ]) = _$MerchantOrderHistoryDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantOrderHistoryDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantOrderHistoryDtoOutput> get serializer =>
      _$MerchantOrderHistoryDtoOutputSerializer();
}

class _$MerchantOrderHistoryDtoOutputSerializer
    implements PrimitiveSerializer<MerchantOrderHistoryDtoOutput> {
  @override
  final Iterable<Type> types = const [
    MerchantOrderHistoryDtoOutput,
    _$MerchantOrderHistoryDtoOutput,
  ];

  @override
  final String wireName = r'MerchantOrderHistoryDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantOrderHistoryDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'owner';
    yield serializers.serialize(
      object.owner,
      specifiedType: const FullType(bool),
    );
    yield r'fromDay';
    yield serializers.serialize(
      object.fromDay,
      specifiedType: const FullType(Date),
    );
    yield r'toDay';
    yield serializers.serialize(
      object.toDay,
      specifiedType: const FullType(Date),
    );
    yield r'orders';
    yield serializers.serialize(
      object.orders,
      specifiedType: const FullType(BuiltList, [
        FullType(MerchantOrderHistoryDtoOutputOrdersInner),
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
    MerchantOrderHistoryDtoOutput object, {
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
    required MerchantOrderHistoryDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'owner':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.owner = valueDes;
          break;
        case r'fromDay':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(Date),
                  )
                  as Date;
          result.fromDay = valueDes;
          break;
        case r'toDay':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(Date),
                  )
                  as Date;
          result.toDay = valueDes;
          break;
        case r'orders':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(MerchantOrderHistoryDtoOutputOrdersInner),
                    ]),
                  )
                  as BuiltList<MerchantOrderHistoryDtoOutputOrdersInner>;
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
  MerchantOrderHistoryDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantOrderHistoryDtoOutputBuilder();
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
