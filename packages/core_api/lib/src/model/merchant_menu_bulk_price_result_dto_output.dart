//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_menu_bulk_price_result_dto_output.g.dart';

/// MerchantMenuBulkPriceResultDtoOutput
///
/// Properties:
/// * [changed]
/// * [unchanged]
@BuiltValue()
abstract class MerchantMenuBulkPriceResultDtoOutput
    implements
        Built<
          MerchantMenuBulkPriceResultDtoOutput,
          MerchantMenuBulkPriceResultDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'changed')
  int get changed;

  @BuiltValueField(wireName: r'unchanged')
  int get unchanged;

  MerchantMenuBulkPriceResultDtoOutput._();

  factory MerchantMenuBulkPriceResultDtoOutput([
    void updates(MerchantMenuBulkPriceResultDtoOutputBuilder b),
  ]) = _$MerchantMenuBulkPriceResultDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantMenuBulkPriceResultDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantMenuBulkPriceResultDtoOutput> get serializer =>
      _$MerchantMenuBulkPriceResultDtoOutputSerializer();
}

class _$MerchantMenuBulkPriceResultDtoOutputSerializer
    implements PrimitiveSerializer<MerchantMenuBulkPriceResultDtoOutput> {
  @override
  final Iterable<Type> types = const [
    MerchantMenuBulkPriceResultDtoOutput,
    _$MerchantMenuBulkPriceResultDtoOutput,
  ];

  @override
  final String wireName = r'MerchantMenuBulkPriceResultDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantMenuBulkPriceResultDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'changed';
    yield serializers.serialize(
      object.changed,
      specifiedType: const FullType(int),
    );
    yield r'unchanged';
    yield serializers.serialize(
      object.unchanged,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantMenuBulkPriceResultDtoOutput object, {
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
    required MerchantMenuBulkPriceResultDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'changed':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.changed = valueDes;
          break;
        case r'unchanged':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.unchanged = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantMenuBulkPriceResultDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantMenuBulkPriceResultDtoOutputBuilder();
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
