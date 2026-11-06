//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_orders_dto_output_orders_inner_lines_inner_options_inner.g.dart';

/// MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInner
///
/// Properties:
/// * [name]
@BuiltValue()
abstract class MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInner
    implements
        Built<
          MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInner,
          MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInnerBuilder
        > {
  @BuiltValueField(wireName: r'name')
  String get name;

  MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInner._();

  factory MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInner([
    void updates(
      MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInnerBuilder b,
    ),
  ]) = _$MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInner>
  get serializer =>
      _$MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInnerSerializer();
}

class _$MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInnerSerializer
    implements
        PrimitiveSerializer<
          MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInner
        > {
  @override
  final Iterable<Type> types = const [
    MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInner,
    _$MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInner,
  ];

  @override
  final String wireName =
      r'MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInner object, {
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
    required MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInnerBuilder
    result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.name = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInnerBuilder();
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
