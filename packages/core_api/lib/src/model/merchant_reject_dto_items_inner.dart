//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_reject_dto_items_inner.g.dart';

/// MerchantRejectDtoItemsInner
///
/// Properties:
/// * [itemId]
/// * [until] - «حتى الغد» (the default) or «حتى أعيده» (RA §9.3).
@BuiltValue()
abstract class MerchantRejectDtoItemsInner
    implements
        Built<MerchantRejectDtoItemsInner, MerchantRejectDtoItemsInnerBuilder> {
  @BuiltValueField(wireName: r'itemId')
  String get itemId;

  /// «حتى الغد» (the default) or «حتى أعيده» (RA §9.3).
  @BuiltValueField(wireName: r'until')
  MerchantRejectDtoItemsInnerUntilEnum get until;
  // enum untilEnum {  tomorrow,  turned_back_on,  };

  MerchantRejectDtoItemsInner._();

  factory MerchantRejectDtoItemsInner([
    void updates(MerchantRejectDtoItemsInnerBuilder b),
  ]) = _$MerchantRejectDtoItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantRejectDtoItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantRejectDtoItemsInner> get serializer =>
      _$MerchantRejectDtoItemsInnerSerializer();
}

class _$MerchantRejectDtoItemsInnerSerializer
    implements PrimitiveSerializer<MerchantRejectDtoItemsInner> {
  @override
  final Iterable<Type> types = const [
    MerchantRejectDtoItemsInner,
    _$MerchantRejectDtoItemsInner,
  ];

  @override
  final String wireName = r'MerchantRejectDtoItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantRejectDtoItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'itemId';
    yield serializers.serialize(
      object.itemId,
      specifiedType: const FullType(String),
    );
    yield r'until';
    yield serializers.serialize(
      object.until,
      specifiedType: const FullType(MerchantRejectDtoItemsInnerUntilEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantRejectDtoItemsInner object, {
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
    required MerchantRejectDtoItemsInnerBuilder result,
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
        case r'until':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      MerchantRejectDtoItemsInnerUntilEnum,
                    ),
                  )
                  as MerchantRejectDtoItemsInnerUntilEnum;
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
  MerchantRejectDtoItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantRejectDtoItemsInnerBuilder();
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

/// «حتى الغد» (the default) or «حتى أعيده» (RA §9.3).
class MerchantRejectDtoItemsInnerUntilEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'tomorrow')
  static const MerchantRejectDtoItemsInnerUntilEnum tomorrow =
      _$merchantRejectDtoItemsInnerUntilEnum_tomorrow;
  @BuiltValueEnumConst(wireName: r'turned_back_on')
  static const MerchantRejectDtoItemsInnerUntilEnum turnedBackOn =
      _$merchantRejectDtoItemsInnerUntilEnum_turnedBackOn;

  static Serializer<MerchantRejectDtoItemsInnerUntilEnum> get serializer =>
      _$merchantRejectDtoItemsInnerUntilEnumSerializer;

  const MerchantRejectDtoItemsInnerUntilEnum._(String name) : super(name);

  static BuiltSet<MerchantRejectDtoItemsInnerUntilEnum> get values =>
      _$merchantRejectDtoItemsInnerUntilEnumValues;
  static MerchantRejectDtoItemsInnerUntilEnum valueOf(String name) =>
      _$merchantRejectDtoItemsInnerUntilEnumValueOf(name);
}
