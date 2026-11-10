//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_orders_dto_output_orders_inner_item_report_items_inner.g.dart';

/// MerchantOrdersDtoOutputOrdersInnerItemReportItemsInner
///
/// Properties:
/// * [itemId]
/// * [name]
/// * [until]
@BuiltValue()
abstract class MerchantOrdersDtoOutputOrdersInnerItemReportItemsInner
    implements
        Built<
          MerchantOrdersDtoOutputOrdersInnerItemReportItemsInner,
          MerchantOrdersDtoOutputOrdersInnerItemReportItemsInnerBuilder
        > {
  @BuiltValueField(wireName: r'itemId')
  String get itemId;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'until')
  MerchantOrdersDtoOutputOrdersInnerItemReportItemsInnerUntilEnum get until;
  // enum untilEnum {  tomorrow,  turned_back_on,  };

  MerchantOrdersDtoOutputOrdersInnerItemReportItemsInner._();

  factory MerchantOrdersDtoOutputOrdersInnerItemReportItemsInner([
    void updates(
      MerchantOrdersDtoOutputOrdersInnerItemReportItemsInnerBuilder b,
    ),
  ]) = _$MerchantOrdersDtoOutputOrdersInnerItemReportItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    MerchantOrdersDtoOutputOrdersInnerItemReportItemsInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantOrdersDtoOutputOrdersInnerItemReportItemsInner>
  get serializer =>
      _$MerchantOrdersDtoOutputOrdersInnerItemReportItemsInnerSerializer();
}

class _$MerchantOrdersDtoOutputOrdersInnerItemReportItemsInnerSerializer
    implements
        PrimitiveSerializer<
          MerchantOrdersDtoOutputOrdersInnerItemReportItemsInner
        > {
  @override
  final Iterable<Type> types = const [
    MerchantOrdersDtoOutputOrdersInnerItemReportItemsInner,
    _$MerchantOrdersDtoOutputOrdersInnerItemReportItemsInner,
  ];

  @override
  final String wireName =
      r'MerchantOrdersDtoOutputOrdersInnerItemReportItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantOrdersDtoOutputOrdersInnerItemReportItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'itemId';
    yield serializers.serialize(
      object.itemId,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'until';
    yield serializers.serialize(
      object.until,
      specifiedType: const FullType(
        MerchantOrdersDtoOutputOrdersInnerItemReportItemsInnerUntilEnum,
      ),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantOrdersDtoOutputOrdersInnerItemReportItemsInner object, {
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
    required MerchantOrdersDtoOutputOrdersInnerItemReportItemsInnerBuilder
    result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'itemId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.itemId = valueDes;
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
        case r'until':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      MerchantOrdersDtoOutputOrdersInnerItemReportItemsInnerUntilEnum,
                    ),
                  )
                  as MerchantOrdersDtoOutputOrdersInnerItemReportItemsInnerUntilEnum;
          result.until = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantOrdersDtoOutputOrdersInnerItemReportItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        MerchantOrdersDtoOutputOrdersInnerItemReportItemsInnerBuilder();
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

class MerchantOrdersDtoOutputOrdersInnerItemReportItemsInnerUntilEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'tomorrow')
  static const MerchantOrdersDtoOutputOrdersInnerItemReportItemsInnerUntilEnum
  tomorrow =
      _$merchantOrdersDtoOutputOrdersInnerItemReportItemsInnerUntilEnum_tomorrow;
  @BuiltValueEnumConst(wireName: r'turned_back_on')
  static const MerchantOrdersDtoOutputOrdersInnerItemReportItemsInnerUntilEnum
  turnedBackOn =
      _$merchantOrdersDtoOutputOrdersInnerItemReportItemsInnerUntilEnum_turnedBackOn;

  static Serializer<
    MerchantOrdersDtoOutputOrdersInnerItemReportItemsInnerUntilEnum
  >
  get serializer =>
      _$merchantOrdersDtoOutputOrdersInnerItemReportItemsInnerUntilEnumSerializer;

  const MerchantOrdersDtoOutputOrdersInnerItemReportItemsInnerUntilEnum._(
    String name,
  ) : super(name);

  static BuiltSet<
    MerchantOrdersDtoOutputOrdersInnerItemReportItemsInnerUntilEnum
  >
  get values =>
      _$merchantOrdersDtoOutputOrdersInnerItemReportItemsInnerUntilEnumValues;
  static MerchantOrdersDtoOutputOrdersInnerItemReportItemsInnerUntilEnum
  valueOf(String name) =>
      _$merchantOrdersDtoOutputOrdersInnerItemReportItemsInnerUntilEnumValueOf(
        name,
      );
}
