//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/merchant_price_log_dto_output_entries_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_price_log_dto_output.g.dart';

/// MerchantPriceLogDtoOutput
///
/// Properties:
/// * [entries] - The latest 200, newest first.
@BuiltValue()
abstract class MerchantPriceLogDtoOutput
    implements
        Built<MerchantPriceLogDtoOutput, MerchantPriceLogDtoOutputBuilder> {
  /// The latest 200, newest first.
  @BuiltValueField(wireName: r'entries')
  BuiltList<MerchantPriceLogDtoOutputEntriesInner> get entries;

  MerchantPriceLogDtoOutput._();

  factory MerchantPriceLogDtoOutput([
    void updates(MerchantPriceLogDtoOutputBuilder b),
  ]) = _$MerchantPriceLogDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantPriceLogDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantPriceLogDtoOutput> get serializer =>
      _$MerchantPriceLogDtoOutputSerializer();
}

class _$MerchantPriceLogDtoOutputSerializer
    implements PrimitiveSerializer<MerchantPriceLogDtoOutput> {
  @override
  final Iterable<Type> types = const [
    MerchantPriceLogDtoOutput,
    _$MerchantPriceLogDtoOutput,
  ];

  @override
  final String wireName = r'MerchantPriceLogDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantPriceLogDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'entries';
    yield serializers.serialize(
      object.entries,
      specifiedType: const FullType(BuiltList, [
        FullType(MerchantPriceLogDtoOutputEntriesInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantPriceLogDtoOutput object, {
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
    required MerchantPriceLogDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'entries':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(MerchantPriceLogDtoOutputEntriesInner),
                    ]),
                  )
                  as BuiltList<MerchantPriceLogDtoOutputEntriesInner>;
          result.entries.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantPriceLogDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantPriceLogDtoOutputBuilder();
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
