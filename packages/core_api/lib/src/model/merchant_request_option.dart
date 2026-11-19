//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/merchant_request_option_price_delta.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_request_option.g.dart';

/// MerchantRequestOption
///
/// Properties:
/// * [id] - A new option takes a new id.
/// * [name]
/// * [priceDelta]
@BuiltValue()
abstract class MerchantRequestOption
    implements Built<MerchantRequestOption, MerchantRequestOptionBuilder> {
  /// A new option takes a new id.
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'priceDelta')
  MerchantRequestOptionPriceDelta get priceDelta;

  MerchantRequestOption._();

  factory MerchantRequestOption([
    void updates(MerchantRequestOptionBuilder b),
  ]) = _$MerchantRequestOption;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantRequestOptionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantRequestOption> get serializer =>
      _$MerchantRequestOptionSerializer();
}

class _$MerchantRequestOptionSerializer
    implements PrimitiveSerializer<MerchantRequestOption> {
  @override
  final Iterable<Type> types = const [
    MerchantRequestOption,
    _$MerchantRequestOption,
  ];

  @override
  final String wireName = r'MerchantRequestOption';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantRequestOption object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'priceDelta';
    yield serializers.serialize(
      object.priceDelta,
      specifiedType: const FullType(MerchantRequestOptionPriceDelta),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantRequestOption object, {
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
    required MerchantRequestOptionBuilder result,
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
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.name = valueDes;
          break;
        case r'priceDelta':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      MerchantRequestOptionPriceDelta,
                    ),
                  )
                  as MerchantRequestOptionPriceDelta;
          result.priceDelta.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantRequestOption deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantRequestOptionBuilder();
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
