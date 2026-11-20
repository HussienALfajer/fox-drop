//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/date.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/merchant_order_history_dto_output_orders_inner_owner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_order_history_dto_output_orders_inner.g.dart';

/// MerchantOrderHistoryDtoOutputOrdersInner
///
/// Properties:
/// * [id]
/// * [number]
/// * [placedAt] - «الوقت».
/// * [day] - The business day it was placed on.
/// * [status]
/// * [testOrder] - «طلب تجريبي» (RA §8.16).
/// * [redelivery] - «إعادة توصيل مجانية» (AP §9.9.3).
/// * [itemCount] - «عدد الأصناف»: the quantities added up.
/// * [currency]
/// * [itemsValue] - «قيمة الأصناف», for every user.
/// * [owner]
@BuiltValue()
abstract class MerchantOrderHistoryDtoOutputOrdersInner
    implements
        Built<
          MerchantOrderHistoryDtoOutputOrdersInner,
          MerchantOrderHistoryDtoOutputOrdersInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'number')
  String get number;

  /// «الوقت».
  @BuiltValueField(wireName: r'placedAt')
  DateTime get placedAt;

  /// The business day it was placed on.
  @BuiltValueField(wireName: r'day')
  Date get day;

  @BuiltValueField(wireName: r'status')
  MerchantOrderHistoryDtoOutputOrdersInnerStatusEnum get status;
  // enum statusEnum {  placed,  accepted,  ready,  picked_up,  arrived,  delivered,  rejected,  cancelled,  failed,  };

  /// «طلب تجريبي» (RA §8.16).
  @BuiltValueField(wireName: r'testOrder')
  bool get testOrder;

  /// «إعادة توصيل مجانية» (AP §9.9.3).
  @BuiltValueField(wireName: r'redelivery')
  bool get redelivery;

  /// «عدد الأصناف»: the quantities added up.
  @BuiltValueField(wireName: r'itemCount')
  int get itemCount;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  /// «قيمة الأصناف», for every user.
  @BuiltValueField(wireName: r'itemsValue')
  String get itemsValue;

  @BuiltValueField(wireName: r'owner')
  MerchantOrderHistoryDtoOutputOrdersInnerOwner? get owner;

  MerchantOrderHistoryDtoOutputOrdersInner._();

  factory MerchantOrderHistoryDtoOutputOrdersInner([
    void updates(MerchantOrderHistoryDtoOutputOrdersInnerBuilder b),
  ]) = _$MerchantOrderHistoryDtoOutputOrdersInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantOrderHistoryDtoOutputOrdersInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantOrderHistoryDtoOutputOrdersInner> get serializer =>
      _$MerchantOrderHistoryDtoOutputOrdersInnerSerializer();
}

class _$MerchantOrderHistoryDtoOutputOrdersInnerSerializer
    implements PrimitiveSerializer<MerchantOrderHistoryDtoOutputOrdersInner> {
  @override
  final Iterable<Type> types = const [
    MerchantOrderHistoryDtoOutputOrdersInner,
    _$MerchantOrderHistoryDtoOutputOrdersInner,
  ];

  @override
  final String wireName = r'MerchantOrderHistoryDtoOutputOrdersInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantOrderHistoryDtoOutputOrdersInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'number';
    yield serializers.serialize(
      object.number,
      specifiedType: const FullType(String),
    );
    yield r'placedAt';
    yield serializers.serialize(
      object.placedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'day';
    yield serializers.serialize(
      object.day,
      specifiedType: const FullType(Date),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(
        MerchantOrderHistoryDtoOutputOrdersInnerStatusEnum,
      ),
    );
    yield r'testOrder';
    yield serializers.serialize(
      object.testOrder,
      specifiedType: const FullType(bool),
    );
    yield r'redelivery';
    yield serializers.serialize(
      object.redelivery,
      specifiedType: const FullType(bool),
    );
    yield r'itemCount';
    yield serializers.serialize(
      object.itemCount,
      specifiedType: const FullType(int),
    );
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
    yield r'itemsValue';
    yield serializers.serialize(
      object.itemsValue,
      specifiedType: const FullType(String),
    );
    yield r'owner';
    yield object.owner == null
        ? null
        : serializers.serialize(
            object.owner,
            specifiedType: const FullType.nullable(
              MerchantOrderHistoryDtoOutputOrdersInnerOwner,
            ),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantOrderHistoryDtoOutputOrdersInner object, {
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
    required MerchantOrderHistoryDtoOutputOrdersInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.id = valueDes;
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
        case r'placedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.placedAt = valueDes;
          break;
        case r'day':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(Date),
                  )
                  as Date;
          result.day = valueDes;
          break;
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      MerchantOrderHistoryDtoOutputOrdersInnerStatusEnum,
                    ),
                  )
                  as MerchantOrderHistoryDtoOutputOrdersInnerStatusEnum;
          result.status = valueDes;
          break;
        case r'testOrder':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.testOrder = valueDes;
          break;
        case r'redelivery':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.redelivery = valueDes;
          break;
        case r'itemCount':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.itemCount = valueDes;
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
        case r'itemsValue':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.itemsValue = valueDes;
          break;
        case r'owner':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      MerchantOrderHistoryDtoOutputOrdersInnerOwner,
                    ),
                  )
                  as MerchantOrderHistoryDtoOutputOrdersInnerOwner?;
          if (valueDes == null) continue;
          result.owner.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantOrderHistoryDtoOutputOrdersInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantOrderHistoryDtoOutputOrdersInnerBuilder();
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

class MerchantOrderHistoryDtoOutputOrdersInnerStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'placed')
  static const MerchantOrderHistoryDtoOutputOrdersInnerStatusEnum placed =
      _$merchantOrderHistoryDtoOutputOrdersInnerStatusEnum_placed;
  @BuiltValueEnumConst(wireName: r'accepted')
  static const MerchantOrderHistoryDtoOutputOrdersInnerStatusEnum accepted =
      _$merchantOrderHistoryDtoOutputOrdersInnerStatusEnum_accepted;
  @BuiltValueEnumConst(wireName: r'ready')
  static const MerchantOrderHistoryDtoOutputOrdersInnerStatusEnum ready =
      _$merchantOrderHistoryDtoOutputOrdersInnerStatusEnum_ready;
  @BuiltValueEnumConst(wireName: r'picked_up')
  static const MerchantOrderHistoryDtoOutputOrdersInnerStatusEnum pickedUp =
      _$merchantOrderHistoryDtoOutputOrdersInnerStatusEnum_pickedUp;
  @BuiltValueEnumConst(wireName: r'arrived')
  static const MerchantOrderHistoryDtoOutputOrdersInnerStatusEnum arrived =
      _$merchantOrderHistoryDtoOutputOrdersInnerStatusEnum_arrived;
  @BuiltValueEnumConst(wireName: r'delivered')
  static const MerchantOrderHistoryDtoOutputOrdersInnerStatusEnum delivered =
      _$merchantOrderHistoryDtoOutputOrdersInnerStatusEnum_delivered;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const MerchantOrderHistoryDtoOutputOrdersInnerStatusEnum rejected =
      _$merchantOrderHistoryDtoOutputOrdersInnerStatusEnum_rejected;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const MerchantOrderHistoryDtoOutputOrdersInnerStatusEnum cancelled =
      _$merchantOrderHistoryDtoOutputOrdersInnerStatusEnum_cancelled;
  @BuiltValueEnumConst(wireName: r'failed')
  static const MerchantOrderHistoryDtoOutputOrdersInnerStatusEnum failed =
      _$merchantOrderHistoryDtoOutputOrdersInnerStatusEnum_failed;

  static Serializer<MerchantOrderHistoryDtoOutputOrdersInnerStatusEnum>
  get serializer =>
      _$merchantOrderHistoryDtoOutputOrdersInnerStatusEnumSerializer;

  const MerchantOrderHistoryDtoOutputOrdersInnerStatusEnum._(String name)
    : super(name);

  static BuiltSet<MerchantOrderHistoryDtoOutputOrdersInnerStatusEnum>
  get values => _$merchantOrderHistoryDtoOutputOrdersInnerStatusEnumValues;
  static MerchantOrderHistoryDtoOutputOrdersInnerStatusEnum valueOf(
    String name,
  ) => _$merchantOrderHistoryDtoOutputOrdersInnerStatusEnumValueOf(name);
}
